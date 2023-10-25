local chans = RegisterPlugin('Channels', '1.0.0', '13.6.1')

AddListener('JPLUA_EVENT_CHATMSGSEND', function(msg, mode, targetClient, shortName, identifier)
    if #msg == 0 then return nil end

    if identifier == '' then
        -- not an irregular chatbox tab
        return msg
    end

    print('consuming outgoing chat message to #' .. identifier .. '(' .. mode .. '): ' .. msg)
    SendConsoleCommand('.msgchan ' .. identifier .. ' ' .. msg)
    return nil
end)
