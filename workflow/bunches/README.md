# Bunches System - Context Switching Made Easy

**Automated workspace setup for any workflow**

Version 3.0 - Restructured

---

## 📋 What's in This Directory

This bunches system has been **restructured for maximum flexibility**. Instead of providing many pre-made examples that might not fit your needs, we now provide:

### Core Files (Keep These)

```
bunches/
├── lib-os-detect.sh              ← OS detection library (REQUIRED)
├── bunch-manager.sh              ← CLI tool for running bunches
├── gather-current-space.sh       ← Utility to save current state
│
├── templates/
│   ├── bunch-template.sh         ← Basic template
│   └── bunch-universal-template.sh  ← Advanced template with all features
│
└── Documentation/
    ├── README.md                 ← This file
    ├── BUNCH-USE-CASES.md        ← Complete reference of all possibilities
    └── BUNCH-EXAMPLES.md         ← 15 ready-to-use examples
```

### What Changed from v2.x

**Removed:**
- ❌ `coding-project.sh` (example)
- ❌ `study-math.sh` (example)
- ❌ `email-admin.sh` (example)  
- ❌ `guitar-practice.sh` (example)
- ❌ `reading.sh` (example)

**Why?** These were specific examples that might not match your workflow.

**Added:**
- ✅ **BUNCH-USE-CASES.md** - Complete guide to all possibilities
- ✅ **BUNCH-EXAMPLES.md** - 15 detailed, copy-paste-ready examples
- ✅ **bunch-universal-template.sh** - Advanced template with all features

**Kept:**
- ✅ `lib-os-detect.sh` - Required library
- ✅ `bunch-manager.sh` - Management CLI
- ✅ `gather-current-space.sh` - Utility script
- ✅ Basic template

---

## 🚀 Quick Start

### 1. Read the Documentation

**Start here:**
```bash
# Complete reference of what's possible
cat BUNCH-USE-CASES.md

# Ready-to-use examples (15 different workflows)
cat BUNCH-EXAMPLES.md
```

### 2. Choose Your Approach

**Option A: Use a Ready-Made Example**
```bash
# Find an example in BUNCH-EXAMPLES.md that matches your needs
# Copy it to a new file
cp templates/bunch-template.sh my-workflow.sh

# Paste the example code into your file
# Edit and customize as needed
```

**Option B: Start from Template**
```bash
# For simple bunches
cp templates/bunch-template.sh my-workflow.sh

# For advanced bunches (with all features)
cp templates/bunch-universal-template.sh my-workflow.sh

# Edit with your preferred editor
nvim my-workflow.sh
```

### 3. Customize Your Bunch

Edit your new bunch file and set:
- Workspace assignments
- Applications to launch
- Timing delays
- Any special setup

### 4. Make Executable and Test

```bash
chmod +x my-workflow.sh
./my-workflow.sh
```

---

## 📖 Understanding Bunches

### What is a Bunch?

A **bunch** is a shell script that automatically:
1. Opens specific applications
2. Arranges them across workspaces
3. Optionally starts tmux sessions, opens URLs, etc.

Think of it as **one-command context switching**.

### Core Concept

```bash
# Instead of manually:
# 1. Cmd+3 (go to terminal space)
# 2. Open WezTerm
# 3. Cmd+4 (go to code space)
# 4. Open VS Code
# 5. Cmd+1 (go to browser space)
# 6. Open browser
# ...and so on

# Just run:
./coding-project.sh

# Everything opens automatically!
```

### The 10-Workspace System

Your system has **10 workspaces** (or "spaces"):

```
1. Browser/General
2. [Flexible - assign per bunch]
3. Terminal
4. Code Editor
5. PDF/Documents
6. Notes (Obsidian)
7. Specialized Tools
8. Files/Office
9. Communication
10. Media/Music
```

Bunches help you **set up multiple workspaces at once** for a specific context.

---

## 📚 Documentation Guide

### BUNCH-USE-CASES.md (Complete Reference)

**What's in it:**
- All available commands
- Every use case category (Development, Academic, Creative, etc.)
- Advanced techniques
- Pattern library
- Best practices

**Read this when:**
- Creating your first bunch
- Need to understand what's possible
- Want to learn advanced techniques
- Looking for specific patterns

**Sections:**
1. Available Commands - What you can use
2. Use Case Categories - 40+ different workflows
3. Workspace Assignments - How to organize
4. App Launch Patterns - Different ways to launch
5. Advanced Techniques - Power user features
6. Integration Patterns - Connect with other tools

### BUNCH-EXAMPLES.md (Ready-to-Use Examples)

**What's in it:**
- 15 complete, copy-paste-ready bunch scripts
- Examples for every major use case
- Detailed explanations
- Workspace layouts for each

**Examples included:**
1. **Development** - Basic web dev, full-stack, data science
2. **Academic** - Study sessions, research, problem sets
3. **Creative** - Writing, video editing
4. **Administrative** - Email, meetings
5. **Learning** - Online courses, tutorials
6. **Specialized** - Sysadmin, security testing, music practice

