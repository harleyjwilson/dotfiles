# dotfiles

Arch Linux Sway configuration for this laptop.

## Restore

Clone the repository, install the official packages, then install `yay` using the
[Arch Wiki instructions](https://wiki.archlinux.org/title/AUR_helpers) and restore
AUR packages and Flatpaks:

```sh
mkdir -p ~/projects/hjw
git clone https://github.com/harleyjwilson/dotfiles ~/projects/hjw/dotfiles
cd ~/projects/hjw/dotfiles
sudo pacman -S --needed - < pacman_-Qqen
yay -S --needed - < yay_-Qqem
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
while IFS=$'\t' read -r app branch remote; do
  flatpak install --noninteractive --or-update "$remote" "$app//$branch"
done < flatpak_list_--app_--columns_application_branch_origin
cp .zshrc ~/.zshrc
```

Restart Zsh with `exec zsh`, then run `dotfiles-update-local` and confirm the
prompt. The command copies the tracked home files and selected XDG configuration
into place.

Use `dotfiles-update-remote` to capture the current configuration and package
inventories. It refuses to run while the repository has uncommitted changes.

## Backups

`backup-hdd` and `backup-s3` use a local profile at
`~/.config/resticprofile/profiles.yaml`. Install and verify the upstream
[resticprofile](https://github.com/creativeprojects/resticprofile/releases) binary
on `PATH` (normally `~/.local/bin/resticprofile`), then create the local profile
and private secrets:

```sh
install -d -m 700 ~/.config/resticprofile/secrets
cp ~/.config/resticprofile/profiles.yaml.example ~/.config/resticprofile/profiles.yaml
cp ~/.config/resticprofile/secrets/hdd.password.example ~/.config/resticprofile/secrets/hdd.password
cp ~/.config/resticprofile/secrets/s3.password.example ~/.config/resticprofile/secrets/s3.password
cp ~/.config/resticprofile/secrets/s3.env.example ~/.config/resticprofile/secrets/s3.env
chmod 600 ~/.config/resticprofile/secrets/{hdd.password,s3.password,s3.env}
```

Replace every `REPLACE_WITH_...` value and review the local-drive path before
initialising a repository. Inspect it with
`resticprofile --config ~/.config/resticprofile/profiles.yaml --name hdd show`,
then initialise it with the same command ending in `init`. The local profile and
real secret files are ignored by Git. Update the binary with `resticprofile self-update`.
