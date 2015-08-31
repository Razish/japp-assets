local ignorebot = RegisterPlugin( "IgnoreBot", "1.2" ) -- encapsulate all plugin data and functions in this table

--Return a table of strings split up by JA's chat message escape character.
local function SplitChatMessage( msg )
	local splitMsg = JPUtil.explode( string.format( "%c", 0x19 ), msg )
	local len = #splitMsg

	if len == 2 then -- for regular messages, only one escape character
		local name = string.sub( splitMsg[1], 1, string.len(splitMsg[1])-2 ) -- strip the ^7 at the end
		local message = string.sub( splitMsg[2], 3 ) -- strip the ': ' before each message
		return name, message
	elseif len == 4 then -- for JA+ admin messages...
		local name = string.sub( splitMsg[2], 2, string.len(splitMsg[2])-2 ) -- strip the '(' at the start and ^7 at the end
		local message = string.sub( splitMsg[4], 4 ) -- strip the ': ^3' at the start
		return name, message
	else
		return nil, nil
	end
end

-- Cancel JPLUA_EVENT_CHATMSGRECV if the message was from a bot.
-- Uses an unreliable name-match, will NOT cancel the event if multiple clients are found to have that name
AddListener( "JPLUA_EVENT_CHATMSGRECV", function( msg )
	sender, message = SplitChatMessage( msg )
	ply = GetPlayer( sender )
	if ply and ply.isBot then
		return nil
	else
		return msg
	end
end )
