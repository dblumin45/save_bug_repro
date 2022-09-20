local hashed = require "modules.hashed"
local shared = require "modules.shared"

local table_utils = require "modules.table_utils"
local add_to_table = table_utils.add_to_table
local deep_copy = table_utils.deep_copy

local configurations = {}
configurations.params = {
	controls = { KB = {}, GP = {} },
	graphics = {},
	sound = {},
	accessibility = {},
}
configurations.listeners = {
	controls = {},
	graphics = {},
	sound = {},
	accessibility = {}
}

function configurations.notify_listeners(group)
	local listeners = configurations.listeners[group]
	local len_listeners = #listeners
	for i=1, len_listeners do
		msg.post(listeners[i], "update_"..group)
	end
end

local filename = sys.get_save_file("save_bug_repro", "configurations")
function configurations.save()
	for k,v in pairs(configurations.params) do
		pprint(k, v)
	end
	sys.save(filename, { params = configurations.params})
end

function configurations.load()
	local data = sys.load(filename)
	return data and data.params
end

function configurations.update_controls(t)
	local controls_config = configurations.params.controls
	add_to_table(controls_config.KB, t.KB, true)
	add_to_table(controls_config.GP, t.GP, true)
	if t.aim_assist ~= nil then
		controls_config.aim_assist = t.aim_assist
	end
	configurations.notify_listeners("controls")
end

function configurations.default_controls()
	configurations.update_controls({
		KB = {
			RIGHT = hashed.key_d,
			LEFT = hashed.key_a,
			UP = hashed.key_w,
			DOWN = hashed.key_s,
			JUMP = hashed.key_space,
			INTERACT = hashed.key_r,
			ATTACK1 = hashed.key_j,
			ATTACK2 = hashed.key_k,
			ATTACK3 = hashed.key_l,
			PARRY = hashed.key_x,
			CONSUMABLES_MOD = hashed.key_q,
			SPELLS_MOD = hashed.key_e,
			ATTACK_MODIFIER = hashed.key_lshift,
			HEAL = hashed.key_down,
			SACRIFICE = hashed.key_up,
			TOGGLE_CONSUMABLES = hashed.key_left,
			TOGGLE_ABILITIES = hashed.key_right,
			INVENTORY = hashed.key_tab,
			MENU_RIGHT = hashed.key_right,
			MENU_LEFT = hashed.key_left,
			MENU_UP = hashed.key_up,
			MENU_DOWN = hashed.key_down,
			MENU_CONFIRM = hashed.key_space,
			MENU_CANCEL = hashed.key_lshift,
			MENU_PG_RIGHT = hashed.key_e,
			MENU_PG_LEFT = hashed.key_q,
			MENU_TOGGLE_VIEW = hashed.key_r,
			MENU_DETAILS = hashed.key_j,
			MENU_INFO = hashed.key_k
		},
		GP = {
			RIGHT = hashed.gamepad_lstick_right,
			LEFT = hashed.gamepad_lstick_left,
			UP = hashed.gamepad_lstick_up,
			DOWN = hashed.gamepad_lstick_down,
			JUMP = hashed.gamepad_rpad_down,

			ATTACK1 = hashed.gamepad_rpad_left,
			ATTACK2 = hashed.gamepad_rpad_up,
			ATTACK3 = hashed.gamepad_rpad_right,
			ATTACK_MODIFIER = hashed.gamepad_rshoulder,
			PARRY = hashed.gamepad_lshoulder,
			SPELLS_MOD = hashed.gamepad_rtrigger,
			CONSUMABLES_MOD = hashed.gamepad_ltrigger,
			PAN_UP = hashed.gamepad_rstick_up,
			PAN_DOWN = hashed.gamepad_rstick_down,
			PAN_RIGHT = hashed.gamepad_rstick_right,
			PAN_LEFT = hashed.gamepad_rstick_left,
			INTERACT = hashed.gamepad_rstick_click,
			HEAL = hashed.gamepad_lpad_down,
			SACRIFICE = hashed.gamepad_lpad_up,
			TOGGLE_CONSUMABLES = hashed.gamepad_lpad_left,
			TOGGLE_ABILITIES = hashed.gamepad_lpad_right,
			INVENTORY = hashed.gamepad_start,
			MAP = hashed.gamepad_back,
			MENU_RIGHT = hashed.gamepad_lpad_right,
			MENU_LEFT = hashed.gamepad_lpad_left,
			MENU_UP = hashed.gamepad_lpad_up,
			MENU_DOWN = hashed.gamepad_lpad_down,
			MENU_CONFIRM = hashed.gamepad_rpad_down,
			MENU_CANCEL = hashed.gamepad_rpad_right,
			MENU_DETAILS = hashed.gamepad_rpad_left,
			MENU_INFO = hashed.gamepad_rpad_up,
			MENU_CAT_RIGHT = hashed.gamepad_rshoulder,
			MENU_CAT_LEFT = hashed.gamepad_lshoulder,
			MENU_PG_RIGHT = hashed.gamepad_rtrigger,
			MENU_PG_LEFT = hashed.gamepad_ltrigger,
			MENU_TOGGLE_VIEW = hashed.gamepad_rstick_click
		},
		aim_assist = false
	})
