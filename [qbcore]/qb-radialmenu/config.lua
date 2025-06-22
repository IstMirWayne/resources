Config = {}
Config.Keybind = 'F1'           -- FiveM Keyboard, this is registered keymapping, so needs changed in keybindings if player already has this mapped.
Config.Toggle = false           -- use toggle mode. False requires hold of key
Config.UseWhilstWalking = false -- use whilst walking
Config.EnableExtraMenu = true
Config.Fliptime = 15000

Config.MenuItems = {
    {
        id = 'citizen',
        title = 'Bürger',
        icon = 'user',
        items = {
           {
    id = 'givenum',
    title = 'Kontaktdaten geben',
    icon = 'address-book',
    type = 'client',
    event = 'qb-phone:client:GiveContactDetails',
    shouldClose = true
}, {
    id = 'getintrunk',
    title = 'In den Kofferraum steigen',
    icon = 'car',
    type = 'client',
    event = 'qb-trunk:client:GetIn',
    shouldClose = true
}, {
    id = 'cornerselling',
    title = 'Straßenverkauf',
    icon = 'cannabis',
    type = 'client',
    event = 'qb-drugs:client:cornerselling',
    shouldClose = true
}, {
    id = 'togglehotdogsell',
    title = 'Hotdogs verkaufen',
    icon = 'hotdog',
    type = 'client',
    event = 'qb-hotdogjob:client:ToggleSell',
    shouldClose = true
}, {
    id = 'interactions',
    title = 'Interaktionen',
    icon = 'triangle-exclamation',
    items = {
        {
            id = 'handcuff',
            title = 'Fesseln',
            icon = 'user-lock',
            type = 'client',
            event = 'police:client:CuffPlayerSoft',
            shouldClose = true
        }, {
            id = 'playerinvehicle',
            title = 'In Fahrzeug setzen',
            icon = 'car-side',
            type = 'client',
            event = 'police:client:PutPlayerInVehicle',
            shouldClose = true
        }, {
            id = 'playeroutvehicle',
            title = 'Aus Fahrzeug holen',
            icon = 'car-side',
            type = 'client',
            event = 'police:client:SetPlayerOutVehicle',
            shouldClose = true
        }, {
            id = 'stealplayer',
            title = 'Ausrauben',
            icon = 'mask',
            type = 'client',
            event = 'police:client:RobPlayer',
            shouldClose = true
        }, {
            id = 'escort',
            title = 'Entführen',
            icon = 'user-group',
            type = 'client',
            event = 'police:client:KidnapPlayer',
            shouldClose = true
        }, {
            id = 'escort2',
            title = 'Begleiten',
            icon = 'user-group',
            type = 'client',
            event = 'police:client:EscortPlayer',
            shouldClose = true
        }, {
            id = 'escort554',
            title = 'Geisel nehmen',
            icon = 'child',
            type = 'client',
            event = 'A5:Client:TakeHostage',
            shouldClose = true
        }
        }
        }
        }
    },
 {
    id = 'general',
    title = 'Allgemein',
    icon = 'rectangle-list',
    items = {
        {
            id = 'house',
            title = 'Haus-Interaktion',
            icon = 'house',
            items = {
                {
                    id = 'givehousekey',
                    title = 'Hausschlüssel geben',
                    icon = 'key',
                    type = 'client',
                    event = 'qb-houses:client:giveHouseKey',
                    shouldClose = true
                }, {
                    id = 'removehousekey',
                    title = 'Hausschlüssel entfernen',
                    icon = 'key',
                    type = 'client',
                    event = 'qb-houses:client:removeHouseKey',
                    shouldClose = true
                }, {
                    id = 'togglelock',
                    title = 'Türschloss umschalten',
                    icon = 'door-closed',
                    type = 'client',
                    event = 'qb-houses:client:toggleDoorlock',
                    shouldClose = true
                }, {
                    id = 'decoratehouse',
                    title = 'Haus dekorieren',
                    icon = 'box',
                    type = 'client',
                    event = 'qb-houses:client:decorate',
                    shouldClose = true
                }, {
                    id = 'houseLocations',
                    title = 'Interaktionsorte',
                    icon = 'house',
                    items = {
                        {
                            id = 'setstash',
                            title = 'Stash setzen',
                            icon = 'box-open',
                            type = 'client',
                            event = 'qb-houses:client:setLocation',
                            shouldClose = true
                        }, {
                            id = 'setoutift',
                            title = 'Kleiderschrank setzen',
                            icon = 'shirt',
                            type = 'client',
                            event = 'qb-houses:client:setLocation',
                            shouldClose = true
                        }, {
                            id = 'setlogout',
                            title = 'Logout setzen',
                            icon = 'door-open',
                            type = 'client',
                            event = 'qb-houses:client:setLocation',
                            shouldClose = true
                        }
                    }
                }
            }
        }, {
            id = 'clothesmenu',
            title = 'Kleidung',
            icon = 'shirt',
            items = {
                {
                    id = 'Hair',
                    title = 'Haare',
                    icon = 'user',
                    type = 'client',
                    event = 'qb-radialmenu:ToggleClothing',
                    shouldClose = true
                }, {
                    id = 'Ear',
                    title = 'Ohrstück',
                    icon = 'ear-deaf',
                    type = 'client',
                    event = 'qb-radialmenu:ToggleProps',
                    shouldClose = true
                }, {
                    id = 'Neck',
                    title = 'Hals',
                    icon = 'user-tie',
                    type = 'client',
                    event = 'qb-radialmenu:ToggleClothing',
                    shouldClose = true
                }, {
                    id = 'Top',
                    title = 'Oberteil',
                    icon = 'shirt',
                    type = 'client',
                    event = 'qb-radialmenu:ToggleClothing',
                    shouldClose = true
                }, {
                    id = 'Shirt',
                    title = 'Hemd',
                    icon = 'shirt',
                    type = 'client',
                    event = 'qb-radialmenu:ToggleClothing',
                    shouldClose = true
                }, {
                    id = 'Pants',
                    title = 'Hose',
                    icon = 'user',
                    type = 'client',
                    event = 'qb-radialmenu:ToggleClothing',
                    shouldClose = true
                }, {
                    id = 'Shoes',
                    title = 'Schuhe',
                    icon = 'shoe-prints',
                    type = 'client',
                    event = 'qb-radialmenu:ToggleClothing',
                    shouldClose = true
                }, {
                    id = 'meer',
                    title = 'Extras',
                    icon = 'plus',
                    items = {
                        {
                            id = 'Hat',
                            title = 'Hut',
                            icon = 'hat-cowboy-side',
                            type = 'client',
                            event = 'qb-radialmenu:ToggleProps',
                            shouldClose = true
                        }, {
                            id = 'Glasses',
                            title = 'Brille',
                            icon = 'glasses',
                            type = 'client',
                            event = 'qb-radialmenu:ToggleProps',
                            shouldClose = true
                        }, {
                            id = 'Visor',
                            title = 'Visier',
                            icon = 'hat-cowboy-side',
                            type = 'client',
                            event = 'qb-radialmenu:ToggleProps',
                            shouldClose = true
                        }, {
                            id = 'Mask',
                            title = 'Maske',
                            icon = 'masks-theater',
                            type = 'client',
                            event = 'qb-radialmenu:ToggleClothing',
                            shouldClose = true
                        }, {
                            id = 'Vest',
                            title = 'Weste',
                            icon = 'vest',
                            type = 'client',
                            event = 'qb-radialmenu:ToggleClothing',
                            shouldClose = true
                        }, {
                            id = 'Bag',
                            title = 'Tasche',
                            icon = 'bag-shopping',
                            type = 'client',
                            event = 'qb-radialmenu:ToggleClothing',
                            shouldClose = true
                        }, {
                            id = 'Bracelet',
                            title = 'Armband',
                            icon = 'user',
                            type = 'client',
                            event = 'qb-radialmenu:ToggleProps',
                            shouldClose = true
                        }, {
                            id = 'Watch',
                            title = 'Uhr',
                            icon = 'stopwatch',
                            type = 'client',
                            event = 'qb-radialmenu:ToggleProps',
                            shouldClose = true
                        }, {
                            id = 'Gloves',
                            title = 'Handschuhe',
                            icon = 'mitten',
                            type = 'client',
                            event = 'qb-radialmenu:ToggleClothing',
                            shouldClose = true
                        }
                }
            }
            }
        }
        }
    },
}

