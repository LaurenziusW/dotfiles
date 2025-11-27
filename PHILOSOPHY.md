# Philosophy: Unified Keyboard Environment

This document explains the core design principles, decision-making rationale, and conceptual foundations of the Unified Keyboard Environment.

## 🎯 Core Mission

**Enable deep, focused work by eliminating context-switching friction and cognitive overhead in computing environments.**

Every design decision flows from this central goal. The system should disappear into muscle memory, allowing your mind to stay in flow state.

---

## 🏛️ Foundational Principles

### 1. The Modifier Hierarchy

**Problem**: Traditional desktop environments create chaos by mixing system-level window management with application-level shortcuts. Press `Ctrl+H` in a terminal and it might delete a character. Press it in your window manager and it focuses left. This conflict forces constant mental translation.

**Solution**: Strict hierarchical separation of concerns via modifier keys.

```
┌─────────────────────────────────────────────────────────┐
│ TERTIARY (Super/Cmd+Alt)                                │
│ ↓ System-level actions: Launchers, bunches, utilities  │
├─────────────────────────────────────────────────────────┤
│ PRIMARY (Alt/Cmd)                                       │
│ ↓ Window management: Focus, move, resize, workspaces   │
├─────────────────────────────────────────────────────────┤
│ SECONDARY (Ctrl)                                        │
│ ↓ Application control: Terminal, editor, multiplexer   │
└─────────────────────────────────────────────────────────┘
```

**The Golden Rule**: These layers NEVER overlap. Ctrl belongs exclusively to applications. Alt/Cmd belongs exclusively to window management. Super handles system orchestration.

**Why This Works**:
- **Zero Cognitive Load**: Your fingers know which modifier to reach for based on what you're trying to accomplish
- **Muscle Memory Transfers**: Learn once, works everywhere (terminal, editor, browser)
- **No Surprises**: Pressing `Ctrl+H` always does the same thing in every context

### 2. Cross-Platform Consistency

**Problem**: macOS uses Cmd, Linux uses Alt/Super. Switching between platforms breaks your workflow and requires retraining muscle memory.

**Solution**: Abstract the concept of "primary window management modifier" and map it appropriately per platform.

```bash
# In our system:
# macOS:  Cmd = PRIMARY    Alt = SECONDARY    Cmd+Alt = TERTIARY
# Linux:  Alt = PRIMARY    Ctrl = SECONDARY   Super = TERTIARY

# Same mental model, different physical keys
```

**Implementation**: The `lib-os-detect` script provides platform-aware primitives. Write once, run everywhere.

**Why This Matters**: 
- Developers and students often use both macOS and Linux
- Your workflow becomes platform-agnostic
- No mental translation when switching machines

### 3. Vim Everywhere

**Problem**: Arrow keys require hand movement away from home row. This breaks flow and slows you down.

**Solution**: Use `h/j/k/l` for all directional navigation (windows, panes, text).

**Rationale**:
- **Efficiency**: Fingers never leave home row
- **Consistency**: Same motions in window manager, terminal, editor
- **Scalability**: Easy to extend to diagonal movements (e.g., `Alt+Shift+H` for "move window left")

**Example Flow**:
```
1. Alt+H to focus terminal window (left)
2. Ctrl+A then H to focus left tmux pane
3. In Nvim, type 'h' to move cursor left
```

Same mental model, three different contexts. Your brain doesn't context-switch.

### 4. Workspaces as Contexts, Not Desktops

**Problem**: Traditional "desktops" are spatial metaphors that require you to remember "what's on desktop 3?" This creates mental overhead.

**Solution**: Semantic workspace assignments. Apps auto-route to their conceptual space.

```
Space 1: Browser     → "I need to look something up"
Space 2: Notes       → "I need to write/reference notes"  
Space 3: Code        → "I need to write/run code"
Space 6: Catch-all   → "Random stuff I opened"
```

**Why It Works**:
- **Predictability**: You always know where to find things
- **Auto-organization**: New windows appear in the right place automatically
- **Mental Model Matches Task**: "I need to code" → `Alt+3` → Terminal/Editor ready

**Key Insight**: Space 6 is the "junk drawer." Everything that doesn't fit elsewhere goes there. This prevents pollution of semantic spaces while still being organized.

### 5. Single Source of Truth

**Problem**: Configuration drift. You tweak something on your laptop, forget about it, then wonder why your desktop behaves differently.

**Solution**: All configs live in `~/dotfiles`. Local changes are considered "drift" and are automatically backed up before enforcement.

**Git as the Authority**: 
```bash
# The pattern:
1. Make changes in ~/dotfiles
2. Test locally
3. Commit and push
4. Pull and ./install.sh on other machines
```

