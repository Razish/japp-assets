#!/usr/bin/env lua

require 'lfs' -- lua filesystem

--[[
	JA++ assets package script

	requirements:
	- lua 5.4
	- luafilesystem
	- 7z or zip
--]]

local nixy = true and package.config:find('/') or false
local redirect_stdout = nixy and '>/dev/null' or '>nul'
local redirect_all = nixy and '>/dev/null 2>&1' or '>nul 2>&1'
local function test_cmd(cmd) return os.execute((nixy and 'command -v ' or 'where.exe ') .. cmd .. redirect_all) end

-- LuaFormatter off
-- this is formatted manually until #19 is resolved
local paks = {
	['sh'] = {
		['lua'] = {
			'lua/constants.lua',
			'lua/events.lua',
			'lua/functional.lua',
			'lua/init.lua',
			'lua/math.lua',
			'lua/parser.lua',
			'lua/utils.lua',
		},
		['animations'] = {
			'models/players/_humanoid/animation.cfg',
			'models/players/_humanoid/animevents.cfg',
			'models/players/_humanoid/_humanoid.gla',
		}
	},

	['cl'] = {
		['assets'] = {
			'effects/env/portal1.efx',
			'effects/env/portal2.efx',
			'fonts/japplarge.fontdat',
			'fonts/japplarge.png',
			'fonts/jappmono.fontdat',
			'fonts/jappmono.png',
			'fonts/jappsmall.fontdat',
			'fonts/jappsmall.png',
			'gfx/effects/sabers/blackcore.png',
			'gfx/effects/sabers/blackglow.png',
			'gfx/effects/sabers/blacktrail.png',
			'gfx/effects/sabers/RGBcore1.jpg',
			'gfx/effects/sabers/RGBcore2.jpg',
			'gfx/effects/sabers/RGBcore3.jpg',
			'gfx/effects/sabers/RGBcore4.jpg',
			'gfx/effects/sabers/RGBcore5.jpg',
			'gfx/effects/sabers/RGBglow1.jpg',
			'gfx/effects/sabers/RGBglow2.jpg',
			'gfx/effects/sabers/RGBglow3.jpg',
			'gfx/effects/sabers/RGBglow4.jpg',
			'gfx/effects/sabers/RGBglow5.jpg',
			'gfx/effects/sabers/RGBtrail2.jpg',
			'gfx/effects/sabers/RGBtrail3.jpg',
			'gfx/effects/sabers/RGBtrail4.jpg',
			'gfx/menus/saber_icon_black.jpg',
			'gfx/menus/saber_icon_rgb.jpg',
			'gfx/menus/scoreboard.tga',
			'gfx/menus/missing_skin.jpg',
			'gfx/sfx_sabers/saber_blade.jpg',
			'gfx/sfx_sabers/saber_end.jpg',
			'menu/new/sliderthumbdefault.tga',
			'scripts/sp.arena',
			'shaders/jappmenus.shader',
			'shaders/sabers.shader',
			'shaders/sbRGB.shader',
			'shaders/SFX_Sabers.shader',
			'ui/jamp/advancedcreateserver.menu',
			'ui/jamp/createserver.menu',
			'ui/jamp/demo.menu',
			'ui/jamp/ingame.menu',
			'ui/jamp/ingame_callvote.menu',
			'ui/jamp/ingame_controls.menu',
			'ui/jamp/ingame_player.menu',
			'ui/jamp/ingame_saber.menu',
			'ui/jamp/ingame_setup.menu',
			'ui/jamp/joinserver.menu',
			'ui/jamp/modsay.menu',
			'ui/jamp/player.menu',
			'ui/jamp/quickgame2.menu',
			'ui/jamp/saber.menu',
			'ui/jamp/serverinfo.menu',
			'ui/jampingame.txt',
		},
		["lua_channels"] = {
			'lua/cl/channels/plugin.lua',
		},
		["lua_chatstyle"] = {
			'lua/cl/chatstyle/plugin.lua',
		},
		["lua_ignorebot"] = {
			'lua/cl/ignorebot/plugin.lua',
		},
		["lua_japlusadmguns"] = {
			'lua/cl/japlusadmguns/plugin.lua',
		},
		["lua_japluscompat"] = {
			'lua/cl/japluscompat/plugin.lua',
		},
		["lua_killtracker"] = {
			'lua/cl/killtracker/plugin.lua',
		},
		["lua_notify"] = {
			'lua/cl/notify/plugin.lua',
		},
		["lua_razhud"] = {
			'lua/cl/razhud/plugin.lua',
		},
		["lua_strafehud"] = {
			'lua/cl/strafehud/plugin.lua',
		}
	},

	['sv'] = {
		["lua_automsg"] = {
			'lua/sv/automsg/plugin.lua',
		},
		["lua_duelwhois"] = {
			'lua/sv/duelwhois/plugin.lua',
		},
		["lua_channels"] = {
			'lua/sv/channels/Channel.lua',
			'lua/sv/channels/plugin.lua',
		},
		["lua_iplog"] = {
			'lua/sv/iplog/plugin.lua',
		},
		["lua_japluscompat"] = {
			'lua/sv/japluscompat/plugin.lua',
		},
		["lua_modelscale"] = {
			'lua/sv/modelscale/plugin.lua',
			'modelscale.cfg'
		},
		["lua_motd"] = {
			'lua/sv/motd/plugin.lua',
		},
		["lua_spawnhealth"] = {
			'lua/sv/spawnhealth/plugin.lua',
		},
	}
}
-- LuaFormatter on

for prefix, pak in pairs(paks) do
    for pakname, files in pairs(pak) do
        local filelist = ''
        for _, file in pairs(files) do
            if lfs.touch(file) == nil then
                print('Missing file: ' .. file)
            else
                filelist = filelist .. ' ' .. file -- append file name
            end
        end
        filelist = string.sub(filelist, 2) -- remove the leading space

        local outname = prefix .. '_' .. pakname .. '.pk3'

        -- remove existing pak
        if lfs.touch(outname) ~= nil then
            print('removing existing pak "' .. outname .. '"')
            os.remove(outname)
        end

        if #filelist ~= 0 then
            print('creating "' .. outname .. '"')
            local cmd = nil
            if test_cmd('zip') then
                cmd = 'zip ' .. outname .. ' ' .. filelist .. redirect_stdout
            elseif test_cmd('7z') then
                cmd = '7z a -tzip -y ' .. outname .. ' ' .. filelist .. ' ' .. redirect_stdout
            else
                error('can\'t find zip or 7z on PATH')
            end
            if os.execute(cmd) == nil then error() end
        end
    end
end
