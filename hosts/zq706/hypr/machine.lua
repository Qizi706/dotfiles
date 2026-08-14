-- zq706: exact monitor and NVIDIA overrides, loaded after shared/DMS modules.
hl.monitor({
	output = "DP-4",
	mode = "2560x1440@143.999",
	position = "auto",
	scale = 1.25,
	vrr = 0,
})

hl.config({
	cursor = {
		no_hardware_cursors = 1,
	},
	misc = {
		vrr = 0,
	},
})
