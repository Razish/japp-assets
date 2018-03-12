local razhud = RegisterPlugin( 'Razhud', '1.7.2', '13.2.1' )
razhud.shaders = {}

razhud.text = TextBox()
	razhud.text.scale = 0.5
	razhud.text.font = RegisterFont( Font.JAPPSMALL )
	razhud.text.colour = { 1.0, 0.0, 0.0, 1.0 }
	razhud.text.style = TextStyle.Shadowed
	razhud.text.centered = true

local gametype = GetGametype()
if gametype >= Gametype.CTF then
	razhud.shaders.redFlag = RegisterShader(
		(gametype == Gametype.CTY) and 'gfx/hud/mpi_rflag_x' or 'gfx/hud/mpi_rflag', true
	);
	razhud.shaders.blueFlag = RegisterShader(
		(gametype == Gametype.CTY) and 'gfx/hud/mpi_bflag_ys' or 'gfx/hud/mpi_bflag', true
	);
	razhud.shaders.defer = RegisterShader( 'gfx/2d/defer', true )
	razhud.shaders.assault = RegisterShader( 'ui/assets/statusbar/assault', true )
end
RemapShader( 'console', 'gfx/menus/scanlines', '0' )

AddListener( 'JPLUA_EVENT_UNLOAD', function()
	RemapShader( 'console', 'console', '0' )
end )

local cg_razhud = CreateCvar( 'cg_razhud', 1, CvarFlags.ARCHIVE )
local japp_ratioFix = GetCvar( 'japp_ratioFix' )

local saberStyleInfo = {
	[SaberStyle.None]	= { name = 'None',		colour = { 1.0, 1.0, 1.0, 0.5 } },
	[SaberStyle.Fast]	= { name = 'Fast',		colour = { .300, .628, .816, 0.5 } },
	[SaberStyle.Medium]	= { name = 'Medium',	colour = { 1.0, 1.0, 0.0, 0.5 } },
	[SaberStyle.Strong]	= { name = 'Strong',	colour = { 1.0, 0.0, 0.0, 0.5 } },
	[SaberStyle.Desann]	= { name = 'Desann',	colour = { 1.0, .658, .062, 0.5 } },
	[SaberStyle.Tavion]	= { name = 'Tavion',	colour = { .648, .562, .784, 0.5 } },
	[SaberStyle.Dual]	= { name = 'Akimbo',	colour = { 1.0, 1.0, 0.0, 0.5 } },
	[SaberStyle.Staff]	= { name = 'Staff',		colour = { 1.0, 1.0, 0.0, 0.5 } }
}

--[[
local weaponNames = {
	[Weapon.NONE] = '',
	[Weapon.STUN_BATON] = 'Stun Baton',
	[Weapon.MELEE] = 'Fisticuffs',
	[Weapon.SABER] = 'Lightsaber',
	[Weapon.BRYAR_PISTOL] = 'DL-44',
	[Weapon.BLASTER] = 'E-11',
	[Weapon.DISRUPTOR] = 'Disruptor',
	[Weapon.BOWCASTER] = 'Wookiee Bowcaster',
	[Weapon.REPEATER] = 'Heavy Repeater',
	[Weapon.DEMP2] = 'DEMP2',
	[Weapon.FLECHETTE] = 'Golan-Arms',
	[Weapon.ROCKET_LAUNCHER] = 'Rocket Launcher',
	[Weapon.THERMAL] = 'Thermal Detonator',
	[Weapon.TRIP_MINE] = 'Trip Mine',
	[Weapon.DET_PACK] = 'Detonation Pack',
	[Weapon.CONCUSSION] = 'Concussion Rifle',
	[Weapon.BRYAR_OLD] = 'Bryar Pistol',
	[Weapon.EMPLACED_GUN] = 'Emplaced Gun',
	[Weapon.TURRET] = 'Turret Gun'
}
--]]

local white = { 1.0, 1.0, 1.0, 1.0 }
local yellow = { 1.0, 1.0, 0.0, 0.5 }
local red = { 1.0, 0.0, 0.0, 0.5 }
--local ratioRed = { 1.0, 0.0, 0.0, 1.0 }
local green = { 0.0, 0.66666, 0.0, 0.5 }
local lightblue = { 0.33333, 0.33333, 1.0, 0.5 }
local orange = { 1.0, 0.5, 0.0, 0.5 }
local redScore = { 1.0, 0.0, 0.0, 1.0 }
local cyanScore = { 0.0, 1.0, 1.0, 1.0 }

local function RenderMeterHorz( x, y, w, h, minValue, maxValue, colour, background, flipped )
	-- first the black border
	DrawRect( x, y, w, h, background )

	if minValue == nil then
		return
	end

	if minValue > 0 then
		local consume = minValue
		while consume > 0 do
			local percent = (consume / maxValue) * w
			if consume > maxValue then
				percent = w;
			end
			local padding = 2
			-- then fill it
			if flipped then
				x = x + (w - percent)
			end
			DrawRect(
				x + padding,
				y + padding,
				w - (w - percent) - (padding * 2),
				h - (padding * 2),
				colour
			)
			consume = consume - maxValue
		end
	end
