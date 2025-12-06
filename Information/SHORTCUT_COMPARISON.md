# Shortcut Comparison: macOS vs Arch (Hyprland)

This document analyzes the differences in keyboard shortcuts between the macOS (`skhd`) and Arch Linux (`hyprland`) configurations found in the dotfiles.

## Definitions

*   **Primary Modifier**:
    *   **macOS**: `Cmd` (Command)
    *   **Arch**: `ALT` (defined as `$mainMod`)
*   **Secondary/Shift**: `Shift`
*   **Tertiary**: `Alt` (on macOS).

**Note on Arch Primary Key:** Since Arch defines `$mainMod = ALT`, "Primary" and "Alt" are the same physical key. This causes "Primary + Shift" and "Alt + Shift" to be identical on Arch, whereas they are distinct combinations on macOS (`Cmd+Shift` vs `Alt+Shift`).

## Conflict Analysis

### 1. The `Primary + Shift + R` Conflict
*   **macOS (`Cmd+Shift+R`)**: `yabai -m space --rotate 90` (Rotates the window layout).
*   **Arch (`Alt+Shift+R`)**: `exec, hyprctl reload` (Reloads the Hyprland configuration).
*   **Status**: **NOT UNIFIED**.
*   **Recommendation**:
    *   Change Arch reload to something else (e.g., `Primary + Shift + C` or `Primary + Alt + R` if possible).
    *   Or change Mac rotate to match.

### 2. The `Primary + Shift + S` Situation
*   **macOS (`Cmd+Shift+S`)**: `$HOME/.local/bin/uke-sticky toggle` (Toggles sticky/pinned window).
*   **Arch (`Alt+Shift+S`)**: `exec, ~/.local/bin/uke-sticky toggle` (Toggles sticky/pinned window).
*   **Status**: **Technically Unified**, but problematic.
    *   **Issue**: On macOS, `Cmd+Shift+S` is a standard system shortcut for "Save As". Using it for window management might conflict with active applications unless `skhd` consumes the event completely (which it usually does).
    *   **Mac Conflict**: The `skhdrc` file also has a **double binding** for `cmd + ctrl - s`:
        1. `yabai -m window --insert stack`
        2. `$HOME/.local/bin/uke-session save quick`
        *One of these will not work.*

### 3. The Move vs. Resize Collision (CRITICAL ARCH ISSUE)
*   **macOS**:
    *   **Move Window**: `Cmd + Shift + hjkl` (Primary + Shift)
    *   **Resize Window**: `Alt + Shift + hjkl` (Tertiary + Shift)
*   **Arch**:
    *   **Move Window**: `$mainMod SHIFT + hjkl` (Alt + Shift)
    *   **Resize Window**: `$mainMod SHIFT + hjkl` (Alt + Shift)
*   **Status**: **BROKEN on Arch**.
    *   Because Primary is `Alt` on Arch, the config binds the *same keystroke* (`Alt+Shift+h`) to *both* `movewindow` and `resizeactive`. Hyprland will likely only execute one, rendering the other impossible.
    *   **Recommendation**: Change Arch `$mainMod` to `SUPER` (Windows key) to allow `Alt` to be used for resizing, mimicking the Mac structure (`Super` = `Cmd`). Or use a specific submap for resizing.

## Comparison Table

| Action | macOS Shortcut (`Cmd` based) | Arch Shortcut (`Alt` based) | Unified? |
| :--- | :--- | :--- | :--- |
| **Window Focus** | `Cmd + h/j/k/l` | `Alt + h/j/k/l` | ✅ Yes (conceptually) |
| **Move Window** | `Cmd + Shift + h/j/k/l` | `Alt + Shift + h/j/k/l` | ⚠️ Collision in Arch |
| **Resize Window** | `Alt + Shift + h/j/k/l` | `Alt + Shift + h/j/k/l` | ⚠️ Collision in Arch |
| **Fullscreen** | `Cmd + Shift + f` | `Alt + Shift + f` | ✅ Yes |
| **Toggle Float** | `Cmd + Shift + Space` | `Alt + Shift + Space` | ✅ Yes |
| **Toggle Split** | `Cmd + Shift + \` | `Alt + Shift + \` | ✅ Yes |
| **Rotate Layout** | `Cmd + Shift + r` | *(Mapped to Reload)* | ❌ **NO** |
| **Reload Config** | `Cmd + Alt + s` | `Alt + Shift + r` | ❌ **NO** |
| **Sticky Toggle** | `Cmd + Shift + s` | `Alt + Shift + s` | ✅ Yes |
| **Terminal** | `Cmd + Return` | `Alt + Return` | ✅ Yes |
| **Launcher** | `Cmd + Alt + [key]` | `Alt + Alt + [key]` (Invalid) | ❌ Inconsistent* |
| **Workspaces** | `Cmd + 0-9` | `Alt + 0-9` | ✅ Yes |
| **Move to Space**| `Cmd + Shift + 0-9` | `Alt + Shift + 0-9` | ✅ Yes |
| **Gather Windows**| `Cmd + 	` (Grave) | `Alt + 	` (Grave) | ✅ Yes |

*	Launcher Note*: Arch config has `bind = $mainMod ALT, [key]`. Since `$mainMod` is `ALT`, this means `ALT + ALT + [key]`, which is just `ALT + [key]`. This overlaps with other bindings or might not work as intended.

## Action Items

1.  **Resolve Arch Primary Key**: Consider changing `$mainMod` to `SUPER` in `common.conf` to match the `Cmd` key on Mac and free up `Alt` for other uses.
2.  **Fix Arch Overlaps**: Separate Move (`Main+Shift`) and Resize bindings.
3.  **Fix Mac Duplicates**: Resolve the double binding for `cmd + ctrl - s`.
4.  **Harmonize Reload/Rotate**: Pick one shortcut for Reload (e.g., `Primary + Shift + Escape`) and one for Rotate.
