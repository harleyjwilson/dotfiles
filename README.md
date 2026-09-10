# Dotfiles

Personal configuration managed with [chezmoi](https://www.chezmoi.io/). The source directory is the desired state; chezmoi renders templates and copies the result into the home directory.

The configuration has two mutually exclusive install profiles: `personal` and `work`. Personal installation scripts use `Brewfile` on Apple Silicon macOS and the Fedora package script on Fedora; the work profile has no installation scripts yet.

## Current Status

This is an active personal configuration. Applying it manages:

- shell, Git, SSH, Starship, Ghostty, Helix, and lf configuration;
- personal package installation through Homebrew Bundle or DNF;
- age-encrypted `~/.ssh/id_ed25519` plus its public key;
- a Restic backup command and non-secret local/remote environment-file examples; and
- macOS keyboard-repeat, Dock, sound, and pointing-device defaults.

For the personal profile on Apple Silicon macOS, a `run_once` script installs Homebrew when needed and a `run_onchange` script applies `Brewfile`. On Fedora, personal-profile `run_onchange` scripts install DNF packages and configure Docker CE after the other setup scripts finish. Mac defaults are also personal-only. The work profile has no profile-specific installation scripts. Each package script runs again when its rendered source changes; the Mac script includes a `Brewfile` hash so a `Brewfile` change triggers it. When GPG signing is enabled, an after script verifies that the encrypted backup contains the configured signing key and imports it.

## Contents

- [Install Profiles](#install-profiles)
- [Prerequisites](#prerequisites)
- [Bootstrap](#bootstrap)
- [Managed Configuration](#managed-configuration)
- [Encryption](#encryption)
- [Git Signing](#git-signing)
- [Daily Use](#daily-use)
- [Troubleshooting](#troubleshooting)

## Install Profiles

During the first `chezmoi init`, select exactly one profile:

| Choice     | Stored data boolean |
| ---------- | ------------------- |
| `personal` | `.personal`         |
| `work`     | `.work`             |

Chezmoi stores two profile booleans. Exactly one boolean is `true`, so profile-specific templates and scripts can use a straightforward guard such as:

```gotemplate
{{ if .personal }}# Personal-only content{{ end }}
```

Package scripts also check the current platform because both Apple Silicon macOS and Fedora use the personal profile.

The profile selector appears every time you run `chezmoi init` and has no default, so you must explicitly choose a profile. Choose a different profile there, then run `chezmoi apply`.

## Prerequisites

- Internet access and `git`
- The age X25519 identity copied from 1Password **before** the first `chezmoi init --apply`
- `gpg` available when enabling GPG signing; personal profiles install it before the signing script runs

Chezmoi derives the corresponding public recipient from that identity during initialization, so it does not need to be copied or entered separately.

The private identity is not stored in this repository. Copy it to the fixed path with restrictive permissions:

```sh
umask 077
mkdir -p ~/.config/chezmoi
chmod 700 ~/.config/chezmoi
$EDITOR ~/.config/chezmoi/key.txt
chmod 600 ~/.config/chezmoi/key.txt
```

Paste the complete age identity into that file, save it, and do not commit or share it. Chezmoi always reads the identity from `~/.config/chezmoi/key.txt`.

### macOS (Apple Silicon)

Personal-profile scripts on macOS install Homebrew if it is not already available, then apply `Brewfile`. 1Password is not needed to bootstrap encryption when the age identity has already been copied into place.

## Bootstrap

Bootstrap from the `harleyjwilson` GitHub account (chezmoi resolves this shorthand to its `dotfiles` repository).

### macOS (Apple Silicon)

```sh
# 1. Copy the age identity from 1Password to ~/.config/chezmoi/key.txt.
# 2. Install chezmoi, clone this source repository, prompt for configuration,
#    and apply the files.
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply harleyjwilson
```

### Fedora

```sh
# 1. Copy the age identity from 1Password to ~/.config/chezmoi/key.txt.
# 2. Install chezmoi, clone this source repository, prompt for configuration,
#    and apply the files.
sudo dnf install --assumeyes chezmoi
chezmoi init --apply harleyjwilson
```

For a local checkout, initialize and apply from that directory in one command:

```sh
chezmoi --source "$PWD" init --apply
```

On the first initialization, chezmoi asks for these non-secret values:

| Prompt                    | Purpose                                                               |
| ------------------------- | --------------------------------------------------------------------- |
| Install profile           | One of `personal` or `work`                                           |
| Enable GPG commit signing | Imports the encrypted secret key and enables signed commits when true |

The public X25519 recipient is derived from the fixed identity file automatically and is written into `~/.config/chezmoi/chezmoi.toml`. The GPG-signing choice is stored under `[data]`, so later `chezmoi init` runs do not ask for it again; the profile selector always appears.

Verify the resulting configuration:

```sh
chezmoi dump-config
chezmoi diff
```

## Managed Configuration

| Source                                                                                   | Target            | Notes                                                                                                              |
| ---------------------------------------------------------------------------------------- | ----------------- | ------------------------------------------------------------------------------------------------------------------ |
| `Brewfile`                                                                               | `~/Brewfile`     | Mac Homebrew Bundle declaration; also read by the personal macOS package script.                                 |
| `.chezmoiscripts/`                                                                       | —                 | Profile- and platform-gated installation, macOS defaults, and optional GPG signing configuration scripts.       |
| `dot_zshrc.tmpl`                                                                         | `~/.zshrc`       | Zsh completions, history, aliases, and integrations for Homebrew tools, fzf, zoxide, Starship, and Ghostty. |
| `dot_config/git/`                                                                        | `~/.config/git/` | Global Git defaults, Delta pager, ignore file, identity template, and optional GPG signing.                       |
| `dot_config/ghostty/`, `dot_config/helix/`, `dot_config/jrnl/`, `dot_config/lf/`         | `~/.config/…`    | Terminal, editor, journal, and file-manager configuration.                                                        |
| `dot_config/starship.toml`                                                               | `~/.config/starship.toml` | Shell prompt configuration.                                                                                 |
| `private_dot_gnupg/`                                                                    | `~/.gnupg/`      | GPG agent settings; the encrypted GPG backup remains source-only for the signing script.                      |
| `private_dot_ssh/`                                                                      | `~/.ssh/`        | Encrypted Ed25519 private key and matching public key.                                                         |
| `dot_agents/`                                                                            | `~/.agents/`     | Agent skills and their supporting references.                                                                      |
| `bin/executable_backup`, `bin/executable_dt`                                             | `~/bin/backup`, `~/bin/dt` | Restic backup command and terminal clock.                                                                  |

## Encryption

`.chezmoi.toml.tmpl` configures chezmoi to use age asymmetric encryption with its built-in age implementation:

- X25519 identity file: `~/.config/chezmoi/key.txt`
- Recipient: the `age1…` public key derived from that identity during initialization
- Passphrases: disabled

The built-in implementation avoids an external `age` dependency. The recipient is safe to store in configuration; the private identity is not.

### Add an encrypted file

```sh
chezmoi add --encrypt ~/.config/example/secret
```

Chezmoi stores ciphertext in the source directory and decrypts it only when applying the target file. To edit an already managed secret, use:

```sh
chezmoi edit ~/.config/example/secret
```

### Add encrypted GPG secret-key

List the secret keys and select the full, space-free fingerprint on the indented line below the `sec` entry:

```sh
gpg --list-secret-keys --keyid-format=long
```

From the chezmoi source directory, create or refresh the encrypted backup. Run this in an interactive terminal so GPG can use its agent or pinentry to unlock the key. Replace `PRIMARY_KEY_FINGERPRINT` with the fingerprint you selected. The private-key export flows through a pipe and is never saved unencrypted.

```sh
(
  set -euo pipefail

  GPG_SECRET_KEY_FINGERPRINT=PRIMARY_KEY_FINGERPRINT
  GPG_SECRET_KEY_BACKUP=private_dot_gnupg/encrypted_gpg-secret-key.asc

  if ! gpg --batch --list-secret-keys "$GPG_SECRET_KEY_FINGERPRINT" >/dev/null 2>&1; then
    printf 'GPG backup failed: secret key %s was not found\n' \
      "$GPG_SECRET_KEY_FINGERPRINT" >&2
    exit 1
  fi

  mkdir -p "$(dirname "$GPG_SECRET_KEY_BACKUP")"
  GPG_SECRET_KEY_BACKUP_TEMP="$(mktemp "${GPG_SECRET_KEY_BACKUP}.XXXXXX")"
  trap 'rm -f "$GPG_SECRET_KEY_BACKUP_TEMP"' EXIT

  gpg --armor --export-secret-keys "$GPG_SECRET_KEY_FINGERPRINT" \
    | chezmoi encrypt --output "$GPG_SECRET_KEY_BACKUP_TEMP"

  BACKUP_FINGERPRINT="$(
    chezmoi decrypt "$GPG_SECRET_KEY_BACKUP_TEMP" \
      | gpg --batch --with-colons --import-options show-only --import \
      | awk -F: '$1 == "fpr" && fingerprint == "" { fingerprint = $10 } END { print fingerprint }'
  )"
  if [[ "$BACKUP_FINGERPRINT" != "$GPG_SECRET_KEY_FINGERPRINT" ]]; then
    printf 'GPG backup failed: encrypted backup fingerprint is %s, expected %s\n' \
      "${BACKUP_FINGERPRINT:-missing}" "$GPG_SECRET_KEY_FINGERPRINT" >&2
    exit 1
  fi

  chmod 600 "$GPG_SECRET_KEY_BACKUP_TEMP"
  mv -f "$GPG_SECRET_KEY_BACKUP_TEMP" "$GPG_SECRET_KEY_BACKUP"
  trap - EXIT
  git add "$GPG_SECRET_KEY_BACKUP"
)
```

## Git Signing

The initial chezmoi configuration asks whether to enable GPG commit signing. The public signing-key fingerprint is stored directly in the managed Git configuration template and is emitted only when signing is enabled.

When enabled, the after script:

1. decrypts the GPG secret-key backup and derives its primary fingerprint;
2. verifies that the derived fingerprint matches `user.signingKey` in the applied Git configuration; and
3. imports the backup when that secret key is absent.

When signing is disabled, chezmoi omits `commit.gpgsign` and `user.signingKey` and does not import the backup. A secret key imported by an earlier configuration is left in the GnuPG keyring, but Git no longer selects it for automatic commit signing.

Confirm that the imported key can sign:

```sh
printf 'test\n' | gpg --clearsign
```

## Daily Use

```sh
# Inspect planned changes without writing them.
chezmoi diff

# Apply all managed files.
chezmoi apply

# Edit a managed target through chezmoi.
chezmoi edit ~/.zshrc

# Show source/target differences.
chezmoi status

# Enter the source directory to review and commit changes.
chezmoi cd
```

After changing source files, review the result before committing:

```sh
chezmoi diff
git status
git add -A
git commit -m "chore: update dotfiles"
```

## Troubleshooting

### Age decryption fails

Confirm that the identity exists, is the same identity used to derive the configured recipient, and has mode `0600`:

```sh
ls -l ~/.config/chezmoi/key.txt
chezmoi age-keygen --convert ~/.config/chezmoi/key.txt
chezmoi dump-config
```

The recipient printed by `chezmoi age-keygen --convert` must match `age.recipient` in `chezmoi dump-config`.

### Packages did not install

The Apple Silicon macOS bootstrap script installs Homebrew before applying `Brewfile`. If package installation fails, re-render and run the macOS package script:

```sh
chezmoi execute-template --file \
  "$(chezmoi source-path)/.chezmoiscripts/run_onchange_10_mac-homebrew-packages.sh.tmpl" \
  | bash
```

On Fedora, re-render and run the DNF package script:

```sh
chezmoi execute-template --file \
  "$(chezmoi source-path)/.chezmoiscripts/run_onchange_10_fedora-dnf-packages.sh.tmpl" \
  | bash
```
