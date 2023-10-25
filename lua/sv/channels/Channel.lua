local Channel = {}

-- constructor
local new = function(name, password)
    local channel = {name = name, password = password, clients = {}}
    return setmetatable(channel, Channel)
end

-- string representation of channel
function Channel:__tostring() return self.name .. '(' .. #self.clients .. ' clients)' end

-- returns number of clients currently in the channel
function Channel:__len()
    local numClients = 0
    for _, _ in next, self.clients do numClients = numClients + 1 end
    return numClients
end

-- is player in the channel?
function Channel:IsMember(ply) return self.clients[ply.id] == true end

-- return an array of client numbers
function Channel:GetMembers()
    local result = {}
    for clientNum, _ in next, self.clients do table.insert(result, clientNum) end
    return result
end

-- join a channel and notify channel members
-- NOTE: alerts if player is already in channel
function Channel:Join(ply)
    if ply == nil then
        print('invalid player tried to join channel \'' .. self.name .. '\'')
        return
    end

    -- check if they're already in the channel
    if self:IsMember(ply) then
        ply:ConsolePrint('oops! you are already in this channel\n')
        return
    end

    -- notify members and join
    self:Message(nil, ply.name .. ChatColour.White .. ' has joined the channel')
    self.clients[ply.id] = true
end

-- send a message to a channel
-- delimiter around channel is 0x11
-- delimiter around name is 0x19
-- if ply is nil, message is sent generically (e.g. for system alerts)
function Channel:Message(ply, msg)
    local tabEC = string.char(0x11)
    -- local chanEC = string.char( 0x14 )
    local msgEC = string.char(0x19)
    for clientNum, _ in next, self.clients do
        local prefix = (ply == nil) and
                           ('<' .. ChatColour.Yellow .. 'system~' .. ChatColour.White .. tabEC ..
                               JPUtil.StripColours(self.name) .. tabEC .. '>') or
                           ('<' .. ply.name .. ChatColour.White .. '#' .. tabEC .. JPUtil.StripColours(self.name) ..
                               tabEC .. '>')

        SendReliableCommand(clientNum, 'chat "' .. prefix .. msgEC .. ': ' .. msg .. '"\n')
    end
end

-- leave a channel and notify channel members
function Channel:Leave(ply)
    if ply == nil then return false end

    if self:IsMember(ply) == false then return false end

    print(ply.name .. ' ' .. ChatColour.White .. 'has left channel \'' .. self.name .. '\'')
    self.clients[ply.id] = nil

    return true
end

Channel.__index = Channel
Channel.__metatable = {}

return setmetatable({}, {__call = function(cls, ...) return new(...) end})
