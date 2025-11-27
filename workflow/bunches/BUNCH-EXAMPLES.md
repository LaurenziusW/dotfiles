# Bunch System - Complete Examples Collection

**Ready-to-use bunch scripts for every workflow**

---

## 📚 Table of Contents

1. [Development Examples](#development-examples)
2. [Academic Examples](#academic-examples)
3. [Creative Examples](#creative-examples)
4. [Administrative Examples](#administrative-examples)
5. [Learning Examples](#learning-examples)
6. [Specialized Examples](#specialized-examples)

---

## Development Examples

### Example 1: Basic Web Development

**Use Case**: Front-end web development with live server, editor, and browser

```bash
#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════
# BUNCH: Web Development
# Description: Setup for front-end web development
# Workspaces: 1 (Browser), 3 (Terminal), 4 (Editor)
# ═══════════════════════════════════════════════════════════

source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

echo "🌐 Starting: Web Development Environment"

# Terminal for dev server (Space 3)
echo "▸ Setting up terminal..."
$WM_FOCUS_SPACE 3
launch_app "terminal"
sleep 1

# Code editor (Space 4)
echo "▸ Opening code editor..."
$WM_FOCUS_SPACE 4
launch_app "code"
sleep 2

# Browser for testing (Space 1)
echo "▸ Opening browser..."
$WM_FOCUS_SPACE 1
launch_app "browser"
sleep 2

# Open localhost
if [[ $(detect_os) == "macos" ]]; then
    open "http://localhost:3000"
else
    xdg-open "http://localhost:3000"
fi

# Return to terminal to start dev server
$WM_FOCUS_SPACE 3

echo "✅ Web dev environment ready!"
echo "   • Space 3: Terminal (run 'npm run dev')"
echo "   • Space 4: Code editor"
echo "   • Space 1: Browser with localhost"
```

---

### Example 2: Full-Stack Development

**Use Case**: Backend + frontend development with database

```bash
#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════
# BUNCH: Full-Stack Development
# Description: Complete full-stack development environment
# Workspaces: 1 (Browser), 3 (Backend Term), 4 (Editor), 
#             7 (Database), 8 (Frontend Term)
# ═══════════════════════════════════════════════════════════

source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

PROJECT_DIR="$HOME/Projects/my-fullstack-app"

echo "🚀 Starting: Full-Stack Development Environment"

# Pre-flight check
if [[ ! -d "$PROJECT_DIR" ]]; then
    echo "⚠️  Project directory not found: $PROJECT_DIR"
    echo "   Using current directory instead"
    PROJECT_DIR="$PWD"
fi

# Backend terminal (Space 3)
echo "▸ Setting up backend terminal..."
$WM_FOCUS_SPACE 3
launch_app "terminal"
sleep 1

# Code editor with project (Space 4)
echo "▸ Opening project in editor..."
$WM_FOCUS_SPACE 4
if [[ $(detect_os) == "macos" ]]; then
    open -a "Visual Studio Code" "$PROJECT_DIR"
else
    code "$PROJECT_DIR"
fi
sleep 3

# Database client (Space 7)
echo "▸ Setting up database tools..."
$WM_FOCUS_SPACE 7
launch_app "terminal"
sleep 1

# Frontend terminal (Space 8)
echo "▸ Setting up frontend terminal..."
$WM_FOCUS_SPACE 8
launch_app "terminal"
sleep 1

# Browser for testing (Space 1)
echo "▸ Opening browser..."
$WM_FOCUS_SPACE 1
launch_app "browser"
sleep 2

# Open useful URLs in tabs
if [[ $(detect_os) == "macos" ]]; then
    open "http://localhost:3000"
    open "http://localhost:8080/api"
else
    xdg-open "http://localhost:3000" &
    xdg-open "http://localhost:8080/api" &
fi

# Return to backend terminal
$WM_FOCUS_SPACE 3

echo "✅ Full-stack environment ready!"
echo ""
echo "   Workspace Layout:"
echo "   • Space 1: Browser (localhost:3000, localhost:8080)"
echo "   • Space 3: Backend terminal (cd backend && npm start)"
echo "   • Space 4: Code editor"
echo "   • Space 7: Database terminal (psql or mongo)"
echo "   • Space 8: Frontend terminal (cd frontend && npm start)"
```

---

### Example 3: Data Science / Jupyter

**Use Case**: Data analysis with Jupyter, terminal, and documentation

```bash
#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════
# BUNCH: Data Science Workflow
# Description: Jupyter notebook environment for data analysis
# Workspaces: 1 (Browser/Jupyter), 3 (Terminal), 
#             6 (Notes), 8 (Data Files)
# ═══════════════════════════════════════════════════════════

source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

NOTEBOOK_DIR="${NOTEBOOK_DIR:-$HOME/Notebooks}"

echo "📊 Starting: Data Science Workflow"

# Terminal for Python/conda (Space 3)
echo "▸ Setting up Python environment..."
$WM_FOCUS_SPACE 3
launch_app "terminal"
sleep 1

# Notes for observations (Space 6)
echo "▸ Opening notes..."
$WM_FOCUS_SPACE 6
launch_app "notes"
sleep 2

# File manager for datasets (Space 8)
echo "▸ Opening file manager..."
$WM_FOCUS_SPACE 8
if [[ $(detect_os) == "macos" ]]; then
    open "$NOTEBOOK_DIR"
else
    xdg-open "$NOTEBOOK_DIR"
fi

# Browser for Jupyter (Space 1)
echo "▸ Opening browser..."
$WM_FOCUS_SPACE 1
launch_app "browser"
sleep 2

# Return to terminal
$WM_FOCUS_SPACE 3

echo "✅ Data science environment ready!"
echo ""
echo "   Next steps:"
echo "   1. Activate conda env: conda activate myenv"
echo "   2. Start Jupyter: jupyter lab"
echo "   3. Browser will open automatically"
echo ""
echo "   Workspace Layout:"
echo "   • Space 1: Browser (Jupyter interface)"
echo "   • Space 3: Terminal (Python/conda)"
echo "   • Space 6: Notes (Obsidian)"
echo "   • Space 8: File manager (datasets)"
```

---

## Academic Examples

### Example 4: Study Session with Notes & PDFs

**Use Case**: Studying from textbook with note-taking

```bash
#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════
# BUNCH: Study Session
# Description: Study environment with textbook and notes
# Workspaces: 1 (Browser/lookup), 5 (PDF textbook), 
#             6 (Notes), 3 (Terminal/calc)
# ═══════════════════════════════════════════════════════════

source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

TEXTBOOK_PDF="${TEXTBOOK_PDF:-}"
VAULT_PATH="${VAULT_PATH:-$HOME/Obsidian/Study}"

echo "📚 Starting: Study Session"

# Notes in Obsidian (Space 6)
echo "▸ Opening notes..."
$WM_FOCUS_SPACE 6
launch_app "notes"
sleep 2

# PDF reader for textbook (Space 5)
echo "▸ Opening PDF reader..."
$WM_FOCUS_SPACE 5
launch_app "pdf"
sleep 1

# Open specific textbook if provided
if [[ -n "$TEXTBOOK_PDF" ]] && [[ -f "$TEXTBOOK_PDF" ]]; then
    if [[ $(detect_os) == "macos" ]]; then
        open "$TEXTBOOK_PDF"
    else
        xdg-open "$TEXTBOOK_PDF"
    fi
    echo "   Opened: $(basename "$TEXTBOOK_PDF")"
fi

# Browser for lookups (Space 1)
echo "▸ Opening browser for references..."
$WM_FOCUS_SPACE 1
launch_app "browser"
sleep 2

# Terminal with calculator (Space 3)
echo "▸ Setting up terminal..."
$WM_FOCUS_SPACE 3
launch_app "terminal"
sleep 1

# Return to notes
$WM_FOCUS_SPACE 6

echo "✅ Study environment ready!"
echo ""
echo "   Workspace Layout:"
echo "   • Space 6: Notes (Obsidian) ← You are here"
echo "   • Space 5: PDF textbook"
echo "   • Space 1: Browser (Wikipedia, etc.)"
echo "   • Space 3: Terminal (calculator, scripts)"
echo ""
echo "   Tip: Use Cmd+1/2/3... to switch between spaces"
```

---

### Example 5: Research Paper Writing

**Use Case**: Academic writing with sources and references

```bash
#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════
# BUNCH: Research & Writing
# Description: Academic paper writing environment
# Workspaces: 1 (Browser/research), 5 (Reference PDFs),
#             6 (Writing), 7 (Citations), 10 (Music)
# ═══════════════════════════════════════════════════════════

source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

PAPERS_DIR="${PAPERS_DIR:-$HOME/Documents/Research Papers}"
WRITING_APP="${WRITING_APP:-notes}"  # or "office-word"

echo "✍️  Starting: Research & Writing Environment"

# Main writing space (Space 6)
echo "▸ Opening writing application..."
$WM_FOCUS_SPACE 6
launch_app "$WRITING_APP"
sleep 2

# PDF reader for reference papers (Space 5)
echo "▸ Opening PDF reader..."
$WM_FOCUS_SPACE 5
launch_app "pdf"
sleep 1

# Open papers directory
if [[ -d "$PAPERS_DIR" ]]; then
    if [[ $(detect_os) == "macos" ]]; then
        open "$PAPERS_DIR"
    else
        xdg-open "$PAPERS_DIR"
    fi
fi

# Browser for research (Space 1)
echo "▸ Opening browser..."
$WM_FOCUS_SPACE 1
launch_app "browser"
sleep 2

# Open research tools
if [[ $(detect_os) == "macos" ]]; then
    open "https://scholar.google.com"
else
    xdg-open "https://scholar.google.com"
fi

# Citation manager / notes (Space 7)
echo "▸ Setting up citation workspace..."
$WM_FOCUS_SPACE 7
launch_app "terminal"
sleep 1

# Focus music (Space 10)
echo "▸ Starting focus music..."
$WM_FOCUS_SPACE 10
if ! pgrep -x "Spotify" > /dev/null; then
    launch_app "music"
fi

# Return to writing
$WM_FOCUS_SPACE 6

echo "✅ Research environment ready!"
echo ""
echo "   Workspace Layout:"
echo "   • Space 6: Writing document ← You are here"
echo "   • Space 5: Reference PDFs"
echo "   • Space 1: Browser (Google Scholar)"
echo "   • Space 7: Terminal (citations/notes)"
echo "   • Space 10: Spotify (focus music)"
echo ""
echo "   Workflow:"
echo "   1. Research in browser (Space 1)"
echo "   2. Read papers (Space 5)"
echo "   3. Take notes and write (Space 6)"
echo "   4. Manage citations (Space 7)"
```

---

### Example 6: Problem Set Workflow

**Use Case**: Working through homework/problem sets

```bash
#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════
# BUNCH: Problem Set Workflow
# Description: Environment for completing problem sets
# Workspaces: 3 (Terminal/nvim), 5 (Problem Set PDF),
#             1 (Browser/resources), 7 (Calculator)
# ═══════════════════════════════════════════════════════════

source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

PSET_PDF="${PSET_PDF:-}"
PSET_DIR="${PSET_DIR:-$HOME/University/Problem Sets}"

echo "📝 Starting: Problem Set Workflow"

# Terminal with Neovim for solutions (Space 3)
echo "▸ Setting up terminal..."
$WM_FOCUS_SPACE 3
launch_app "terminal"
sleep 2

# Setup tmux session for problem solving
if command -v tmux &> /dev/null; then
    if ! tmux has-session -t pset 2>/dev/null; then
        tmux new-session -d -s pset -c "$PSET_DIR"
        tmux split-window -h -t pset
        tmux select-pane -t 0
        tmux send-keys -t pset:0.0 "nvim solutions.md" C-m
        echo "   Created tmux session 'pset'"
    fi
fi

# Problem set PDF (Space 5)
echo "▸ Opening problem set..."
$WM_FOCUS_SPACE 5
launch_app "pdf"
sleep 1

if [[ -n "$PSET_PDF" ]] && [[ -f "$PSET_PDF" ]]; then
    if [[ $(detect_os) == "macos" ]]; then
        open "$PSET_PDF"
    else
        xdg-open "$PSET_PDF"
    fi
fi

# Browser for resources (Space 1)
echo "▸ Opening browser..."
$WM_FOCUS_SPACE 1
launch_app "browser"
sleep 2

# Terminal for calculations (Space 7)
echo "▸ Setting up calculation workspace..."
$WM_FOCUS_SPACE 7
launch_app "terminal"
sleep 1

# Return to main workspace
$WM_FOCUS_SPACE 3

echo "✅ Problem set environment ready!"
echo ""
echo "   Workspace Layout:"
echo "   • Space 3: Terminal + Neovim ← You are here"
echo "   • Space 5: Problem set PDF"
echo "   • Space 1: Browser (resources)"
echo "   • Space 7: Terminal (Python/calculations)"
echo ""
echo "   Tmux Session 'pset':"
echo "   • Left pane: Neovim (solutions)"
echo "   • Right pane: Shell (testing)"
echo ""
echo "   Attach with: tmux attach -t pset"
```

---

## Creative Examples

### Example 7: Writing / Blogging

**Use Case**: Creative writing or blog post creation

```bash
#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════
# BUNCH: Creative Writing
# Description: Distraction-free writing environment
# Workspaces: 6 (Writing), 1 (Research browser),
#             10 (Music), 5 (Reference docs)
# ═══════════════════════════════════════════════════════════

source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

WRITING_APP="${WRITING_APP:-notes}"
MUSIC_PLAYLIST="${MUSIC_PLAYLIST:-}"

echo "✍️  Starting: Creative Writing Environment"

# Main writing app (Space 6)
echo "▸ Opening writing application..."
$WM_FOCUS_SPACE 6
launch_app "$WRITING_APP"
sleep 2

# Focus music (Space 10)
echo "▸ Starting focus music..."
$WM_FOCUS_SPACE 10
if ! pgrep -x "Spotify" > /dev/null; then
    launch_app "music"
    sleep 2
    
    # Open playlist if specified
    if [[ -n "$MUSIC_PLAYLIST" ]]; then
        if [[ $(detect_os) == "macos" ]]; then
            open "$MUSIC_PLAYLIST"
        else
            xdg-open "$MUSIC_PLAYLIST"
        fi
    fi
fi

# Research browser (Space 1) - start but don't focus
$WM_FOCUS_SPACE 1
launch_app "browser"
sleep 2

# Reference docs (Space 5) - ready but not opened
$WM_FOCUS_SPACE 5
launch_app "pdf"
sleep 1

# Return to writing - this is the main focus
$WM_FOCUS_SPACE 6

echo "✅ Writing environment ready!"
echo ""
echo "   Workspace Layout:"
echo "   • Space 6: Writing app ← You are here (FOCUS)"
echo "   • Space 10: Spotify (background music)"
echo "   • Space 1: Browser (quick research)"
echo "   • Space 5: PDF reader (reference docs)"
echo ""
echo "   💡 Tip: Stay in Space 6 for deep focus"
echo "   📱 Other spaces available when needed"
```

---

### Example 8: Video/Audio Editing

**Use Case**: Media editing with preview and assets

```bash
#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════
# BUNCH: Media Editing
# Description: Video/audio editing workspace
# Workspaces: 7 (Editor), 8 (Assets/Files),
#             1 (Reference browser), 10 (Preview/playback)
# ═══════════════════════════════════════════════════════════

source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

EDITOR_APP="${EDITOR_APP:-}"  # e.g., "Final Cut Pro" or "kdenlive"
PROJECT_DIR="${PROJECT_DIR:-$HOME/Videos/Projects}"

echo "🎬 Starting: Media Editing Environment"

# Main editing app (Space 7)
echo "▸ Opening editor..."
$WM_FOCUS_SPACE 7
if [[ -n "$EDITOR_APP" ]]; then
    if [[ $(detect_os) == "macos" ]]; then
        open -a "$EDITOR_APP"
    else
        "$EDITOR_APP" &
    fi
    sleep 3
else
    echo "   ⚠️  No editor specified (set EDITOR_APP variable)"
fi

# File manager for assets (Space 8)
echo "▸ Opening assets folder..."
$WM_FOCUS_SPACE 8
if [[ -d "$PROJECT_DIR" ]]; then
    if [[ $(detect_os) == "macos" ]]; then
        open "$PROJECT_DIR"
    else
        xdg-open "$PROJECT_DIR"
    fi
fi
sleep 1

# Browser for tutorials/reference (Space 1)
echo "▸ Opening browser..."
$WM_FOCUS_SPACE 1
launch_app "browser"
sleep 2

# Media player for preview (Space 10)
$WM_FOCUS_SPACE 10
launch_app "video"
sleep 1

# Return to editor
$WM_FOCUS_SPACE 7

echo "✅ Media editing environment ready!"
echo ""
echo "   Workspace Layout:"
echo "   • Space 7: Video/Audio editor ← You are here"
echo "   • Space 8: File manager (assets)"
echo "   • Space 1: Browser (tutorials/stock media)"
echo "   • Space 10: Media player (preview)"
echo ""
echo "   Project: $PROJECT_DIR"
```

---

## Administrative Examples

### Example 9: Email & Admin Work

**Use Case**: Email management and administrative tasks

```bash
#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════
# BUNCH: Email & Admin
# Description: Email, calendar, and administrative work
# Workspaces: 9 (Email/Comm), 8 (Files/Documents),
#             1 (Browser), 6 (Notes)
# ═══════════════════════════════════════════════════════════

source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

echo "📧 Starting: Email & Admin Environment"

# Email and calendar (Space 9)
echo "▸ Opening email..."
$WM_FOCUS_SPACE 9
launch_app "email"
sleep 2

# Browser for web apps (Space 1)
echo "▸ Opening browser..."
$WM_FOCUS_SPACE 1
launch_app "browser"
sleep 2

# Open common web apps
if [[ $(detect_os) == "macos" ]]; then
    open "https://calendar.google.com"
    sleep 1
    open "https://drive.google.com"
else
    xdg-open "https://calendar.google.com" &
    sleep 1
    xdg-open "https://drive.google.com" &
fi

# File manager / documents (Space 8)
echo "▸ Opening file manager..."
$WM_FOCUS_SPACE 8
if [[ $(detect_os) == "macos" ]]; then
    open "$HOME/Documents"
else
    xdg-open "$HOME/Documents"
fi

# Notes for tasks (Space 6)
echo "▸ Opening notes..."
$WM_FOCUS_SPACE 6
launch_app "notes"
sleep 2

# Return to email
$WM_FOCUS_SPACE 9

echo "✅ Admin environment ready!"
echo ""
echo "   Workspace Layout:"
echo "   • Space 9: Email ← You are here"
echo "   • Space 1: Browser (Calendar, Drive)"
echo "   • Space 8: File manager (Documents)"
echo "   • Space 6: Notes (task lists)"
echo ""
echo "   Start with email, use other spaces as needed"
```

---

### Example 10: Meeting Preparation

**Use Case**: Preparing for and conducting a meeting

```bash
#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════
# BUNCH: Meeting Preparation
# Description: Setup for virtual meeting
# Workspaces: 9 (Video call), 8 (Presentation),
#             6 (Notes/agenda), 1 (Browser/docs)
# ═══════════════════════════════════════════════════════════

source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

MEETING_URL="${MEETING_URL:-}"
PRESENTATION="${PRESENTATION:-}"
AGENDA="${AGENDA:-}"

echo "🎤 Starting: Meeting Preparation"

# Notes with agenda (Space 6)
echo "▸ Opening meeting notes..."
$WM_FOCUS_SPACE 6
launch_app "notes"
sleep 2

# Open agenda if specified
if [[ -n "$AGENDA" ]] && [[ -f "$AGENDA" ]]; then
    if [[ $(detect_os) == "macos" ]]; then
        open "$AGENDA"
    else
        xdg-open "$AGENDA"
    fi
fi

# Presentation (Space 8)
if [[ -n "$PRESENTATION" ]] && [[ -f "$PRESENTATION" ]]; then
    echo "▸ Opening presentation..."
    $WM_FOCUS_SPACE 8
    if [[ $(detect_os) == "macos" ]]; then
        open "$PRESENTATION"
    else
        xdg-open "$PRESENTATION"
    fi
    sleep 2
fi

# Browser for docs/meeting link (Space 1)
echo "▸ Opening browser..."
$WM_FOCUS_SPACE 1
launch_app "browser"
sleep 2

if [[ -n "$MEETING_URL" ]]; then
    echo "   Opening meeting URL..."
    if [[ $(detect_os) == "macos" ]]; then
        open "$MEETING_URL"
    else
        xdg-open "$MEETING_URL"
    fi
fi

# Video call app (Space 9)
echo "▸ Preparing video call workspace..."
$WM_FOCUS_SPACE 9
# Video app will open from browser or can be launched separately

# Return to notes
$WM_FOCUS_SPACE 6

echo "✅ Meeting prep ready!"
echo ""
echo "   Workspace Layout:"
echo "   • Space 6: Notes/Agenda ← You are here"
echo "   • Space 9: Video call (ready)"
echo "   • Space 8: Presentation"
echo "   • Space 1: Browser (docs/shared links)"
echo ""
echo "   Workflow:"
echo "   1. Review agenda (Space 6)"
echo "   2. Join call (Space 9)"
echo "   3. Share screen with presentation (Space 8)"
echo "   4. Take notes during meeting (Space 6)"
```

---

## Learning Examples

### Example 11: Online Course

**Use Case**: Taking an online course with note-taking

```bash
#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════
# BUNCH: Online Course Learning
# Description: Environment for online course with video
# Workspaces: 1 (Course video), 6 (Notes),
#             3 (Practice terminal), 4 (Code editor)
# ═══════════════════════════════════════════════════════════

source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

COURSE_URL="${COURSE_URL:-}"
COURSE_DIR="${COURSE_DIR:-$HOME/Courses/current}"

echo "🎓 Starting: Online Course Environment"

# Notes for course (Space 6)
echo "▸ Opening notes..."
$WM_FOCUS_SPACE 6
launch_app "notes"
sleep 2

# Browser for course video (Space 1)
echo "▸ Opening course browser..."
$WM_FOCUS_SPACE 1
launch_app "browser"
sleep 2

if [[ -n "$COURSE_URL" ]]; then
    if [[ $(detect_os) == "macos" ]]; then
        open "$COURSE_URL"
    else
        xdg-open "$COURSE_URL"
    fi
fi

# Terminal for practice (Space 3)
echo "▸ Setting up practice terminal..."
$WM_FOCUS_SPACE 3
launch_app "terminal"
sleep 1

# Code editor for exercises (Space 4)
echo "▸ Opening code editor..."
$WM_FOCUS_SPACE 4
if [[ -d "$COURSE_DIR" ]]; then
    if [[ $(detect_os) == "macos" ]]; then
        open -a "Visual Studio Code" "$COURSE_DIR"
    else
        code "$COURSE_DIR"
    fi
else
    launch_app "code"
fi
sleep 2

# Return to video to start learning
$WM_FOCUS_SPACE 1

echo "✅ Course environment ready!"
echo ""
echo "   Workspace Layout:"
echo "   • Space 1: Course video ← You are here (START)"
echo "   • Space 6: Notes (take notes while watching)"
echo "   • Space 3: Terminal (practice commands)"
echo "   • Space 4: Code editor (exercises)"
echo ""
echo "   Workflow:"
echo "   1. Watch video (Space 1)"
echo "   2. Take notes (Cmd+6)"
echo "   3. Practice coding (Cmd+3 or Cmd+4)"
echo "   4. Return to video (Cmd+1)"
```

---

### Example 12: Tutorial Following

**Use Case**: Following a coding tutorial step-by-step

```bash
#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════
# BUNCH: Tutorial Following
# Description: Side-by-side tutorial and coding
# Workspaces: 1 (Tutorial browser), 4 (Code editor),
#             3 (Terminal), 5 (Docs PDF)
# ═══════════════════════════════════════════════════════════

source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

TUTORIAL_URL="${TUTORIAL_URL:-}"
PROJECT_DIR="${PROJECT_DIR:-$HOME/Tutorials/current}"

echo "📖 Starting: Tutorial Following Environment"

# Code editor (Space 4)
echo "▸ Opening code editor..."
$WM_FOCUS_SPACE 4
if [[ -d "$PROJECT_DIR" ]]; then
    if [[ $(detect_os) == "macos" ]]; then
        open -a "Visual Studio Code" "$PROJECT_DIR"
    else
        code "$PROJECT_DIR"
    fi
    sleep 3
else
    launch_app "code"
    sleep 2
fi

# Tutorial browser (Space 1)
echo "▸ Opening tutorial..."
$WM_FOCUS_SPACE 1
launch_app "browser"
sleep 2

if [[ -n "$TUTORIAL_URL" ]]; then
    if [[ $(detect_os) == "macos" ]]; then
        open "$TUTORIAL_URL"
    else
        xdg-open "$TUTORIAL_URL"
    fi
fi

# Terminal for running code (Space 3)
echo "▸ Setting up terminal..."
$WM_FOCUS_SPACE 3
launch_app "terminal"
sleep 1

# Documentation (Space 5)
echo "▸ Preparing documentation workspace..."
$WM_FOCUS_SPACE 5
launch_app "pdf"
sleep 1

# Start with tutorial visible
$WM_FOCUS_SPACE 1

echo "✅ Tutorial environment ready!"
echo ""
echo "   Workspace Layout:"
echo "   • Space 1: Tutorial browser ← You are here"
echo "   • Space 4: Code editor"
echo "   • Space 3: Terminal (run code)"
echo "   • Space 5: Documentation"
echo ""
echo "   Workflow:"
echo "   1. Read tutorial step (Space 1)"
echo "   2. Write code (Cmd+4)"
echo "   3. Test code (Cmd+3)"
echo "   4. Check docs if needed (Cmd+5)"
echo "   5. Return to tutorial (Cmd+1)"
echo ""
echo "   💡 Tip: Use two monitors for side-by-side"
```

---

## Specialized Examples

### Example 13: System Administration

**Use Case**: Managing multiple servers via SSH

```bash
#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════
# BUNCH: System Administration
# Description: Multi-server management environment
# Workspaces: 3, 7, 8 (Multiple terminals),
#             1 (Monitoring dashboards), 6 (Notes/runbook)
# ═══════════════════════════════════════════════════════════

source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

SERVER_LIST=("prod-web" "prod-db" "staging")

echo "🔧 Starting: System Administration Environment"

# Notes with runbook (Space 6)
echo "▸ Opening runbook notes..."
$WM_FOCUS_SPACE 6
launch_app "notes"
sleep 2

# Primary terminal with tmux (Space 3)
echo "▸ Setting up primary terminal..."
$WM_FOCUS_SPACE 3
launch_app "terminal"
sleep 2

# Setup tmux session with multiple windows for servers
if command -v tmux &> /dev/null; then
    if ! tmux has-session -t sysadmin 2>/dev/null; then
        echo "   Creating tmux session for servers..."
        tmux new-session -d -s sysadmin -n "monitoring"
        
        for server in "${SERVER_LIST[@]}"; do
            tmux new-window -t sysadmin -n "$server"
            # Optional: auto-connect to each server
            # tmux send-keys -t sysadmin:$server "ssh $server" C-m
        done
        
        echo "   ✓ Created tmux session 'sysadmin'"
        echo "   Attach with: tmux attach -t sysadmin"
    fi
fi

# Secondary terminal (Space 7)
echo "▸ Setting up secondary terminal..."
$WM_FOCUS_SPACE 7
launch_app "terminal"
sleep 1

# Tertiary terminal (Space 8)
echo "▸ Setting up tertiary terminal..."
$WM_FOCUS_SPACE 8
launch_app "terminal"
sleep 1

# Monitoring dashboards (Space 1)
echo "▸ Opening monitoring dashboards..."
$WM_FOCUS_SPACE 1
launch_app "browser"
sleep 2

# Open monitoring tools
if [[ $(detect_os) == "macos" ]]; then
    open "https://grafana.internal/dashboards"
    open "https://prometheus.internal"
else
    xdg-open "https://grafana.internal/dashboards" &
    xdg-open "https://prometheus.internal" &
fi

# Return to primary terminal
$WM_FOCUS_SPACE 3

echo "✅ Sysadmin environment ready!"
echo ""
echo "   Workspace Layout:"
echo "   • Space 3: Primary terminal (tmux) ← You are here"
echo "   • Space 7: Secondary terminal"
echo "   • Space 8: Tertiary terminal"
echo "   • Space 1: Monitoring dashboards"
echo "   • Space 6: Runbook notes"
echo ""
echo "   Tmux Session 'sysadmin':"
for server in "${SERVER_LIST[@]}"; do
    echo "   • Window: $server"
done
echo ""
echo "   Use: tmux attach -t sysadmin"
```

---

### Example 14: Security Testing / CTF

**Use Case**: Penetration testing or Capture The Flag challenges

```bash
#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════
# BUNCH: Security Testing / CTF
# Description: Environment for security research/CTF
# Workspaces: 3 (Tools terminal), 1 (Target browser),
#             6 (Notes/findings), 7 (Burp/proxy), 4 (Scripts)
# ═══════════════════════════════════════════════════════════

source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

TARGET_URL="${TARGET_URL:-}"
NOTES_DIR="${NOTES_DIR:-$HOME/Security/CTF}"

echo "🔐 Starting: Security Testing Environment"

# Notes for findings (Space 6)
echo "▸ Opening notes..."
$WM_FOCUS_SPACE 6
launch_app "notes"
sleep 2

# Main tools terminal (Space 3)
echo "▸ Setting up tools terminal..."
$WM_FOCUS_SPACE 3
launch_app "terminal"
sleep 2

# Setup tmux with common tools
if command -v tmux &> /dev/null; then
    if ! tmux has-session -t ctf 2>/dev/null; then
        tmux new-session -d -s ctf -n "recon"
        tmux new-window -t ctf -n "exploit"
        tmux new-window -t ctf -n "listener"
        echo "   ✓ Created tmux session 'ctf'"
    fi
fi

# Scripts/code editor (Space 4)
echo "▸ Opening code editor..."
$WM_FOCUS_SPACE 4
launch_app "code"
sleep 2

# Proxy tool (Space 7)
echo "▸ Preparing proxy workspace..."
$WM_FOCUS_SPACE 7
launch_app "terminal"
sleep 1
echo "   Launch Burp Suite or other proxy manually"

# Target browser (Space 1)
echo "▸ Opening target browser..."
$WM_FOCUS_SPACE 1
launch_app "browser"
sleep 2

if [[ -n "$TARGET_URL" ]]; then
    if [[ $(detect_os) == "macos" ]]; then
        open "$TARGET_URL"
    else
        xdg-open "$TARGET_URL"
    fi
fi

# Return to tools terminal
$WM_FOCUS_SPACE 3

echo "✅ Security testing environment ready!"
echo ""
echo "   Workspace Layout:"
echo "   • Space 3: Tools terminal (tmux) ← You are here"
echo "   • Space 1: Target browser"
echo "   • Space 6: Notes (findings/methodology)"
echo "   • Space 7: Burp Suite / proxy"
echo "   • Space 4: Scripts (exploits/tools)"
echo ""
echo "   Tmux Session 'ctf':"
echo "   • recon: Reconnaissance tools"
echo "   • exploit: Exploitation attempts"
echo "   • listener: Reverse shell listeners"
echo ""
echo "   Attach with: tmux attach -t ctf"
```

---

### Example 15: Music Practice

**Use Case**: Practicing instrument with materials

```bash
#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════
# BUNCH: Music Practice
# Description: Setup for instrument practice
# Workspaces: 5 (Sheet music), 1 (Tutorial videos),
#             10 (Metronome/tuner), 6 (Practice notes)
# ═══════════════════════════════════════════════════════════

source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

SHEET_MUSIC="${SHEET_MUSIC:-}"
TUTORIAL_URL="${TUTORIAL_URL:-}"

echo "🎸 Starting: Music Practice Environment"

# Practice notes (Space 6)
echo "▸ Opening practice journal..."
$WM_FOCUS_SPACE 6
launch_app "notes"
sleep 2

# Sheet music (Space 5)
echo "▸ Opening sheet music..."
$WM_FOCUS_SPACE 5
launch_app "pdf"
sleep 1

if [[ -n "$SHEET_MUSIC" ]] && [[ -f "$SHEET_MUSIC" ]]; then
    if [[ $(detect_os) == "macos" ]]; then
        open "$SHEET_MUSIC"
    else
        xdg-open "$SHEET_MUSIC"
    fi
fi

# Tutorial videos (Space 1)
echo "▸ Opening tutorial browser..."
$WM_FOCUS_SPACE 1
launch_app "browser"
sleep 2

if [[ -n "$TUTORIAL_URL" ]]; then
    if [[ $(detect_os) == "macos" ]]; then
        open "$TUTORIAL_URL"
    else
        xdg-open "$TUTORIAL_URL"
    fi
fi

# Metronome/tuner app (Space 10)
echo "▸ Preparing metronome workspace..."
$WM_FOCUS_SPACE 10
launch_app "browser"
sleep 1
# Open online metronome
if [[ $(detect_os) == "macos" ]]; then
    open "https://www.metronomeonline.com"
else
    xdg-open "https://www.metronomeonline.com"
fi

# Return to sheet music
$WM_FOCUS_SPACE 5

echo "✅ Practice environment ready!"
echo ""
echo "   Workspace Layout:"
echo "   • Space 5: Sheet music ← You are here"
echo "   • Space 1: Tutorial videos"
echo "   • Space 10: Metronome"
echo "   • Space 6: Practice journal"
echo ""
echo "   🎵 Happy practicing!"
```

---

## Usage Tips

### Running Bunches

```bash
# Direct execution
./my-bunch.sh

# With bunch manager
bunch-manager.sh my-bunch

# With environment variables
TEXTBOOK_PDF="~/Books/calc.pdf" ./study-session.sh
PROFILE="minimal" ./coding-project.sh
```

### Customizing Examples

1. Copy an example that matches your use case
2. Modify the workspace assignments
3. Change the applications launched
4. Adjust timing delays
5. Add your specific URLs or file paths
6. Test and iterate!

### Creating Variations

```bash
# Create variations for different contexts
cp study-session.sh math-study.sh
cp study-session.sh cs-study.sh

# Edit each with subject-specific settings
TEXTBOOK_PDF="~/Books/math.pdf" ./math-study.sh
TEXTBOOK_PDF="~/Books/cs.pdf" ./cs-study.sh
```

---

## Next Steps

1. **Choose an Example**: Find one that matches your workflow
2. **Copy and Customize**: Modify for your specific needs
3. **Test It**: Run and refine the timings/apps
4. **Create Variations**: Make versions for different contexts
5. **Share**: Help others by sharing your custom bunches!

For more information:
- **BUNCH-USE-CASES.md** - Complete reference guide
- **bunch-universal-template.sh** - Advanced template with all features
- **lib-os-detect.sh** - Available commands and functions

Happy bunch-ing! 🚀