Config.VehicleDoors = {
    id = 'vehicledoors',
    title = 'Fahrzeugtüren',
    icon = 'car-side',
    items = {
        {
            id = 'door0',
            title = 'Fahrertür',
            icon = 'car-side',
            type = 'client',
            event = 'qb-radialmenu:client:openDoor',
            shouldClose = false
        }, {
            id = 'door4',
            title = 'Motorhaube',
            icon = 'car',
            type = 'client',
            event = 'qb-radialmenu:client:openDoor',
            shouldClose = false
        }, {
            id = 'door1',
            title = 'Beifahrertür',
            icon = 'car-side',
            type = 'client',
            event = 'qb-radialmenu:client:openDoor',
            shouldClose = false
        }, {
            id = 'door3',
            title = 'Rechts hinten',
            icon = 'car-side',
            type = 'client',
            event = 'qb-radialmenu:client:openDoor',
            shouldClose = false
        }, {
            id = 'door5',
            title = 'Kofferraum',
            icon = 'car',
            type = 'client',
            event = 'qb-radialmenu:client:openDoor',
            shouldClose = false
        }, {
            id = 'door2',
            title = 'Links hinten',
            icon = 'car-side',
            type = 'client',
            event = 'qb-radialmenu:client:openDoor',
            shouldClose = false
        }
    }
}

