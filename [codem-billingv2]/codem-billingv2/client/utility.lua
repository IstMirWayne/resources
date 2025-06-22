local BillingPed = nil
local LoadedPlayer = false
AddEventHandler('onResourceStart', function(resourceName)
    if (resourceName == GetCurrentResourceName()) then
        LoadedPlayer = true
        Wait(2000)
        TriggerServerEvent('codem-billing:loadinfo')
    end
end)
RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()
    Wait(1000)
    TriggerServerEvent('codem-billing:loadinfo')
    LoadedPlayer = true
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    Wait(1000)
    TriggerServerEvent('codem-billing:loadinfo')
    LoadedPlayer = true
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate")
AddEventHandler("QBCore:Client:OnJobUpdate", function(data)
    Wait(1000)
    TriggerServerEvent('codem-billing:server:UpdateJob')
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    Wait(1000)
    TriggerServerEvent('codem-billing:server:UpdateJob')
end)

GetClosestPlayers = function()
    local players = {}
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    for _, player in ipairs(GetActivePlayers()) do
        local target = GetPlayerPed(player)
        if target ~= ped then
            local targetCoords = GetEntityCoords(target)
            local distance = #(pedCoords - targetCoords)
            if distance < 3.5 then
                table.insert(players, GetPlayerServerId(player))
            end
        end
    end
    return players
end

Citizen.CreateThread(function()
    while not LoadedPlayer do
        Wait(0)
    end
    InitMenu()
    SpawnNPC(Config.ApprovalBilling.NpcModel, Config.ApprovalBilling.NpcCoords, Config.ApprovalBilling.NpcHeading)
end)


function SpawnNPC(model, coords, heading)
    if DoesEntityExist(BillingPed) then
        DeleteEntity(BillingPed)
    end
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    BillingPed = CreatePed(0, model, coords, false, false)
    FreezeEntityPosition(BillingPed, true)
    SetEntityInvincible(BillingPed, true)
    SetEntityHeading(BillingPed, heading)
    SetBlockingOfNonTemporaryEvents(BillingPed, true)
    if Config.ApprovalBilling.Blip.Show then
        local BlipSettings = Config.ApprovalBilling.Blip
        local blip = AddBlipForCoord(coords)
        SetBlipSprite(blip, BlipSettings.Sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, BlipSettings.Scale)
        SetBlipColour(blip, BlipSettings.Color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(BlipSettings.Name)
        EndTextCommandSetBlipName(blip)
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then

    end
end)



function TriggerCallback(name, data)
    local incomingData = false
    local status = 'UNKOWN'
    local counter = 0
    while Core == nil do
        Wait(0)
    end
    if Config.Framework == 'esx' then
        Core.TriggerServerCallback(name, function(payload)
            status = 'SUCCESS'
            incomingData = payload
        end, data)
    else
        Core.Functions.TriggerCallback(name, function(payload)
            status = 'SUCCESS'
            incomingData = payload
        end, data)
    end
    CreateThread(function()
        while incomingData == 'UNKOWN' do
            Wait(1000)
            if counter == 4 then
                status = 'FAILED'
                incomingData = false
                break
            end
            counter = counter + 1
        end
    end)

    while status == 'UNKOWN' do
        Wait(0)
    end
    return incomingData
end

function DrawText3D(x, y, z, text)
    if not text then
        text = 'Missing Text'
    end
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.3, 0.3)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 90)
end
