local kt = RegisterPlugin( 'Kill Tracker', '1.1.2', '13.2.0' )

local function sum( t )
	local s = t[1] - t[1]
	for _,v in next, t do
		s = s + v
	end
	return s
end

-- generates a random real number between a (inclusive) and b (exclusive)
local function flrand( lo, hi )
	return lo + (hi - lo) * math.random()
end

local kt_spam = CreateCvar( 'kt_spam', 1, CvarFlags.ARCHIVE )

kt.textbox = TextBox()
	kt.textbox.scale = 0.5
	kt.textbox.font = RegisterFont( Font.JAPPSMALL )
	kt.textbox.colour = { 1.0, 1.0, 1.0, 1.0 }
	kt.textbox.style = TextStyle.Shadowed
	kt.textbox.centered = false

kt.alerts = {}

local function InitDB()
	-- initialise kt table
	kt.db = {}
	kt.db.kills = 0
	kt.db.killed = {}
	kt.db.killedBy = {}
	kt.db.deaths = 0
	kt.db.suicides = 0
	kt.db.duelWins = {}
	kt.db.duelsWon = 0
	kt.db.duelsLost = 0
	kt.db.duelLosses = {}
end

local function LoadDB()
	local sr = GetSerialiser( 'db.json', FSMode.Read )
	if sr == nil then
		InitDB()
		return
	end
	kt.db = sr:ReadTable( 'db' )
	sr:Close()
end
LoadDB()

local function SaveDB()
	local sr = GetSerialiser( 'db.json', FSMode.Write )
	sr:AddTable( 'db', kt.db )
	sr:Close( 1 )
end

local function Alert( textBegin, textEnd )
	local alert = {}
	alert.textBegin = textBegin
	alert.textEnd = textEnd
	alert.duration = { 125, 4000, 125 }
	alert.time = 0
	alert.padding  = 2
	table.insert( kt.alerts, alert )
end

AddListener( 'JPLUA_EVENT_UNLOAD', function()
	if kt.power then
		SaveDB()
	end
end )

-- track kills/deaths
AddListener( 'JPLUA_EVENT_PLAYERDEATH', function( victim, methodOfDeath, inflictor )
	if not kt.power or (victim and victim.isBot) or (inflictor and inflictor.isBot) then
		return
	end

	local self = GetPlayer(nil)
	if victim == inflictor then
		if victim == self then
			-- we killed ourselves
			kt.db.suicides = kt.db.suicides + 1
		else
			-- victim.name killed themselves
		end
	elseif inflictor then
		if inflictor == self then
			-- we killed victim.name
			if self.isDueling then
				local victimName = JPUtil.StripColours( inflictor.name )
				if kt.db.duelWins[victimName] then
					kt.db.duelWins[victimName] = kt.db.duelWins[victimName] + 1
				else
					kt.db.duelWins[victimName] = 1
				end
				kt.db.duelsWon = kt.db.duelsWon + 1
				Alert(
					ChatColour.Green .. '+1 duel won against ' .. ChatColour.White .. self.duelPartner.name,
					ChatColour.Green .. math.floor( kt.db.duelsWon ) .. ChatColour.White .. '/' .. math.floor( kt.db.duelsLost )
				)
			--FIXME: powerduel etc?
			elseif GetGametype() < Gametype.TEAM or victim.team ~= self.team then
				if victim.isBot then
					kt.db.botKills = kt.db.botKills + 1
				else
					local victimName = JPUtil.StripColours( victim.name )
					if kt.db.killed[victimName] then
						kt.db.killed[victimName] = kt.db.killed[victimName] + 1
					else
						kt.db.killed[victimName] = 1
					end
					kt.db.kills = kt.db.kills + 1
					Alert(
						ChatColour.Green .. '+1 kill',
						ChatColour.Green .. math.floor( kt.db.kills ) .. ChatColour.White .. '/' .. math.floor( kt.db.deaths )
					)
				end
			end
		elseif victim == self then
			-- inflictor.name killed us
			if self.isDueling then
				local inflictorName = JPUtil.StripColours( inflictor.name )
				if kt.db.duelLosses[inflictorName] then
					kt.db.duelLosses[inflictorName] = kt.db.duelLosses[inflictorName] + 1
				else
					kt.db.duelLosses[inflictorName] = 1
				end
				kt.db.duelsLost = kt.db.duelsLost + 1
				Alert(
					ChatColour.Red .. '-1 duel loss against ' .. ChatColour.White .. self.duelPartner.name,
					ChatColour.White .. math.floor( kt.db.duelsWon ) .. '/' .. ChatColour.Red .. math.floor( kt.db.duelsLost )
				)
			elseif inflictor.isBot then
				kt.db.botDeaths = kt.db.botDeaths + 1
			else
				local inflictorName = JPUtil.StripColours( inflictor.name )
				if kt.db.killedBy[inflictorName] then
					kt.db.killedBy[inflictorName] = kt.db.killedBy[inflictorName] + 1
				else
					kt.db.killedBy[inflictorName] = 1
				end
				kt.db.deaths = kt.db.deaths + 1
				Alert(
					ChatColour.Red .. '-1 death',
					ChatColour.White .. math.floor( kt.db.kills ) .. '/' .. ChatColour.Red .. math.floor( kt.db.deaths )
				)
			end
		else
			-- inflictor.name killed victim.name
		end
	else
		-- victim.name somehow died
	end
end )

