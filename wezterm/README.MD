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

> **SendKey vs SendString**: Navigation uses `SendKey { key="b", mods="META" }` instead of `SendString("\x1bb")`. Both result in the same escape sequence, but `SendKey` sends a proper key event that respects the terminal's current encoding mode — more correct, more readable.

---

### Tabs

| Key | Action |
|-----|--------|
| `cmd+t` | New tab |
| `cmd+w` | Close tab (no confirm) |
| `cmd+1–9` | Switch to tab 1–9 |
| `cmd+shift+r` | Rename current tab |

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

---

### Font Size

| Key | Action |
|-----|--------|
| `cmd+=` | Increase font size |
| `cmd+-` | Decrease font size |
| `cmd+0` | Reset font size |

---

### Scrollback

| Key | Action |
|-----|--------|
| `cmd+k` | Clear scrollback (keeps visible) |
| `shift+pageup` | Scroll up one page |
| `shift+pagedown` | Scroll down one page |

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

Activate with `cmd+shift+space`. Instantly highlights common patterns (URLs, git hashes, file paths, IPs, UUIDs) — press the shown letter to copy it to clipboard.

Useful for: copying a URL from output, grabbing a git commit hash, copying a file path from a stack trace.

---

### Search Scrollback

`cmd+f` — opens incremental search through all scrollback output.

---

### Other

| Key | Action |
|-----|--------|
| `cmd+f` | Search scrollback |
| `cmd+p` | Command palette |
| `cmd+shift+f` | Toggle fullscreen |
| `ctrl+enter` | Send `ctrl+enter` escape (for editors like Neovim) |
| `shift+enter` | Send `shift+enter` escape |

---

### Mouse

| Action | Behavior |
|--------|----------|
| Right-click | Paste from clipboard |
| `ctrl+click` link | Open hyperlink |
| `opt+click` link | Open hyperlink (WezTerm default) |

---

## Right Status Bar

The right side of the tab bar shows:
- **Z** (gold) — current pane is zoomed (`cmd+z`)
- **session name** (teal) — when tmux is the foreground process, shows the pane/terminal title (populated by tmux's `set-titles`)
- **HH:MM** — current time

### Tmux session identifier setup

To make WezTerm show which tmux session you're in (useful when you have multiple tabs each running a different session), add to your `~/.tmux.conf`:

```sh
set-option -g set-titles on
set-option -g set-titles-string "#S"   # shows session name; use "#S:#W" for session:window
```

With this, each WezTerm tab running a different `tmux attach -t <name>` will display its session name in the right status.

---

## Theme

Set the `WEZTERM_THEME` env variable to switch color schemes:

```sh
export WEZTERM_THEME=nord      # Nord
export WEZTERM_THEME=onedark   # One Dark
```

---

## Background

Uses a local image at `~/.config/wezterm/dark-desert.jpg` with a semi-transparent dark overlay. To change the background swap out the image file or edit `config.background` in `config.lua`.

Config auto-reloads on save — no restart needed.