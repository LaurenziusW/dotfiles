I am handing off the current state of my "Unified Keyboard Environment" (UKE) project to you. I have attached the complete codebase, configuration files, and documentation.

### 1. THE PROJECT
This is a cross-platform, keyboard-driven workflow system for macOS (Yabai/skhd) and Linux (Hyprland). It uses a "Single Source of Truth" architecture where `config/registry.yaml` generates platform-specific configs.

### 2. CORE PHILOSOPHY (IMMUTABLE RULES)
You must strictly adhere to these principles when suggesting changes:
1. **Modifier Layer Separation:**
   - **PRIMARY (Cmd/Alt):** Exclusively for Window Manager & GUI control.
   - **SECONDARY (Ctrl):** Exclusively for Terminal/App internals (MUST pass through).
   - **TERTIARY (Alt+Shift/Super+Shift):** Window resizing.
   - **NEVER** create a keybinding that conflicts with standard terminal signals (Ctrl+C, etc).
2. **Cross-Platform Parity:** Functionality must work identically on macOS and Linux (e.g., if you add a feature for Yabai, consider the Hyprland equivalent).
3. **Generated Configs:** Do NOT suggest editing files in `gen/` manually. Always modify the generator (`lib/gen.sh`) or the source (`config/registry.yaml`).

### 3. INSTRUCTIONS FOR ANALYSIS
Before answering my request, please analyze the attached files to establish the current state:
- **For App Assignments & Hotkeys:** Read `config/registry.yaml`.
- **For Architecture:** Read `docs/ARCHITECTURE.md`.
- **For Project Structure:** Check `README.md` and the file tree.
- **For Current System Status:** Check `system-info/system-report.txt` (if present) or infer from the `scripts/install.sh` logic.

### 4. MY REQUEST
[ INSERT YOUR SPECIFIC QUESTION, BUG REPORT, OR FEATURE REQUEST HERE ]
