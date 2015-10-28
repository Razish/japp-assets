-- Authors: EpicLoyd, Raz0r
local plugin = RegisterPlugin( 'iplog', '0.2.0', '13.0.0' )

local iplist = {}
local logname = 'ips.json'

local function Load()
	local sr = GetSerialiser( logname, FSMode.Read )
	iplist = sr:ReadTable( 'iplist' )
	sr:Close()
	sr = nil
end
Load()

local function Save()
	print( 'Saving IP log...' )
	local sr = GetSerialiser( logname, FSMode.Write )
	local t = iplist
	sr:AddTable( 'iplist', iplist )
	sr:Close()
	sr = nil
end

AddServerCommand( 'iplog', function( args )
	if #args == 0 then
		print( 'Usage: \\iplog [clear]' )
	elseif #args == 1 then
		if args[1] == 'clear' then
			print( 'Clearing IP log...' )
			for k in pairs( iplist ) do
				iplist[k] = nil
			end
			Save()
		end
	end
end )

AddListener( 'JPLUA_EVENT_CLIENTCONNECT', function( id, info, ip, firsttime )
	if ip == 'Bot' or not firsttime then
		return nil
	end

	local pos = ip:find( ':' )
	if pos ~= nil then
		ip = ip:sub( 1, pos-1 )
	end

	local name = info['name']
	if iplist[ip] == nil then
		iplist[ip] = name
		return nil
	elseif iplist[ip] ~= nil and iplist[ip] == name then
		return nil
	else
		local old = iplist[ip]
		local msg = 'Player ' .. name .. ' connected...^1Player with same IP ' .. iplist[ip]
		print( msg )
		SendReliableCommand( -1, 'print "' .. msg .. '\n"' )
	end
end )

AddListener( 'JPLUA_EVENT_UNLOAD', Save )
