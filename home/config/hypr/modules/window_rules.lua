--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },

    no_focus = true,
})

hl.window_rule({
    name = "zen-browser-on-w1",
    match = { class = "^(zen)$" },
    workspace = "1",
})

hl.window_rule({
    name = "librewolf-browser-on-w1",
    match = { class = "^(librewolf)$" },
    workspace = "1",
})

hl.window_rule({
    name = "chromium-browser-on-w1",
    match = { class = "^(chromium-browser)$" },
    workspace = "1",
})

-- Assign workspaces 1 to 6 to HDMI-A-1 monitor and remaining to eDP-1
for i = 1, 6, 1 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1" })
end

for i = 7, 10, 1 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1" })
end
