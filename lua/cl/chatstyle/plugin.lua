local chatstyle = RegisterPlugin( 'ChatStyle', '1.3.1', '13.0.0' )
local fileName = 'chatstyles.json'

local cvars = {
	['cg_chatStyle']	= CreateCvar( 'cg_chatStyle', '1', CvarFlags.ARCHIVE ),
}

local function SaveChatStyles()
	print( 'Saving ChatStyles...' )
	local sr = GetSerialiser( fileName, FSMode.Write )
	sr:AddTable( 'chatstyles', chatstyle.styles )
	sr:Close()
	sr = nil
end

local function LoadChatStyles()
	local sr = GetSerialiser( fileName, FSMode.Read )
	if not sr then
		SaveChatStyles()
		return
	end
	chatstyle.styles = sr:ReadTable( 'chatstyles' )
	sr:Close()
	sr = nil

	-- sanity check
	if chatstyle.styles['current'] == nil or chatstyle.styles[chatstyle.styles['current']] == nil then
		print( 'oops, looks like ChatStyles got corrupt, attempting repair' )
		chatstyle.styles['none'] = {
			['prefix'] = '',
			['suffix'] = ''
		}
		chatstyle.styles['current'] = 'none'
	end

end

local function CreateChatStyle( name, prefix, suffix )
	-- see if it already exists
	if chatstyle.styles[name] ~= nil then
		print( 'ChatStyle ' .. name .. ' already exists' )
		return
	end

	-- insert and save to disk
	chatstyle.styles[name] = {
		['prefix'] = prefix,
		['suffix'] = suffix
	}
	SaveChatStyles()
end

local function RemoveChatStyle( name )
	if chatstyle.styles[name] == nil then
		print( 'ChatStyle ' .. name .. ' doesn\'t exist' )
		return
	end

	-- if we're removing the current style, retrieve the name
	if name == 'current' then
		name = chatstyle.styles[name]
	end
	if name ~= nil then
		print( 'removing chatstyle ' .. name )
		chatstyle.styles[name] = nil
		if chatstyle.styles['current'] == name then
			-- attempt to fall back to 'none' - may not exist, but if it does it's the cleanest thing we can do short of
			--	re-adding it, which the user may not want
			chatstyle.styles['current'] = 'none'
		end
	end
end

local function ListChatStyles( func )
	func( 'ChatStyles list:' )
	for k,v in next, chatstyle.styles do
		if k ~= 'current' then -- skip
			func( '  ' .. k .. ': ' .. v['prefix'] .. 'example text' .. v['suffix'] )
		end
	end
end

local function SetChatStyle( name )
	if chatstyle.styles[name] == nil then
		SendChatText( 'ChatStyle ' .. name .. ' doesn\'t exist' )
		return nil
	end
	if name ~= 'current' then
		chatstyle.styles['current'] = name
	end
	return chatstyle.styles[name]
end

AddListener( 'JPLUA_EVENT_CHATMSGSEND', function( msg, mode, target )
	local enabled = cvars['cg_chatStyle']:GetInteger()
	if #msg == 0 or bit32.band( enabled, bit32.lshift( 1, mode ) ) == 0 then
		return msg
	end

	local currentStyle = chatstyle.styles[chatstyle.styles['current']]

	local pt = JPUtil.explode( ' ', msg )
	if pt[1] == '!chatstyle' then
		if #pt == 2 then
			if pt[2] == 'list' then
				ListChatStyles( SendChatText )
				return nil
			else
				currentStyle = SetChatStyle( pt[2] )
			end
		end
		if currentStyle ~= nil then
			SendChatText( 'Current ChatStyle: ' .. currentStyle['prefix'] .. chatstyle.styles['current']
				.. currentStyle['suffix']
			)
		else
			SendChatText( 'no ChatStyle selected' )
		end
		return nil
	end

	if currentStyle ~= nil then
		return chatstyle.styles[chatstyle.styles['current']]['prefix'] .. msg
			.. chatstyle.styles[chatstyle.styles['current']]['suffix']
	else
		return msg
	end
end )

-- chatstyle_create name prefix suffix
AddConsoleCommand( 'chatstyle_create', function( cmd, args )
	if #args < 2 or #args > 3 then
		print( 'Usage: /chatstyle_create name prefix [suffix]' )
		return
	end

	local name = args[1]
 	local prefix = args[2]
 	local suffix = ''
	 if #args == 3 then
	 	suffix = args[3]
	 end
	 CreateChatStyle( name, prefix, suffix )
end )

-- chatstyle_remove name
AddConsoleCommand('chatstyle_remove', function( cmd, args )
	if #args ~= 1 then
		print( 'Usage: /chatstyle_remove <name>' )
		return
	end

	RemoveChatStyle( args[1] )
end)

AddConsoleCommand('chatstyle_list', function( cmd, args )
	ListChatStyles( print )
end)

AddListener( 'JPLUA_EVENT_UNLOAD', SaveChatStyles )
LoadChatStyles()
