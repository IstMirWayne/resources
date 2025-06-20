local moduleType = "lockpick" -- Module category
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
Integrations[moduleType][moduleName].startLockpick = function(attempts)
    local resName = EXTERNAL_SCRIPTS_NAMES["lockpick"]
    
    if(GetResourceState(resName) ~= "started") then
        notifyClient("Check F8")
        print("^1To use the lockpick minigame, you need ^3lockpick^1 to be ^2installed and started^1, you can change the script folder name in ^3integrations/sh_integrations.lua^1")
        print("^1FOLLOW THE SCRIPT INSTALLATION TUTORIAL TO FIND IT^7")
        return false
    end

    return exports[resName]:startLockpick(attempts)
end 
