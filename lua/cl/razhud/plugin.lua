local razhud = RegisterPlugin( "Razhud", "1.5", 3 ) -- encapsulate all plugin data and functions in this table

razhud.horizontalMeters = false

local function RenderMeterHorz( x, y, w, h, minvalue, maxvalue, colour )
	local percent = ( minvalue/maxvalue ) * w
	if ( minvalue > maxvalue ) then
		percent = w;
	end
	if ( minvalue > 0 ) then
		DrawRect( x+1, y+1, w-(w-( (percent>maxvalue) and maxvalue or percent) )-1, h-2, colour );
	end
end

local function RenderMeterVert( x, y, w, h, minvalue, maxvalue, colour )
	local percent = ( minvalue/maxvalue ) * h
	if ( minvalue > maxvalue ) then
		percent = h;
	end
	if ( minvalue > 0 ) then
		DrawRect( x+1, y+(h-percent)+1, w-2, h-(h-( (percent>maxvalue) and maxvalue or percent) )-1, colour );
	end
end

local function GetAlignment( x, str, fontIndex, fontScale, alignment )
	if ( alignment == 1 ) then -- center
		return x - (Font_StringLengthPixels( str, fontScale, fontIndex ) / 2.0)
	elseif ( alignment == 2 ) then -- right-align
		return x - Font_StringLengthPixels( str, fontScale, fontIndex )
	else
		return x -- default to left-align
	end
end

local function GetAlignment2( x, size, alignment )
	if ( alignment == 1 ) then -- center
		return x - (size / 2.0)
	elseif ( alignment == 2 ) then -- max-align
		return x - size
	else
		return x -- default to left-align
	end
end

-- TODO: replace cvars with this + serialisation (+ menu binding?)
-- default positional information
---[[
razhud.data = {
	simple = {
		fontScale = 2.0,
		fontIndex = Fonts.JAPPMONO,
		fontStyle = TextStyle.SHADOWED,
		health = { x = 320 - 26*4 - 39, y = 320, colour = { .835, .015, .015, 1.0 } },
		armor = { x = 320 + 26 + 39, y = 320, colour = { 0.0, .613, .097, 1.0 } },
		force = { x = 320 - 39, y = 320, colour = { .567, .685, 1.0, 1.0 } },
		timer = { x = 320 - 32.5, y = 300, colour = { 1.0, 1.0, 1.0, 1.0 } },
		ammo = { x = 320 - 45.5, y = 380, colour = { 1.0, .658, .062, 1.0 } },
	--	weapon = { x = 576, y = 440, colour = { 1.0, .658, .062, 1.0 } }
	},
	advanced = {
		fontScale = .7,
		fontIndex = Fonts.JAPPSMALL,
		fontStyle = TextStyle.SHADOWED,

		horizontal = {
			health = { x = 24, y = 410, w = 68, h = 16, t = 12, colour = { .835, .015, .015, 1.0 } },
			armor = { x = 24, y = 430, w = 68, h = 16, t = 12, colour = { 0.0, .613, .097, 1.0 } },
			force = { x = 24, y = 450, w = 68, h = 16, t = 12, colour = { .567, .685, 1.0, 1.0 } },
			weapon = { x = 2, y = 390, scale = .5 }
		},
		vertical = {
			health = { x = 8, y = 398, w = 16, h = 68, t = 4, colour = { .835, .015, .015, 1.0 } },
			armor = { x = 32, y = 398, w = 16, h = 68, t = 4, colour = { 0.0, .613, .097, 1.0 } },
			force = { x = 58, y = 398, w = 16, h = 68, t = 4, colour = { .567, .685, 1.0, 1.0 } },
			weapon = { x = 18, y = 375, scale = .5 }
		}
	}
}
--]]

razhud.black = { 0.0, 0.0, 0.0, .7 }
razhud.white = { 1.0, 1.0, 1.0, 1.0 }

