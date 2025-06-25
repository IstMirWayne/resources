-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

Config = {}

Config.BackgroundType =
'video'                      -- image, video or slideshow (for image, just add the background.jpg to the assets/images folder & for slideshow add multiple images to the assets/images folder like background1.jpg, background2.jpg, etc)

Config.UseLocalVideo = true -- If above you set video and you want to use a local video add it to the assets folder named 'background.webm', otherwise set the youtube URL below

Config.Platform = 'youtube'  -- youtube or streamable (only used if UseLocalVideo is set to false)

Config.VideoID = 'tJmkCz7UYm8' -- Only used if UseLocalVideo is set to false (if you are using a youtube video get the video code from the URL after the v= & if you are using streamable get the video code from the URL after the /)

Config.AddBlurToBackground = true               -- Add blur to the background image/video

Config.MainColor = 'FF1D26D9'                    -- Main color used for the whole UI

Config.DelayOnStaffSlides = 5                   -- Delay on staff slides in seconds

Config.TebexLink = '' -- Link to your Tebex store

Config.RandomizeMusics = true                   -- Randomize the music playlist order

Config.DefaultVolume = 0.1                      -- Default music volume

Config.SlideshowUpdateInterval = 5              -- Slideshow update interval in seconds

Config.AddBackgroundEffect = 'none'             -- Add a background effect to the background (snow & rain or none)

Config.KeyboardLayout = 'QWERTY'                -- QWERTY or AZERTY

Config.Translations = {
    servername = 'Code 3 Roleplay',
    serverdesc = 'FivePD',
    updates = 'Updates',
    team = 'Team',
    rules = 'Regeln',
    keyboard = 'Tastatur',
    tebexlink = '',
    loading = 'Die Stadt wird geladen...',
}

Config.Updates = {
    [1] = {
        title = "Patchnote #4",
        date = "25. Juni 2025",
        name = "Systembereinigung & Übersetzungen",
        description = "Das Voice-System wurde angepasst. Übersetzungen für neues Inventory, Jewelry, Management und Policejob wurden ergänzt. Ein neues Fuel-System wurde implementiert. Zudem wurden mehrere alte Module entfernt (qb-garages, qb-inventory, qb-recyclejob, qb-scoreboard, qb-scrapyard) und Blips überarbeitet sowie lokalisiert."
    },
    [2] = {
        title = "Patchnote #3.1",
        date = "24. Juni 2025",
        name = "Ressourcen & Audio",
        description = "Eigene Waffensounds von Lukas wurden integriert. Zusätzlich wurde wasabi_ambulance hinzugefügt und erneut hochgeladen."
    },
    [3] = {
        title = "Patchnote #3",
        date = "21. Juni 2025",
        name = "Performance & visuelle Verbesserungen",
        description = "Ein neuer Ladebildschirm wurde hinzugefügt. Das Banking-System wurde komplett überarbeitet. Unnötige Scripts wurden entfernt. Zudem gab es Performance-Verbesserungen, verbesserte Straßentexturen und einige UI-Elemente wurden farblich angepasst."
    },
    [4] = {
        title = "Patchnote #2",
        date = "20. Juni 2025",
        name = "Kleidung & Jobs",
        description = "Ein neues Kleidersystem wurde implementiert. Zusätzlich gibt es neue LSPD-Kleidung. Das Jobsystem wurde überarbeitet für mehr Flexibilität und Stabilität."
    },
    [5] = {
        title = "Patchnote #1",
        date = "19. Juni 2025",
        name = "FivePD Konfiguration",
        description = "FivePD wurde vollständig konfiguriert und angepasst. Dies ermöglicht jetzt ein reibungsloseres Polizei-Rollenspiel."
    }
}

