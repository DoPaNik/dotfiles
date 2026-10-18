# dotfiles

Provisioning for my Mac (Apple Silicon, macOS 26+): Homebrew packages, zsh with
Oh My Zsh + Starship, mise runtimes, Git config and macOS settings.

Every step checks the current state first and only changes what differs, so
`./install.sh` can be run again at any time. A second run should report
`0 changed`.

## Usage

```bash
git clone git@github.com:DoPaNik/dotfiles.git ~/Documents/Github/dotfiles
cd ~/Documents/Github/dotfiles
./install.sh --dry-run      # show what would change
./install.sh                # run all steps
./install.sh shell git      # run selected steps
./install.sh --list         # list steps
```

| Step | What it does |
|---|---|
| `preflight` | macOS, Apple Silicon, Command Line Tools, admin rights |
| `homebrew` | installs Homebrew if missing |
| `packages` | `brew bundle` with the [Brewfile](Brewfile), reports extra packages |
| `shell` | Oh My Zsh, links `~/.zshrc`, `~/.zprofile`, `~/.config/starship.toml`, `~/.dotfiles` |
| `git` | links `~/.gitconfig` and the global ignore file |
| `mise` | links `~/.config/mise/config.toml`, installs Python and Node.js |
| `macos` | user settings from `macos/user-*.sh`, restarts only changed apps |
| `system` | system settings from `macos/system.sh` (sudo) |

Files that are replaced by a link are moved to `~/.dotfiles-backup/<timestamp>/`.

## Layout

```
install.sh        entry point
lib/common.sh     helpers: link_file, set_default, set_pref_path, set_pmset, dry-run
steps/            one file per step
macos/            macOS settings, split by area
home/             files linked into $HOME
zsh/              sourced by Oh My Zsh (ZSH_CUSTOM): aliases, PATH, tools
Brewfile          packages, apps and fonts
```

## Manual steps

- Run `./install.sh` from iTerm2 and give it two permissions first
  (*System Settings → Privacy & Security*), then restart iTerm2:
  - *App Management*: needed to adopt apps that were installed by hand
  - *Full Disk Access*: needed by `systemsetup` in the `system` step
- Git identity: `~/.gitconfig.local` with `user.name` and `user.email`
- Log out and in again after the first run: language, keyboard repeat and
  the new fonts only take effect then
- iTerm2: set the font to *Hack Nerd Font Mono*
- Machine specific shell settings go into `~/.zshrc.local`
