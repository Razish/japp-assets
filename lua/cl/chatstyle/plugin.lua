local chatstyle = RegisterPlugin( 'ChatStyle', '1.2.0', '13.0.0' )
local chatstyles = {}
local chatstyle['current'] = 'none'
local filename = 'chatstyles.json'

local function saveChatStyles()
		print( 'Saving ChatStyles...' )
	local sr = GetSerialiser( filename , FSMode.Write )
	local t = chatstyles
	sr:AddTable( 'chatstyles', chatstyles )
	sr:Close()
	sr = nil
end

local function loadChatStyles()
	local sr = GetSerialiser(filename , FSMode.Read )
	if not sr then
		saveChatStyles()
		return
	end
	iplist = sr:ReadTable( 'chatstyles' )
	sr:Close()
	sr = nil
end

local function listChatStyles()
	print('ChatStyles list: \n')
	for k,v in pairs(chatstyle)
		if k ~= 'current' then --skip
			print(string.format("Name: '%s' Prefix: %s Suffix: %s\n"), k, v['prefix'], v['suffix'])
		end
	end
	print('\n')
end

local function createChatStyle(name, prefix, suffix)
	if chatstyles[name] ~= nil then
		print("ChatStyle '" .. name .. "' already exist!\n")
		return
	end
	chatstyles[name] = {}
	chatstyles[name]['prefix'] = prefix
	chatstyles[name]['suffix'] = suffix
	saveChatStyles()
end

local function removeChatStyle(name))
	if chatstyles[name] == nil then
		print("ChatStyle '" .. name .. "' not exist!\n")
		return
	end
	chatstyles[name]['prefix'] = prefix
	chatstyles[name]['suffix'] = suffix
end

local function setChatStyle(name)
	if chatstyles[name] == nil then
		print("ChatStyle '" .. name .. "' not exist!\n")
		return
	end
	chatstyles['current'] = name
	return 1
end

local cvars = {
	['cg_chatPrefix']	= CreateCvar( 'cg_chatPrefix', '', CvarFlags.ARCHIVE ),
	['cg_chatSuffix']	= CreateCvar( 'cg_chatSuffix', '', CvarFlags.ARCHIVE ),
	['cg_chatStyle']	= CreateCvar( 'cg_chatStyle', '1', CvarFlags.ARCHIVE ),
	['cg_chatAnnounce']	= CreateCvar( 'cg_chatAnnounce', '0', CvarFlags.ARCHIVE ),
}


AddListener( 'JPLUA_EVENT_CHATMSGSEND', function( msg, mode, target )
	local pt = JPUtil.explode(' ', msg)
	if pt[1] == '!chatstyle' then
		if pt[2] == 'set' then
			setChatStyle(pt[3])
		elseif pt[2] == 'current' or pt[2] == nil then
			local str = string.format("Current ChatStyle: %s%s%s", chatstyles[chatstyles['current']]['prefix'],
																			  chatstyles['current'],
																			  chatstyles[chatstyles['current']]['suffix']))
			if cvars['cg_chatAnnounce']:GetInteger() then
				SendConsoleCommand("say " .. str)
			else
				SendConsoleCommand(string.format("lua SendChatText('%s')", str)) -- lol, should be inserted after message below
			end
		end
		if cvars['cg_chatAnnounce']:GetInteger() then
			return msg
		else
			SendChatText(msg)
		end
	end
	local enabled = cvars['cg_chatStyle']:GetInteger()
	if string.len( msg ) == 0 or bit32.band( enabled, bit32.lshift( 1, mode ) ) ~= enabled then
		return msg
	end
	return chatstyles[chatstyles['current']]['prefix'] .. msg .. chatstyles[chatstyles['current']]['suffix']
end )

AddConsoleCommand('cg_newChatStyle', function(args) --- /cg_newChatStyle name prefix suffix
	if not args[1] then
		print("Usage: /cg_newChatStyle name prefix/suffix [suffix]\n")
	end
	 local name = args[1]
	 if args[2] ~= "''" or args[2] ~= '""' then
	 	local prefix = args[2]
	 else
	 	local prefix = ''
	 end
	 if args[3] ~= "''" or args[3] ~= '""' then
	 	local prefix = args[2]
	 else
	 	local prefix = ''
	 end
	 createChatStyle(name, prefix, suffix
end)

AddConsoleCommand('cg_removeChatStyle', function(args)
	if not args[1] then
		print("Usage: /cg_removeChatStyle name \n")
	end
	removeChatStyle(args[1])
end)

AddConsoleCommand('cg_listChatStyles', function(args)
	listChatStyles()
end)

AddListener( 'JPLUA_EVENT_UNLOAD', saveChatStyles() )
loadChatStyles()