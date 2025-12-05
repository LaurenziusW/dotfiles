Here is the updated **UKE v8 Toolchain** documentation, incorporating the potential new tools at the end as requested.

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







## 8. Potential Additions (Not Yet Utilized)


Yes, **many** packages were missing from the previous "New" list because I initially filtered them to show only the "highest impact" tools. Since you want a **complete inventory** (every unique tool mentioned in your texts) without duplicates, I have regenerated the full list below.

I have organized them by **Priority** (Best-in-Class/Modern) vs. **Extended** (Alternatives/Niche) so you still have a clear path for installation, but **every single tool** from your notes is accounted for here.

***

### 1. The "Must-Have" Core (Modern Daily Drivers)
*These are the best-in-class tools for your M1 Mac, CS/Physics workflow, and Neovim setup.*

**Navigation & Shell**
* **zoxide**: Smarter `cd` that remembers directory history.
* **fzf**: Fuzzy finder. Essential for Neovim and shell history.
* **starship**: High-performance, customizable shell prompt.
* **thefuck**: Auto-corrects console command errors.
* **tldr**: Simplified man pages with examples.
* **bat**: `cat` clone with syntax highlighting and Git integration.
* **direnv**: Loads environment variables automatically when entering directories.

**File Operations & Search**
* **ripgrep (rg)**: The fastest grep. Essential for coding.
* **fd**: User-friendly, faster alternative to `find`.
* **lsd** (or **eza**): Modern `ls` with icons.
* **dust**: Visual disk usage analyzer (tree view).
* **delta**: Syntax-highlighted git diff viewer.

**Git & Version Control**
* **lazygit**: Powerful Terminal UI (TUI) for git.
* **gh**: Official GitHub CLI.

**Development & Physics**
* **just**: Modern command runner (simpler `make`).
* **entr**: Run arbitrary commands when files change.
* **hyperfine**: Command-line benchmarking (great for algorithm testing).
* **scc**: Fast line-of-code counter and complexity analyzer.
* **jq**: Command-line JSON processor.

**System Monitoring**
* **btop**: The best visual resource monitor (CPU/GPU).
* **bandwhich**: Network bandwidth monitor by process.

---

### 2. The Extended Arsenal (Restored Packages)
*These are valuable tools from your old list that are specific, niche, or alternatives to the core tools.*

**AI & LLMs (Terminal Based)**
* **ollama**: Run local LLMs (Llama 3, etc.) offline on your M1.
* **aichat**: ChatGPT-like terminal interface.
* **aider**: AI pair programming in the terminal.
* **mods**: AI pipe processing.
* **github-copilot-cli**: Copilot for the shell.
* **qodo-command**: AI agents for code generation.

**Databases (SQL & NoSQL)**
* **duckdb**: OLAP database (great for physics data analysis).
* **pgcli**: Postgres client with auto-completion.
* **mycli**: MySQL client with auto-completion.
* **redis-cli**: Redis client.
* **sqlite-cli**: SQLite client.
* **dblab**: Database lab for cloning/testing.
* **gobang**: TUI for database management.

**Rust & Code Dev Utilities**
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

**Security & Encryption**
* **gpg**: Gnu Privacy Guard.
* **age** / **rage**: Simple, modern file encryption.
* **bitwarden-cli**: Password manager CLI.
* **nmap**: Network scanner.
* **openssl**: Crypto toolkit.
* **ssh-keyscan**: Gather SSH public keys.

**Networking & Web**
* **httpie** / **xh**: User-friendly HTTP clients (xh is the Rust version).
* **aria2**: High-speed download utility.
* **wget**: Classic file downloader.
* **ngrok**: Tunnel localhost to the web.
* **dog**: Modern DNS lookup (alternative to `dig`).
* **gping**: Ping with a graph.
* **atac**: Postman-like API client in terminal.
* **step-ci** / **tavern**: API testing frameworks.
* **wuzz**: Interactive HTTP inspector.

**Productivity & Organization**
* **taskwarrior** / **vit**: Command line TODO list + TUI.
* **nb**: CLI note-taking with encryption and git syncing.
* **jrnl**: CLI journaling.
* **calcure**: TUI calendar.
* **obsidian** / **logseq**: (Usually GUI apps, but listed in your notes).

**Science, Math & Binary Analysis**
* **julia**: High-performance scientific language.
* **octave**: Open-source Matlab alternative.
* **hexyl**: Command-line hex viewer.
* **pandoc**: Document converter (LaTeX/Markdown).
* **graphviz**: Graph visualization software.
* **ffmpeg**: Video/audio processing.
* **imagemagick**: Image manipulation.

**Containers & Cloud**
* **lazydocker**: TUI for Docker.
* **k9s**: TUI for Kubernetes.
* **aws-cli** / **az** / **gcloud**: Cloud provider CLIs.
* **terraform** / **ansible**: Infrastructure as Code.
* **dive**: Docker image layer inspector.

---

### 3. Redundant / Lower Priority / Alternatives
*These are present in your list but functionally "covered" by better tools in Section 1, or are very specific.*

* **File Managers:** `ranger`, `nnn`, `lf`, `mc`, `xplr` (You likely only need one; `lf` or `yazi` are the modern fast ones).
* **Find/Search Alts:** `ack`, `grep` (use `rg`), `find` (use `fd`).
* **Multiplexers:** `tmux`, `zellij`, `screen` (Pick one. `tmux` is standard, `zellij` is modern).
* **Text Editors:** `micro`, `nano`, `helix`, `vim` (You use Neovim).
* **Monitoring Alts:** `htop`, `glances`, `bottom`, `gtop` (You have `btop`).
* **Disk Usage Alts:** `duf`, `ncdu`, `dua-cli` (You have `dust`).
* **Benchmark Alts:** `vegeta`, `k6`, `ab` (HTTP load testing, distinct from `hyperfine`).

---

### 4. Incompatible or "Built-in" (Do Not Install via Brew)
*These appeared in your old lists but are either Linux-specific or come pre-installed on macOS.*

* **Linux Package Managers:** `apt`, `pacman`, `dnf`, `yum`. (Use `brew`).
* **Linux-Specific System Tools:**
    * `perf` (Linux profiler; use `Instruments` on Mac).
    * `strace` / `ltrace` (Linux; macOS uses `dtruss` or `sc_usage`, though a limited `strace` exists in brew).
    * `free`, `vmstat`, `iostat` (BSD versions come pre-installed on Mac).
* **Pre-installed (or handled by specific environments):**
    * `python`, `pip` (Better managed via `pyenv` or `conda` to avoid messing up system Python).
    * `ruby`, `perl`.
    * `curl` (Pre-installed, though brew version is newer).
    * `make` (Comes with Xcode Command Line Tools).

---

### 5. "Just for Fun" (Visuals)
* `cmatrix`, `cowsay`, `sl`, `figlet`, `toilet`, `asciiquarium`, `pipes.sh`, `lolcat`, `neofetch`.

### Next Step
Since this list is massive (over 150 items), **would you like me to generate a categorized installation script** that asks you Yes/No for each *category* (e.g., "Install AI Tools?", "Install Rust Tools?") so you don't have to install everything at once?