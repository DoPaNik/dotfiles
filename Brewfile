# Homebrew Bundle — https://docs.brew.sh/Brew-Bundle-and-Brewfile
# Install: ./install.sh packages   (or: brew bundle install --no-upgrade)

tap 'ddev/ddev'

# adopt: take over apps that were installed by hand instead of failing
cask_args appdir: '/Applications', adopt: true

# Shell & basics
brew 'coreutils' # GNU File, Shell, and Text utilities (first in PATH, see zsh/path.zsh)
brew 'findutils' # GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew 'lsd' # Clone of ls with colorful output, file type icons, and more
brew 'bat' # Cat on steroids
brew 'tree' # Display directories as trees
brew 'watch' # Executes a program periodically, showing output fullscreen
brew 'wget' # Internet file retriever
brew 'jq' # Lightweight and flexible command-line JSON processor
brew 'fzf' # Fuzzy search
brew 'zsh-completions' # Additional completion definitions for zsh
brew 'starship' # Cross-shell prompt
brew 'mise' # Version manager for Python, Node.js & co (see home/.config/mise)

# Git + GitHub
brew 'git'
brew 'gh' # GitHub CLI (successor of hub)

# Repo tooling
brew 'pre-commit' # Git hook manager (see .pre-commit-config.yaml)
brew 'shellcheck' # Static analysis for shell scripts

# Container
brew 'podman' # Daemonless container engine for developing, managing, and running OCI Containers
brew 'dive' # Exploring each layer in an image

# Kubernetes
brew 'kubernetes-cli' # kubectl
brew 'helm' # Kubernetes package manager
brew 'k9s' # Kubernetes CLI to manage your clusters in style
brew 'krew' # Package manager for kubectl plugins
brew 'kubectx' # Switch between kubectl contexts and namespaces
brew 'popeye' # A Kubernetes cluster sanitizer
brew 'stern' # Tail multiple Kubernetes pods & their containers

# PHP
brew 'php'
brew 'composer' # Dependency manager for PHP
brew 'ddev/ddev/ddev' # A local PHP development environment system

# Azure
cask 'azure-cli'

# Applications
cask '1password'
cask 'alfred'
cask 'bartender'
cask 'chatgpt'
cask 'claude'
cask 'claude-code'
cask 'cyberghost-vpn'
cask 'dropbox'
cask 'elgato-stream-deck'
cask 'elgato-wave-link'
cask 'firefox'
cask 'iterm2'
cask 'jump-desktop-connect'
cask 'lm-studio'
cask 'obsidian'
cask 'spotify'
cask 'supacode'
cask 'visual-studio-code'

# Fonts
cask 'font-hack-nerd-font' # Prompt glyphs for Starship
cask 'font-open-sans'
cask 'font-roboto'
cask 'font-roboto-condensed'
cask 'font-source-code-pro'
