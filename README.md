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
./install.sh update         # upgrade packages, runtimes and Oh My Zsh
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
| `ai-buddy` | clones [ai-buddy](https://github.com/DoPaNik/ai-buddy) if missing, builds and installs it to `~/Applications` when the installed app is from another commit (needs Xcode) |
| `macos` | user settings from `macos/user-*.sh`, restarts only changed apps |
| `system` | system settings from `macos/system.sh` (sudo) |
| `update` | `brew upgrade`, `mise upgrade`, Oh My Zsh update; only runs when named |

Files that are replaced by a link are moved to `~/.dotfiles-backup/<timestamp>/`.

## CI

[`.github/workflows/ci.yml`](.github/workflows/ci.yml) runs on every push, pull
request and weekly: `shellcheck`, [`bin/check-brewfile`](bin/check-brewfile)
(fails when a formula or cask was renamed, removed or disabled) and
`./install.sh --dry-run` on a macOS runner.

## Layout

```
install.sh        entry point
bin/              helper scripts (check-brewfile)
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
- Xcode: install it from the App Store and open it once, then run
  `./install.sh ai-buddy`. In AI Buddy (glasses icon in the menu bar) turn on
  *Beim Login starten* and set up the Claude status line.

### Docker runtime for ddev (once)

ddev runs on [Colima](https://github.com/abiosoft/colima) (Docker engine in a
VM) with the Homebrew `docker` CLI. Projects must live below `$HOME`.

```bash
# Let the Docker CLI find the Homebrew buildx plugin
mkdir -p ~/.docker && echo '{"cliPluginsExtraDirs": ["/opt/homebrew/lib/docker/cli-plugins"]}' > ~/.docker/config.json

# Create and start the VM (settings recommended by ddev), creates the "colima" docker context
colima start --cpu 4 --memory 6 --disk 100 --vm-type=vz --mount-type=virtiofs --dns=1.1.1.1

# No usage statistics to the ddev developers
ddev config global --instrumentation-opt-in=false

# Trust ddev's local HTTPS certificates (asks for your password)
mkcert -install
```

After a reboot run `colima start` again.
