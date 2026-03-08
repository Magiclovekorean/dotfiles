# Yazi Configuration

## Image Preview in WezTerm + WSL

To get image preview working in Yazi when using WezTerm on Windows 11 with WSL:

### 1. WezTerm Config (`wezterm.lua`)

Add to enable Kitty graphics protocol:
```lua
config.enable_kitty_graphics = true
```

### 2. Yazi Config (`yazi.toml`)

Add under `[preview]`:
```toml
image_protocol = "kitty"
```

### 3. Tmux Config (`.tmux.conf`)

If using tmux, add:
```bash
set -g allow-passthrough on
set -ga update-environment TERM
set -ga update-environment TERM_PROGRAM
```

### 4. SSH Setup (Required for WezTerm + WSL)

WezTerm must connect to WSL via SSH to bypass ConPTY limitations.

**Install SSH server in WSL:**
```bash
sudo apt install openssh-server
sudo service ssh start
```

**Auto-start SSH on WSL boot:**
Add to `/etc/wsl.conf`:
```ini
[boot]
command="service ssh start"
```

**Setup SSH key auth (Windows side):**
```powershell
ssh-keygen -t ed25519 -C "wezterm"
ssh-keyscan 127.0.0.1 >> $env:USERPROFILE\.ssh\known_hosts
```

**Copy public key to WSL:**
```powershell
Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub
```

Then in WSL:
```bash
echo "PASTE_KEY_HERE" > ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

### 5. Connect via SSH (manual)

Instead of using WSL directly, connect via:
```bash
wezterm ssh magictt@127.0.0.1
```

Then run `yazi` - images should render properly with full Kitty image support.

### 6. Auto-connect via SSH on WezTerm startup (no extra log window)

To have WezTerm always open directly into the SSH-connected WSL session (without an extra window just showing logs), use an SSH domain instead of running `wezterm ssh` as a command.

In `wezterm.lua` on Windows:

```lua
-- SSH domain pointing to WSL
config.ssh_domains = {
  {
    name = "magictt-wsl",
    remote_address = "127.0.0.1",
    username = "magictt",
    multiplexing = "None", -- don't require wezterm on the server
  },
}

-- Open this domain by default when WezTerm starts
config.default_domain = "magictt-wsl"
```

This:
1. Makes every new WezTerm window open directly into `magictt@127.0.0.1` over SSH.
2. Avoids spawning a separate window/pane with SSH logs.
3. Keeps full Kitty image preview working in Yazi (since the connection still bypasses ConPTY).

### 7. Optional: clear SSH login noise in WSL

If you want a perfectly clean prompt when WezTerm connects over SSH, add this at the end of your `~/.zshrc` in WSL:

```bash
if [[ "$TERM_PROGRAM" == "WezTerm" && -n "$SSH_CONNECTION" ]]; then
  clear
fi
```

This clears the screen after the SSH banner and any connection messages, so you only see your prompt when Yazi/WezTerm starts.
