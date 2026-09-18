#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: checkout.sh <repo> [options]

Ensure a cached checkout exists at:
  ~/.cache/checkouts/<host>/<org>/<repo>

Examples:
  checkout.sh mitsuhiko/minijinja
  checkout.sh github.com/mitsuhiko/minijinja
  checkout.sh https://github.com/mitsuhiko/minijinja
  checkout.sh https://gitlab.com/group/project/-/tree/main
  checkout.sh https://bitbucket.org/workspace/project/src/main
  checkout.sh git@github.com:mitsuhiko/minijinja.git

Options:
  --path-only                 Print only the checkout path.
  --force-update              Always fetch from origin and attempt fast-forward.
  --update-interval <secs>    Minimum seconds between updates (default: 300).

Environment:
  LIBRARIAN_CACHE_ROOT        Override cache root (default: ~/.cache/checkouts)
  LIBRARIAN_DEFAULT_HOST      Host for owner/repo shorthand (default: github.com)
  LIBRARIAN_UPDATE_INTERVAL   Default update interval in seconds
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

repo_input=""
path_only=0
force_update=0
update_interval="${LIBRARIAN_UPDATE_INTERVAL:-300}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --path-only)
      path_only=1
      shift
      ;;
    --force-update)
      force_update=1
      shift
      ;;
    --update-interval)
      if [[ $# -lt 2 ]]; then
        echo "error: --update-interval expects a value" >&2
        exit 2
      fi
      update_interval="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [[ -z "$repo_input" ]]; then
        repo_input="$1"
      else
        echo "error: unexpected argument: $1" >&2
        exit 2
      fi
      shift
      ;;
  esac
done

if [[ -z "$repo_input" ]]; then
  echo "error: repository is required" >&2
  exit 2
fi

if ! [[ "$update_interval" =~ ^[0-9]+$ ]]; then
  echo "error: update interval must be a non-negative integer" >&2
  exit 2
fi

trim_repo_input() {
  local s="$1"
  # Trim leading/trailing whitespace.
  s="${s#${s%%[![:space:]]*}}"
  s="${s%${s##*[![:space:]]}}"
  printf '%s' "$s"
}

# Print the host portion of permitted network remote transports. Reject all
# other forms so a cached origin cannot make Git access a local path.
repository_remote_host() {
  local remote_url="$1" rest authority remote_host

  case "$remote_url" in
    git@*:* )
      remote_host="${remote_url#git@}"
      remote_host="${remote_host%%:*}"
      ;;
    ssh://*|http://*|https://*|git://* )
      rest="${remote_url#*://}"
      authority="${rest%%/*}"
      authority="${authority##*@}"
      # IPv6 literals and port-bearing authorities are intentionally rejected:
      # cache paths only support DNS names and IPv4 literals without a port.
      remote_host="${authority%%:*}"
      if [[ -z "$remote_host" || "$authority" != "$remote_host" ]]; then
        echo "error: unsupported repository remote authority: $authority" >&2
        return 1
      fi
      ;;
    * )
      echo "error: unsupported repository remote transport: $remote_url" >&2
      return 1
      ;;
  esac

  if [[ -z "$remote_host" || ! "$remote_host" =~ ^[A-Za-z0-9][A-Za-z0-9.-]*$ ]]; then
    echo "error: invalid repository remote host: $remote_host" >&2
    return 1
  fi

  printf '%s\n' "$remote_host"
}