end

AddListener( 'JPLUA_EVENT_HUD', function( events )
	local style = cg_razhud:GetInteger()

	-- aspect-ratio fix
	local ratioFix = japp_ratioFix:GetBoolean()
	local widthRatioCoef = 1.0
	if ratioFix then
		local glConfig = GetGLConfig()
		widthRatioCoef = (screenWidth * glConfig.height) / (screenHeight * glConfig.width)
	end

	local self = GetPlayer( nil )
	local hp = self.health
	local ap = self.armor
	local fp = self.force
	local wp = self.weapon
	local ammo = self.ammo[wp]
	local maxAmmo = self.maxAmmo[wp]
	local saberStyle = self.saberStyle
	local team = self.team

	if ( bit32.band( style, HudEvent.Stats ) == HudEvent.Stats ) then
		local barWidth = 213.33333
		local barHeight = 24.0
		local background = { 0.0, 0.0, 0.0, 0.175 }
		local hpColour = JPUtil.deepcopy( red )

		if self.isAlive == false then
			goto fail
		end

		if gametype >= Gametype.TEAM then
			local f = 0.5
			if team == Team.Red then
				background[1] = background[1] + f * (red[1] - background[1])
				background[2] = background[2] + f * (red[2] - background[2])
				background[3] = background[3] + f * (red[3] - background[3])
			elseif team == Team.Blue then
				background[1] = background[1] + f * (lightblue[1] - background[1])
				background[2] = background[2] + f * (lightblue[2] - background[2])
				background[3] = background[3] + f * (lightblue[3] - background[3])
			end
		end

		-- health
		if (hp+ap) <= 45 then
			local a = hp / 45.0
			local point = math.abs( math.sin( GetTime() / (350.0 * a) ) )
			hpColour[1] = red[1] + point * (yellow[1] - red[1])
			hpColour[2] = red[2] + point * (yellow[2] - red[2])
			hpColour[3] = red[3] + point * (yellow[3] - red[3])
		end
		RenderMeterHorz(
			(screenWidth / 2.0) - barWidth * widthRatioCoef,
			screenHeight - (barHeight * 2.0),
			barWidth * widthRatioCoef,
			barHeight,
			hp, 100,
			hpColour, background,
			true
		)
		razhud.text.centered = true
		razhud.text.colour = white
		razhud.text.text = tostring( hp )
		razhud.text:Draw(
			(screenWidth / 2.0) - barWidth * widthRatioCoef + (barWidth * widthRatioCoef) / 2.0,
			screenHeight - (barHeight * 2.0)
		)

		-- armor
		RenderMeterHorz(
			(screenWidth / 2.0) - barWidth * widthRatioCoef,
			screenHeight - barHeight,
			barWidth * widthRatioCoef,
			barHeight,
			ap, 100,
			green, background,
			true
		)
		razhud.text.text = tostring( ap )
		razhud.text:Draw(
			(screenWidth / 2.0) - barWidth * widthRatioCoef + (barWidth * widthRatioCoef) / 2.0,
			screenHeight - barHeight
		)

		-- force
		RenderMeterHorz(
			screenWidth / 2.0,
			screenHeight - (barHeight * 2.0),
			barWidth * widthRatioCoef,
			barHeight,
			fp, 100,
			lightblue, background,
			false
		)
		razhud.text.text = tostring( fp )
		razhud.text:Draw(
			(screenWidth / 2.0) + (barWidth / 2.0) * widthRatioCoef,
			screenHeight - (barHeight * 2.0)
		)

		-- ammo / saber
		if wp == Weapon.SABER then
			local styleInfo = saberStyleInfo[saberStyle]
			local padding = 2
			DrawRect(
				screenWidth / 2.0,
				screenHeight - barHeight,
				barWidth * widthRatioCoef,
				barHeight,
				background
			)
			DrawRect(
				screenWidth / 2.0 + padding,
				screenHeight - barHeight + padding,
				(barWidth - (padding * 2.0)) * widthRatioCoef,
				barHeight - (padding * 2.0),
				styleInfo.colour
			)
		else
			RenderMeterHorz(
				screenWidth / 2.0,
				screenHeight - barHeight,
				barWidth * widthRatioCoef,
				barHeight,
				ammo, maxAmmo,
				orange, background,
				false
			)
			razhud.text.text = tostring( ammo ) .. '/' .. tostring( maxAmmo )
			razhud.text:Draw(
				(screenWidth / 2.0) + (barWidth / 2.0) * widthRatioCoef,
				screenHeight - barHeight
			)
		end

		::fail::
		events = bit32.bor( events, HudEvent.Stats )
	end

	if ( bit32.band( style, HudEvent.Flags ) == HudEvent.Flags ) then
		local scores1, scores2 = GetScores()
		local iconSize = 48.0
		local leftX = (screenWidth / 2.0)				-- center screen
			- (iconSize / 2.0)							-- <- half icon size
			- iconSize									-- <- icon size
			+ (iconSize - (iconSize * widthRatioCoef))	-- widescreen adjust

		local rightX = (screenWidth / 2.0)	-- center screen
			+ (iconSize / 2.0)				-- -> half icon size

		local y = screenHeight - iconSize;
		if bit32.band( style, HudEvent.Stats ) == HudEvent.Stats then
			y = y - 48.0
		end
		local faded = { 0.25, 0.25, 0.25, 0.75 }
		--local defer = { 1.0, 1.0, 1.0, 0.8 }
		local ourFlag = (team == Team.Red) and razhud.shaders.redFlag or razhud.shaders.blueFlag
		local theirFlag = (team == Team.Red) and razhud.shaders.blueFlag or razhud.shaders.redFlag

		local otherTeamHasFlag = false
		local otherTeamDroppedFlag = false
		local ourTeamHasFlag = false
		local ourTeamDroppedFlag = false
		local redFlagStatus
		local blueFlagStatus

		if self.isAlive == false or gametype < Gametype.CTF then
			goto fail
		end

		redFlagStatus, blueFlagStatus = GetFlagStatus()
		if team == Team.Red then
			otherTeamHasFlag = redFlagStatus == FlagStatus.Taken
			otherTeamDroppedFlag = redFlagStatus == FlagStatus.Dropped
			ourTeamHasFlag = blueFlagStatus == FlagStatus.Taken
			ourTeamDroppedFlag = blueFlagStatus == FlagStatus.Dropped
		elseif team == Team.Blue then
			otherTeamHasFlag = blueFlagStatus == FlagStatus.Taken
			otherTeamDroppedFlag = blueFlagStatus == FlagStatus.Dropped
			ourTeamHasFlag = redFlagStatus == FlagStatus.Taken
			ourTeamDroppedFlag = redFlagStatus == FlagStatus.Dropped
		end

		-- left side
		if ( otherTeamHasFlag ) then
			DrawPic( leftX, y, iconSize * widthRatioCoef, iconSize, nil, ourFlag )
			DrawPic( leftX, y, iconSize * widthRatioCoef, iconSize, nil, razhud.shaders.defer )
			razhud.text.text = 'Flag stolen!'
			razhud.text:Draw(
				leftX + ((iconSize * widthRatioCoef) / 2.0),
				y - razhud.text.height * 2.0
			)
		else
			DrawPic( leftX, y, iconSize * widthRatioCoef, iconSize, otherTeamDroppedFlag and faded or nil, ourFlag )
		end
		razhud.text.text = tostring( (team == Team.Red) and scores1 or scores2 )
		razhud.text.colour = (team == Team.Red) and redScore or cyanScore
		razhud.text:Draw( leftX + ((iconSize * widthRatioCoef) / 2.0), y - razhud.text.height )

		-- right side
		if ( ourTeamHasFlag ) then
			DrawPic( rightX, y, iconSize * widthRatioCoef, iconSize, nil, theirFlag )
			DrawPic( rightX, y, iconSize * widthRatioCoef, iconSize, nil, razhud.shaders.assault )
		else
			DrawPic( rightX, y, iconSize * widthRatioCoef, iconSize, ourTeamDroppedFlag and faded or nil, theirFlag )
		end
		razhud.text.text = tostring( (team == Team.Red) and scores2 or scores1 )
		razhud.text.colour = (team == Team.Red) and cyanScore or redScore
		razhud.text:Draw( rightX + ((iconSize * widthRatioCoef) / 2.0), y - razhud.text.height )

		::fail::
		events = bit32.bor( events, HudEvent.Flags )
	end

	if ( bit32.band( style, HudEvent.Scores ) == HudEvent.Scores ) then
		local barWidth = 213.33333
		local barHeight = 24.0
		local kills = self.score
		local deaths = self.deaths
		local net = kills - deaths
		local ratio = (self.deaths ~= 0) and (self.score / self.deaths) or self.score
		local sign = (net >= 0) and '+' or '-'

		if self.isAlive == false then
			goto fail
		end

		if gametype >= Gametype.TEAM then
			-- TODO: team HUD
		else
			local list = {}
			table.insert( list, 'Net: ' .. sign .. math.abs( net ) )

			local ratioColour
			if ratio < 0.25 then
				ratioColour = ChatColour.Red
			elseif ratio < 0.5 then
				ratioColour = ChatColour.Orange
			elseif ratio < 0.75 then
				ratioColour = ChatColour.Yellow
			elseif ratio < 1.0 then
				ratioColour = ChatColour.White
			else
				ratioColour = ChatColour.Green
			end
			table.insert( list, 'KDR: ' .. ratioColour .. string.format( "%0.02f", ratio ) )

			local maxlen = 0
			for _,v in ipairs(list) do
				razhud.text.text = v
				if razhud.text.width > maxlen then
					maxlen = razhud.text.width
				end
			end

			for i,v in next, list do
				razhud.text.text = v
				razhud.text.centered = false
				razhud.text:Draw(
					((screenWidth / 2.0) - barWidth * widthRatioCoef) - maxlen,
					(screenHeight - ( barHeight * 2.0)) + (barHeight * (i-1))
				)
			end
		end

		::fail::
		events = bit32.bor( events, HudEvent.Scores )
	end

	return events
end )
