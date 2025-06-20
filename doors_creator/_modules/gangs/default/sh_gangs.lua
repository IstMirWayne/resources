local moduleType = "gangs" -- Module category
local moduleName = "default" -- THIS module name

-- Don't touch, required to appear in in-game settings
Integrations.modules = Integrations.modules or {}
Integrations.modules[moduleType] = Integrations.modules[moduleType] or {}
Integrations[moduleType] = Integrations[moduleType] or {}
Integrations[moduleType][moduleName] = {}
table.insert(Integrations.modules[moduleType], moduleName)

--[[
    You can edit below here
]]

--[[
    Checks if a player has permission to open a door based on their gang and grade level
    
    @param playerId number - The server ID of the player
    @param allowedGangs table - Table of allowed gangs and their grades
        Format: {
            gangName = true, -- Allow all grades of this gang
            gangName2 = { -- Allow specific grades
                ["0"] = true,
                ["1"] = true
            }
        }
    @return boolean - Whether player has permission
]]
Integrations[moduleType][moduleName].isPlayerGangAllowedToOpenDoor = function(playerId, allowedGangs)
    if not IsDuplicityVersion() then return end -- Only server side

    -- No gang system currently implemented for ESX, you can add your own
    if(Framework.getFramework() == "ESX") then return true end

    local xPlayer = QBCore.Functions.GetPlayer(playerId)
    local gangName = xPlayer.PlayerData.gang.name
    local gangGrade = xPlayer.PlayerData.gang.grade.level

    if(allowedGangs[gangName] == true) then -- Any grade of the gang allowed
        return true
    elseif(allowedGangs[gangName]) then -- Specific grade of the gang allowed
        return allowedGangs[gangName] and allowedGangs[gangName][tostring(gangGrade)]
    end

    -- If no gang is allowed, return false
    return false
end

--[[
    Returns all gangs available in the game, must be in the format of the example below

    Example:
    {
        ballas = {
            label = "Ballas",
            grades = {
                [0] = {
                    grade = 0,
                    label = "Recruit"
                },
                [1] = {
                    grade = 1,  
                    label = "Member"
                },
                [2] = {
                    grade = 2,
                    label = "Boss"
                }
            }
        }
    }
]]
Integrations[moduleType][moduleName].getAllGangs = function()
    if(Framework.getFramework() == "ESX") then return {} end -- By default on ESX no gangs are available

    return QBCore.Shared.Gangs
end