**Read this when:**
- Want to quickly set up a workflow
- Need inspiration for your own bunches
- Learning by example

### Templates

**bunch-template.sh** - Simple template
- Basic structure
- Minimal features
- Good for straightforward workflows

**bunch-universal-template.sh** - Advanced template
- All features included
- Pre-flight checks
- Tmux integration
- Notifications
- Profile support
- Error handling
- Good for complex workflows

---

## 🎯 Common Workflows

### Academic Study

```bash
# Copy the study session example
cat BUNCH-EXAMPLES.md  # Find "Example 4: Study Session"

# Create your bunch
cp templates/bunch-template.sh my-study.sh

# Paste and customize the example
# Set your textbook PDF path
# Set your vault path
# Make executable
chmod +x my-study.sh

# Run it
./my-study.sh
```

### Coding Project

```bash
# Find Example 1 or 2 in BUNCH-EXAMPLES.md

cp templates/bunch-template.sh coding.sh

# Customize with your:
# - Project directory
# - Preferred editor
# - Required tools

chmod +x coding.sh
./coding.sh
```

### Writing/Blogging

```bash
# Example 7 in BUNCH-EXAMPLES.md

cp templates/bunch-template.sh writing.sh

# Customize with your:
# - Writing app
# - Music playlist

chmod +x writing.sh
./writing.sh
```

---

## 🔧 Core Files Explained

### lib-os-detect.sh (REQUIRED)

**Purpose:** Cross-platform compatibility

**What it does:**
- Detects if you're on macOS or Linux
- Provides OS-specific commands
- Translates app names between platforms

**Key functions:**
```bash
detect_os                # Returns "macos" or "linux"
setup_os_commands       # Sets up variables
launch_app "browser"    # Launches correct browser for OS
get_app_command "app"   # Gets OS-specific app name
```

**Your bunches must source this file:**
```bash
source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands
```

### bunch-manager.sh

**Purpose:** CLI tool for running bunches

**Usage:**
```bash
# List available bunches
./bunch-manager.sh list

# Run a bunch
./bunch-manager.sh my-workflow

# Get help
./bunch-manager.sh help
```

**Optional:** You can also run bunches directly:
```bash
./my-workflow.sh
```

### gather-current-space.sh

**Purpose:** Utility to gather all windows to their assigned workspaces

**Usage:**
```bash
# Run it to organize your windows
./gather-current-space.sh
```

**What it does:**
- Detects current workspace
- Moves windows to their correct workspaces based on app type
- Useful for cleaning up after working across multiple spaces

**Works with:**
- Space 1: Browsers
- Space 2: Obsidian
- Space 3: Terminal/Code
- Space 5: PDF readers
- Space 6: Raindrop
- Space 7: Spotify
- Space 8: Office apps
- Space 9: Communication apps
- Space 10: AI apps

---

## 💡 Tips & Best Practices

### Start Simple

```bash
# First bunch: Just 2-3 apps
$WM_FOCUS_SPACE 3
launch_app "terminal"

$WM_FOCUS_SPACE 1
launch_app "browser"
```

### Add Complexity Gradually

Once basic bunches work:
- Add more apps
- Add tmux sessions
- Add URL opening
- Add notifications
- Add profiles

### Use Comments

```bash
# Terminal for git operations (Space 3)
$WM_FOCUS_SPACE 3
launch_app "terminal"

# Code editor with project (Space 4)
$WM_FOCUS_SPACE 4
launch_app "code"
```

### Test Timing

```bash
# Heavy apps need more time
launch_app "browser"
sleep 3  # Wait for browser to fully load

# Light apps are faster
launch_app "terminal"
sleep 1
```

### Make It Idempotent

```bash
# Safe to run multiple times
if ! pgrep -x "Obsidian" > /dev/null; then
    launch_app "notes"
fi
```

### Document Your Bunches

```bash
#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════
# BUNCH: My Workflow
# Description: What this does
# Workspaces: What spaces are used
# ═══════════════════════════════════════════════════════════
```

---

## 🎨 Creating Your First Bunch

### Step-by-Step Guide

**1. Define Your Workflow**

Ask yourself:
- What apps do I need?
- What workspaces make sense?
- What order to open them?

Example: "I need terminal, editor, and browser for coding"

**2. Choose a Template**

```bash
# Simple workflow
cp templates/bunch-template.sh my-first-bunch.sh

# Complex workflow
cp templates/bunch-universal-template.sh my-first-bunch.sh
```

**3. Edit the Bunch**

```bash
nvim my-first-bunch.sh
```

Replace the placeholder sections with your apps:

```bash
# Terminal (Space 3)
$WM_FOCUS_SPACE 3
launch_app "terminal"
sleep 1

# Editor (Space 4)
$WM_FOCUS_SPACE 4
launch_app "code"
sleep 2

# Browser (Space 1)
$WM_FOCUS_SPACE 1
launch_app "browser"
```

**4. Make Executable**

