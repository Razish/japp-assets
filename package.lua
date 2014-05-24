--[[
	JA++ Assets Package Script
	by Raz0r

	Requires lua 5.1, lua-filesystem, 7zip
--]]

require "lfs" -- lua filesystem

if lfs == nil then
	error( 'lua-filesystem not available for this version of lua (' .. _VERSION .. ')' )
end

local paks = {
	['sh'] = {
		['lua'] = {
			'lua/constants.lua',
			'lua/events.lua',
			'lua/init.lua',
			'lua/math.lua',
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
			'gfx/sfx_sabers/saber_blade.jpg',
			'gfx/sfx_sabers/saber_end.jpg',
			'menu/new/sliderthumbdefault.tga',
			'shaders/jappmenus.shader',
			'shaders/sabers.shader',
			'shaders/sbRGB.shader',
			'shaders/SFX_Sabers.shader',
			'shaders/post/bloom.glsl',
			'shaders/post/brightpass.glsl',
			'shaders/post/downscaleLuminance.glsl',
			'shaders/post/final.glsl',
			'shaders/post/gaussianBlur3x3_horizontal.glsl',
			'shaders/post/gaussianBlur3x3_vertical.glsl',
			'shaders/post/gaussianBlur6x6_horizontal.glsl',
			'shaders/post/gaussianBlur6x6_vertical.glsl',
			'shaders/post/luminance.glsl',
			'ui/jamp/demo.menu',
			'ui/jamp/ingame.menu',
			'ui/jamp/ingame_controls.menu',
			'ui/jamp/ingame_player.menu',
			'ui/jamp/ingame_saber.menu',
			'ui/jamp/ingame_setup.menu',
			'ui/jamp/joinserver.menu',
			'ui/jamp/player.menu',
			'ui/jamp/saber.menu'
		},
		["lua_ignorebot"] = {
			'lua/cl/ignorebot/plugin.lua',
		},
		["lua_chatstyle"] = {
			'lua/cl/chatstyle/plugin.lua',
		},
		["lua_japlusadmguns"] = {
			'lua/cl/japlusadmguns/plugin.lua',
		},
		["lua_japluscompat"] = {
			'lua/cl/japluscompat/plugin.lua',
		},
		["lua_razhud"] = {
			'lua/cl/razhud/plugin.lua',
		},
		["lua_strafehud"] = {
			'lua/cl/strafehud/plugin.lua',
		}
	},

	['sv'] = {
		["lua_duelwhois"] = {
			'lua/sv/duelwhois/plugin.lua',
		},
		["lua_japluscompat"] = {
			'lua/sv/japluscompat/plugin.lua',
		},
		["lua_iplog"] = {
			'lua/sv/iplog/plugin.lua',
		},
		["lua_motd"] = {
			'lua/sv/motd/plugin.lua',
		},
		["lua_spawnhealth"] = {
			'lua/sv/spawnhealth/plugin.lua',
		},
	}
}

local linux = true and package.config:find( '/' ) or false

for prefix,pak in pairs( paks ) do
	for pakname,files in pairs( pak ) do
		local filelist = ''
		for _,file in pairs( files ) do
			if lfs.touch( file ) == nil then
				error( 'Missing file ' .. file )
			else
				filelist = filelist .. ' ' .. file -- append file name
			end
		end
		filelist = string.sub( filelist, 2 ) -- remove the leading space

		local outname = prefix .. '_' .. pakname .. '.pk3'

		-- remove existing pak
		if lfs.touch( outname ) ~= nil then
			print( 'removing existing pak "' .. outname .. '"' )
			os.remove( outname )
		end

		print( 'creating "' .. outname .. '"' )
		if linux ~= false then
			os.execute( '7z a -tzip -y ' .. outname .. ' ' .. filelist .. ' >/dev/null 2>&1' )
		else
			os.execute( '7z a -tzip -y ' .. outname .. ' ' .. filelist .. ' >nul 2>&1' )
		end
	end
end
