# Dotfiles

Personal configuration managed with [chezmoi](https://www.chezmoi.io/). The source directory is the desired state; chezmoi renders templates and copies the result into the home directory.

The configuration currently targets macOS. Homebrew packages and applications are declared in the included `Brewfile`.

## Current Status

This is an active macOS workstation configuration. Applying it manages:

- shell, Git, SSH, Starship, Ghostty, Helix, lf, and Neovim configuration;
- a large Homebrew bundle of command-line tools, developer language servers, and desktop applications;
- age-encrypted `~/.ssh/id_ed25519` plus its public key;
- a Restic backup command and non-secret local/remote environment-file examples; and
- macOS keyboard-repeat, Dock, sound, and pointing-device defaults.

A macOS `run_once` script installs Homebrew when needed. `run_onchange` scripts then apply the Brewfile and macOS defaults; the Brewfile script is re-run when the Brewfile changes, and the defaults script is re-run when its source changes.

## Contents

- [Prerequisites](#prerequisites)
- [Bootstrap](#bootstrap)
- [Managed Configuration](#managed-configuration)
- [Encryption](#encryption)
- [Git Signing](#git-signing)
- [Backups](#backups)
- [Daily Use](#daily-use)
- [Troubleshooting](#troubleshooting)

## Prerequisites

- Internet access and `git`
- The age X25519 identity copied from 1Password **before** the first `chezmoi init --apply`

Chezmoi derives the corresponding public recipient from that identity during initialization, so it does not need to be copied or entered separately.

The private identity is not stored in this repository. Copy it to the default path with restrictive permissions:

```sh
mkdir -p ~/.config/chezmoi
umask 077
$EDITOR ~/.config/chezmoi/key.txt
chmod 600 ~/.config/chezmoi/key.txt
```

Paste the complete age identity into that file, save it, and do not commit or share it. The default path can be changed when chezmoi prompts for `Age identity file location`.

### macOS

The macOS scripts install Homebrew if it is not already available, then run `brew bundle` with this repository's `Brewfile`. The Brewfile includes age, chezmoi, 1Password, and 1Password CLI. 1Password is not needed to bootstrap encryption when the identity has already been copied into place.

## Bootstrap

Bootstrap from the `harleyjwilson` GitHub account (chezmoi resolves this shorthand to its `dotfiles` repository).

### macOS

```sh
# 1. Copy the age identity from 1Password to ~/.config/chezmoi/key.txt.
# 2. Install chezmoi, clone this source repository, prompt for configuration,
#    and apply the files.
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply harleyjwilson
```

For a local checkout, initialize and apply from that directory in one command:

```sh
chezmoi --source "$PWD" init --apply
```

On the first initialization, chezmoi asks for these non-secret values:

| Prompt                     | Purpose                                                          |
| -------------------------- | ---------------------------------------------------------------- |
| Email address              | Git email address                                                |
| Full name                  | Git author name                                                  |
| GPG key ID                 | Enables signed Git commits when supplied; leave empty to disable |
| Age identity file location | Local X25519 identity; defaults to `~/.config/chezmoi/key.txt`   |

The public X25519 recipient is derived from the identity file automatically and is written into `~/.config/chezmoi/chezmoi.toml`. The values are stored under `[data]`, so later `chezmoi init` runs do not ask again.

Verify the resulting configuration:

```sh
chezmoi dump-config
chezmoi diff
```

## Managed Configuration

| Source                                                                                   | Target            | Notes                                                                                                              |
| ---------------------------------------------------------------------------------------- | ----------------- | ------------------------------------------------------------------------------------------------------------------ |
| `dot_zshrc.tmpl`                                                                         | `~/.zshrc`        | Zsh completions, history, aliases, and integrations for Homebrew tools, fzf, zoxide, atuin, Starship, and Ghostty. |
| `dot_config/git/`                                                                        | `~/.config/git/`  | Global Git defaults, Delta pager, ignore file, identity template, and optional GPG signing.                        |
| `private_dot_ssh/`                                                                       | `~/.ssh/`         | Encrypted Ed25519 private key and matching public key.                                                             |
| `dot_config/ghostty/`, `dot_config/helix/`, `dot_config/lf/`, `dot_config/starship.toml` | `~/.config/…`     | Terminal, editor, file-manager, and prompt configuration.                                                          |
| `dot_config/nvim/`                                                                       | `~/.config/nvim/` | Mini.nvim-based Neovim setup, Tree-sitter, LSP settings, snippets, and format-on-demand support.                   |
| `bin/executable_backup`                                                                  | `~/bin/backup`    | Restic backup command.                                                                                             |

The Neovim configuration enables LSP integrations for Bash, CSS, Docker/Compose, Go, HTML, JSON, Lua, Markdown, Python, Rust, Svelte, Tailwind CSS, TOML, TypeScript, and YAML. The corresponding server packages are declared in the Brewfile where available.

## Encryption

`.chezmoi.toml.tmpl` configures chezmoi to use age asymmetric encryption with its built-in age implementation:

- X25519 identity file: `~/.config/chezmoi/key.txt` by default
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
export GPG_SECRET_KEY_FINGERPRINT=PRIMARY_KEY_FINGERPRINT
export GPG_SECRET_KEY_BACKUP=private_dot_gnupg/encrypted_gpg-secret-key.asc

mkdir -p "$(dirname "$GPG_SECRET_KEY_BACKUP")"
gpg --armor --export-secret-keys "$GPG_SECRET_KEY_FINGERPRINT" \
  | chezmoi encrypt --output "$GPG_SECRET_KEY_BACKUP"
chmod 600 "$GPG_SECRET_KEY_BACKUP"
git add "$GPG_SECRET_KEY_BACKUP"
```

## Git Signing

The initial chezmoi configuration asks for a GPG key ID. Supply the full fingerprint of a private key that is already available in your local GnuPG keyring; leave the prompt empty to disable Git commit signing.

On a machine initialized from this repository, `chezmoi apply` imports the encrypted backup automatically when the private key is absent. To import a key manually instead:

```sh
gpg --import /path/to/private-key.asc
```

List private keys and their long identifiers:

```sh
gpg --list-secret-keys --keyid-format=long
```

For example:

```text
sec   ed25519/ABCDEF1234567890 ...
      0123456789ABCDEF0123456789ABCDEF01234567
```

Use the full fingerprint on the indented line for the `GPG key ID` prompt. Confirm that the key can sign:

```sh
printf 'test\n' | gpg --clearsign
```

When a key ID is supplied, the Git configuration template sets `user.signingKey` and `commit.gpgsign = true`.

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

### Change the identity path

Re-run the config template prompt to derive a new recipient, then apply again:

```sh
chezmoi init --prompt
chezmoi apply
```

### Homebrew packages did not install

The macOS bootstrap script installs Homebrew before applying the Brewfile. If the package installation fails, re-run:

```sh
brew bundle --file="$(chezmoi source-path)/Brewfile"
```