```bash
chmod +x my-first-bunch.sh
```

**5. Test It**

```bash
./my-first-bunch.sh
```

**6. Refine**

- Adjust timing if apps don't load in time
- Add or remove workspaces
- Try different app orders
- Add echo messages for feedback

---

## 🔍 Troubleshooting

### "App doesn't launch"

**Check:**
1. Is the app installed?
2. Is the app key correct? (see BUNCH-USE-CASES.md for valid keys)
3. Try launching manually with `launch_app "appkey"`

**Fix:**
```bash
# Test app launching
launch_app "terminal"  # Should work
launch_app "browser"   # Should work

# If not, check OS detection
detect_os  # Should show "macos" or "linux"
```

### "Timing is off"

**Problem:** Apps open but get assigned to wrong spaces

**Fix:** Increase sleep delays
```bash
# Before
launch_app "browser"
sleep 1  # Too fast!

# After
launch_app "browser"
sleep 3  # Better for heavy apps
```

### "Bunch fails"

**Check:**
1. Did you source `lib-os-detect.sh`?
2. Did you call `setup_os_commands`?
3. Are there syntax errors?

**Debug:**
```bash
# Run with bash explicitly
bash -x my-bunch.sh

# Check for errors
bash -n my-bunch.sh  # Syntax check
```

### "Apps open on wrong spaces"

**Issue:** Window manager hasn't focused space yet

**Fix:** Add small delay after focusing space
```bash
$WM_FOCUS_SPACE 3
sleep 0.5  # Give WM time to switch
launch_app "terminal"
```

---

## 📊 Example Bunches for Different Users

### For Students

**Study Session:**
- Obsidian notes (space 6)
- PDF textbook (space 5)
- Browser for lookups (space 1)
- Terminal for calculations (space 3)

**See:** Example 4 in BUNCH-EXAMPLES.md

### For Developers

**Coding Project:**
- Terminal for git (space 3)
- VS Code (space 4)
- Browser for docs (space 1)

**Full-Stack:**
- Backend terminal (space 3)
- Frontend terminal (space 8)
- Code editor (space 4)
- Browser (space 1)
- Database terminal (space 7)

**See:** Examples 1, 2, 3 in BUNCH-EXAMPLES.md

### For Writers

**Writing Session:**
- Word/Obsidian (space 6)
- PDF sources (space 5)
- Browser research (space 1)
- Music (space 10)

**See:** Example 7 in BUNCH-EXAMPLES.md

### For System Administrators

**Server Management:**
- Multiple terminals with tmux (spaces 3, 7, 8)
- Monitoring dashboards (space 1)
- Runbook notes (space 6)

**See:** Example 13 in BUNCH-EXAMPLES.md

---

## 🚦 Next Steps

### 1. Explore the Documentation

```bash
# Start here - understand what's possible
cat BUNCH-USE-CASES.md | less

# See real examples
cat BUNCH-EXAMPLES.md | less
```

### 2. Create Your First Bunch

```bash
# Copy a template
cp templates/bunch-template.sh my-workflow.sh

# Edit it
nvim my-workflow.sh

# Make it executable
chmod +x my-workflow.sh

# Test it
./my-workflow.sh
```

### 3. Build Your Library

Create bunches for your common contexts:
- `./study.sh` - For studying
- `./code.sh` - For coding
- `./write.sh` - For writing
- `./admin.sh` - For email/admin work
- `./research.sh` - For research

### 4. Refine and Share

- Adjust timing and apps
- Add custom features
- Share your bunches with others!

---

## 💬 Getting Help

### Resources in This Directory

1. **BUNCH-USE-CASES.md** - Complete reference guide
   - All commands and options
   - Every use case category
   - Advanced patterns
   
2. **BUNCH-EXAMPLES.md** - 15 ready-to-use examples
   - Copy-paste ready
   - Detailed explanations
   - Various workflows

3. **Templates** - Starting points
   - Basic template for simple bunches
   - Advanced template for complex bunches

### Need AI Help?

Use the collection script:
```bash
# From the parent directory
./collect-for-ai.sh

# This will package:
# - All your bunches
# - System configuration
# - Documentation

# Then share with AI assistant
```

---

## 📝 Summary

The bunches system has been **restructured** to be more flexible:

**What You Have:**
- ✅ Core library (lib-os-detect.sh)
- ✅ Management tools (bunch-manager.sh, gather-current-space.sh)
- ✅ Two templates (basic and advanced)
- ✅ Complete documentation (USE-CASES + EXAMPLES)

**What You Do:**
1. Read **BUNCH-USE-CASES.md** to understand possibilities
2. Find a relevant example in **BUNCH-EXAMPLES.md**
3. Copy template and customize for your needs
4. Test and refine

**Benefits:**
- More flexible than rigid pre-made examples
- Learn the system better by creating your own
- Get exactly what you need for your workflow
- Understand how it works under the hood

---

**Ready to create your first bunch? Start with BUNCH-EXAMPLES.md!** 🚀