Config.VehicleExtras = {
    id = 'vehicleextras',
    title = 'Fahrzeug Extras',
    icon = 'plus',
    items = {
        {
            id = 'extra1',
            title = 'Extra 1',
            icon = 'box-open',
            type = 'client',
            event = 'qb-radialmenu:client:setExtra',
            shouldClose = false
        }, {
        id = 'extra2',
        title = 'Extra 2',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
        }, {
        id = 'extra3',
        title = 'Extra 3',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
        }, {
        id = 'extra4',
        title = 'Extra 4',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
        }, {
        id = 'extra5',
        title = 'Extra 5',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
        }, {
        id = 'extra6',
        title = 'Extra 6',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
        }, {
        id = 'extra7',
        title = 'Extra 7',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
        }, {
        id = 'extra8',
        title = 'Extra 8',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
        }, {
        id = 'extra9',
        title = 'Extra 9',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
        }, {
        id = 'extra10',
        title = 'Extra 10',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
        }, {
        id = 'extra11',
        title = 'Extra 11',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
        }, {
        id = 'extra12',
        title = 'Extra 12',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
        }, {
        id = 'extra13',
        title = 'Extra 13',
        icon = 'box-open',
        type = 'client',
        event = 'qb-radialmenu:client:setExtra',
        shouldClose = false
        }
    }
}

Config.VehicleSeats = {
    id = 'vehicleseats',
    title = 'Fahrzeugsitze',
    icon = 'chair',
    items = {}
}


