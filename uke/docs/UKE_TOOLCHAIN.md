Here is the unified **UKE v8 Toolchain** documentation.

I have consolidated the active toolchain and the comprehensive inventory into a single document. **Duplicate entries have been removed**: if a tool appears in Sections 1–7 (Active), it was removed from Section 8 (Roadmap/Inventory) to ensure a clean list.

***

# UKE v8 Toolchain

This project relies on a specific set of tools to unify the workflow between macOS and Arch Linux.

## 1. Core Infrastructure
These tools are the foundation of the deployment and management system.

| Tool | Purpose |
| :--- | :--- |
| **GNU Stow** | Symlink farm manager. The engine behind `installation_manager.sh`. Manages dotfiles without copying them. |
| **Git** | Version control. |
| **Bash** | Used for all installation, maintenance, and utility scripts (`uke-*`). |
| **JQ** | Command-line JSON processor. Critical for parsing window manager state (Yabai/Hyprland) in scripts like `uke-gather`. |

## 2. Shell & Terminal
The cross-platform interactive environment.

| Tool | Purpose |
| :--- | :--- |
| **WezTerm** | GPU-accelerated terminal emulator. Configured via Lua to handle the "Secondary" modifier layer. |
| **Zsh** | The default shell. Configured with a unified `.zshrc`. |
| **Tmux** | Terminal multiplexer. Handles session management (persistence) and splits. |
| **Starship** | Cross-shell prompt. Provides the visual status bar in the shell. |
| **Zoxide** | Smarter `cd`. Remembers frequently used directories for fast navigation. |

## 3. Platform Specifics

### The "Mac Stack" (macOS)
| Tool | Purpose |
| :--- | :--- |
| **Yabai** | Tiling window manager. Handles window placement and spaces. |
| **Skhd** | Hotkey daemon. Intercepts keyboard input to drive Yabai and system actions. |
| **Homebrew** | Package manager used to install prerequisites. |
| **JankyBorders** | *(Optional)* Draws colored borders around focused windows. |

### The "Wayland Stack" (Arch Linux)
| Tool | Purpose |
| :--- | :--- |
| **Hyprland** | Wayland compositor (Window Manager). Replaces Yabai. |
| **Waybar** | Status bar for Hyprland. |
| **Keyd** | System-level key remapping daemon. Handles the "CapsLock to Nav Layer" logic. |
| **Wofi** | Application launcher (dmenu/rofi alternative for Wayland). |
| **Pacman / Yay** | Package managers (System & AUR). |

## 4. Modern CLI Utilities
UKE replaces standard unix tools with modern Rust/Go alternatives in `.zshrc`.

| Command | Replaces | Description |
| :--- | :--- | :--- |
| **Eza** | `ls` | Modern file lister with icons, git status, and tree views. |
| **FZF** | `grep`/History | Command-line fuzzy finder. Used for history search, file navigation, and process killing. |
| **Bat** | `cat` | Cat clone with syntax highlighting and git integration. |
| **Fd** | `find` | Faster alternative to find, used by FZF for file indexing. |
| **Ripgrep** | `grep` | Faster search tool, used alongside FZF. |

## 5. Editors & Viewers
| Tool | Purpose |
| :--- | :--- |
| **Neovim** | The primary text editor. Sourced as `v` or `vim`. |
| **Zathura** | PDF viewer (specifically for Linux/Hyprland workflow). |

## 6. System & Maintenance
| Tool | Purpose |
| :--- | :--- |
| **UKE Scripts** | Custom suite (`uke-doctor`, `uke-gather`, `uke-bunch`) located in `.local/bin`. |
| **Htop / Btop** | Process viewers/System monitors. |
| **Neofetch** | System information display. |

## 7. Fonts
* **JetBrains Mono Nerd Font**: Required for icons in the terminal, Starship prompt, and status bars.

---

## 8. Extended Inventory & Roadmap
The following tools are part of the comprehensive UKE inventory but are either optional, specialized, or waiting to be fully integrated into the core automation scripts.

### High Priority / Daily Drivers
*Tools that complement the core workflow established above.*

* **thefuck**: Auto-corrects console command errors.
* **tldr**: Simplified man pages with examples.
* **wikiman**: Offline search for Arch Wiki, Gentoo Wiki, man pages, and tldr.
* **direnv**: Loads environment variables automatically when entering directories.
* **dust**: Visual disk usage analyzer (tree view).
* **delta**: Syntax-highlighted git diff viewer.
* **lazygit**: Powerful Terminal UI (TUI) for git.
* **gh**: Official GitHub CLI.
* **just**: Modern command runner (simpler `make`).
* **entr**: Run arbitrary commands when files change.
* **hyperfine**: Command-line benchmarking (great for algorithm testing).
* **scc**: Fast line-of-code counter and complexity analyzer.
* **bandwhich**: Network bandwidth monitor by process.

