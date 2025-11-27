#!/bin/bash

# repoedit.sh - Interactive repository configuration helper with TUI
# Features: Change repo name, manage branches, view repo info, configure remotes
# Usage: repoedit [repo-path]

set -e

# Colors for TUI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Determine current repo (use argument or current directory)
if [ -n "$1" ]; then
    REPO_PATH="$1"
else
    REPO_PATH="$(pwd)"
fi

# Verify it's a git repository
if [ ! -d "$REPO_PATH/.git" ]; then
    echo -e "${RED}✗ Fehler: Kein Git-Repository gefunden in $REPO_PATH${NC}"
    exit 1
fi

cd "$REPO_PATH"

# Get current repo info
REPO_NAME=$(basename "$REPO_PATH")
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
COMMIT_COUNT=$(git rev-list --count HEAD 2>/dev/null || echo "0")
REMOTE_URL=$(git config --get remote.origin.url 2>/dev/null || echo "Nicht konfiguriert")

# Main menu function
show_main_menu() {
    clear
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN}    Repository Helper - Konfiguration${NC}"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${BOLD}Repository:${NC} $REPO_NAME"
    echo -e "${BOLD}Pfad:${NC} $REPO_PATH"
    echo -e "${BOLD}Branch:${NC} $CURRENT_BRANCH"
    echo -e "${BOLD}Commits:${NC} $COMMIT_COUNT"
    echo ""
    echo -e "${BOLD}${CYAN}Menü:${NC}"
    echo -e "  ${GREEN}1${NC} - Repository-Informationen anzeigen"
    echo -e "  ${GREEN}2${NC} - Branch verwalten"
    echo -e "  ${GREEN}3${NC} - Remote verwalten"
    echo -e "  ${GREEN}4${NC} - Repository umbenennen"
    echo -e "  ${GREEN}5${NC} - Git-Konfiguration anzeigen"
    echo -e "  ${GREEN}6${NC} - Repository Status"
    echo -e "  ${GREEN}0${NC} - Beenden"
    echo ""
    echo -n -e "${YELLOW}Wähle eine Option (0-6):${NC} "
}

# Show repository info
show_repo_info() {
    clear
    echo -e "${BOLD}${CYAN}Repository-Informationen${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "Name:        $REPO_NAME"
    echo -e "Pfad:        $REPO_PATH"
    echo -e "Branch:      $CURRENT_BRANCH"
    echo -e "Commits:     $COMMIT_COUNT"
    echo -e "Remote URL:  $REMOTE_URL"
    echo ""
    echo -e "Branches:"
    git branch -a | sed 's/^/  /'
    echo ""
    echo -n "Drücke Enter zum Fortfahren..."
    read
}

# Manage branches
manage_branches() {
    clear
    echo -e "${BOLD}${CYAN}Branch-Verwaltung${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "  ${GREEN}1${NC} - Neuen Branch erstellen"
    echo -e "  ${GREEN}2${NC} - Branch löschen"
    echo -e "  ${GREEN}3${NC} - Zu Branch wechseln"
    echo -e "  ${GREEN}4${NC} - Alle Branches auflisten"
    echo -e "  ${GREEN}0${NC} - Zurück"
    echo ""
    echo -n "Wähle eine Option: "
    read branch_choice

    case $branch_choice in
        1)
            echo -n "Neuer Branch-Name: "
            read new_branch
            if git checkout -b "$new_branch"; then
                echo -e "${GREEN}✓ Branch '$new_branch' erstellt und aktiviert${NC}"
            fi
            ;;
        2)
            echo -n "Branch zum Löschen (nicht der aktuelle): "
            read del_branch
            if git branch -d "$del_branch"; then
                echo -e "${GREEN}✓ Branch '$del_branch' gelöscht${NC}"
            fi
            ;;
        3)
            echo -n "Zu welchem Branch wechseln? "
            read switch_branch
            if git checkout "$switch_branch"; then
                echo -e "${GREEN}✓ Zu Branch '$switch_branch' gewechselt${NC}"
            fi
            ;;
        4)
            echo ""
            git branch -a
            ;;
        0)
            return
            ;;
        *)
            echo -e "${RED}Ungültige Option${NC}"
            ;;
    esac

    echo ""
    echo -n "Drücke Enter zum Fortfahren..."
    read
}

