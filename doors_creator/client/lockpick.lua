local ATTEMPTS = 3

local function lockpickDoor(doorsId)
    local plyPed = PlayerPedId()
    local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
    local animName = "machinic_loop_mechandplayer"

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(10)
    end

    TaskPlayAnim(plyPed, animDict, animName, 8.0, 8.0, -1, 17, 1.0, false, false, false)

    local successful = Utils.callModuleFunc('lockpick', 'startLockpick', ATTEMPTS)

    ClearPedTasks(plyPed)
    
    RemoveAnimDict(animDict)

    if(successful) then
        TriggerServerEvent("doors_creator:doorLockpicked", doorsId)
    end
end

RegisterNetEvent("doors_creator:startLockpick", function(comesFromVehicleKeysScript)
    local closestDoor, closestDist = DoorsCreator.getClosestActiveDoor()

    if not closestDoor or closestDist >= 5.0 then
        local message = comesFromVehicleKeysScript and getLocalizedText("no_close_door_or_vehicle") or getLocalizedText("no_close_door")
        notifyClient(message)
        return
    end

    if not DoorsCreator.allDoors[closestDoor.id].canBeLockpicked then
        notifyClient( getLocalizedText("you_cant_lockpick_this_door") )
        return
    end

    local canLockpick = TriggerServerPromise(Utils.eventsPrefix .. ":canLockpickDoor")
    if not canLockpick then return end

    lockpickDoor(closestDoor.id)
end)
