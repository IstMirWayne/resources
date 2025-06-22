Settings = {
    Framework = "QBCore", -- Esx or NewESX and QBCore or OldQBCore
    Voice = "mumble-voip", --  pma-voice & saltychat & mumble-voip
    MaxFrequency = 500, --  Max Frequency
    ResetCommad = "radioreset",
    Language = {
        ["group"] = "GROUP",
        ["enter_frequency"] = "ENTER FREQUENCY",
        ["volume_settings"] = "VOLUME SETTINGS",
        ["radio_connet_number"] = "RADIO CONNECTED NUMBER",
        ["settings"] = "Settings",
        ["join"] = "Join",
        ["encrypted"] = "This frequency is encrypted",
        ["move"] = "Move",
        ["joined"] = "Joined",
        ["leaved"] = "Leaved"
    },

    OnlyJob = {
        [1] = {
            RadioCode = 1, 
            Jobs = {"lspd", "bcso", "sast"},
        },
        [2] = {
            RadioCode = 2, 
            Jobs = {"lspd", "bcso", "sast"},
        },
        [3] = {
            RadioCode = 3, 
            Jobs = {"lspd", "bcso", "sast"},
        },
        [4] = {
            RadioCode = 4, 
            Jobs = {"lspd"},
        },
        [5] = {
            RadioCode = 5, 
            Jobs = {"sast"},
        },
        [6] = {
            RadioCode = 6, 
            Jobs = {"bcso"},
        },   
        [7] = {
            RadioCode = 7, 
            Jobs = {"sheriff"},
        }, 
    },
}

GetFramework = function()
    local Get = nil
    if Settings.Framework == "ESX" then
        while Get == nil do
            TriggerEvent('esx:getSharedObject', function(Set) Get = Set end)
            Citizen.Wait(0)
        end
    end
    if Settings.Framework == "NewESX" then
        Get = exports['es_extended']:getSharedObject()
    end
    if Settings.Framework == "QBCore" then
        Get = exports["qb-core"]:GetCoreObject()
    end
    if Settings.Framework == "OldQBCore" then
        while Get == nil do
            TriggerEvent('QBCore:GetObject', function(Set) Get = Set end)
            Citizen.Wait(200)
        end
    end
    return Get
end

ClientNotification = function(message, type) -- You can change notification event here
    if Settings.Framework == "ESX" then
        TriggerEvent('esx:showNotification', message)
    elseif Settings.Framework == "QBCore" then 
       TriggerEvent('QBCore:Notify', message, type, 1500)
    end
end

ConnectRadio = function(data) 
    TriggerServerEvent("setRadioChannel", data)
    if Settings.Voice == "pma-voice" then 
        exports["pma-voice"]:setRadioChannel(0)
        exports["pma-voice"]:setRadioChannel(data)
    elseif Settings.Voice == "saltychat" then
        exports["saltychat"]:SetRadioChannel(0, true)
        exports["saltychat"]:SetRadioChannel(data, true)
    elseif Settings.Voice == "mumble-voip" then
        exports["mumble-voip"]:SetRadioChannel(0)
        exports["mumble-voip"]:SetRadioChannel(data)
    end 
end

RadioLeave = function()
    if RadioCode then
        ClientNotification(Settings.Language.leaved .. " " .. RadioCode, "error")
    end

    TriggerServerEvent("setRadioChannel", 0)

    if Settings.Voice == "pma-voice" then 
        exports['pma-voice']:removePlayerFromRadio()
    elseif Settings.Voice == "saltychat" then
        exports["saltychat"]:RemovePlayerRadioChannel()
    elseif Settings.Voice == "mumble-voip" then
        exports["mumble-voip"]:removePlayerFromRadio()
    end 

    RadioCode = nil
end

setVolume = function(data)
    if Settings.Voice == "pma-voice" then 
        exports['pma-voice']:setRadioVolume(tonumber(data)) 
    elseif Settings.Voice == "saltychat" then
        exports["saltychat"]:SetRadioVolume(tonumber(data)) 
    end 
end

AddEventHandler('ox_inventory:itemCount', function(itemName, totalCount)
    if itemName ~= 'radio' then return end
    if totalCount <= 0 then
        RadioLeave()
    end
end)

RegisterNetEvent('codem-inventory:client:removeitemtoclientInventory', function(item, amount)
    local Inv = exports['codem-inventory']:GetClientPlayerInventory()
    local radioAmount = 0

    for k, v in pairs(Inv) do
        if v.name == "radio" then
            radioAmount = v.amount - amount
        end
    end

    if radioAmount == 0 then
        RadioLeave()
    end
end)

AddEventHandler('ox_inventory:itemCount', function(itemName, totalCount)
    if itemName ~= 'radio' then return end
    if totalCount <= 0 then
        RadioLeave()
    end
end)

RegisterNetEvent('codem-radio:client:onRadioDrop', function()
    RadioLeave()
end)

RegisterNetEvent('qb-inventory:client:updateInventory', function()
    local Player = Framework.Functions.GetPlayerData()
    local radioAmount = 0

    if PlayerData and type(PlayerData.items) == "table" then
        items = PlayerData.items
    end

    for k, v in pairs(items) do
        if v.name == "radio" then
            radioAmount = v.amount
        end
    end

    if radioAmount == 0 then
        RadioLeave()
    end
end)