**Stow as the Enforcer**:
- Symlinks (not copies) ensure the repo is always the active config
- Changes in the repo instantly affect your system
- No sync lag, no "did I copy the latest version?"

**Drift Protection**: 
```bash
# If you accidentally edit ~/.zshrc instead of ~/dotfiles/zsh/.zshrc:
./install.sh  # Detects conflict, backs up your change, restores the link
```

**Philosophy**: Local modifications are treated as experiments. Promote good experiments to the repository; discard bad ones.

### 6. Environment Bunches: Context Loading

**Problem**: Starting a deep work session requires:
1. Opening 5 different apps
2. Arranging them across workspaces
3. Navigating to project directories
4. Starting background services

This takes 2-3 minutes and breaks pre-focus.

**Solution**: "Bunches" - executable bash scripts that orchestrate your environment.

```bash
# Example: study-math.sh
1. Opens Obsidian to math notes (Space 2)
2. Opens browser for research (Space 1)
3. Opens terminal in project directory (Space 3)
4. Opens PDF reader with textbook (Space 5)
5. Returns focus to notes

# One keystroke: Cmd+Ctrl+1
# 30 seconds later: Entire environment ready
```

**Why Scripts, Not GUIs**:
- **Composability**: Bunches can call other scripts
- **Version Control**: Bunch definitions live in Git
- **Cross-Platform**: Same script works on macOS and Linux (via `lib-os-detect`)
- **Extensibility**: Easy to add custom logic

**Philosophy**: Your work contexts should be **one-button deployable**. Creativity starts when setup ends.

### 7. Keyboard-Centricity

**Problem**: Mouse usage is:
- Slower (hand movement)
- Imprecise (fine motor control)
- Attention-demanding (visual targeting)

**Solution**: Keyboard shortcuts for 99% of actions.

**The 1% Exception**: Some tasks are genuinely mouse-native (graphic design, photo editing). Don't fight it. But for text, code, browsing, communication? Keyboard always wins.

**Implementation**:
- Caps Lock → Esc (wasted key reclaimed)
- Caps Lock + H/J/K/L → Arrow keys (system-wide, via keyd/Karabiner)
- Alt/Cmd + Backtick → `gather-current-space` (cleanup shortcut)

**Ergonomics**: The less your hands move, the longer you can work without fatigue.

---

## 🧠 Design Patterns

### Pattern: Spatial Consistency

**Principle**: Same key combination should do "conceptually the same thing" regardless of context.

**Examples**:
- `Alt+H`: Focus window to the left (WM), Focus pane to the left (Terminal), Move cursor left (Editor)
- `Alt+1-9`: Switch to workspace 1-9 (WM), Switch to tab 1-9 (Terminal)

**Why**: Reduces cognitive load. You're not memorizing different shortcuts per app, you're learning one spatial model.

### Pattern: Shift as Intensifier

**Principle**: Adding Shift makes an action "stronger" or "more permanent."

**Examples**:
- `Alt+3`: Go to workspace 3
- `Alt+Shift+3`: Move window to workspace 3 (and follow)
- `Alt+H`: Focus left
- `Alt+Shift+H`: Move window left

**Why**: Logical, easy to remember, scales to new shortcuts naturally.

### Pattern: Progressive Disclosure

**Principle**: Common actions use simple shortcuts. Advanced actions require modifier combinations.

**Examples**:
```
Common:     Alt+F         (Fullscreen)
Uncommon:   Alt+Shift+R   (Rotate tree 90°)
Rare:       Alt+Ctrl+T    (Toggle layout BSP/Stack)
```

**Why**: Beginners aren't overwhelmed. Power users have full control.

---

## 🚫 Anti-Patterns (What We Avoid)

### ❌ The "Swiss Army Knife" Trap

**Bad**: One tool that tries to do everything (window manager + compositor + status bar + launcher + terminal).

**Our Approach**: Best-of-breed tools, loosely coupled.
- Yabai (WM) + skhd (hotkeys) on macOS
- Hyprland (compositor) on Linux
- WezTerm (terminal) everywhere
- Bunches (orchestration) as glue

**Why**: Tools that do one thing well compose better than monoliths.

### ❌ The "Configuration by Accident" Problem

**Bad**: Making changes directly in `~/.config`, forgetting what you changed, losing those changes on reinstall.

**Our Approach**: All changes go through `~/dotfiles`. Enforced symlinks prevent accidental drift.

**Why**: Your environment should be **reproducible and portable**.

### ❌ The "GUI Settings Maze"

