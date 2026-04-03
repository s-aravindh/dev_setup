# WezTerm Config

configs copied from https://github.com/hendrikmi/dotfiles.git and modified

---

## Key Bindings

### Shell / Readline Navigation

| Key | Action |
|-----|--------|
| `opt+left` | Move word back |
| `opt+right` | Move word forward |
| `cmd+left` | Move to beginning of line |
| `cmd+right` | Move to end of line |
| `opt+backspace` | Delete word back |
| `opt+delete` | Delete word forward |
| `cmd+backspace` | Delete to beginning of line |


---

### Tabs

| Key | Action |
|-----|--------|
| `cmd+t` | New tab |
| `cmd+w` | Close tab (no confirm) |
| `cmd+1–9` | Switch to tab 1–9 |
| `cmd+shift+r` | Rename current tab |
| `cmd+e` | Tab navigator — fuzzy search all open tabs |

---

### Panes

| Key | Action |
|-----|--------|
| `cmd+d` | Split pane right (horizontal) |
| `cmd+shift+d` | Split pane down (vertical) |
| `cmd+[` | Focus pane left |
| `cmd+]` | Focus pane right |
| `cmd+up` | Focus pane above |
| `cmd+down` | Focus pane below |
| `cmd+z` | Toggle zoom (maximize current pane) |
| `cmd+x` | Close current pane (asks confirm) |
| `cmd+s` | **Pane Select** — visual labels on all panes, press letter to jump |

---

### Workspaces (like tmux sessions — native WezTerm)

| Key | Action |
|-----|--------|
| `cmd+o` | Fuzzy workspace switcher |
| `cmd+shift+n` | Create / switch to a named workspace |
| `ctrl+shift+]` | Next workspace |
| `ctrl+shift+[` | Previous workspace |

Workspaces group tabs together. Switch between them without closing anything.
The active workspace name shows in the right status bar (blue).

---

### Scrollback & Prompts

| Key | Action |
|-----|--------|
| `cmd+k` | Clear scrollback (keeps visible) |
| `shift+pageup` | Scroll up one page |
| `shift+pagedown` | Scroll down one page |
| `ctrl+shift+up` | Jump to **previous** shell prompt in scrollback (requires shell integration) |
| `ctrl+shift+down` | Jump to **next** shell prompt in scrollback (requires shell integration) |

---

### Launch Menu

`cmd+l` — opens a fuzzy launcher with predefined commands:
- Python REPL (`python3`)
- IPython REPL
- Node REPL
- Top (system monitor)
- Bash
- SSH — RunPod (reads `$RUNPOD_HOST`)

Add/edit entries in `config.lua` under `config.launch_menu`.

---

### Copy Mode (vi-style)

Activate with `ctrl+shift+x`. Navigate terminal output without a mouse.

| Key | Action |
|-----|--------|
| `hjkl` / arrows | Move cursor |
| `w` / `b` | Jump word forward / back |
| `v` | Start selection |
| `V` | Select whole line |
| `y` | Copy selection and exit |
| `q` / `Esc` | Exit copy mode |
| `/` | Search forward |
| `?` | Search backward |
| `n` / `N` | Next / previous search match |
| `0` / `$` | Start / end of line |
| `gg` / `G` | Top / bottom of scrollback |

---

### Quick Select

`cmd+shift+space` — instantly highlights URLs, git hashes, file paths, IPs, UUIDs.  
Press the shown letter to copy to clipboard. Great for grabbing git commit hashes from logs.

---

### Font Size

| Key | Action |
|-----|--------|
| `cmd+=` | Increase font size |
| `cmd+-` | Decrease font size |
| `cmd+0` | Reset font size |

---

### Other

| Key | Action |
|-----|--------|
| `cmd+f` | Search scrollback |
| `cmd+p` | Command palette |
| `cmd+shift+f` | Toggle fullscreen |
| `ctrl+enter` | Send `ctrl+enter` escape (Neovim etc.) |
| `shift+enter` | Send `shift+enter` escape |

---

### Mouse

| Action | Behavior |
|--------|----------|
| Right-click | Paste from clipboard |
| `ctrl+click` link | Open hyperlink |
| `opt+click` link | Open hyperlink (WezTerm default) |

---

## Shell Integration

Source `shell-integration.zsh` in your `~/.zshrc` to unlock prompt-aware features:

```sh
# In ~/.zshrc:
source ~/.config/wezterm/shell-integration.zsh
```

**What it enables:**
- `ctrl+shift+up/down` jumps between shell prompts in scrollback (`ScrollToPrompt`)
- New tabs/panes inherit the current working directory (OSC 7)
- Right status bar shows the current directory
- Semantic zones: select entire command output as a block in copy mode
- User vars: `WEZTERM_PROG`, `WEZTERM_HOST`, `WEZTERM_USER` for scripting

---

## Right Status Bar

Right-to-left:
- **Time** (HH:MM)
- **CWD** — shortened path (e.g. `~/p/dev/foo`)
- **Tmux session** (teal) — when inside tmux, shows session name
- **Z** (gold) — when pane is zoomed (`cmd+z`)
- **Workspace** (blue) — active workspace name (hidden when `main`)

---

## Tmux Session Identifier

To show tmux session name in WezTerm's status bar, add to `~/.tmux.conf`:

```sh
set-option -g set-titles on
set-option -g set-titles-string "#S"   # session name only; use "#S:#W" for session:window
```

If using tmux inside WezTerm (not using WezTerm workspaces), also add:
```sh
set -g allow-passthrough on   # required for OSC user vars to work through tmux
```

---

## Workspaces vs tmux Sessions

| Feature | WezTerm Workspaces | tmux Sessions |
|---------|-------------------|---------------|
| Scope | WezTerm tabs/panes | Any terminal |
| Persistence after close | No | Yes (tmux server stays alive) |
| Keybinding to switch | `cmd+o` (fuzzy) | Depends on your tmux config |
| CWD in status bar | Yes (native) | Needs `set-titles` |
| Use together | Can run tmux inside WezTerm panes | — |

---

## Scrollback

Default increased to **10,000 lines** (from WezTerm default 3,500).  
`scroll_to_bottom_on_input = true` — typing always brings you back to the bottom.

---

## Theme

Set the `WEZTERM_THEME` env variable to switch color schemes:

```sh
export WEZTERM_THEME=nord      # Nord
export WEZTERM_THEME=onedark   # One Dark
```

---

## Background

Uses a local image at `~/.config/wezterm/dark-desert.jpg` with a semi-transparent dark overlay.  
Swap the image or edit `config.background` in `config.lua` to change it.

Config auto-reloads on save — no restart needed.