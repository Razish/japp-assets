local chans = RegisterPlugin('Channels', '1.0.0', '13.6.1')

local Channel = require 'channels/Channel.lua'

--[[
	TODO:
		* reserve passworded channels by server owner
		* decide whether we want channels to be publicly visible (chanlist)
		* filter identifiers for c < '$' || c > '}' || c == ';'
		* enforce maximum channel length (32)
--]]

local japp_maxChannels = CreateCvar('japp_maxChannels', '3', CvarFlags.ARCHIVE) -- user can't be in more than this many channels at once (0 = disabled)
local japp_channelSize = CreateCvar('japp_channelSize', '0', CvarFlags.ARCHIVE) -- channels can't have more than this many users as once (0 = disabled)

chans.channels = {}
chans.selectedChan = {} -- map of ply.id -> Channel.name

local function IsLegacyClient(ply) return bit32.band(ply.supportFlags, CSF.CHAT_FILTERS) ~= CSF.CHAT_FILTERS end

-- lazy constructor
local function GetChannel(name, password)
    for channelName, channel in next, chans.channels do if channelName == name then return channel end end

    print('creating new channel \'' .. name .. '\'')
    local channel = Channel(name, password)
    chans.channels[name] = channel
    return channel
end

local function GetJoinedChannels(ply)
    local result = {}
    local joinedChans = filter(function(channel) return channel:IsMember(ply) end, chans.channels)
    for _, channel in next, joinedChans do table.insert(result, channel) end
    return result
end

local function ListJoinedChannels(ply)
    if not ply then return end

    local selectedChan = chans.selectedChan[ply.id]
    local channels = table.concat(map(function(channel)
        return (channel.name == selectedChan) and (ChatColour.Green .. channel.name .. ChatColour.White) or channel.name
    end, GetJoinedChannels(ply)), ', ')
    ply:ConsolePrint('channels: ' .. channels .. '\n')
end

local function RemoveEmptyChannel(channel)
    if #channel == 0 then
        print('removing empty channel \'' .. channel.name .. '\'')
        chans.channels[channel.name] = nil
        return true
    end
    return false
end

local function SelectNextChannel(ply)
    local joinedChans = GetJoinedChannels(ply)
    local numJoinedChannels = 0
    for _, _ in next, joinedChans do numJoinedChannels = numJoinedChannels + 1 end
    if numJoinedChannels == 0 then
        ply:ConsolePrint('oops! you\'re not in any channels\n')
        return
    end

    local newIdx = nil
    for i, channel in pairs(joinedChans) do
        if channel.name == chans.selectedChan[ply.id] then
            newIdx = (i % numJoinedChannels) + 1
            break
        end
    end

    if newIdx ~= nil then
        ply:ConsolePrint('selecting channel \'' .. joinedChans[newIdx].name .. '\'\n')
        chans.selectedChan[ply.id] = joinedChans[newIdx].name
        ListJoinedChannels(ply)
    else
        ply:ConsolePrint('error switching channel :(\n')
    end
end

local function SelectPrevChannel(ply)
    local joinedChans = GetJoinedChannels(ply)
    local numJoinedChannels = 0
    for _, _ in next, joinedChans do numJoinedChannels = numJoinedChannels + 1 end
    if numJoinedChannels == 0 then
        ply:ConsolePrint('oops! you\'re not in any channels\n')
        return
    end

    local newIdx = nil
    for i, channel in pairs(joinedChans) do
        if channel.name == chans.selectedChan[ply.id] then
            newIdx = ((i - 2) % numJoinedChannels) + 1
            break
        end
    end

    if newIdx ~= nil then
        ply:ConsolePrint('selecting channel \'' .. joinedChans[newIdx].name .. '\'\n')
        chans.selectedChan[ply.id] = joinedChans[newIdx].name
        ListJoinedChannels(ply)
    else
        ply:ConsolePrint('error switching channel :(\n')
    end
end

AddListener('JPLUA_EVENT_CLIENTDISCONNECT', function(ply)
    if not ply then return end

    -- remove from any channels they're in, notify others in the channel
    for _, channel in next, chans.channels do
        if channel:IsMember(ply) then
            channel:Leave(ply)
            if not RemoveEmptyChannel(channel) then
                channel:Message(nil, ply.name .. ' ' .. ChatColour.White .. 'has left the channel')
            end
        end
    end
end)

