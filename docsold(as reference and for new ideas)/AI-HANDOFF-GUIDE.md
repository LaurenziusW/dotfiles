
# AI Handoff Guide: Collecting Your Unified Keyboard Environment

**Complete Guide for Transferring Your Setup to a New AI Assistant**

---

## Table of Contents

1. [Purpose](#purpose)
2. [What to Collect](#what-to-collect)
3. [Collection Commands](#collection-commands)
4. [Packaging Everything](#packaging-everything)
5. [Creating the Context Document](#creating-the-context-document)
6. [Handoff Prompt Template](#handoff-prompt-template)
7. [Verification Checklist](#verification-checklist)

---

## Purpose

This guide helps you collect **everything** about your Unified Keyboard Environment setup so you can:
- Hand it off to a new AI assistant
- Get help troubleshooting or extending your setup
- Preserve your complete configuration state
- Share your setup with others
- Backup for restoration

The goal: Give another AI **complete context** to understand and work on your system.

---

## What to Collect

### 1. Configuration Files

**macOS:**
- `~/.config/yabai/yabairc` (Yabai window manager config)
- `~/.config/skhd/skhdrc` (Hotkey daemon config)

**Linux:**
- `~/.config/hypr/hyprland.conf` (Hyprland compositor config)

**Cross-Platform (Both Systems):**
- `~/.wezterm.lua` (Terminal emulator config)
- `~/.tmux.conf` (Terminal multiplexer config)

**Obsidian:**
- `~/.obsidian/hotkeys.json` (First vault's hotkeys)
- Or find all: `find ~ -path "*/.obsidian/hotkeys.json" 2>/dev/null`

### 2. Bunches System

**All Bunches:**
- `~/OneDrive/bunches/` (Entire directory)
  - `lib-os-detect.sh` (OS detection library)
  - `bunch-manager.sh` (Management CLI)
  - All `.sh` bunch scripts
  - `templates/` directory

### 3. Documentation

**Core Docs:**
- `MASTER-DOCUMENTATION.md`
- `COMPLETE-CHEATSHEET.md`
- `UNIFIED-SETUP-GUIDE.md`
- `AI-HANDOFF-GUIDE.md` (This file)

### 4. System Information

**To Collect:**
- Operating system version
- Window manager version
- Installed applications
- Current customizations
- Known issues or quirks
- Workspace/space configuration

### 5. Change History

**Document:**
- What you changed from defaults
- Why you made those changes
- Custom bunches you created
- Apps you added/removed
- Any problems you encountered and solved

---

## Collection Commands

### Automated Collection Script

Use the `collect-for-ai.sh` script to gather all files automatically.

Save this script as `collect-for-ai.sh` and run it:

```bash
chmod +x collect-for-ai.sh
./collect-for-ai.sh
````

This script (which we already updated) will create a `keyboard-env-collection-YYYYMMDD-HHMMSS` directory and a `.tar.gz` archive containing all the files listed in the "What to Collect" section.

---

## Packaging Everything

### After Running Collection Script

1. **Review the Collection:**
    
    Bash
    
    ```
    cd ~/keyboard-env-collection-YYYYMMDD-HHMMSS
    ls -la
    ```
    
2. Fill Out Custom Changes:
    
    This is the most important step.
    
    Bash
    
    ```
    # Edit with your preferred editor
    vim custom-changes.txt
    # or
    nano custom-changes.txt
    ```
    
3. **Review Handoff Prompt:**
    
    Bash
    
    ```
    cat HANDOFF-PROMPT.txt
    # Customize it for your specific needs
    ```
    
4. **Create Final Archive:**
    
    Bash
    
    ```
    cd ~
    tar -czf keyboard-env-for-ai.tar.gz keyboard-env-collection-*/
    ```
    

### What You'll Have

```
keyboard-env-for-ai.tar.gz
└── keyboard-env-collection-YYYYMMDD-HHMMSS/
    ├── README.txt              (Overview of collection)
    ├── custom-changes.txt      (YOUR modifications)
    ├── HANDOFF-PROMPT.txt      (Prompt template for AI)
    ├── configs/
    │   ├── wezterm.lua
    │   ├── tmux.conf
    │   ├── yabairc
    │   ├── skhdrc
    │   ├── hyprland.conf
    │   └── obsidian-hotkeys.json
    ├── bunches/
    │   ├── lib-os-detect.sh
    │   ├── bunch-manager.sh
    │   └── [your custom bunches]
    ├── docs/
    │   ├── MASTER-DOCUMENTATION.md
    │   ├── COMPLETE-CHEATSHEET.md
    │   ├── UNIFIED-SETUP-GUIDE.md
    │   └── AI-HANDOFF-GUIDE.md
    ├── system-info/
    │   ├── system-report.txt
    │   └── spaces-config.json
    └── logs/
        ├── yabai-errors.log
        └── skhd-errors.log
```

---

## Creating the Context Document

### Write a Comprehensive `custom-changes.txt`

This is **crucial** for helping the AI understand your setup. Be detailed!

**Good Example:**

Plaintext

```
CUSTOMIZED SHORTCUTS
────────────────────────────────────────────────────────────
- Changed Cmd+F from fullscreen to "focus mode" (custom bunch)
- Added Cmd+G for opening Git GUI client
- Remapped Cmd+Shift+B from "balance" to "browser focus"
  (I use this more frequently than balance)

CUSTOM BUNCHES CREATED
────────────────────────────────────────────────────────────
1. deep-work.sh (Cmd+Ctrl+6)
   - Closes all communication apps
   - Opens Obsidian in Space 2
   - Opens browser in focus mode (specific profile)
   - Starts Pomodoro timer
   - Disables notifications

2. client-meeting.sh (Cmd+Ctrl+7)
   - Opens Zoom in Space 5
   - Opens client project in VS Code (Space 4)
   - Opens relevant Notion pages (Space 2)
   - Opens Slack filtered to client channel
   - Sets status to "In Meeting"

APP ASSIGNMENTS CHANGED
────────────────────────────────────────────────────────────
- Moved VS Code from Space 4 to Space 3 (I use it with terminal)
- Added IntelliJ IDEA to Space 4 (Java projects)
- Added Figma to Space 2 (with design notes in Obsidian)
- Firefox Developer Edition → Space 1
- Zoom → Space 9 (I prefer it floating)

KNOWN ISSUES OR QUIRKS
────────────────────────────────────────────────────────────
- Spotify sometimes opens on Space 1 instead of 6
  Workaround: Manually move it with Cmd+Shift+6
- After macOS updates, need to re-grant accessibility permissions
- Hyprland on my Linux machine: Firefox takes 2-3 seconds to launch
  (might be my hardware, not config issue)

CONTEXT FOR AI ASSISTANT
────────────────────────────────────────────────────────────
- I'm a full-stack web developer (React, Node.js, PostgreSQL)
- I switch between MacBook Pro (main) and Arch Linux desktop (home)
- I prefer keyboard-only workflow 90% of the time
```

---

## Handoff Prompt Template

### Complete Prompt to Give AI

When you have everything collected, use this prompt:

```
I have a Unified Keyboard Environment setup that I need help with.
I've collected all my configuration files, documentation, and system
information. Let me upload the files and explain what I need.

[Upload your tar.gz file]

PROJECT OVERVIEW
────────────────────────────────────────────────────────────
This is a cross-platform keyboard-driven workflow system that works
on both macOS (using Yabai/skhd) and Linux (using Hyprland). 

Key Features:
- Clean modifier layer separation (Cmd/Alt never conflicts with Ctrl)
- 9-workspace system with smart app assignments
- Context-based "bunches" (environment presets)
- Cross-platform WezTerm and Tmux configurations
- Vim-style H/J/K/L navigation throughout the entire system

WHAT I'VE PROVIDED
────────────────────────────────────────────────────────────
1. configs/ - All configuration files
2. bunches/ - Complete bunches system with OS detection
3. docs/ - The 4 core documentation files
4. system-info/ - Current system state and versions
5. custom-changes.txt - MY specific modifications and context

MY CURRENT SETUP
────────────────────────────────────────────────────────────
Operating System: [macOS Sonoma 14.x / Arch Linux / Both]
Window Manager: [Yabai 7.x.x / Hyprland 0.x.x]
Main Applications: [VS Code, Obsidian, Firefox, Slack, etc.]
Use Case: [Developer / Student / Writer / etc.]

WHAT I NEED HELP WITH
────────────────────────────────────────────────────────────
[Be specific! Examples:]

- Troubleshooting: "My workspace shortcuts (Cmd+1-9) stopped working after upgrading macOS."

- Adding Feature: "I want to create a new bunch called 'video-editing.sh' that:
  - Opens DaVinci Resolve on Space 7
  - Opens Finder in my video-projects folder on Space 9
  - Disables all notifications"

- Optimization: "Can you review my workflow
  and suggest better space assignments?"

IMPORTANT: Please read these files first:
────────────────────────────────────────────────────────────
1. docs/UNIFIED-SETUP-GUIDE.md (To see the overview)
2. docs/MASTER-DOCUMENTATION.md (For system philosophy)
3. custom-changes.txt (To understand MY specific setup)
4. system-info/system-report.txt (My current system state)

KEY PRINCIPLES TO PRESERVE
────────────────────────────────────────────────────────────
- PRIMARY layer (Cmd/Alt) must NEVER conflict with Ctrl
- Terminal shortcuts (Ctrl+C, Ctrl+Z, etc.) are sacred
- Cross-platform compatibility is essential

Please confirm you've reviewed the documentation and let me know
if you need any clarification before we proceed.
```

---

## Verification Checklist

Before sending to AI, verify you have:

### Required Files

- [ ] All config files collected
    
- [ ] All bunches scripts included
    
- [ ] 4 core documentation files present
    
- [ ] System information generated
    
- [ ] `custom-changes.txt` filled out
    
- [ ] `HANDOFF-PROMPT.txt` reviewed
    

### Context Information

- [ ] Described your specific use case
    
- [ ] Listed your main applications
    
- [ ] Documented customizations
    
- [ ] Noted any known issues
    
- [ ] Specified what you need help with
    
- [ ] Mentioned your OS (macOS/Linux/Both)
    

### File Organization

- [ ] Files organized in logical directories
    
- [ ] `README.txt` explains structure
    
- [ ] Archive is compressed (`.tar.gz`)
    

---

## Tips for Effective AI Handoff

### 1. Be Specific About Problems

Bad:

"My shortcuts don't work"

Good:

"After upgrading to macOS Sonoma 14.5, pressing Cmd+H no longer focuses

the left window. I've checked: (1) yabai is running, (2) skhd is running,

(3) Accessibility permissions are granted. Error logs show: [paste error]"

### 2. Describe Your Workflow

Bad:

"I'm a developer"

Good:

"I'm a full-stack web developer. My typical workflow: Terminal in Space 3,

VS Code in Space 4, browser with DevTools in Space 1, Obsidian for

documentation in Space 2."

### 3. Include Relevant Error Messages

Always include actual error messages from logs:

Bash

```
# Include output from:
tail -20 /tmp/yabai_*.err.log
tail -20 /tmp/skhd_*.err.log
# or on Linux:
journalctl --user -u hyprland -n 20
```

### 4. Specify Desired Outcome

Bad:

"Make it better"

Good:

"I want to optimize for video editing. Ideally: DaVinci Resolve

fullscreen on Space 7, Finder with footage on Space 8, reference materials

on Space 2. I want to switch between these instantly."

---

## Summary

**To collect everything for AI:**

1. ✅ Run `collect-for-ai.sh` script
    
2. ✅ Fill out `custom-changes.txt` thoroughly
    
3. ✅ Customize `HANDOFF-PROMPT.txt`
    
4. ✅ Create archive
    
5. ✅ Upload to AI with detailed prompt
    

**Result:** Effective help with specific, contextual advice!

---

Last Updated: November 14, 2025

Version: 2.0