**Bad**: Clicking through nested menus to change settings. Settings are opaque, not version-controlled.

**Our Approach**: Plain text config files in Git.

**Why**: 
- You can `grep` your entire setup
- Changes have git history
- You can fork and modify
- AI assistants can help you

### ❌ The "Mouse-First Mindset"

**Bad**: Designing workflows that require mouse interaction.

**Our Approach**: Keyboard-first, mouse-optional.

**Why**: Speed, ergonomics, accessibility.

---

## 🎨 Aesthetic Philosophy

### Minimalism

**Goal**: The system should be invisible until you need it.

**Implementation**:
- Borderless windows (borders utility only shows active window)
- Hidden status bars (Waybar/none)
- No desktop icons
- No dock (apps launch via keyboard)

**Rationale**: Visual clutter is cognitive clutter.

### Consistency Over Novelty

**Goal**: Boring is good. Predictable is better.

**Implementation**:
- Same color scheme everywhere (Catppuccin)
- Same font everywhere (Nerd Font)
- Same key patterns everywhere (vim motions)

**Rationale**: You want to think about your work, not your tools.

---

## 🔮 Future-Proofing

### Technology Changes

**Problem**: Yabai might be abandoned. Hyprland might become unmaintained. macOS might break compatibility.

**Mitigation**:
- **Abstraction**: `lib-os-detect` decouples our logic from specific tools
- **Documentation**: Heavy commenting explains "why" not just "what"
- **Modularity**: Swapping out Yabai for a different WM only requires editing `yabai/` package

**Philosophy**: Tools are temporary. Principles are permanent.

### Personal Evolution

**Problem**: Your needs in 5 years might be different than today.

**Mitigation**:
- **Templates**: Bunch template makes it easy to create new environments
- **Escape Hatches**: Space 6 (catch-all) and traditional app launching still work
- **Extensibility**: The system should be a starting point, not a prison

**Philosophy**: The best systems grow with you, not against you.

---

## 🤔 FAQ: Philosophy Edition

### "Why not just use [popular DE/WM]?"

**Answer**: Most DEs optimize for discoverability and simplicity. We optimize for speed and flow. The learning curve is steeper, but the ceiling is much higher.

### "Why bash scripts instead of a proper programming language?"

**Answer**: Bash is:
- Universal (every UNIX has it)
- Simple (easy to read, easy to modify)
- Fast (scripts start instantly)
- Self-documenting (you can read the code)

For our use case (launching apps, orchestrating windows), bash is ideal.

### "Why Neovim instead of VS Code?"

**Answer**: We don't mandate editors. The system works with any editor. Neovim is included because:
- It's keyboard-native (no mouse required)
- It's cross-platform
- It works over SSH
- It's fast and extensible

But if you prefer VS Code, swap out the `nvim/` package.

### "Why not [tiling WM X]?"

**Answer**: Yabai and Hyprland are well-maintained, widely used, and thoroughly documented. They're **good enough**. Perfect is the enemy of done.

We prioritize:
1. Stability
2. Documentation
3. Community support

Over:
1. Maximum customization
2. Bleeding-edge features
3. Ideological purity

### "Why go through all this effort?"

**Answer**: Time investment analysis:

```
Setup time: ~4 hours (first install + learning)
Daily time saved: ~15 minutes (reduced context switching)
Payback period: ~16 days

After 1 year: ~90 hours saved
After 5 years: ~450 hours saved
```

More importantly: **the quality of your focus improves**. Flow states become easier to enter and maintain.

---

## 📖 Recommended Reading

**On Keyboard Efficiency:**
- "The Pragmatic Programmer" - Andy Hunt & Dave Thomas
- "Practical Vim" - Drew Neil

**On Environment Design:**
- "Atomic Habits" - James Clear (on environmental design)
- "Deep Work" - Cal Newport (on focus and distraction)

**On UNIX Philosophy:**
- "The Art of UNIX Programming" - Eric S. Raymond
- "UNIX Power Tools" - Shelley Powers et al.

---

## ✨ Closing Thoughts

This system is not about memorizing 100 keybindings. It's about building a **mental model** of your computing environment where:

1. **Actions are predictable** (same key = same result)
2. **Tools are composable** (each does one thing well)
3. **Workflows are reproducible** (from machine to machine)
4. **Focus is protected** (minimal context switching)

The keyboard is not just an input device—it's an **extension of thought**. When you can manipulate your environment at the speed of thinking, the computer stops being a tool and becomes a **medium**.

That's the goal.

---

**Last Updated**: 2024-11-27  
**Author**: Laurenz (@LaurenziusW)  
**Status**: Living Document (evolves with the system)