end

local resolutions = {
	{ x = 800, y = 600 },
	{ x = 1024, y = 768 },
	{ x = 1152, y = 864 },
	{ x = 1176, y = 664 },
	{ x = 1280, y = 720 },
	{ x = 1280, y = 768 },
	{ x = 1280, y = 800 },
	{ x = 1280, y = 960 },
	{ x = 1280, y = 1024 },
	{ x = 1360, y = 768 },
	{ x = 1366, y = 768 },
	{ x = 1440, y = 900 },
	{ x = 1600, y = 900 },
	{ x = 1600, y = 1024 },
	{ x = 1680, y = 1050 },
	{ x = 1920, y = 1080 },
	{ x = 1920, y = 1200 },
	{ x = 1920, y = 1440 },
	{ x = 2048, y = 1536 },
	{ x = 2560, y = 1440 },
	{ x = 2560, y = 1600 },
	{ x = 3840, y = 2160 }
}

shared.resolutions = resolutions

local lighting_presets = {
	{
		label = "Performance",
		resolution = 256,
		light_delay = 1/30
	},
	{
		label = "Low",
		resolution = 256,
		light_delay = 1/60
	},
	{
		label = "Medium",
		si = vmath.vector4(1, 2, 0, 0),
		resolution = 256,
		light_delay = 1/60
	},
	{
		label = "High",
		si = vmath.vector4(1, 2, 0, 0),
		resolution = 512,
		light_delay = 1/60
	}
}
configurations.params.graphics.lighting_presets = lighting_presets
configurations.params.graphics.resolutions = resolutions
shared.lighting_presets = lighting_presets

local resolution_scale = 1

function configurations.update_graphics(t)
	local graphics_config = configurations.params.graphics
	add_to_table(graphics_config, t, true)

	local resolution = resolutions[graphics_config.resolutions_index]

	if not graphics_config.is_fullscreen and t.resolutions_index then
		--defos.set_view_size(0, 0, resolution.x, resolution.y)
	end
	--defos.set_fullscreen(graphics_config.is_fullscreen)
	msg.post("@render:", "update_lighting_preset")
end
function configurations.default_graphics()
	-- default resolution to current resolution mode
	local display = defos.get_displays()[ defos.get_current_display_id() ].mode
	local width = display.width
	local height = display.height
	local resolution_index = 16
	local resolution = resolutions[resolution_index]

	for i,v in pairs(resolutions) do
		if not v.label then
			v.label = v.x..":"..v.y
		end
	end

	configurations.update_graphics({
		is_fullscreen = false,
		resolutions_index = resolution_index,
		lighting_presets_index = 4,
		resolution_scale = resolution_scale
	})

end
shared.configuration_params = configurations.params

function configurations.update_sound(t)
	local sound_config = configurations.params.sound
	add_to_table(sound_config, t, true)
	for i,v in pairs(sound_config) do
		--sound.set_group_gain(hash_with_reference(i), v)
	end	
end

function configurations.default_sound()
	configurations.update_sound({
		master = 1, music = 0.0, fx = 0.5
	})
end

function configurations.update_accessibility(t)
	local accessibility_config = configurations.params.accessibility
	add_to_table(accessibility_config, t, true)
	if t.game_speed then
		--msg.post("loader:/go#", "update_game_speed")
	end	
end

function configurations.default_accessibility()
	configurations.update_accessibility({
		game_speed = 1
	})
end

function configurations.default()
	configurations.default_controls()
	configurations.default_graphics()
	configurations.default_sound()
	configurations.default_accessibility()
end



function configurations.init()
	-- prehash all input values:
	local loaded, error = sys.load_resource("/input/all.input_binding") 
	if error then
		print_line("could not load input bindings!")
	end

	for line in loaded:gmatch("([^\n]+)") do
		local quote = line:find('"')
		if quote then
			local input = line:sub(quote + 1, #line - 2)
			hash_with_reference(input)
		end
	end
	local loaded = configurations.load()
	if true or not loaded then
		pprint("save")
		configurations.default()
		configurations.save()
		pprint("success!")
	else
		configurations.params = loaded
	end	
end

return configurations