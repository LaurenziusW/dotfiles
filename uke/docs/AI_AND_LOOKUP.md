# UKE AI & Lookup Guide

This guide explains how to use the integrated assistance tools in UKE v8: `uke-lookup` (deterministic) and `uke-ai` (generative).

---

## 1. uke-lookup: The Deterministic Tool

Use this when you need an **exact answer** quickly. It parses your actual configuration files and documentation, guaranteeing 100% accuracy.

### Prerequisites
- **fzf**: Required for fuzzy finding. (Installed by default via `bootstrap.sh` on Arch, or `brew install fzf` on macOS).

### Usage

| Command | Action |
|:--------|:-------|
| `uke-lookup` | Opens the main menu to select a category. |
| `uke-lookup aliases` | Lists all aliases from `.zshrc`. Press **Enter** to copy the alias command to your clipboard. |
| `uke-lookup keys` | Lists all active hotkeys from `skhdrc` (macOS) or `hyprland.conf` (Linux). |
| `uke-lookup docs` | Searches headers in `UKE_REFERENCE.md` and previews the content. |

### Optimization Tips
- **Fuzzy Search**: Type vaguely what you remember (e.g., "git log" or "resize") and `fzf` will find it.
- **Clipboard**: The alias search automatically copies the *expansion* of the alias to your clipboard.
    - *Example:* Search "gco", select it, and `git checkout` is now in your clipboard.

---

## 2. uke-ai: The Generative Assistant

Use this when you need **explanations**, **guides**, or complex answers that require understanding the context of your system.

### Prerequisites
- **Ollama**: The local LLM runner.
    - **macOS**: `brew install ollama`
    - **Linux**: `curl -fsSL https://ollama.com/install.sh | sh` (or via AUR: `ollama-bin`)
- **Model**: You must pull a model first. We recommend `llama3.2` (lightweight, 3B parameters) or `qwen2.5-coder` (optimized for code).
    ```bash
    ollama pull llama3.2
    ```

### Usage

```bash
# Ask a question
uke-ai "How do I reset my local git branch to match remote?"

# Ask about UKE specifics (it knows your docs!)
uke-ai "What is the hotkey for sticky windows?"
```

### How it Works
1. The script reads `UKE_REFERENCE.md`.
2. It constructs a system prompt: "You are an expert on UKE... here is the reference doc...".
3. It appends your question.
4. It sends the full context to your local Ollama instance for inference.

### Configuration & Optimization
The script is located at `~/.local/bin/uke-ai`.

**Change the Model:**
Edit the `MODEL` variable at the top of the script to use a different model:
```bash
MODEL="qwen2.5-coder"  # Better for coding questions
# or
MODEL="mistral"        # Larger, more general knowledge
```

**Performance:**
- `llama3.2` (3B) is fast and runs on almost any CPU/GPU.
- `llama3.1` (8B) is smarter but requires more RAM (approx 8GB).
- If responses are slow, stick to the 3B models.

### Privacy
Everything runs **locally**. No data is sent to the cloud. You can use `uke-ai` completely offline.