### AI & LLMs (Terminal Based)
* **ollama**: Run local LLMs (Llama 3, etc.) offline on your M1.
* **aichat**: ChatGPT-like terminal interface.
* **aider**: AI pair programming in the terminal.
* **mods**: AI pipe processing.
* **github-copilot-cli**: Copilot for the shell.
* **qodo-command**: AI agents for code generation.

### Databases (SQL & NoSQL)
* **duckdb**: OLAP database (great for physics data analysis).
* **pgcli**: Postgres client with auto-completion.
* **mycli**: MySQL client with auto-completion.
* **redis-cli**: Redis client.
* **sqlite-cli**: SQLite client.
* **dblab**: Database lab for cloning/testing.
* **gobang**: TUI for database management.

### Rust & Code Dev Utilities
* **bacon**: Background Rust compiler (watch mode).
* **cargo**: Rust package manager.
* **rustup**: Rust toolchain installer.
* **asdf**: Version manager for multiple languages (Node, Python, Ruby, etc.).
* **tokei** / **loc**: Alternatives to `scc` (code counting).
* **onefetch**: Git repository summary (like neofetch for code).
* **grex**: Generate regular expressions from test cases.
* **git-cliff**: Changelog generator.
* **gitui**: Extremely fast Git TUI (Alternative to lazygit).
* **interactive-rebase-tool**: Visual git rebase editor.

### Security & Encryption
* **gpg**: Gnu Privacy Guard.
* **age** / **rage**: Simple, modern file encryption.
* **bitwarden-cli**: Password manager CLI.
* **nmap**: Network scanner.
* **openssl**: Crypto toolkit.
* **ssh-keyscan**: Gather SSH public keys.

### Networking & Web
* **httpie** / **xh**: User-friendly HTTP clients (xh is the Rust version).
* **aria2**: High-speed download utility.
* **wget**: Classic file downloader.
* **ngrok**: Tunnel localhost to the web.
* **dog**: Modern DNS lookup (alternative to `dig`).
* **gping**: Ping with a graph.
* **atac**: Postman-like API client in terminal.
* **step-ci** / **tavern**: API testing frameworks.
* **wuzz**: Interactive HTTP inspector.

### Productivity & Organization
* **taskwarrior** / **vit**: Command line TODO list + TUI.
* **nb**: CLI note-taking with encryption and git syncing.
* **jrnl**: CLI journaling.
* **calcure**: TUI calendar.
* **obsidian** / **logseq**: (GUI apps referenced in notes).

### Science, Math & Binary Analysis
* **julia**: High-performance scientific language.
* **octave**: Open-source Matlab alternative.
* **hexyl**: Command-line hex viewer.
* **pandoc**: Document converter (LaTeX/Markdown).
* **graphviz**: Graph visualization software.
* **ffmpeg**: Video/audio processing.
* **imagemagick**: Image manipulation.

### Containers & Cloud
* **lazydocker**: TUI for Docker.
* **k9s**: TUI for Kubernetes.
* **aws-cli** / **az** / **gcloud**: Cloud provider CLIs.
* **terraform** / **ansible**: Infrastructure as Code.
* **dive**: Docker image layer inspector.

### Alternatives & Redundant Tools (Reference)
*Alternatives to the current stack, listed for reference but not installed by default.*

* **File Managers:** `ranger`, `nnn`, `lf`, `mc`, `xplr`, `yazi`.
* **Multiplexers:** `zellij`, `screen` (Alternatives to `tmux`).
* **Text Editors:** `micro`, `nano`, `helix` (Alternatives to `neovim`).
* **Monitoring:** `glances`, `bottom`, `gtop` (Alternatives to `btop`).
* **Disk Usage:** `duf`, `ncdu`, `dua-cli` (Alternatives to `dust`).

### Incompatible / Native Tools (Do Not Install)
* **Linux Specifics:** `perf`, `strace`, `ltrace`, `free`, `vmstat`, `iostat`.
* **Language Managers:** `python`/`pip` (Use `conda` or `pyenv`), `ruby`, `perl`.
* **Build Tools:** `make` (Use Xcode CLI tools).

### Visuals ("Just for Fun")
* `cmatrix`, `cowsay`, `sl`, `figlet`, `toilet`, `asciiquarium`, `pipes.sh`, `lolcat`.

### Next Step
Would you like me to create an **interactive installation script** (e.g., `uke-extras`) that iterates through these specific "Extended Inventory" categories (AI, Science, Dev, etc.) and allows you to toggle them on or off?