AddListener('JPLUA_EVENT_CLIENTSPAWN', function(ply, firstSpawn)
    if firstSpawn then
        -- TODO: stay awhile and listen
    end
end)

AddClientCommand('.joinchan', function(ply, args)
    if #args < 1 then
        ply:ConsolePrint('usage: joinchan <name> [password]\n')
        return
    end

    local channel = GetChannel(args[1], args[2])

    if channel:IsMember(ply) then
        ply:ConsolePrint('oops! you are already in this channel\n')
        return
    end

    if #channel == 0 then
        -- freshly created
        if #args == 2 then channel:SetPassword(args[2]) end
    elseif channel.password and channel.password ~= args[2] then
        ply:ConsolePrint(ChatColour.Red .. 'invalid password!\n')
        return
    end
    ply:ConsolePrint('joining channel \'' .. channel.name .. '\'\n')
    channel:Join(ply)
    chans.selectedChan[ply.id] = channel.name

    ListJoinedChannels(ply)
end)

-- list everyone in specified (or current) channel
AddClientCommand('.whoischan', function(ply, args)
    local channel = chans.channels[(#args == 1) and args[1] or chans.selectedChan[ply.id]]

    if channel == nil then
        ply:ConsolePrint('invalid channel\n')
        return
    elseif not channel:IsMember(ply) and channel.password ~= nil then
        ply:ConsolePrint('oops! you\'re not in that password-protected channel\n')
        return
    end

    local members = table.concat(map(function(id) return GetPlayer(id).name end, channel:GetMembers()), ', ')
    ply:ConsolePrint('members in \'' .. channel.name .. '\': ' .. members .. '\n')
end)

-- leave specified (or current) channel
AddClientCommand('.leavechan', function(ply, args)
    local channel = chans.channels[(#args == 1) and args[1] or chans.selectedChan[ply.id]]

    if channel == nil or not channel:IsMember(ply) then
        ply:ConsolePrint('oops! you\'re not in that channel\n')
        return
    end

    ply:ConsolePrint('left channel \'' .. channel.name .. '\'\n')
    channel:Leave(ply)
    if not RemoveEmptyChannel(channel) then
        channel:Message(nil, ply.name .. ' ' .. ChatColour.White .. 'has left the channel')
    end
end)

AddClientCommand('.nextchan', function(ply, args) SelectNextChannel(ply) end)

AddClientCommand('.prevchan', function(ply, args) SelectPrevChannel(ply) end)

-- send message to specified (or current if legacy) channel
AddClientCommand('.msgchan', function(ply, args)
    if #args < 2 then
        ply:ConsolePrint('usage: \\.msgchan <channel name> <message>\n')
        return
    end

    local channel -- = nil
    if IsLegacyClient(ply) then
        local selectedChan = chans.selectedChan[ply.id]
        if selectedChan == nil then
            ply:ConsolePrint('oops! you\'re not in any channels\n')
            return
        end
        channel = chans.channels[selectedChan]
    else
        channel = chans.channels[args[1]]
    end

    if channel == nil then
        ply:ConsolePrint('oops! no such channel :(\n')
        return
    end

    if not channel:IsMember(ply) then
        ply:ConsolePrint('oops! you\'re not in that channel\n')
        return
    end

    local msg = table.concat({table.unpack(args, 2, #args)}, ' ')
    print('msgchan: ' .. ply.name .. ' to #' .. channel.name .. ': ' .. msg)
    if channel:IsMember(ply) then channel:Message(ply, msg) end
end)

AddListener('JPLUA_EVENT_CHATMSGPLUGIN', function(ply, msg)
    -- make sure we're in a channel
    local selectedChan = chans.selectedChan[ply.id]
    if selectedChan == nil then
        ply:ConsolePrint('oops! you\'re not in any channels\n')
        return nil
    end
    local channel = chans.channels[selectedChan]

    -- send to selected channel
    print('say_plugin: ' .. ply.name .. ' to #' .. channel.name .. ': ' .. msg)
    channel:Message(ply, msg)

    -- cancel event
    return nil
end)

-- list channels
AddClientCommand('.chanlist', function(ply, args) ListJoinedChannels(ply) end)
AddServerCommand('.chanlist', function(args)
    local numChannels = 0
    local channelNames = {}
    for channelName, _ in next, chans.channels do
        numChannels = numChannels + 1
        table.insert(channelNames, channelName)
    end
    print(numChannels .. ' channels: ' .. table.concat(channelNames, ', '))
end)
