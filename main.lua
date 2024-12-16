-- Infinite Bandit Standoff v1.0.1
-- SmoothSpatula

log.info("Successfully loaded ".._ENV["!guid"]..".")

-- ========== Parameters ==========

mods.on_all_mods_loaded(function() for k, v in pairs(mods) do if type(v) == "table" and v.tomlfuncs then Toml = v end end 
    params = {
        IBS_enabled = true,
    }
    params = Toml.config_update(_ENV["!guid"], params) -- Load Save
end)

mods["RoRRModdingToolkit-RoRR_Modding_Toolkit"].auto(true)

-- ========== ImGui ==========

gui.add_to_menu_bar(function()
    local new_value, clicked = ImGui.Checkbox("Enable Infinite Bandit Standoff", params['IBS_enabled'])
    if clicked then
        params['IBS_enabled'] = new_value
        Toml.save_cfg(_ENV["!guid"], params)
    end
end)

-- ========== Sprites ==========

local skulls_sprite = nil
local skull_colours = {
    gm.make_colour_rgb(56, 142, 240),
    gm.make_colour_rgb(63, 197, 227),
    gm.make_colour_rgb(94, 218, 246),
    gm.make_colour_rgb(191, 237, 248),
    gm.make_colour_rgb(255, 255, 255)
}

-- ========== Init/Callback ==========

local players = nil
local getPlayers = function()
    players = Instance.find_all(gm.constants.oP)
end

init = function()
    skulls_sprite = Resources.sprite_load("smsp", "skull", path.combine(_ENV["!plugins_mod_folder_path"], "skulls.png"), 5, 13, 11)
    local banditSkull = gm.variable_global_get("class_buff")[37]
    gm.array_set(banditSkull, 3, skulls_sprite)
    gm.array_set(banditSkull, 9, -1)

    Callback.add("onStageStart", "InifiniteBanditStandoff-getPlayers", getPlayers)
    
    gm.post_code_execute("gml_Object_oInit_Draw_73", function(self, other)
        if params['IBS_enabled'] and players then
            for _, player in ipairs(players) do
                if not player.dead and player.buff_stack and player.buff_stack[37] ~= 0 then
    
                    local colour = skull_colours[gm.clamp(player.buff_stack[37], 1, 5)]
    
                    gm.draw_set_font(25)
                    gm.draw_set_halign(0)
                    gm.draw_text_colour(player.x + 8, player.y - 42, player.buff_stack[37], colour, colour, colour, colour, 1)
                end
            end
        end
    end)
end

Initialize(init)
if hot_reload then init() end
hot_reload = true