local saberStyleInfo = {
	[SaberStyle.NONE]	= { name = "None",		colour = { 1.0, 1.0, 1.0, 1.0 } },
	[SaberStyle.FAST]	= { name = "Fast",		colour = { .300, .628, .816, 1.0 } },
	[SaberStyle.MEDIUM]	= { name = "Medium",	colour = { 1.0, 1.0, 0.0, 1.0 } },
	[SaberStyle.STRONG]	= { name = "Strong",	colour = { 1.0, 0.0, 0.0, 1.0 } },
	[SaberStyle.DESANN]	= { name = "Desann",	colour = { 1.0, .658, .062, 1.0 } },
	[SaberStyle.TAVION]	= { name = "Tavion",	colour = { .648, .562, .784, 1.0 } },
	[SaberStyle.DUAL]	= { name = "Akimbo",	colour = { 1.0, 1.0, 0.0, 1.0 } },
	[SaberStyle.STAFF]	= { name = "Staff",		colour = { 1.0, 1.0, 0.0, 1.0 } }
}

local weaponNames = {
	[Weapons.NONE] = "",
	[Weapons.STUN_BATON] = "Stun Baton",
	[Weapons.MELEE] = "Fisticuffs",
	[Weapons.SABER] = "Lightsaber",
	[Weapons.BRYAR_PISTOL] = "DL-44",
	[Weapons.BLASTER] = "E-11",
	[Weapons.DISRUPTOR] = "Disruptor",
	[Weapons.BOWCASTER] = "Wookiee Bowcaster",
	[Weapons.REPEATER] = "Heavy Repeater",
	[Weapons.DEMP2] = "DEMP2",
	[Weapons.FLECHETTE] = "Golan-Arms",
	[Weapons.ROCKET_LAUNCHER] = "Rocket Launcher",
	[Weapons.THERMAL] = "Thermal Detonator",
	[Weapons.TRIP_MINE] = "Trip Mine",
	[Weapons.DET_PACK] = "Detonation Pack",
	[Weapons.CONCUSSION] = "Concussion Rifle",
	[Weapons.BRYAR_OLD] = "Bryar Pistol",
	[Weapons.EMPLACED_GUN] = "Emplaced Gun",
	[Weapons.TURRET] = "Turret Gun"
}

local cvars = {
	-- New cvars
	["cg_razhud"]			= CreateCvar( "cg_razhud", 1, CvarFlags.ARCHIVE ),
	["cg_hudHealthX"]		= CreateCvar( "cg_hudHealthX", 8, CvarFlags.ARCHIVE ),
	["cg_hudHealthY"]		= CreateCvar( "cg_hudHealthY", 398, CvarFlags.ARCHIVE ),
	["cg_hudHealthW"]		= CreateCvar( "cg_hudHealthW", 16, CvarFlags.ARCHIVE ),
	["cg_hudHealthH"]		= CreateCvar( "cg_hudHealthH", 68, CvarFlags.ARCHIVE ),
	["cg_hudHealthT"]		= CreateCvar( "cg_hudHealthT", 4, CvarFlags.ARCHIVE ),
	["cg_hudHealthAlign"]	= CreateCvar( "cg_hudHealthAlign", 1, CvarFlags.ARCHIVE ),
	["cg_hudArmorX"]		= CreateCvar( "cg_hudArmorX", 30, CvarFlags.ARCHIVE ),
	["cg_hudArmorY"]		= CreateCvar( "cg_hudArmorY", 398, CvarFlags.ARCHIVE ),
	["cg_hudArmorW"]		= CreateCvar( "cg_hudArmorW", 16, CvarFlags.ARCHIVE ),
	["cg_hudArmorH"]		= CreateCvar( "cg_hudArmorH", 68, CvarFlags.ARCHIVE ),
	["cg_hudArmorT"]		= CreateCvar( "cg_hudArmorT", 4, CvarFlags.ARCHIVE ),
	["cg_hudArmorAlign"]	= CreateCvar( "cg_hudArmorAlign", 1, CvarFlags.ARCHIVE ),
	["cg_hudForceX"]		= CreateCvar( "cg_hudForceX", 52, CvarFlags.ARCHIVE ),
	["cg_hudForceY"]		= CreateCvar( "cg_hudForceY", 398, CvarFlags.ARCHIVE ),
	["cg_hudForceW"]		= CreateCvar( "cg_hudForceW", 16, CvarFlags.ARCHIVE ),
	["cg_hudForceH"]		= CreateCvar( "cg_hudForceH", 68, CvarFlags.ARCHIVE ),
	["cg_hudForceT"]		= CreateCvar( "cg_hudForceT", 4, CvarFlags.ARCHIVE ),
	["cg_hudForceAlign"]	= CreateCvar( "cg_hudForceAlign", 1, CvarFlags.ARCHIVE ),
	["cg_hudAmmoX"]			= CreateCvar( "cg_hudAmmoX", 512, CvarFlags.ARCHIVE ),
	["cg_hudAmmoY"]			= CreateCvar( "cg_hudAmmoY", 456, CvarFlags.ARCHIVE ),
	["cg_hudAmmoW"]			= CreateCvar( "cg_hudAmmoW", 16, CvarFlags.ARCHIVE ),
	["cg_hudAmmoH"]			= CreateCvar( "cg_hudAmmoH", 68, CvarFlags.ARCHIVE ),
	["cg_hudAmmoT"]			= CreateCvar( "cg_hudAmmoT", 4, CvarFlags.ARCHIVE ),
	["cg_hudWeaponX"]		= CreateCvar( "cg_hudWeaponX", 512, CvarFlags.ARCHIVE ),
	["cg_hudWeaponY"]		= CreateCvar( "cg_hudWeaponY", 440, CvarFlags.ARCHIVE ),
	["cg_hudWeaponW"]		= CreateCvar( "cg_hudWeaponW", 16, CvarFlags.ARCHIVE ),
	["cg_hudWeaponH"]		= CreateCvar( "cg_hudWeaponH", 68, CvarFlags.ARCHIVE ),
	["cg_hudWeaponT"]		= CreateCvar( "cg_hudWeaponT", 4, CvarFlags.ARCHIVE ),
}

