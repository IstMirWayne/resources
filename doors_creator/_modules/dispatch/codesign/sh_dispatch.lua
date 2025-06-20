local moduleType = "dispatch" -- Module category
local moduleName = "codesign" -- THIS module name

-- Don't touch, required to appear in in-game settings
Integrations.modules = Integrations.modules or {}
Integrations.modules[moduleType] = Integrations.modules[moduleType] or {}
Integrations[moduleType] = Integrations[moduleType] or {}
Integrations[moduleType][moduleName] = {}
table.insert(Integrations.modules[moduleType], moduleName)

--[[
    You can edit below here
]]

-- Code inside here will happen once per call server side
Integrations[moduleType][moduleName].alertPoliceServerSide = function(coords, message, category)
    if not IsDuplicityVersion() then return end

    TriggerClientEvent('cd_dispatch:AddNotification', -1, {
        job_table = {'police', },
        coords = coords,
        title = '10-15 - Door lockpicked',
        message = message,
        flash = 0,
        unique_id = tostring(math.random(0000000,9999999)),
        sound = 1,
        blip = {
            sprite = 431,
            scale = 1.2,
            colour = 3,
            flashes = false,
            text = '911 - Door',
            time = 5,
            radius = 0,
        }
    })
end

-- Code inside here will happen client side ON ALL COPS CLIENTS
Integrations[moduleType][moduleName].alertPoliceMemberClientSide = function(coords, message, category)
    if IsDuplicityVersion() then return end

    -- Code may also go here
end
