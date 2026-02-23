# Tmux Scripts

A collection of tmux configuration snippets and scripts.

---

## Enable Mouse Support

Add mouse support to tmux in 3 simple steps:

### 1. Open your tmux config file

```bash
nano ~/.tmux.conf
```

### 2. Add this line

```bash
set -g mouse on
```

### 3. Reload config (or restart tmux)

```bash
tmux source-file ~/.tmux.conf
```

---

## Add Config Reload Key Binding

Add a quick shortcut to reload tmux config without restarting:

### 1. Open your tmux config file

```bash
nano ~/.tmux.conf
```

### 2. Add this line anywhere in the file

```bash
bind r source-file ~/.tmux.conf \; display "Reloaded!"
```

### 3. Save and reload

```bash
tmux source-file ~/.tmux.conf
```

> **Note:** Put this inside your tmux config file, not directly in the tmux terminal.

After adding this, you can press `Prefix + r` (default prefix is `Ctrl+b`) to reload your tmux configuration instantly.

---

## Full Example ~/.tmux.conf

```bash
# Enable mouse support
set -g mouse on

# Reload config with Prefix + r
bind r source-file ~/.tmux.conf \; display "Reloaded!"
```




tmux list-sessions

tmux attach -t 4panes


tmux attach