# Manage remotes - ENHANCED
manage_remotes() {
    while true; do
        clear
        echo -e "${BOLD}${CYAN}Remote-Verwaltung${NC}"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Aktuelle Remotes:"
        if git remote -v | grep -q .; then
            git remote -v | sed 's/^/  /'
        else
            echo "  Keine Remotes konfiguriert"
        fi
        echo ""
        echo -e "  ${GREEN}1${NC} - Remote hinzufügen"
        echo -e "  ${GREEN}2${NC} - Remote URL ändern"
        echo -e "  ${GREEN}3${NC} - Remote-Namen ändern"
        echo -e "  ${GREEN}4${NC} - Remote entfernen"
        echo -e "  ${GREEN}5${NC} - Remote-Details anzeigen"
        echo -e "  ${GREEN}6${NC} - GitHub Remote Setup (SSH)"
        echo -e "  ${GREEN}7${NC} - GitHub Remote Setup (HTTPS)"
        echo -e "  ${GREEN}8${NC} - Alle Remotes auf einmal anzeigen"
        echo -e "  ${GREEN}0${NC} - Zurück"
        echo ""
        echo -n "Wähle eine Option: "
        read remote_choice

        case $remote_choice in
            1)
                echo -n "Remote-Name (z.B. origin): "
                read remote_name
                echo -n "Remote URL: "
                read remote_url
                if git remote add "$remote_name" "$remote_url"; then
                    echo -e "${GREEN}✓ Remote '$remote_name' hinzugefügt${NC}"
                else
                    echo -e "${RED}✗ Remote konnte nicht hinzugefügt werden${NC}"
                fi
                ;;
            2)
                echo -n "Remote-Name zum Ändern: "
                read change_remote
                echo -n "Neue URL: "
                read new_url
                if git remote set-url "$change_remote" "$new_url"; then
                    echo -e "${GREEN}✓ Remote-URL aktualisiert${NC}"
                else
                    echo -e "${RED}✗ Fehler beim Aktualisieren der URL${NC}"
                fi
                ;;
            3)
                echo -n "Aktueller Remote-Name: "
                read old_remote_name
                echo -n "Neuer Remote-Name: "
                read new_remote_name
                if git remote rename "$old_remote_name" "$new_remote_name"; then
                    echo -e "${GREEN}✓ Remote umbenannt: $old_remote_name → $new_remote_name${NC}"
                else
                    echo -e "${RED}✗ Fehler beim Umbenennen${NC}"
                fi
                ;;
            4)
                echo -n "Remote-Name zum Löschen: "
                read del_remote
                if git remote remove "$del_remote"; then
                    echo -e "${GREEN}✓ Remote '$del_remote' entfernt${NC}"
                else
                    echo -e "${RED}✗ Remote konnte nicht gelöscht werden${NC}"
                fi
                ;;
            5)
                echo -n "Remote-Name zum Anzeigen: "
                read show_remote
                echo ""
                echo -e "${BOLD}Details für Remote '$show_remote':${NC}"
                git remote show "$show_remote" 2>/dev/null || echo -e "${RED}Remote nicht gefunden${NC}"
                ;;
            6)
                echo -n "GitHub Username: "
                read gh_user
                echo -n "Repository-Name: "
                read repo_name
                remote_url="git@github.com:${gh_user}/${repo_name}.git"
                
                if git remote | grep -q origin; then
                    echo "Remote 'origin' existiert bereits. Möchtest du es überschreiben? (j/n): "
                    read overwrite
                    if [ "$overwrite" = "j" ]; then
                        git remote set-url origin "$remote_url"
                        echo -e "${GREEN}✓ Remote-URL aktualisiert${NC}"
                    fi
                else
                    git remote add origin "$remote_url"
                    echo -e "${GREEN}✓ Remote 'origin' hinzugefügt (SSH)${NC}"
                fi
                echo -e "URL: $remote_url"
                ;;
            7)
                echo -n "GitHub Username: "
                read gh_user
                echo -n "Repository-Name: "
                read repo_name
                remote_url="https://github.com/${gh_user}/${repo_name}.git"
                
                if git remote | grep -q origin; then
                    echo "Remote 'origin' existiert bereits. Möchtest du es überschreiben? (j/n): "
                    read overwrite
                    if [ "$overwrite" = "j" ]; then
                        git remote set-url origin "$remote_url"
                        echo -e "${GREEN}✓ Remote-URL aktualisiert${NC}"
                    fi
                else
                    git remote add origin "$remote_url"
                    echo -e "${GREEN}✓ Remote 'origin' hinzugefügt (HTTPS)${NC}"
                fi
                echo -e "URL: $remote_url"
                ;;
            8)
                clear
                echo -e "${BOLD}${CYAN}Alle Remotes im Detail${NC}"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                for remote in $(git remote); do
                    echo ""
                    echo -e "${MAGENTA}Remote: $remote${NC}"
                    git remote show "$remote" 2>/dev/null | sed 's/^/  /'
                done
                ;;
            0)
                return
                ;;
            *)
                echo -e "${RED}Ungültige Option${NC}"
                ;;
        esac

        echo ""
        echo -n "Drücke Enter zum Fortfahren..."
        read
    done
}

# Rename repository
rename_repo() {
    clear
    echo -e "${BOLD}${CYAN}Repository umbenennen${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Aktueller Name: $REPO_NAME"
    echo -n "Neuer Name: "
    read new_name

    if [ -z "$new_name" ]; then
        echo -e "${RED}✗ Name darf nicht leer sein${NC}"
        return
    fi

    NEW_PATH="$(dirname "$REPO_PATH")/$new_name"

    if mv "$REPO_PATH" "$NEW_PATH"; then
        echo -e "${GREEN}✓ Repository umbenannt zu: $new_name${NC}"
        echo -e "${YELLOW}Hinweis: Bitte aktualisiere deine Umgebungsvariablen${NC}"
        REPO_PATH="$NEW_PATH"
        REPO_NAME="$new_name"
    else
        echo -e "${RED}✗ Fehler beim Umbenennen${NC}"
    fi

    echo ""
    echo -n "Drücke Enter zum Fortfahren..."
    read
}

# Show git config
show_git_config() {
    clear
    echo -e "${BOLD}${CYAN}Git-Konfiguration${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    git config --list
    echo ""
    echo -n "Drücke Enter zum Fortfahren..."
    read
}

# Show repository status
show_status() {
    clear
    echo -e "${BOLD}${CYAN}Repository Status${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    git status
    echo ""
    echo -n "Drücke Enter zum Fortfahren..."
    read
}

# Main loop
while true; do
    show_main_menu
    read choice

    case $choice in
        1)
            show_repo_info
            ;;
        2)
            manage_branches
            ;;
        3)
            manage_remotes
            ;;
        4)
            rename_repo
            ;;
        5)
            show_git_config
            ;;
        6)
            show_status
            ;;
        0)
            echo -e "${GREEN}✓ Auf Wiedersehen!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Ungültige Option${NC}"
            sleep 1
            ;;
    esac
done
