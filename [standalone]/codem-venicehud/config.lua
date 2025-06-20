
-------------------------------------------- General --------------------------------------------
Config = {}
Config.Framework = "newqb" -- newqb, oldqb, esx
Config.NewESX = true
Config.Mysql = "oxmysql" -- mysql-async, ghmattimysql, oxmysql
Config.Voice = "pma" -- mumble, saltychat, pma
Config.DefaultHud = "vertexhud" -- Default hud when player first login avaliable huds [venicehud, malibuhud, belairhud]
Config.DefaultCarHud = "vertexhud" -- Default hud when player first login avaliable huds [vertexhud, mayhemhud, perspecthud]
Config.EnableDynamicStatusFirstJoin = false -- Enable dynamic status first join
Config.DefaultSpeedUnit = "mph" -- Default speed unit when player first login avaliable speed units [kmh, mph]
Config.HudSettingsCommand = 'hud' -- Command for open hud settings
Config.DisplayMapOnWalk = true -- true - Show map when walking | false - Hide map when walking
Config.DisplayRealTime = true -- if you set this to true will show the real time according to player local time | if false it will show the game time
Config.EnableSpamNotification = true -- Spam preventation for seatbelt, cruise etc.
Config.EnableDateDisplay = true -- Determines if display date or nor
Config.DefaultSpeedometerSize = 1.2 -- 0.5 - 1.3
Config.DefaultHudSize = 1.0 -- 0.5 - 1.0
Config.EnableAmmoHud = true -- Determines if display ammo hud or nor
Config.RefreshRates = {
    ["armor"] = 1750,
    ["health"] = 1750,
    ["ammo"] = 2000,
}

Config.EnableHudSettings = {
    --SHOOOOOOOOOOW image link
    -- https://cdn.discordapp.com/attachments/983471660684423240/1019920558604951592/unknown.png
    ['alltextmenu'] = true,

    -- VENİCE HUD  SETTİNGS
    ["venicehudhealt"] = true,
    ["venicehudarmour"] = true,
    ["venicehudthirst"] = true,
    ["venicehudhunger"] = true,
    ["venicehudstamina"] = true,
    ["venicehudstress"] = true,
    ["venicehudoxy"] = true,


    -- MALİBUHUD SETTINGS
    ["malibuhudhealt"] = true,
    ["malibuhudarmour"] = true,
    ["malibuhudthirst"] = true,
    ["malibuhudhunger"] = true,
    ["malibuhudstamina"] = true,
    ["malibuhudstress"] = true,
    ["malibuhudoxy"] = true,

      -- Belair SETTINGS
    ["belairhudhealt"] = true,
    ["belairhudarmour"] = true,
    ["belairhudthirst"] = true,
    ["belairhudhunger"] = true,
    ["belairhudstamina"] = true,
    ["belairhudstress"] = true,
    ["belairhudoxy"] = true,

    --CAR HUD

    ["vertexhud"] = true,
    ["mayhemhud"] = true,
    ["perspecthud"] = true,

}


Config.CarnameandStreetname = true --- true === disabled  --  false === enabled