local function TogglePower( cmd, args )
	if kt.power then
		SaveDB()
		InitDB()
		kt.power = false
		print( ChatColour.Yellow .. 'Killtracker turned ' .. ChatColour.Red .. 'off' )
	else
		LoadDB()
		kt.power = true
		Alert(
			ChatColour.Yellow .. 'Killtracker turned ' .. ChatColour.Green .. 'on',
			ChatColour.Yellow .. 'Welcome back ' .. ChatColour.White .. GetCvar('name'):GetString()
		)
	end
end
TogglePower()

AddConsoleCommand( 'kt_power', TogglePower )

AddConsoleCommand( 'kt_reset', function( cmd, args )
	if not kt.power then
		print( ChatColour.Yellow .. 'Killtracker is powered off' )
		return
	end
	print( ChatColour.Yellow .. 'Resetting killtracker statistics' )
	InitDB()
	SaveDB()
end )

AddConsoleCommand( 'kt_nemesis', function( cmd, args )
	if not kt.power then
		print( ChatColour.Yellow .. 'Killtracker is powered off' )
		return
	end
	local highestKill = {
		k = nil, v = 0
	}
	for k,v in pairs( kt.db.killedBy ) do
		if v > highestKill.v then
			highestKill.k = k
			highestKill.v = v
		end
	end

	if highestKill.k ~= nil then
		print( 'your nemesis is ' .. ChatColour.Yellow .. highestKill.k .. ChatColour.White .. ' who has killed you '
			.. ChatColour.Yellow .. math.floor(highestKill.v) .. ChatColour.White .. ' times'
		)
	end
end )

AddConsoleCommand( 'kt_stats', function( cmd, args )
	if not kt.power then
		print( ChatColour.Yellow .. 'Killtracker is powered off' )
		return
	end
	if #args > 0 then
		local s = table.concat( args, ' ' )
		print( 'you have killed ' .. s .. ' ' .. (kt.db.killed[s] and kt.db.killed[s] or 0) .. ' times' )
		print( s .. ' has killed you ' .. (kt.db.killedBy[s] and kt.db.killedBy[s] or 0) .. ' times' )
	else
		local ratio = (kt.db.deaths ~= 0) and (kt.db.kills / kt.db.deaths) or kt.db.kills
		local net = kt.db.kills - kt.db.deaths
		local netSign = (net >= 0) and '+' or '-'
		net = math.floor( math.abs( net ) )
		local duelRatio = (kt.db.duelsLost ~= 0) and (kt.db.duelsWon / kt.db.duelsLost) or kt.db.duelsWon
		local duelNet = kt.db.duelsWon - kt.db.duelsLost
		local duelNetSign = (duelNet >= 0) and '+' or '-'
		duelNet = math.floor( math.abs( duelNet ) )

		if kt_spam:GetBoolean() then
			SendServerCommand(
				'say '
					.. ChatColour.White .. 'K/D: ' .. ChatColour.Green .. math.floor(kt.db.kills) .. ChatColour.White
					.. '/' .. ChatColour.Red .. math.floor(kt.db.deaths) .. ' '
					.. ((kt.db.kills - kt.db.deaths) >= 0 and ChatColour.Green or ChatColour.Red) .. netSign .. net
					.. ChatColour.White .. '   W/L: ' .. ChatColour.Cyan .. math.floor(kt.db.duelsWon)
					.. ChatColour.White .. '/' .. ChatColour.Yellow .. math.floor(kt.db.duelsLost) .. ' '
					.. ((kt.db.duelsWon - kt.db.duelsLost) >= 0 and ChatColour.Green or ChatColour.Red) .. duelNetSign
					.. duelNet
			)
		else
			print( ChatColour.Yellow .. 'KillTracker stats:' )
			print( ChatColour.Yellow .. '      kills: ' .. ChatColour.White .. math.floor(kt.db.kills) )
			print( ChatColour.Yellow .. '     deaths: ' .. ChatColour.White .. math.floor(kt.db.deaths) )
			print( ChatColour.Yellow .. '      ratio: ' .. ChatColour.White .. string.format( "%.3f", ratio ) )
			print( ChatColour.Yellow .. '        net: ' .. ChatColour.White .. netSign .. net )
			print( ChatColour.Cyan   .. '  duel wins: ' .. ChatColour.White .. math.floor(kt.db.duelsWon) )
			print( ChatColour.Cyan   .. 'duel losses: ' .. ChatColour.White .. math.floor(kt.db.duelsLost) )
			print( ChatColour.Cyan   .. ' duel ratio: ' .. ChatColour.White .. string.format( "%.3f", duelRatio ) )
			print( ChatColour.Cyan   .. '   duel net: ' .. ChatColour.White .. duelNetSign .. duelNet )
			print( ChatColour.Yellow .. '   suicides: ' .. ChatColour.White .. math.floor(kt.db.suicides) )
		end
	end
end )