Config.JobInteractions = {
    ['ambulance'] = {
        {
            id = 'statuscheck',
            title = 'Gesundheitsstatus prüfen',
            icon = 'heart-pulse',
            type = 'client',
            event = 'hospital:client:CheckStatus',
            shouldClose = true
        }, {
            id = 'revivep',
            title = 'Wiederbeleben',
            icon = 'user-doctor',
            type = 'client',
            event = 'hospital:client:RevivePlayer',
            shouldClose = true
        }, {
            id = 'treatwounds',
            title = 'Wunden heilen',
            icon = 'bandage',
            type = 'client',
            event = 'hospital:client:TreatWounds',
            shouldClose = true
        }, {
            id = 'emergencybutton2',
            title = 'Notfallknopf',
            icon = 'bell',
            type = 'client',
            event = 'police:client:SendPoliceEmergencyAlert',
            shouldClose = true
        }, {
            id = 'escort',
            title = 'Begleiten',
            icon = 'user-group',
            type = 'client',
            event = 'police:client:EscortPlayer',
            shouldClose = true
        }, {
            id = 'stretcheroptions',
            title = 'Trage',
            icon = 'bed-pulse',
            items = {
                {
                    id = 'spawnstretcher',
                    title = 'Trage spawnen',
                    icon = 'plus',
                    type = 'client',
                    event = 'qb-radialmenu:client:TakeStretcher',
                    shouldClose = false
                }, {
                    id = 'despawnstretcher',
                    title = 'Trage entfernen',
                    icon = 'minus',
                    type = 'client',
                    event = 'qb-radialmenu:client:RemoveStretcher',
                    shouldClose = false
                }
            }
        }
    },
    ['taxi'] = {
        {
            id = 'togglemeter',
            title = 'Anzeige ein-/ausblenden',
            icon = 'eye-slash',
            type = 'client',
            event = 'qb-taxi:client:toggleMeter',
            shouldClose = false
        }, {
            id = 'togglemouse',
            title = 'Anzeige starten/stoppen',
            icon = 'hourglass-start',
            type = 'client',
            event = 'qb-taxi:client:enableMeter',
            shouldClose = true
        }, {
            id = 'npc_mission',
            title = 'NPC-Mission',
            icon = 'taxi',
            type = 'client',
            event = 'qb-taxi:client:DoTaxiNpc',
            shouldClose = true
        }
    },
    ['tow'] = {
        {
            id = 'togglenpc',
            title = 'NPC umschalten',
            icon = 'toggle-on',
            type = 'client',
            event = 'jobs:client:ToggleNpc',
            shouldClose = true
        }, {
            id = 'towvehicle',
            title = 'Fahrzeug abschleppen',
            icon = 'truck-pickup',
            type = 'client',
            event = 'qb-tow:client:TowVehicle',
            shouldClose = true
        }
    },
    ['mechanic'] = {
        {
            id = 'towvehicle',
            title = 'Fahrzeug abschleppen',
            icon = 'truck-pickup',
            type = 'client',
            event = 'qb-tow:client:TowVehicle',
            shouldClose = true
        }
    },
    ['police'] = {
        {
            id = 'emergencybutton',
            title = 'Notfallknopf',
            icon = 'bell',
            type = 'client',
            event = 'police:client:SendPoliceEmergencyAlert',
            shouldClose = true
        }, {
            id = 'checkvehstatus',
            title = 'Tuning-Status prüfen',
            icon = 'circle-info',
            type = 'client',
            event = 'qb-tunerchip:client:TuneStatus',
            shouldClose = true
        }, {
            id = 'resethouse',
            title = 'Hausschloss zurücksetzen',
            icon = 'key',
            type = 'client',
            event = 'qb-houses:client:ResetHouse',
            shouldClose = true
        }, {
            id = 'takedriverlicense',
            title = 'Führerschein entziehen',
            icon = 'id-card',
            type = 'client',
            event = 'police:client:SeizeDriverLicense',
            shouldClose = true
        }, {
            id = 'policeinteraction',
            title = 'Polizeiaktionen',
            icon = 'list-check',
            items = {
                {
                    id = 'statuscheck',
                    title = 'Gesundheitsstatus prüfen',
                    icon = 'heart-pulse',
                    type = 'client',
                    event = 'hospital:client:CheckStatus',
                    shouldClose = true
                }, {
                    id = 'checkstatus',
                    title = 'Status prüfen',
                    icon = 'question',
                    type = 'client',
                    event = 'police:client:CheckStatus',
                    shouldClose = true
                }, {
                    id = 'escort',
                    title = 'Begleiten',
                    icon = 'user-group',
                    type = 'client',
                    event = 'police:client:EscortPlayer',
                    shouldClose = true
                }, {
                    id = 'searchplayer',
                    title = 'Durchsuchen',
                    icon = 'magnifying-glass',
                    type = 'server',
                    event = 'police:server:SearchPlayer',
                    shouldClose = true
                }, {
                    id = 'jailplayer',
                    title = 'Inhaftieren',
                    icon = 'user-lock',
                    type = 'client',
                    event = 'police:client:JailPlayer',
                    shouldClose = true
                }
            }
        }, {
            id = 'policeobjects',
            title = 'Objekte',
            icon = 'road',
            items = {
                {
                    id = 'spawnpion',
                    title = 'Kegel',
                    icon = 'triangle-exclamation',
                    type = 'client',
                    event = 'police:client:spawnCone',
                    shouldClose = false
                }, {
                    id = 'spawnhek',
                    title = 'Sperre',
                    icon = 'torii-gate',
                    type = 'client',
                    event = 'police:client:spawnBarrier',
                    shouldClose = false
                }, {
                    id = 'spawnschotten',
                    title = 'Tempolimit-Schild',
                    icon = 'sign-hanging',
                    type = 'client',
                    event = 'police:client:spawnRoadSign',
                    shouldClose = false
                }, {
                    id = 'spawntent',
                    title = 'Zelt',
                    icon = 'campground',
                    type = 'client',
                    event = 'police:client:spawnTent',
                    shouldClose = false
                }, {
                    id = 'spawnverlichting',
                    title = 'Beleuchtung',
                    icon = 'lightbulb',
                    type = 'client',
                    event = 'police:client:spawnLight',
                    shouldClose = false
                }, {
                    id = 'spikestrip',
                    title = 'Nagelband',
                    icon = 'caret-up',
                    type = 'client',
                    event = 'police:client:SpawnSpikeStrip',
                    shouldClose = false
                }, {
                    id = 'deleteobject',
                    title = 'Objekt entfernen',
                    icon = 'trash',
                    type = 'client',
                    event = 'police:client:deleteObject',
                    shouldClose = false
                }
            }
        }
    },
    ['hotdog'] = {
        {
            id = 'togglesell',
            title = 'Verkauf umschalten',
            icon = 'hotdog',
            type = 'client',
            event = 'qb-hotdogjob:client:ToggleSell',
            shouldClose = true
        }
    }
}