Config.DefaultHudColors = {
    ["venicehud"] = {
        ["health"] = "#FF4848ac",
        ["armor"] = "#FFFFFFac",
        ["hunger"] = "#FFA048ac",
        ["thirst"] = "#4886FFac",
        ["stress"] = "#48A7FFac",
        ["stamina"] = "#C4FF48ac",
        ["oxy"] = "#48A7FFac",
        ["parachute"] = "#48FFBDac",
        ["nitro"] = "#AFFF48ac",
        ["altitude"] = "#00FFF0ac",
    },
    ["malibuhud"] = {
        ["health"] = "#FF4848",
        ["armor"] = "#FFFFFF",
        ["hunger"] = "#FFA048",
        ["thirst"] = "#4886FF",
        ["stress"] = "#48A7FF",
        ["stamina"] = "#C4FF48",
        ["parachute"] = "#48FFBD",
        ["oxy"] = "#48A7FF",
        ["nitro"] = "#AFFF48",
        ["altitude"] = "#00FFF0",
    },
    ["belairhud"] = {
        ["health"] = "#FF8A00",
        ["armor"] = "#2E3893",
        ["hunger"] = "#FF8A00",
        ["thirst"] = "#00C6BA",
        ["stress"] = "#CD007B",
        ["oxy"] = "#48A7FFac",
        ["stamina"] = "#c4ff48",
        ["parachute"] = "#48ffde",
        ["nitro"] = "#8eff48",
        ["altitude"] = "#48deff",
    },
}
Config.DefaultCarHudColors = {
    ["mayhemhud"] = {
        ["circle"] = "#FF4848",
        ["shift"] = "#FF4848",
        ["needle"] = "#FF4848",
        ["speed"] = "#FF4848",
        ["s0"] = "#00ffff84",
        ["s20"] = "#00ffff",
        ["s40"] = "#00ffff84",
        ["s60"] = "#00ffff",
        ["s80"] = "#00ffff84",
        ["s100"] = "#00ffff",
        ["s120"] = "#00ffff84",
        ["s140"] = "#00ffff",
        ["s160"] = "#00ffff84",
        ["s180"] = "#00ffff",
        ["s200"] = "#00ffff84",
        ["s220"] = "#00ffff",
        ["s240"] = "#00ffff84",
        ["s260"] = "#00ffff",
        ["gas"] = "#00ffff",
        ["health"] = "#FF4848",
        ["nitro"] = "#00ffff",
        ["wind"] = "#FF4848",
        ["altitude"] = "#00ffff",

    },
    ["vertexhud"] = {
        ["health"] = "#00FFF0",
        ["speed"] = "#00FFF0",
        ["gas"] = "#00FFF0"
    },
    ["perspecthud"] = {
        ["wind"] = "#00FFF0",
        ["nitro"] = "#00FFF0",
        ["shift"] = "#00FFF0" ,
        ["health"] = "#00FFF0" ,
        ["gas"] = "#00FFF0" ,
        ["speed"] = "#00FFF0" ,
        ["altitude"] = "#00FFF0" ,
        ["roads"] = "#00FFF0" ,
    },
}


-------------------------------------------- Locale --------------------------------------------
Config.Locale = {
["STATUS"] = 'Status',
["SPEEDOMETER"] = 'Tachometer',
["SHOW_HUD"] = 'HUD anzeigen',
["HIDE_HUD"] = 'HUD ausblenden',
["CINEMATIC_MODE"] = 'Kino-Modus',
["RESET_HUD"] = 'HUD zurücksetzen',
["SELECT"] = 'Auswählen',
["EDIT"] = 'Bearbeiten',
["ID"] = 'ID',
["ONLINE"] = 'Online',
["CHANGE_ALL_COLORS"] = 'Alle Farben ändern',
["DRAG_DROP"] = 'Ziehen & Ablegen',
["DEFAULT"] = 'Standard',
["CIRCLE"] = 'Kreis',
["SHIFT"] = 'Schalten',
["NEEDLE"] = 'Nadel',
["SPEED"] = 'Geschwindigkeit',
["GAS"] = 'Benzin',
["HEALTH"] = 'Gesundheit',
["NITRO"] = 'Nitro',
["WIND"] = 'Wind',
["ROADS"] = 'Straßen',
["ALTITUDE"] = 'Höhe',
["ARMOUR"] = 'Rüstung',
["THIRST"] = 'Durst',
["HUNGER"] = 'Hunger',
["STRESS"] = 'Stress',
["LUNGS"] = 'Lungen',
["STAMINA"] = 'Ausdauer',
["AT"] = 'bei',
["RESET"] = 'Zurücksetzen',
["HIDE_ID"] = 'ID ausblenden',
["SHOW_ID"] = 'ID anzeigen',
["HIDE_ONLINE"] = 'Online ausblenden',
["SHOW_ONLINE"] = 'Online anzeigen',
["HIDE_MONEY"] = 'Geld ausblenden',
["SHOW_MONEY"] = 'Geld anzeigen',
["HIDE_JOB"] = 'Job ausblenden',
["SHOW_JOB"] = 'Job anzeigen',
["HIDE_AMMO"] = 'Munition ausblenden',
["SHOW_AMMO"] = 'Munition anzeigen',
["SHOW_PHONE_KEY"] = 'Telefon-Taste anzeigen',
["HIDE_PHONE_KEY"] = 'Telefon-Taste ausblenden',
["HIDE_INVENTORY_KEY"] = 'Inventar-Taste ausblenden',
["SHOW_INVENTORY_KEY"] = 'Inventar-Taste anzeigen',
["HIDE_MENU_KEY"] = 'Menü-Taste ausblenden',
["SHOW_MENU_KEY"] = 'Menü-Taste anzeigen',
["HIDE_MIC_KEY"] = 'Mikrofon-Taste ausblenden',
["SHOW_MIC_KEY"] = 'Mikrofon-Taste anzeigen',
["SHOW_LOGO"] = 'Logo anzeigen',
["HIDE_LOGO"] = 'Logo ausblenden',
["EDIT_PAGE"] = 'Seite bearbeiten',
["HUD"] = 'HUD',
["STYLE_SELECTOR"] = 'Stilauswahl',
["DISABLED"] = 'Nicht aktiv',


}


