radioConfig = {
    Controls = {
        Activator = { -- Funkgerät öffnen/schließen
            Name = "INPUT_REPLAY_START_STOP_RECORDING_SECONDARY",
            Key = 289, -- F2
        },
        Secondary = { -- Zweite Taste zum Öffnen notwendig (optional)
            Name = "INPUT_SPRINT",
            Key = 21, -- Linke Shift-Taste
            Enabled = true, -- Muss gedrückt werden, um Funk zu öffnen (zusammen mit F2)
        },
        Toggle = { -- Funkgerät ein-/ausschalten (Power)
            Name = "INPUT_CONTEXT",
            Key = 51, -- E
        },
        Increase = { -- Kanal hoch
            Name = "INPUT_CELLPHONE_RIGHT",
            Key = 175, -- Pfeil rechts
            Pressed = false,
        },
        Decrease = { -- Kanal runter
            Name = "INPUT_CELLPHONE_LEFT",
            Key = 174, -- Pfeil links
            Pressed = false,
        },
        Input = { -- Kanal direkt eingeben (Bestätigen)
            Name = "INPUT_FRONTEND_ACCEPT",
            Key = 201, -- Enter
            Pressed = false,
        },
        Broadcast = { -- Push-to-Talk / Funken
            Name = "INPUT_VEH_PUSHBIKE_SPRINT",
            Key = 137, -- CAPSLOCK
        },
        ToggleClicks = { -- Funk-Klicks ein-/ausschalten
            Name = "INPUT_SELECT_WEAPON",
            Key = 37, -- TAB
        }
    },

    Frequency = {
        Private = {
            [10] = true, -- Kanal 1 ist privat (z. B. LSPD)
            [211] = true, -- Kanal 2 ist privat (z. B. BCSO)
            [311] = true, -- Kanal 3 ist privat (z. B. SAST)
            [411] = true, -- Gemeinsamer Einsatzkanal 1
            [511] = true, -- Gemeinsamer Einsatzkanal 2
            [116] = true, -- Gemeinsamer Einsatzkanal 3
        },
        Current = 1,         -- Nicht ändern
        CurrentIndex = 1,    -- Nicht ändern
        Min = 1,             -- Unterster Kanal
        Max = 800,           -- Höchster Kanal (Limit)
        List = {},           -- Interne Kanal-Liste (nicht anfassen)
        Access = {},         -- Zugelassene Kanäle (wird automatisch verwaltet)
    },

    AllowRadioWhenClosed = false -- Funk nur bei geöffnetem Funkgerät verwendbar (true = Polizei-Animation erlaubt Nutzung im Hintergrund)
}