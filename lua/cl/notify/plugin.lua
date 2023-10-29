local notify = RegisterPlugin('Notifications', '1.0.2', '13.6.0')

local cg_notifyMention = CreateCvar('cg_notifyMention', '1', CvarFlags.ARCHIVE)
local cg_notifyTriggers = CreateCvar('cg_notifyTriggers', '', CvarFlags.ARCHIVE)
local cg_notifyConnect = CreateCvar('cg_notifyConnect', '1', CvarFlags.ARCHIVE)

AddListener('JPLUA_EVENT_CLIENTCONNECT', function(player)
    if cg_notifyConnect:GetBoolean() then
        -- TODO: check if we were the only other player in the server, now we have friends :3
        SendNotification('connect', '* ' .. JPUtil.StripColours(player.name) .. ' connected', 3000, 'call-start')
    end
end)

AddListener('JPLUA_EVENT_CHATMSGRECV', function(msg)
    local sender, text = JPUtil.SplitChatMessage(msg)
    if sender == nil or text == nil then return msg end
    local ply = GetPlayer(sender)
    local us = GetPlayer(nil)
    if ply ~= nil and ply ~= us then
        local ourName = JPUtil.StripColours(us.name)
        if cg_notifyMention:GetBoolean() and string.find(text:lower(), ourName:lower(), 1, true) then
            SendNotification('mentioned by ' .. JPUtil.StripColours(ply.name), JPUtil.StripColours(text), 5000,
                             'appointment-new')
        elseif #cg_notifyTriggers:GetString() ~= 0 then
            local toks = JPUtil.explode(' ', text)
            local triggers = JPUtil.explode(' ', cg_notifyTriggers:GetString())
            for _, tok in next, toks do
                for _, trigger in next, triggers do
                    if tok == trigger then
                        SendNotification('#TRIGGERED', JPUtil.StripColours(text):gsub(trigger, '#' .. trigger .. '#'),
                                         5000, 'emblem-important')
                        break
                    end
                end
            end
        end
    end
    return msg
end)
