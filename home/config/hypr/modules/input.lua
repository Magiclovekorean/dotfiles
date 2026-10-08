---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "es,us",
		kb_variant = "",
		kb_model = "",
		-- grp:alt_altgr_toggle: press both Alts together to switch layout;
		-- right Alt alone stays AltGr (alts_toggle would break AltGr+key, e.g. AltGr+2 = @ in es)
		kb_options = "compose:caps,shift:both_capslock_cancel,grp:alt_altgr_toggle",
		kb_rules = "",

		repeat_rate = 25,
		repeat_delay = 300,

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.2,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})
