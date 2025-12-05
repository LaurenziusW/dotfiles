# GNU Stow Guide for UKE

This project uses [GNU Stow](https://www.gnu.org/software/stow/) to manage dotfiles. Stow is a symlink farm manager which takes distinct packages of software and/or data located in separate directories on the filesystem, and makes them appear to be installed in the same place.

## Directory Structure

The repository is organized into "packages" that Stow manages.

```text
uke/
├── shared/       # Configurations used on all platforms
│   ├── .zshrc
│   ├── .config/
│   │   ├── nvim/
│   │   └── tmux/
├── mac/          # macOS-specific configurations
│   ├── .config/
│   │   ├── yabai/
│   │   └── skhd/
└── arch/         # Arch Linux-specific configurations
    ├── .config/
    │   ├── hypr/
    │   └── waybar/
```

When you run the installation script, Stow creates symbolic links from these directories to your home directory (`~`).

## How it Works

Stow mirrors the structure of the source directory into the target directory (your `$HOME`).

### Example: Shared Configs
If you have `uke/shared/.config/nvim/init.lua`, running stow on `shared` will create:
`~/.config/nvim` -> Symlink to `.../uke/shared/.config/nvim`

**Note:** Stow uses "directory folding" by default. If `~/.config` already exists, it won't symlink the whole `.config` folder. Instead, it will look inside and symlink only the subdirectories (like `nvim`) that are inside the source package.

## Managing Symlinks

### 1. Installing / Updating
We recommend using the provided manager script, which handles platform selection and safety checks:

```bash
./installation_manager.sh install
```

This runs the equivalent of:
```bash
cd uke/shared && stow -R -t ~ .
cd uke/mac    && stow -R -t ~ .  # if on macOS
```
* `-R` (Restow): Useful for pruning obsolete links and updating the tree.
* `-t ~` (Target): Tells stow to install to your home directory.

### 2. Adding a New Config
To add a new dotfile (e.g., `.myconfig`), determine if it's shared or platform-specific, then create the file inside the corresponding folder, mimicking the home directory structure.

**Correct:**
`uke/shared/.myconfig`
`uke/shared/.config/app/config.toml`

**Incorrect:**
`uke/.myconfig` (Stow won't see this)

After creating the file, run `./installation_manager.sh install` to link it.

### 3. removing a Config
1. Delete the file from the `uke` repository.
2. Run `./installation_manager.sh install`. Stow will detect the missing file and remove the dead symlink from your home directory.

### 4. Ignoring Files
Stow can sometimes conflict with system files like `.DS_Store` or `.git`. We use `.stow-local-ignore` files in each package directory to prevent this.

Example `.stow-local-ignore`:
```text
\.DS_Store
\.git
LICENSE
README.md
```

## Troubleshooting

### "Conflict" Errors
If you see an error like:
`existing target is neither a link nor a directory: .config/nvim`

This means you have a real file (not a symlink) at `~/.config/nvim` that blocks Stow from creating its link.
**Solution:**
1. Back up your existing config.
2. Delete the conflicting file/folder.
3. Run `./installation_manager.sh install` again.

Alternatively, use the wipe command (WARNING: Deletes existing configs):
```bash
./installation_manager.sh wipe
```

### Directory Folding
If `~/.config/nvim` is a symlink to `uke/shared/.config/nvim`, any new file you create inside `~/.config/nvim` is actually created inside the repo. This is the desired behavior!

However, if `~/.config/nvim` is a *real directory*, and only `init.lua` is a symlink, then creating `plugin.lua` next to it will verify it exists only in `~`, not in your repo.
*Check `installation_manager.sh status` to see if your directories are correctly linked.*