Config.Rules = {
    [1] = {
        title = "Cheating, Hacking & Modding",
        description = "Jegliche Form von Hacks, Cheats, Scripts oder Mods, die einen unfairen Vorteil verschaffen (z. B. Godmode, Aimbot, Wallhack), sind strengstens verboten. Auch externe Programme wie Cheat-Engines sind nicht erlaubt."
    },
    [2] = {
        title = "Bugusing & Exploits",
        description = "Das absichtliche Ausnutzen von Bugs oder Glitches (z. B. Unsterblichkeit, Durch-Wände-Clipping, Fahrzeug-Duping) ist untersagt. Alle Bugs müssen sofort dem Admin gemeldet werden."
    },
    [3] = {
        title = "Fahrzeugnutzung",
        description = "Nur zulässige Fahrzeuge dürfen genutzt werden. Fraktionsfahrzeuge dürfen nicht von unbefugten Spielern verwendet werden (z. B. Zivilisten dürfen keine Polizeifahrzeuge fahren)."
    },
    [4] = {
        title = "Charakter- und Spieleraktionen",
        description = "Mass-Respawn-Spamming ist verboten. Auch unlogisches oder unrealistisches Verhalten (z. B. mit Faust auf Langwaffe losgehen oder wildes Herumstürmen) ist zu unterlassen. Verwende Menüs nicht zur Unverwundbarkeit."
    },
    [5] = {
        title = "Inventar & Ausrüstung",
        description = "Duping oder unberechtigtes Erhalten von Items, Waffen oder Fahrzeugen ist streng verboten."
    },
    [6] = {
        title = "Servermanipulation",
        description = "Jegliche Manipulation oder Beendigung von Scripts oder Serverdaten (z. B. DDoS, Netzwerktools oder clientseitige Eingriffe) führt zu einem permanenten Bann."
    },
    [7] = {
        title = "Multiaccounting & Bannumgehung",
        description = "Die Nutzung mehrerer Accounts zur Umgehung von Banns oder für Vorteile ist verboten. Bannumgehung – z. B. durch VPNs oder neue Steam-Accounts – führt zur permanenten Sperrung aller erkannten Accounts."
    },
    [8] = {
        title = "Regel gelesen?",
        description = "Bitte lest euch die Regeln sorgfältig durch. Wenn ihr damit einverstanden seid, klickt auf den Haken, um fortzufahren."
    }
}

Config.Team = {
    [1] = {
        name = "Oliver",
        title = "Projektleitung",
        image = "user.png"
    },
    [2] = {
        name = "Lukas",
        title = "Projektleitung",
        image = "user.png"
    }
}

Config.Songs = {
    [1] = {
        name = "Doxx My Heart",
        artist = "Diamond Eyes",
        file = "doxxmyheart.mp3"
    },
    [2] = {
        name = "Overdrive",
        artist = "Aspyer",
        file = "overdrive.mp3"
    },
    [3] = {
        name = "Muscle Up",
        artist = "Skan",
        file = "muscleup.mp3"
    },
    [4] = {
        name = "Freefall",
        artist = "Rienk & Nct",
        file = "freefall.mp3"
    },
}

Config.Links = {
    tiktok = {
        url = "https://tiktok.com/@deinkanal",
        icon = "fa-brands fa-tiktok",
    },
    youtube = {
        url = "https://youtube.com/@deinkanal",
        icon = "fa-brands fa-youtube",
    },
    discord = {
        url = "https://discord.gg/fwePma2DhK",
        icon = "fa-brands fa-discord",
    },
}

Config.KeyboardKeys = {
    -- Polizei / FivePD
    f1 = "Radialmenü öffnen",
    f2 = "Funkgerät öffnen (RP-Radio)",
    f6 = "Job-Menü öffnen (Creator)",
    f8 = "FiveM Konsole öffnen",
    f9 = "ALPR umschalten",
    f10 = "Sprachreichweite ändern (Mumble)",
    f11 = "Dienstmenü öffnen",
    y = "Einsatz/Backup annehmen",
    z = "Einsatzmenü öffnen",
    g = "Dispatch-Menü öffnen",
    x = "Ped-Menü & Verkehrsstop",
    o = "Wegpunkt zum Gefängnis setzen",
    e = "Ped stoppen / ins Fahrzeug setzen",
    lshift_e = "Nagelbänder platzieren/entfernen",
    u = "Ped ins Gefängnis bringen",
    j = "Ausweis anzeigen",
    f7 = "Multijob-Menü öffnen",
    b = "MDT öffnen",
    lshift = "Verkehrskontrolle starten/abbrechen",
    lctrl = "Tempomat an/aus",
    num_plus = "Tempomat schneller",
    num_minus = "Tempomat langsamer",

    -- Gameplay & Sonstiges
    right_alt = "AI-PIT aktivieren",
    l = "Chat ein-/ausblenden",
    k = "Sicherheitsgurt an-/ausziehen",
    n = "Nitro ein-/ausschalten",
    tab = "Inventar öffnen",
    left_alt = "Drittes Auge öffnen",

    -- Kommunikation
    caps = "Funken",

    -- Schnellslots
    ["1"] = "Slot 1 benutzen",
    ["2"] = "Slot 2 benutzen",
    ["3"] = "Slot 3 benutzen",
    ["4"] = "Slot 4 benutzen",
    ["5"] = "Slot 5 benutzen"
}