parse_repo() {
  local input host path first rest
  input="$(trim_repo_input "$1")"

  # Strip query/fragment for URL-like inputs.
  input="${input%%\?*}"
  input="${input%%#*}"

  case "$input" in
    git@*:* )
      host="${input#git@}"
      host="${host%%:*}"
      path="${input#*:}"
      ;;
    ssh://* )
      rest="${input#ssh://}"
      host="${rest%%/*}"
      host="${host#*@}"
      path="${rest#*/}"
      ;;
    http://*|https://* )
      rest="${input#*://}"
      host="${rest%%/*}"
      path="${rest#*/}"
      ;;
    */* )
      first="${input%%/*}"
      if [[ "$first" == *.* || "$first" == localhost ]]; then
        host="$first"
        path="${input#*/}"
      else
        host="${LIBRARIAN_DEFAULT_HOST:-github.com}"
        path="$input"
      fi
      ;;
    * )
      echo "error: unsupported repository format: $input" >&2
      return 1
      ;;
  esac

  host="${host#*@}"
  path="${path#/}"
  path="${path%/}"

  # Strip provider-specific web URL suffixes before deriving org and repo.
  # GitLab's `/-/tree/<ref>` marker follows the complete namespace/repository
  # path, including nested groups. It also supports self-hosted GitLab.
  if [[ "$path" == */-/* ]]; then
    path="${path%%/-/*}"
  # Bitbucket Cloud uses `/src/<ref>/...`.
  elif [[ "$host" == bitbucket.org || "$host" == *.bitbucket.org ]] && [[ "$path" == */src/* ]]; then
    path="${path%%/src/*}"
  fi

  # For GitHub-like deep links, use owner/repo only.
  IFS='/' read -r -a parts <<< "$path"
  if [[ ${#parts[@]} -ge 3 ]]; then
    case "${parts[2]}" in
      tree|blob|pull|issues|commit|actions|releases|compare|wiki)
        path="${parts[0]}/${parts[1]}"
        ;;
    esac
  fi

  # Strip optional .git suffix.
  path="${path%.git}"

  IFS='/' read -r -a parts <<< "$path"
  if [[ ${#parts[@]} -lt 2 ]]; then
    echo "error: repository path must contain at least org/repo: $path" >&2
    return 1
  fi

  local last_index=$(( ${#parts[@]} - 1 ))
  local repo="${parts[$last_index]}"
  local org_parts=("${parts[@]:0:$last_index}")
  local org
  org="$(IFS='/'; echo "${org_parts[*]}")"

  if [[ -z "$host" || -z "$org" || -z "$repo" ]]; then
    echo "error: failed to parse repository: $input" >&2
    return 1
  fi

  printf '%s\n%s\n%s\n' "$host" "$org" "$repo"
}

# Do not use process substitution here: its failure status is not propagated to
# this shell, which could otherwise leave these values empty after a parse error.
if ! parsed="$(parse_repo "$repo_input")"; then
  exit 2
fi
parsed_parts=()
while IFS= read -r line; do
  parsed_parts[${#parsed_parts[@]}]="$line"
done <<< "$parsed"
if [[ ${#parsed_parts[@]} -ne 3 ]]; then
  echo "error: failed to parse repository: $repo_input" >&2
  exit 2
fi

host="${parsed_parts[0]}"
org="${parsed_parts[1]}"
repo="${parsed_parts[2]}"

# Keep cache paths strictly below the configured cache root. Git hosts, groups,
# and repository names never need path traversal or whitespace characters.
if ! [[ "$host" =~ ^[A-Za-z0-9][A-Za-z0-9.-]*$ ]] || [[ "$host" == "." || "$host" == ".." ]]; then
  echo "error: invalid repository host: $host" >&2
  exit 2
fi
IFS='/' read -r -a path_parts <<< "$org/$repo"
for part in "${path_parts[@]}"; do
  if [[ -z "$part" || "$part" == "." || "$part" == ".." || ! "$part" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]; then
    echo "error: invalid repository path component: $part" >&2
    exit 2
  fi
done

cache_root="${LIBRARIAN_CACHE_ROOT:-$HOME/.cache/checkouts}"
checkout_path="$cache_root/$host/$org/$repo"
# Preserve SSH when it was explicitly requested; shorthand and web URLs use
# HTTPS. An existing cache keeps its configured origin to avoid surprising
# transport changes when it is referenced later with a different spelling.
case "$(trim_repo_input "$repo_input")" in
  git@*:*|ssh://*) origin_url="git@$host:$org/$repo.git" ;;
  *) origin_url="https://$host/$org/$repo.git" ;;
esac

mkdir -p "$(dirname "$checkout_path")"

# Re-execute beneath an advisory per-checkout lock so clone, fetch,
# fast-forward, and fetch-timestamp updates cannot race for one checkout.
if [[ "${LIBRARIAN_CHECKOUT_LOCK_HELD:-}" != "$checkout_path" ]]; then
  script_path="${BASH_SOURCE[0]}"
  lock_path="${checkout_path}.librarian.lock"
  lock_command=(env "LIBRARIAN_CHECKOUT_LOCK_HELD=$checkout_path" bash "$script_path" "$repo_input" --update-interval "$update_interval")
  if (( path_only == 1 )); then
    lock_command+=(--path-only)
  fi
  if (( force_update == 1 )); then
    lock_command+=(--force-update)
  fi

  if command -v flock >/dev/null 2>&1; then
    exec flock -x "$lock_path" "${lock_command[@]}"
  elif command -v lockf >/dev/null 2>&1; then
    exec lockf -k "$lock_path" "${lock_command[@]}"
  else
    echo "error: per-checkout locking requires flock or lockf" >&2
    exit 3
  fi
fi

if [[ ! -d "$checkout_path/.git" ]]; then
  # Keep the trusted repository URL as the connection target.
  git -c http.followRedirects=false clone --filter=blob:none "$origin_url" "$checkout_path" >/dev/null
  clone_state="cloned"
else
  clone_state="existing"
fi

if [[ ! -d "$checkout_path/.git" ]]; then
  echo "error: checkout path is not a git repository: $checkout_path" >&2
  exit 3
fi

if ! git -C "$checkout_path" remote get-url origin >/dev/null 2>&1; then
  git -C "$checkout_path" remote add origin "$origin_url"
fi

last_fetch_file="$checkout_path/.git/librarian-last-fetch"
now_epoch="$(date +%s)"
needs_update=1

if [[ -f "$last_fetch_file" && "$force_update" -eq 0 ]]; then
  last_epoch="$(<"$last_fetch_file")"
  if [[ "$last_epoch" =~ ^[0-9]+$ ]]; then
    age=$(( now_epoch - last_epoch ))
    if (( age >= 0 && age < update_interval )); then
      needs_update=0
    fi
  fi
fi

update_state="skipped"
ff_state="not-attempted"

if (( needs_update == 1 )); then
  origin_remote_url="$(git -C "$checkout_path" remote get-url origin)"
  if ! repository_remote_host "$origin_remote_url" >/dev/null; then
    exit 3
  fi
  # Keep the cached origin as the connection target.
  git -C "$checkout_path" -c http.followRedirects=false fetch --prune --tags origin >/dev/null
  echo "$now_epoch" > "$last_fetch_file"
  update_state="fetched"

  # A detached HEAD is expected to make symbolic-ref return status 1. Other
  # failures indicate a broken checkout and must stop the update.
  if branch="$(git -C "$checkout_path" symbolic-ref --short -q HEAD)"; then
    upstream="$(git -C "$checkout_path" for-each-ref --format='%(upstream:short)' "refs/heads/$branch")"
  else
    branch_status=$?
    if (( branch_status == 1 )); then
      branch=""
      upstream=""
    else
      echo "error: failed to determine checkout branch for $checkout_path" >&2
      exit "$branch_status"
    fi
  fi
  dirty="$(git -C "$checkout_path" status --porcelain --untracked-files=no)"

  if [[ -n "$branch" && -n "$upstream" && -z "$dirty" ]]; then
    # Exit status 1 means HEAD cannot fast-forward; other failures are operational errors.
    if git -C "$checkout_path" merge-base --is-ancestor HEAD "$upstream"; then
      git -C "$checkout_path" merge --ff-only "$upstream" >/dev/null
      ff_state="fast-forwarded"
    else
      merge_base_status=$?
      if (( merge_base_status == 1 )); then
        ff_state="skipped-non-ff"
      else
        echo "error: failed to determine fast-forward eligibility for $checkout_path" >&2
        exit "$merge_base_status"
      fi
    fi
  elif [[ -n "$dirty" ]]; then
    ff_state="skipped-dirty"
  else
    ff_state="skipped-no-upstream"
  fi
fi

if (( path_only == 1 )); then
  printf '%s\n' "$checkout_path"
  exit 0
fi

cat <<EOF
repo: $host/$org/$repo
path: $checkout_path
state: $clone_state
update: $update_state
fast_forward: $ff_state
EOF