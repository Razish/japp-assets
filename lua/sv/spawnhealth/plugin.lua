local sh = RegisterPlugin('SpawnHealth', '1.0.0', '13.0.0')

local spawnHealth = CreateCvar('japp_spawnHealth', '125', CvarFlags.ARCHIVE)
local spawnArmor = CreateCvar('japp_spawnArmor', '25', CvarFlags.ARCHIVE)

AddListener('JPLUA_EVENT_CLIENTSPAWN', function(ply, firstSpawn)
    -- check if team != spectator? does that happen?
    if ply.team == Team.Spectator then return end
    ply.health = spawnHealth:GetInteger()
    ply.armor = spawnArmor:GetInteger()
end)
