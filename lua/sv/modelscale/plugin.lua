local mscale = RegisterPlugin('ModelScale', '1.1.4', '13.5.0')

-- key: player id
-- value: scale amount
-- set from modelscale command
mscale.list = {}

-- key: player model
-- value: scale amount
-- loaded from modelscale.cfg
mscale.predefined = {}

local japp_modelScale = CreateCvar('japp_modelScale', '1', CvarFlags.ARCHIVE)
local japp_modelScaleCmd = CreateCvar('japp_modelScaleCmd', '0', CvarFlags.ARCHIVE)
local japp_modelScaleRange = CreateCvar('japp_modelScaleRange', '80 120', CvarFlags.ARCHIVE)

local function ParseToken(str, idx) return JPUtil.explode(' ', str)[idx] end

local function LoadCFG()
    local file = OpenFile('modelscale.cfg', FSMode.Read)
    local contents = file:Read(file:Length())
    local compressed = COM_Compress(contents)
    local list = JPUtil.explode(' ', compressed)

    -- list is in the form [ model, scale, model, scale ]
    if list == nil then error('invalid modelscale format') end
    if #list % 2 == 1 then
        print('invalid modelscale format: missing scale for a model? (count: ' .. #list)
        for k, v in next, list do print(k .. ': ' .. v) end
        return
    end

    -- insert into new list
    local i = 1
    while list[i] and list[i + 1] do
        local key = list[i]
        local value = list[i + 1]
        mscale.predefined[key] = value
        i = i + 2
    end
end

LoadCFG()

AddListener('JPLUA_EVENT_CLIENTDISCONNECT', function(ply)
    if not ply then return end
    mscale.list[ply.id] = nil
end)

AddListener('JPLUA_EVENT_CLIENTSPAWN', function(ply, firstSpawn)
    local scale = 100
    if japp_modelScale:GetBoolean() then
        if japp_modelScaleCmd:GetBoolean() and mscale.list[ply.id] then
            scale = math.floor(math.abs(mscale.list[ply.id]))
        elseif mscale.predefined[ply.model] then
            scale = math.floor(math.abs(mscale.predefined[ply.model] * 100))
        end
    end
    ply.entity:Scale(scale)
end)

AddListener('JPLUA_EVENT_CLIENTUSERINFOCHANGED', function(clientNum, userinfo)
    local scale = 100
    local ply = GetPlayer(clientNum)
    if japp_modelScale:GetBoolean() then
        if not ply then return end
        local model = userinfo['model']

        if japp_modelScaleCmd:GetBoolean() and mscale.list[ply.id] then
            scale = math.floor(math.abs(mscale.list[ply.id]))
        elseif mscale.predefined[model] then
            scale = math.floor(math.abs(mscale.predefined[model] * 100))
        end

        if scale ~= 100 then
            ply:ConsolePrint('modelscale: scaling ' .. userinfo['name'] .. ' by ' .. scale .. ' (model: ' .. model ..
                                 ')\n')
        end
    end

    ply.entity:Scale(scale)
end)

AddClientCommand('modelscale', function(ply, args)
    if not japp_modelScale:GetBoolean() or not japp_modelScaleCmd:GetBoolean() then
        ply:ConsolePrint('modelscale is not enabled on this server\n')
        return
    end

    if #args == 1 then
        local scale = tonumber(args[1])
        if scale then
            -- make sure it's in valid range
            local str = japp_modelScaleRange:GetString()
            local range = {min = tonumber(ParseToken(str, 1)), max = tonumber(ParseToken(str, 2))}
            scale = math.min(scale, range.max)
            scale = math.max(range.min, scale)
            ply.entity:Scale(scale)
            mscale.list[ply.id] = scale
            ply:ConsolePrint(ChatColour.Cyan .. 'setting model scale to ' .. ChatColour.Yellow .. scale .. '\n')
        end
    else
        local scale = 100
        if mscale.list[ply.id] then
            scale = math.floor(math.abs(mscale.list[ply.id]))
        elseif mscale.predefined[ply.model] then
            scale = math.floor(math.abs(mscale.predefined[ply.model] * 100))
        end
        ply:ConsolePrint(ChatColour.Cyan .. 'your model scale is: ' .. ChatColour.Yellow .. scale .. '\n')
    end
end)

AddServerCommand('modelscales', function(args) for k, v in next, mscale.predefined do print(k .. ': ' .. v) end end)