-------------------------------------------- Settings hud --------------------------------------------
Config.HelperTextEnable = true  --- true enable --- false disable
Config.HelperText = {
    ['phone'] = 'Phone',['phonepress'] = 'F1',
    ['inventory'] = 'Inventar', ['inventorypress'] = 'TAB',
    ['menu'] = 'Menu',['menupress'] = 'F3',
    ['mic'] = 'Mic',['micpress'] = 'N',
}
-------------------------------------------- general text hud --------------------------------------------

Config.ShowMenu = {
    ['showid'] = true,
    ['showonline'] = true,
    ['showmoney'] = true,
    ['showjob'] = true,
    ['showammo'] = true,
    ['showphonekey'] = true,
    ['showinventorykey'] = true,
    ['showmenukey'] = true,
    ['showmickey'] = true,
    ['showlogo'] = true,
}



-------------------------------------------- Watermark hud --------------------------------------------
Config.DisableWaterMarkTextAndLogo = true -- true - Disable watermark text and logo
Config.UseWaterMarkText = true -- if true text will be shown | if  false logo will be shown
Config.WaterMarkText1 = "CODE 3" -- Top right server text
Config.WaterMarkText2 = "Roleplay"  -- Top right server text
Config.WaterMarkLogo = "https://cdn.discordapp.com/attachments/862018783391252500/967359920703942686/Frame_303.png" -- Logo url
Config.LogoWidth = "11.875rem"
Config.LogoHeight = "3.313rem"
Config.OnlinePlayers = true --Determines if display online players or nor
Config.EnableId = true -- Determines if display server id or nor
Config.EnableBankandCashBorder = true --Determines if display cash or nor
Config.EnableWatermarkCash = true -- Determines if display cash or nor
Config.EnableWatermarkBankMoney = true -- Determines if display bank money or nor
Config.EnableWatermarkJob = true -- Determines if display job or nor
Config.EnableWaterMarkHud = true -- Determines if right-top hud is enabled or not

Config.Text1Style = {
    ["color"] = '#2929c2',
    ["text-shadow"] = "0px 0.38rem 2.566rem rgba(116, 5, 147, 0.55)",
}

Config.Text2Style = {
    ["color"] = "#ffffff",
}

-------------------------------------------- Map Clock streetname compass --------------------------------------------
Config.CompassStreetnameClock = true -- true  show -- false hide

-------------------------------------------- Keys --------------------------------------------
Config.DefaultCruiseControlKey = "b" -- Default control key for cruise. Players can change the key according to their desire
Config.DefaultSeatbeltControlKey = "k" -- Default control key for seatbelt. Players can change the key according to their desire
Config.VehicleEngineToggleKey = "y" -- Default control key for toggle engine. Players can change the key according to their desire
Config.NitroKey = "X" -- Default control key for use nitro. Players can change the key according to their desire

-------------------------------------------- Nitro --------------------------------------------
Config.Nitro = false --- just html icon
Config.RemoveNitroOnpress = 2 -- Determines of how much you want to remove nitro when player press nitro key
Config.NitroItem = "nitro" -- item to install nitro to a vehicle
Config.EnableNitro = true -- Determines if nitro system is enabled or not
Config.NitroForce = 40.0 -- Nitro force when player using nitro

-------------------------------------------- Money commands --------------------------------------------