Config.TrunkClasses = {
    [0] = { allowed = true, x = 0.0, y = -1.5, z = 0.0 },   -- Coupes
    [1] = { allowed = true, x = 0.0, y = -2.0, z = 0.0 },   -- Sedans
    [2] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 },  -- SUVs
    [3] = { allowed = true, x = 0.0, y = -1.5, z = 0.0 },   -- Coupes
    [4] = { allowed = true, x = 0.0, y = -2.0, z = 0.0 },   -- Muscle
    [5] = { allowed = true, x = 0.0, y = -2.0, z = 0.0 },   -- Sports Classics
    [6] = { allowed = true, x = 0.0, y = -2.0, z = 0.0 },   -- Sports
    [7] = { allowed = true, x = 0.0, y = -2.0, z = 0.0 },   -- Super
    [8] = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, -- Motorcycles
    [9] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 },  -- Off-road
    [10] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Industrial
    [11] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Utility
    [12] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Vans
    [13] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Cycles
    [14] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Boats
    [15] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Helicopters
    [16] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Planes
    [17] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Service
    [18] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Emergency
    [19] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Military
    [20] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, -- Commercial
    [21] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }  -- Trains
}

Config.ExtrasEnabled = true

Config.Commands = {
    ['top'] = {
        Func = function() ToggleClothing('Top') end,
        Sprite = 'top',
        Desc = 'Ziehe dein Oberteil an/aus',
        Button = 1,
        Name = 'Oberteil'
    },
    ['gloves'] = {
        Func = function() ToggleClothing('gloves') end,
        Sprite = 'gloves',
        Desc = 'Ziehe deine Handschuhe an/aus',
        Button = 2,
        Name = 'Handschuhe'
    },
    ['visor'] = {
        Func = function() ToggleProps('visor') end,
        Sprite = 'visor',
        Desc = 'Hutvariation umschalten',
        Button = 3,
        Name = 'Visier'
    },
    ['bag'] = {
        Func = function() ToggleClothing('Bag') end,
        Sprite = 'bag',
        Desc = 'Öffne oder schließe deine Tasche',
        Button = 8,
        Name = 'Tasche'
    },
    ['shoes'] = {
        Func = function() ToggleClothing('Shoes') end,
        Sprite = 'shoes',
        Desc = 'Ziehe deine Schuhe an/aus',
        Button = 5,
        Name = 'Schuhe'
    },
    ['vest'] = {
        Func = function() ToggleClothing('Vest') end,
        Sprite = 'vest',
        Desc = 'Ziehe deine Weste an/aus',
        Button = 14,
        Name = 'Weste'
    },
    ['hair'] = {
        Func = function() ToggleClothing('hair') end,
        Sprite = 'hair',
        Desc = 'Frisur hoch/runter/zum Dutt oder Pferdeschwanz ändern.',
        Button = 7,
        Name = 'Haare'
    },
    ['hat'] = {
        Func = function() ToggleProps('Hat') end,
        Sprite = 'hat',
        Desc = 'Ziehe deinen Hut an/aus',
        Button = 4,
        Name = 'Hut'
    },
    ['glasses'] = {
        Func = function() ToggleProps('Glasses') end,
        Sprite = 'glasses',
        Desc = 'Ziehe deine Brille an/aus',
        Button = 9,
        Name = 'Brille'
    },
    ['ear'] = {
        Func = function() ToggleProps('Ear') end,
        Sprite = 'ear',
        Desc = 'Ziehe dein Ohren-Accessoire an/aus',
        Button = 10,
        Name = 'Ohren'
    },
    ['neck'] = {
        Func = function() ToggleClothing('Neck') end,
        Sprite = 'neck',
        Desc = 'Ziehe dein Hals-Accessoire an/aus',
        Button = 11,
        Name = 'Hals'
    },
    ['watch'] = {
        Func = function() ToggleProps('Watch') end,
        Sprite = 'watch',
        Desc = 'Ziehe deine Uhr an/aus',
        Button = 12,
        Name = 'Uhr',
        Rotation = 5.0
    },
    ['bracelet'] = {
        Func = function() ToggleProps('Bracelet') end,
        Sprite = 'bracelet',
        Desc = 'Ziehe dein Armband an/aus',
        Button = 13,
        Name = 'Armband'
    },
    ['mask'] = {
        Func = function() ToggleClothing('Mask') end,
        Sprite = 'mask',
        Desc = 'Ziehe deine Maske an/aus',
        Button = 6,
        Name = 'Maske'
    }
}

