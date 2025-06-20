local QBCore = exports['qb-core']:GetCoreObject()

function CheckJobAndHandleFivePD()
    local playerData = QBCore.Functions.GetPlayerData()

    if playerData and playerData.job then
        if playerData.job.name ~= "police" then
            TriggerEvent("chat:addMessage", {
                color = {255, 0, 0},
                multiline = false,
                args = {"FivePD", "Du musst Polizist sein, um FivePD zu verwenden."}
            })

            TriggerEvent("FivePD:Client:Logout")
        else
            print("[FivePDBridge] Polizei-Job erkannt – Zugriff erlaubt.")
        end
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(1000)
    CheckJobAndHandleFivePD()
end)

Citizen.CreateThread(function()
    while true do
        local player = QBCore.Functions.GetPlayerData()
        if player and player.job then
            CheckJobAndHandleFivePD()
            break
        end
        Wait(500)
    end
end)

RegisterCommand("fivepdmenu", function()
    local job = QBCore.Functions.GetPlayerData().job.name
    if job ~= "police" then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            args = {"FivePD", "Nur für Polizisten verfügbar."}
        })
        return
    end

    TriggerEvent("FivePD:Client:OpenMenu")
end, false)