Config.EnableCashAndBankCommands = true -- true  enabled -- false  -- disabled

Config.CashCommand= 'cash'
Config.BankCommand= 'bank'

-------------------------------------------- Engine Toggle --------------------------------------------
Config.EnableEngineToggle = true -- Determines if engine toggle is enabled or not

-------------------------------------------- Vehicle Functionality --------------------------------------------
Config.EnableCruise = true -- Determines if cruise mode is active
Config.EnableSeatbelt = true -- Determines if seatbelt is active

-------------------------------------------- Settings text --------------------------------------------
Config.SettingsLocale = { -- Settings texts
["text_hud_1"] = "Text",
["text_hud_2"] = "HUD",
["classic_hud_1"] = "Klassisch",
["classic_hud_2"] = "HUD",
["radial_hud_1"] = "Radial",
["radial_hud_2"] = "HUD",
["hide_hud"] = "HUD ausblenden",
["health"] = "Gesundheit",
["armor"] = "Rüstung",
["thirst"] = "Durst",
["stress"] = "Stress",
["oxy"] = "Sauerstoff",
["hunger"] = "Hunger",
["show_hud"] = "HUD anzeigen",
["stamina"] = "Ausdauer",
["nitro"] = "Nitro",
["Altitude"] = "Höhe",
["Parachute"] = "Fallschirm",
["enable_cinematicmode"] = "Kino-Modus aktivieren",
["disable_cinematicmode"] = "Kino-Modus deaktivieren",
["exit_settings_1"] = "VERLASSEN",
["exit_settings_2"] = "EINSTELLUNGEN",
["speedometer"] = "TACHOMETER",
["map"] = "KARTE",
["show_compass"] = "Kompass anzeigen",
["hide_compass"] = "Kompass ausblenden",
["rectangle"] = "Rechteck",
["radial"] = "Radial",
["dynamic"] = "DYNAMISCH",
["status"] = "STATUS",
["enable"] = "Aktivieren",
["hud_size"] = "Statusgröße",
["disable"] = "Deaktivieren",
["hide_at"] = "Ausblenden bei",
["and_above"] = "und höher",
["and_below"] = "und niedriger",
["enable_edit_mode"] = "HUD ziehen (einzeln)",
["enable_edit_mode_2"] = "HUD ziehen (alle)",
["change_status_size"] = "Statusgröße ändern",
["change_color"] = "Farbe des ausgewählten HUD ändern",
["disable_edit_mode"] = "Bearbeitungsmodus deaktivieren",
["reset_hud_positions"] = "HUD-Positionen zurücksetzen",
["info_text"] = "Achtung: Höhere Aktualisierungsrate kann die Spielleistung verringern!",
["speedometer_size"] = "Tachometergröße",
["refresh_rate"] = "Aktualisierungsrate",
["esc_to_exit"] = "ESC DRÜCKEN, UM DEN BEARBEITUNGSMODUS ZU VERLASSEN",
["toggle_minimap"] = "Minikarte umschalten",

}

-------------------------------------------- Fuel --------------------------------------------
Config.EnableFuel = true -- Do NOT Touch if you have any fuel system
Config.FuelSystem = 'LegacyFuel' -- LegacyFuel / ox-fuel / nd-fuel / frfuel / cdn-fuel

Config.GetVehicleFuel = function(vehicle) -- you can change LegacyFuel export if you use another fuel system
    if Config.EnableFuel then
        if DoesEntityExist(vehicle) then
            if Config.FuelSystem == 'LegacyFuel' then
                return exports["LegacyFuel"]:GetFuel(vehicle)
            elseif Config.FuelSystem == 'ox-fuel' then
                return GetVehicleFuelLevel(vehicle)
            elseif Config.FuelSystem == 'nd-fuel' then
                return exports["nd-fuel"]:GetFuel(vehicle)
            elseif Config.FuelSystem == 'frfuel' then
                return exports.frfuel:getCurrentFuelLevel(vehicle)
            elseif Config.FuelSystem == 'cdn-fuel' then
                return exports['cdn-fuel']:GetFuel(vehicle)
            else
                -- You can added export if you want it
            end
        end
    else
        return GetVehicleFuelLevel(vehicle)
    end
end

-------------------------------------------- Stress --------------------------------------------