AddConsoleCommand( 'kt_test', function( cmd, args )
	local kdr = flrand( 0.0, 2.0 )
	local net = flrand( 0.0, 0.01 )
	local netSign = (net >= 0) and '+' or '-'
	net = math.abs( net )
	Alert(
		((net >= 0) and ChatColour.Green or ChatColour.White) .. netSign .. string.format( "%.6f", net ),
		ChatColour.White .. ' ' .. string.format( "%.6f", kdr )
	)
end )

local showStats = false
AddConsoleCommand( '+ktstats', function( cmd, args ) showStats = true end )
AddConsoleCommand( '-ktstats', function( cmd, args ) showStats = false end )

AddListener( 'JPLUA_EVENT_HUD', function( events )
	if kt.power then
		local currTime = GetTime()
		--for i,v in next, kt.alerts do
		local i = 1
		local alert = kt.alerts[1]
		if alert then
			local sDuration = sum( alert.duration )
			if alert.time == 0 then
				alert.time = currTime
			elseif alert.time < currTime - sDuration then
				table.remove( kt.alerts, i )
			else
				local msec = currTime - alert.time
				--local totalF = msec / sDuration
				local f = {
					math.min( msec / alert.duration[1], 1.0 ),
					math.min( math.max( 0.0, (msec - alert.duration[1]) / alert.duration[2] ), 1.0 ),
					math.max( 0.0, (msec - alert.duration[1] - alert.duration[2]) / alert.duration[3] )
				}
				kt.textbox.text = ((sum(f)/3.0) < 0.5) and alert.textBegin or alert.textEnd
				kt.textbox:Draw(
					screenWidth - (alert.padding * 2.0) - (kt.textbox.width * f[1]),
					screenHeight / 2.0
				)
			end
		end

		if showStats then
			local ratio = (kt.db.deaths ~= 0) and (kt.db.kills / kt.db.deaths) or kt.db.kills
			local net = kt.db.kills - kt.db.deaths
			local netSign = (net >= 0) and '+' or '-'
			net = math.floor( math.abs( net ) )
			local duelRatio = (kt.db.duelsLost ~= 0) and (kt.db.duelsWon / kt.db.duelsLost) or kt.db.duelsWon
			local duelNet = kt.db.duelsWon - kt.db.duelsLost
			local duelNetSign = (duelNet >= 0) and '+' or '-'
			duelNet = math.floor( math.abs( duelNet ) )

			local lines = {}
			table.insert( lines, ChatColour.Yellow .. 'KillTracker stats:' )
			table.insert( lines, ChatColour.Yellow .. '      kills: ' .. ChatColour.White .. math.floor(kt.db.kills) )
			table.insert( lines, ChatColour.Yellow .. '     deaths: ' .. ChatColour.White .. math.floor(kt.db.deaths) )
			table.insert( lines, ChatColour.Yellow .. '      ratio: ' .. ChatColour.White .. string.format( "%.3f", ratio ) )
			table.insert( lines, ChatColour.Yellow .. '        net: ' .. ChatColour.White .. netSign .. net )
			table.insert( lines, ChatColour.Cyan   .. '  duel wins: ' .. ChatColour.White .. math.floor(kt.db.duelsWon) )
			table.insert( lines, ChatColour.Cyan   .. 'duel losses: ' .. ChatColour.White .. math.floor(kt.db.duelsLost) )
			table.insert( lines, ChatColour.Cyan   .. ' duel ratio: ' .. ChatColour.White .. string.format( "%.3f", duelRatio ) )
			table.insert( lines, ChatColour.Cyan   .. '   duel net: ' .. ChatColour.White .. duelNetSign .. duelNet )
			table.insert( lines, ChatColour.Yellow .. '   suicides: ' .. ChatColour.White .. math.floor(kt.db.suicides) )

			local lineOffset = 0
			for _,line in next, lines do
				kt.textbox.text = line
				kt.textbox:Draw(
					0.0,
					(screenHeight / 4.0) + lineOffset
				)
				lineOffset = lineOffset + kt.textbox.height
			end
		end
	end

	return events
end )
