Config = {}

Config.RadioItem = 'radio'

Config.RestrictedChannels = {
    [1] = { lspd = true },                     -- LSPD Interner Funkkanal
    [2] = { bcso = true },                     -- BCSO Interner Funkkanal
    [3] = { sast = true },                     -- SAST Interner Funkkanal

    [4] = { lspd = true, bcso = true, sast = true }, -- Gemeinsamer Funk 1
    [5] = { lspd = true, bcso = true, sast = true }, -- Gemeinsamer Funk 2
    [6] = { lspd = true, bcso = true, sast = true }, -- Gemeinsamer Funk 3
}

Config.MaxFrequency = 500