AddListener( "JPLUA_EVENT_HUD", function()
	local self = GetPlayer( nil )
	local health = self:GetHealth()
	local armor = self:GetArmor()
	local force = self:GetForce()
	local weapon = self:GetWeapon()
	local ammo = self:GetAmmo( weapon )
	local maxammo = self:GetMaxAmmo( weapon )
	local saberStyle = self:GetSaberStyle()

	local data = {}

	data.fontScale = 0.5
	data.fontScale2 = 0.5
	data.fontIndex = Fonts.JAPPLARGE
	data.fontStyle = TextStyle.SHADOWEDMORE

	data.health	= { x = cvars["cg_hudHealthX"]:GetFloat(),	y = cvars["cg_hudHealthY"]:GetFloat(),	w = cvars["cg_hudHealthW"]:GetFloat(),	h = cvars["cg_hudHealthH"]:GetFloat(),	t = cvars["cg_hudHealthT"]:GetFloat(),	align = cvars["cg_hudHealthAlign"]:GetInteger(), colour = { .835, .015, .015, 1.0 } }
	data.armor	= { x = cvars["cg_hudArmorX"]:GetFloat(),	y = cvars["cg_hudArmorY"]:GetFloat(),	w = cvars["cg_hudArmorW"]:GetFloat(),	h = cvars["cg_hudArmorH"]:GetFloat(),	t = cvars["cg_hudArmorT"]:GetFloat(),	align = cvars["cg_hudArmorAlign"]:GetInteger(), colour = { 0.0, .613, .097, 1.0 } }
	data.force	= { x = cvars["cg_hudForceX"]:GetFloat(),	y = cvars["cg_hudForceY"]:GetFloat(),	w = cvars["cg_hudForceW"]:GetFloat(),	h = cvars["cg_hudForceH"]:GetFloat(),	t = cvars["cg_hudForceT"]:GetFloat(),	align = cvars["cg_hudForceAlign"]:GetInteger(), colour = { .567, .685, 1.0, 1.0 } }
	data.ammo	= { x = cvars["cg_hudAmmoX"]:GetFloat(),	y = cvars["cg_hudAmmoY"]:GetFloat(),	w = cvars["cg_hudAmmoW"]:GetFloat(),	h = cvars["cg_hudAmmoH"]:GetFloat(),	t = cvars["cg_hudAmmoT"]:GetFloat(),	colour = { 1.0, .658, .062, 1.0 } }
	data.weapon	= { x = cvars["cg_hudWeaponX"]:GetFloat(),	y = cvars["cg_hudWeaponY"]:GetFloat(),	w = cvars["cg_hudWeaponW"]:GetFloat(),	h = cvars["cg_hudWeaponH"]:GetFloat(),	t = cvars["cg_hudWeaponT"]:GetFloat(),	colour = { 1.0, .658, .062, 1.0 } }

	if ( cvars["cg_razhud"]:GetInteger() ~= 0 ) then
		if ( cvars["cg_razhud"]:GetInteger() == 1 ) then
			local fontHeightOffset = -10 -- For vertical meters
			-- health meter
			RenderMeterVert( data.health.x, data.health.y, data.health.w, data.health.h, 100, 100, razhud.black )
			RenderMeterVert( data.health.x+2, data.health.y+2, data.health.w-4, data.health.h-4, health, 100, data.health.colour )
			local str = tostring( health )
			local x = GetAlignment( data.health.x+fontHeightOffset, str, data.fontIndex, data.fontScale, data.health.align )
			DrawText( x+data.health.w, data.health.y+data.health.h-data.health.t, str, data.health.colour, data.fontScale, data.fontStyle, data.fontIndex )

			-- armor meter
			RenderMeterVert( data.armor.x, data.armor.y, data.armor.w, data.armor.h, 100, 100, razhud.black )
			RenderMeterVert( data.armor.x+2, data.armor.y+2, data.armor.w-4, data.armor.h-4, armor, 100, data.armor.colour )
			str = tostring( armor )
			x = GetAlignment( data.armor.x+fontHeightOffset, str, data.fontIndex, data.fontScale, data.armor.align )
			DrawText( x+data.armor.w, data.armor.y+data.armor.h-data.armor.t, str, data.armor.colour, data.fontScale, data.fontStyle, data.fontIndex )

			-- force meter
			RenderMeterVert( data.force.x, data.force.y, data.force.w, data.force.h, 100, 100, razhud.black )
			RenderMeterVert( data.force.x+2, data.force.y+2, data.force.w-4, data.force.h-4, force, 100, data.force.colour )
			str = tostring( force )
			x = GetAlignment( data.force.x+fontHeightOffset, str, data.fontIndex, data.fontScale, data.force.align )
			DrawText( x+data.force.w, data.force.y+data.force.h-data.force.t, str, data.force.colour, data.fontScale, data.fontStyle, data.fontIndex )

			-- saber style
			if weapon == Weapons.SABER then
				local styleInfo = saberStyleInfo[saberStyle]
				DrawText( data.weapon.x, data.weapon.y, "Lightsaber\nStyle: ", razhud.white, data.fontScale2, data.fontStyle, data.fontIndex )
				DrawText( data.weapon.x + Font_StringLengthPixels( "Style: ", data.fontScale2, data.fontIndex ), data.weapon.y + Font_StringHeightPixels( "Lightsaber\n", data.fontScale2, data.fontIndex ), styleInfo.name, styleInfo.colour, data.fontScale2, data.fontStyle, data.fontIndex )
			else
				DrawText( data.weapon.x, data.weapon.y, weaponNames[weapon], razhud.white, data.fontScale2, data.fontStyle, data.fontIndex )
				DrawText( data.ammo.x, data.ammo.y, tostring( ammo ), data.ammo.colour, data.fontScale, data.fontStyle, data.fontIndex )
			end
		elseif ( cvars["cg_razhud"]:GetInteger() == 2 ) then
			-- health meter
			RenderMeterHorz( data.health.x, data.health.y, data.health.w, data.health.h, 100, 100, razhud.black )
			RenderMeterHorz( data.health.x+2, data.health.y+2, data.health.w-4, data.health.h-4, health, 100, data.health.colour )
			local str = tostring( health )
			local x = ( data.health.x - data.health.t - (Font_StringLengthPixels( str, data.fontScale, data.fontIndex ) / 2) )
			local y = GetAlignment( data.health.y+data.health.h, data.health.h, data.health.align ) - 10
			DrawText( x, y, str, data.health.colour, data.fontScale, data.fontStyle, data.fontIndex )

			-- armor meter
			RenderMeterHorz( data.armor.x, data.armor.y, data.armor.w, data.armor.h, 100, 100, razhud.black )
			RenderMeterHorz( data.armor.x+2, data.armor.y+2, data.armor.w-4, data.armor.h-4, armor, 100, data.armor.colour )
			str = tostring( armor )
			x = ( data.armor.x - data.armor.t - (Font_StringLengthPixels( str, data.fontScale, data.fontIndex ) / 2) )
			y = GetAlignment( data.armor.y+data.armor.h, data.armor.h, data.armor.align ) - 10
			DrawText( x, data.armor.y, str, data.armor.colour, data.fontScale, data.fontStyle, data.fontIndex )

			-- force meter
			RenderMeterHorz( data.force.x, data.force.y, data.force.w, data.force.h, 100, 100, razhud.black )
			RenderMeterHorz( data.force.x+2, data.force.y+2, data.force.w-4, data.force.h-4, force, 100, data.force.colour )
			str = tostring( force )
			x = ( data.force.x - data.force.t - (Font_StringLengthPixels( str, data.fontScale, data.fontIndex ) / 2) )
			y = GetAlignment( data.force.y+data.force.h, data.force.h, data.force.align ) - 10
			DrawText( x, data.force.y, str, data.force.colour, data.fontScale, data.fontStyle, data.fontIndex )

			-- saber style
			if weapon == Weapons.SABER then
				local styleInfo = saberStyleInfo[saberStyle]
				DrawText( data.weapon.x, data.weapon.y, "Lightsaber\nStyle: ", razhud.white, data.fontScale2, data.fontStyle, data.fontIndex )
				DrawText( data.weapon.x + Font_StringLengthPixels( "Style: ", data.fontScale2, data.fontIndex ), data.weapon.y + Font_StringHeightPixels( "Lightsaber\n", data.fontScale2, data.fontIndex ), styleInfo.name, styleInfo.colour, data.fontScale2, data.fontStyle, data.fontIndex )
			else
				DrawText( data.weapon.x, data.weapon.y, weaponNames[weapon], razhud.white, data.fontScale2, data.fontStyle, data.fontIndex )
				DrawText( data.ammo.x, data.ammo.y, tostring( ammo ), data.ammo.colour, data.fontScale, data.fontStyle, data.fontIndex )
			end
		elseif ( cvars["cg_razhud"]:GetInteger() == 3 ) then
			data = razhud.data.simple

			DrawText( data.health.x, data.health.y, string.format( "%3d", health ), data.health.colour, data.fontScale, data.fontStyle, data.fontIndex )
			DrawText( data.armor.x, data.armor.y, string.format( "%3d", armor ), data.armor.colour, data.fontScale, data.fontStyle, data.fontIndex )

			if weapon ~= Weapons.SABER then
				DrawText( data.ammo.x, data.ammo.y, string.format( "%3d/%3d", ammo, maxammo ), data.ammo.colour, data.fontScale/2.0, data.fontStyle, data.fontIndex )
			end

			DrawText( data.force.x, data.force.y, string.format( "%3d", force ), data.force.colour, data.fontScale, data.fontStyle, data.fontIndex )
			
			-- timer
			local mins, secs, msec = GetMapTime()
			DrawText( data.timer.x, data.timer.y, string.format( "%02i:%02i", mins, secs ), data.timer.colour, data.fontScale/2.0, data.fontStyle, data.fontIndex )
			end -- horz/vert meters
--[[
		-- saber style
		if weapon == Weapons.SABER then
			local styleInfo = saberStyleInfo[saberStyle]
			DrawText( data.weapon.x, data.weapon.y, "Lightsaber\nStyle: ", razhud.white, data.fontScale2, data.fontStyle, data.fontIndex )
			DrawText( data.weapon.x + Font_StringLengthPixels( "Style: ", data.fontScale2, data.fontIndex ), data.weapon.y + Font_StringHeightPixels( "Lightsaber\n", data.fontScale2, data.fontIndex ), styleInfo.name, styleInfo.colour, data.fontScale2, data.fontStyle, data.fontIndex )
		else
			DrawText( data.weapon.x, data.weapon.y, weaponNames[weapon], razhud.white, data.fontScale2, data.fontStyle, data.fontIndex )
			DrawText( data.ammo.x, data.ammo.y, tostring( ammo ), data.ammo.colour, data.fontScale, data.fontStyle, data.fontIndex )
		end
--]]
		return 1
	end
	return 0
end )