local bags = { [40] = true, [41] = true, [44] = true, [45] = true }

Config.ExtraCommands = {
    ['pants'] = {
        Func = function() ToggleClothing('Pants', true) end,
        Sprite = 'pants',
        Desc = 'Ziehe deine Hose an/aus',
        Name = 'Hose',
        OffsetX = -0.04,
        OffsetY = 0.0
    },
    ['shirt'] = {
        Func = function() ToggleClothing('Shirt', true) end,
        Sprite = 'shirt',
        Desc = 'Ziehe dein Hemd an/aus',
        Name = 'Hemd',
        OffsetX = 0.04,
        OffsetY = 0.0
    },
    ['reset'] = {
        Func = function()
            if not ResetClothing(true) then
                Notify('Nichts zum Zurücksetzen', 'error')
            end
        end,
        Sprite = 'reset',
        Desc = 'Setze alles auf den Normalzustand zurück',
        Name = 'Zurücksetzen',
        OffsetX = 0.12,
        OffsetY = 0.2,
        Rotate = true
    },
    ['bagoff'] = {
        Func = function() ToggleClothing('Bagoff', true) end,
        Sprite = 'bagoff',
        SpriteFunc = function()
            local Bag = GetPedDrawableVariation(PlayerPedId(), 5)
            local BagOff = LastEquipped['Bagoff']
            if LastEquipped['Bagoff'] then
                if bags[BagOff.Drawable] then
                    return 'bagoff'
                else
                    return 'paraoff'
                end
            end
            if Bag ~= 0 then
                if bags[Bag] then
                    return 'bagoff'
                else
                    return 'paraoff'
                end
            else
                return false
            end
        end,
        Desc = 'Ziehe deine Tasche an/aus',
        Name = 'Tasche ab',
        OffsetX = -0.12,
        OffsetY = 0.2
    }
}