Config.UseStress = true -- if you set this to false the stress hud will be removed
Config.StressWhitelistJobs = { -- Add here jobs you want to disable stress
    'police', 'ambulance'
}

Config.WhitelistedWeaponStress = {
    `weapon_petrolcan`,
    `weapon_hazardcan`,
    `weapon_fireextinguisher`
}

Config.AddStress = {
    ["on_shoot"] = {
        min = 1,
        max = 3,
        enable = true,
    },
    ["on_fastdrive"] = {
        min = 1,
        max = 3,
        enable = true,
    },
}

Config.RemoveStress = { -- You can set here amounts by your desire
    ["on_eat"] = {
        min = 5,
        max = 10,
        enable = true,

    },
    ["on_drink"] = {
        min = 5,
        max = 10,
        enable = true,

    },
    ["on_swimming"] = {
        min = 5,
        max = 10,
        enable = true,

    },
    ["on_running"] = {
        min = 5,
        max = 10,
        enable = true,
    },

}



-------------------------------------------- Notifications --------------------------------------------

Config.Notifications = { -- Notifications
     ["stress_gained"] = {
        message = 'Du wirst gestresst',
        type = "error",
    },
    ["stress_relive"] = {
        message = 'Du entspannst dich',
        type = "success",
    },
    ["took_off_seatbelt"] = {
        type = "error",
        message = "Du hast den Sicherheitsgurt abgenommen.",
    },
    ["took_seatbelt"] = {
        type = "success",
        message = "Du hast den Sicherheitsgurt angelegt.",
    },
    ["cruise_actived"] = {
        type = "success",
        message = "Tempomat aktiviert.",
    },
    ["cruise_disabled"] = {
        type = "error",
        message = "Tempomat deaktiviert.",
    },
    ["spam"] = {
        type = "error",
        message = "Bitte warte ein paar Sekunden.",
    },
    ["engine_on"] = {
        type = "success",
        message = "Motor ist eingeschaltet.",
    },
    ["engine_off"] = {
        type = "success",
        message = "Motor ist ausgeschaltet.",
    },
    ["cant_install_nitro"] = {
        type = "error",
        message = "Du kannst Nitro nicht im Fahrzeug installieren.",
    },
    ["no_veh_nearby"] = {
        type = "error",
        message = "Kein Fahrzeug in der Nähe.",
    },
    ["cash_display"] = {
        type = "success",
        message = "Du hast $%s in der Tasche.",
    },
    ["bank_display"] = {
        type = "success",
        message = "Du hast $%s auf der Bank.",
    },
}

Config.Notification = function(message, type, isServer, src) -- You can change here events for notifications
    if isServer then
        if Config.Framework == "esx" then
            TriggerClientEvent("esx:showNotification", src, message)
        else
            TriggerClientEvent('QBCore:Notify', src, message, type, 1500)
        end
    else
        if Config.Framework == "esx" then
            TriggerEvent("esx:showNotification", message)
        else
            TriggerEvent('QBCore:Notify', message, type, 1500)
        end
    end
end




Citizen.CreateThread(function()
    frameworkObject = GetFrameworkObject()
    Config.GetStatus = function()
        Citizen.Wait(100)
        while true do
                if Config.Framework == "newqb" or Config.Framework == "oldqb"  then

                    WaitPlayer()
                    local myhunger = frameworkObject.Functions.GetPlayerData().metadata["hunger"]
                    local mythirst = frameworkObject.Functions.GetPlayerData().metadata["thirst"]


                    SendNUIMessage({
                        type = "set_status",
                        statustype = "hunger",
                        value =  myhunger,
                    })
                    SendNUIMessage({
                        type = "set_status",
                        statustype = "thirst",
                        value =  mythirst,
                    })
                end
                if Config.Framework == "esx" then
                    TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
                        TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
                            local myhunger = hunger.getPercent()
                            local mythirst = thirst.getPercent()
                            SendNUIMessage({
                                type = "set_status",
                                statustype = "hunger",
                                value =  myhunger,
                            })
                            SendNUIMessage({
                                type = "set_status",
                                statustype = "thirst",
                                value =  mythirst,
                            })
                        end)
                    end)
                end

            Citizen.Wait(7000)
        end
    end

end)

