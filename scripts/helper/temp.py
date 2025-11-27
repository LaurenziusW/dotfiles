#!/usr/bin/env python3
"""
Interactive Obsidian Plugin Sorter
Allows you to organize plugins into Keep, Maybe, and Remove categories
with drag-and-drop functionality and state export
"""

import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import json
from pathlib import Path
from dataclasses import dataclass
from datetime import datetime

@dataclass
class Plugin:
    name: str
    slug: str
    category: str = "maybe"
    
    def __str__(self):
        return f"{self.name}  {self.slug}" if self.slug else self.name


class PluginSorter:
    KEEP = "keep"
    MAYBE = "maybe"
    REMOVE = "remove"
    
    def __init__(self, root):
        self.root = root
        self.root.title("Obsidian Plugin Sorter")
        self.root.geometry("1200x700")
        
        # Plugin storage
        self.plugins = {
            self.KEEP: [],
            self.MAYBE: [],
            self.REMOVE: []
        }
        
        self.load_plugins()
        self.create_ui()
        
    def load_plugins(self):
        """Load plugins from your files"""
        # Keep plugins
        keep_list = [
            ("Statusbar Pomodoro", "statusbar-pomodoro"),
            ("Local Backup", "local-backup"),
            ("Longform", "longform"),
            ("Meld Encrypt", "meld-encrypt"),
            ("Metadata Menu", "metadata-menu"),
            ("MetaEdit", "metaedit"),
            ("Dataview", "dataview"),
            ("Templater", "templater-obsidian"),
            ("QuickAdd", "quickadd"),
            ("Advanced Tables", "table-editor-obsidian"),
            ("Vimrc Support", "obsidian-vimrc-support"),
            ("Vault Changelog", "obsidian-vault-changelog"),
            ("Home tab", "home-tab"),
            ("Homepage", "homepage"),
            ("Hotkeys++", "hotkeysplus-obsidian"),
            ("Global Search and Replace", "global-search-and-replace"),
            ("External File Embed and Link", "external-file-embed-and-link"),
            ("Spaced Repetition", "obsidian-spaced-repetition"),
            ("Obsidian_to_Anki", "obsidian-to-anki-plugin"),
            ("Edit in Neovim", "edit-in-neovim"),
            ("Regex Find/Replace", "obsidian-regex-replace"),
            ("Find and replace in selection", "find-and-replace-in-selection"),
            ("Advanced URI", "obsidian-advanced-uri"),
            ("Transcriptor", "obsidian-transcriptor"),
            ("Status Bar Pomodoro Timer", "obsidian-statusbar-pomo"),
            ("TagFolder", "obsidian-tagfolder"),
            ("Trash Explorer", "obsidian-trash-explorer"),
            ("Zotero Integration", "obsidian-zotero-desktop-connector"),
            ("BRAT", "obsidian42-brat"),
            ("Omnisearch", "omnisearch"),
            ("Plugin Tracker", "plugin-tracker"),
            ("Recent Files", "recent-files-obsidian"),
            ("Settings Search", "settings-search"),
            ("Tag Wrangler", "tag-wrangler"),
        ]
        
        maybe_list = [
            ("Chord Sheets", "chord-sheets"),
            ("LaTeX-like Theorem & Equation Referencer", "math-booster"),
            ("Image2LaTEX", "image2latex"),
            ("Latex OCR", "latex-ocr"),
            ("TikZJax", "obsidian-tikzjax"),
            ("Quick Latex", "quick-latex"),
            ("MathLinks", "mathlinks"),
            ("Pretty BibTeX", "obsidian-pretty-bibtex"),
            ("Latex Environments", "obsidian-latex-environments"),
            ("Obsidian matrix", "obsidian-matrix"),
            ("Latex Suite", "obsidian-latex-suite"),
            ("Plugin Groups", "obsidian-plugin-groups"),
            ("Lazy Plugin Loader", "lazy-plugins"),
            ("Guitar Chord", "guitar-chord"),
            ("Diagrams", "drawio-obsidian"),
            ("Plugin Update Tracker", "obsidian-plugin-update-tracker"),
            ("Editing Toolbar", "editing-toolbar"),
            ("ExcaliBrain", "excalibrain"),
            ("Execute Code", "execute-code"),
            ("Find orphaned files and broken links", "find-unlinked-files"),
            ("Floating Search", "float-search"),
            ("Image Converter", "image-converter"),
            ("Janitor", "janitor"),
            ("Journals", "journals"),
            ("JS Engine", "js-engine"),
            ("Keyboard Analyzer", "keyboard-analyzer"),
            ("File Cleaner", "obsidian-file-cleaner"),
            ("Dictionary", "obsidian-dictionary-plugin"),
            ("Doubleshift", "obsidian-doubleshift"),
            ("Desmos", "obsidian-desmos"),
            ("Ledger", "ledger-obsidian"),
            ("Enhancing Export", "obsidian-enhancing-export"),
            ("Git", "obsidian-git"),
            ("Importer", "obsidian-importer"),
        ]
        
        for name, slug in keep_list:
            self.plugins[self.KEEP].append(Plugin(name, slug, self.KEEP))
        
        for name, slug in maybe_list:
            self.plugins[self.MAYBE].append(Plugin(name, slug, self.MAYBE))
    
    def create_ui(self):
        """Create the main UI"""
        # Top frame for controls
        control_frame = ttk.Frame(self.root)
        control_frame.pack(side=tk.TOP, fill=tk.X, padx=10, pady=10)
        
        ttk.Button(control_frame, text="Export State (JSON)", command=self.export_json).pack(side=tk.LEFT, padx=5)
        ttk.Button(control_frame, text="Export Readable", command=self.export_readable).pack(side=tk.LEFT, padx=5)
        ttk.Button(control_frame, text="Import from JSON", command=self.import_json).pack(side=tk.LEFT, padx=5)
        ttk.Button(control_frame, text="Clear All", command=self.clear_all).pack(side=tk.LEFT, padx=5)
        
        # Main container with three columns
        main_frame = ttk.Frame(self.root)
        main_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        
        # Keep column
        self.create_column(main_frame, self.KEEP, "KEEP âœ“", 0)
        
        # Maybe column
        self.create_column(main_frame, self.MAYBE, "MAYBE ?", 1)
        
        # Remove column
        self.create_column(main_frame, self.REMOVE, "REMOVE âœ—", 2)
    
    def create_column(self, parent, category, label, column):
        """Create a category column"""
        frame = ttk.LabelFrame(parent, text=label, padding=10)
        frame.grid(row=0, column=column, sticky="nsew", padx=5, pady=5)
        parent.columnconfigure(column, weight=1)
        
        # Listbox for plugins
        listbox = tk.Listbox(
            frame,
            height=30,
            width=30,
            selectmode=tk.EXTENDED,
            font=("Monospace", 10)
        )
        listbox.pack(fill=tk.BOTH, expand=True, side=tk.LEFT)
        
        # Scrollbar
        scrollbar = ttk.Scrollbar(frame, orient=tk.VERTICAL, command=listbox.yview)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        listbox.config(yscrollcommand=scrollbar.set)
        
        # Populate listbox
        for plugin in self.plugins[category]:
            listbox.insert(tk.END, str(plugin))
        
        # Bind double-click to move plugin
        def on_double_click(event):
            selection = listbox.curselection()
            if selection:
                idx = selection[0]
                plugin = self.plugins[category][idx]
                self.move_plugin(plugin, category)
        
        listbox.bind("<Double-Button-1>", on_double_click)
        
        # Store reference for updates
        if not hasattr(self, 'listboxes'):
            self.listboxes = {}
        self.listboxes[category] = listbox
    
    def move_plugin(self, plugin, from_category):
        """Move plugin to next category"""
        categories = [self.KEEP, self.MAYBE, self.REMOVE]
        current_idx = categories.index(from_category)
        next_idx = (current_idx + 1) % len(categories)
        next_category = categories[next_idx]
        
        # Remove from current
        self.plugins[from_category].remove(plugin)
        
        # Add to next
        plugin.category = next_category
        self.plugins[next_category].append(plugin)
        
        # Update UI
        self.refresh_ui()
    
    def refresh_ui(self):
        """Refresh all listboxes"""
        for category in [self.KEEP, self.MAYBE, self.REMOVE]:
            listbox = self.listboxes[category]
            listbox.delete(0, tk.END)
            for plugin in self.plugins[category]:
                listbox.insert(tk.END, str(plugin))
    
    def export_json(self):
        """Export state as JSON"""
        state = {
            "timestamp": datetime.now().isoformat(),
            "keep": [{"name": p.name, "slug": p.slug} for p in self.plugins[self.KEEP]],
            "maybe": [{"name": p.name, "slug": p.slug} for p in self.plugins[self.MAYBE]],
            "remove": [{"name": p.name, "slug": p.slug} for p in self.plugins[self.REMOVE]],
        }
        
        file_path = filedialog.asksaveasfilename(
            defaultextension=".json",
            filetypes=[("JSON files", "*.json"), ("All files", "*.*")]
        )
        
        if file_path:
            with open(file_path, 'w') as f:
                json.dump(state, f, indent=2)
            messagebox.showinfo("Success", f"Exported to {file_path}")
    
    def export_readable(self):
        """Export as readable markdown/text"""
        file_path = filedialog.asksaveasfilename(
            defaultextension=".md",
            filetypes=[("Markdown files", "*.md"), ("Text files", "*.txt"), ("All files", "*.*")]
        )
        
        if file_path:
            with open(file_path, 'w') as f:
                f.write("# Obsidian Plugin Organization\n\n")
                f.write(f"Exported: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
                
                f.write("## KEEP âœ“\n\n")
                for p in self.plugins[self.KEEP]:
                    f.write(f"- {p.name}  `{p.slug}`\n")
                
                f.write(f"\n**Total: {len(self.plugins[self.KEEP])} plugins**\n\n")
                
                f.write("## MAYBE ?\n\n")
                for p in self.plugins[self.MAYBE]:
                    f.write(f"- {p.name}  `{p.slug}`\n")
                
                f.write(f"\n**Total: {len(self.plugins[self.MAYBE])} plugins**\n\n")
                
                f.write("## REMOVE âœ—\n\n")
                for p in self.plugins[self.REMOVE]:
                    f.write(f"- {p.name}  `{p.slug}`\n")
                
                f.write(f"\n**Total: {len(self.plugins[self.REMOVE])} plugins**\n")
            
            messagebox.showinfo("Success", f"Exported to {file_path}")
    
    def import_json(self):
        """Import state from JSON"""
        file_path = filedialog.askopenfilename(
            filetypes=[("JSON files", "*.json"), ("All files", "*.*")]
        )
        
        if file_path:
            try:
                with open(file_path, 'r') as f:
                    state = json.load(f)
                
                self.plugins[self.KEEP] = [Plugin(p["name"], p["slug"], self.KEEP) for p in state.get("keep", [])]
                self.plugins[self.MAYBE] = [Plugin(p["name"], p["slug"], self.MAYBE) for p in state.get("maybe", [])]
                self.plugins[self.REMOVE] = [Plugin(p["name"], p["slug"], self.REMOVE) for p in state.get("remove", [])]
                
                self.refresh_ui()
                messagebox.showinfo("Success", "Imported from JSON")
            except Exception as e:
                messagebox.showerror("Error", f"Failed to import: {e}")
    
    def clear_all(self):
        """Clear all and reset"""
        if messagebox.askyesno("Clear All", "Reset all plugins to default?"):
            self.plugins = {self.KEEP: [], self.MAYBE: [], self.REMOVE: []}
            self.load_plugins()
            self.refresh_ui()


if __name__ == "__main__":
    root = tk.Tk()
    app = PluginSorter(root)
    root.mainloop()