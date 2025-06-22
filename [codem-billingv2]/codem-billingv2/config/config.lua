-- ░██████╗░███████╗███╗░░██╗███████╗██████╗░░█████╗░██╗░░░░░
-- ██╔════╝░██╔════╝████╗░██║██╔════╝██╔══██╗██╔══██╗██║░░░░░
-- ██║░░██╗░█████╗░░██╔██╗██║█████╗░░██████╔╝███████║██║░░░░░
-- ██║░░╚██╗██╔══╝░░██║╚████║██╔══╝░░██╔══██╗██╔══██║██║░░░░░
-- ╚██████╔╝███████╗██║░╚███║███████╗██║░░██║██║░░██║███████╗
-- ░╚═════╝░╚══════╝╚═╝░░╚══╝╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝
Config = {}
Locales = Locales or {}
Config.Framework = "qb" -- esx, oldesx, qb, oldqb, qbox
Config.SQL = "oxmysql"  -- oxmysql, ghmattimysql, mysql-async
Config.VersionChecker = true
Config.Language = "tr"

Config.UsingCodemBossmenuv2 = true

--[[
    Tax check interval in minutes for personel taxes
]]
Config.TaxCheckInterval = 30 * 60 * 1000 --  30  Minutes
--[[
    qb_target,
    ox_target,
    qb_textui,
    esx_textui,
    drawtext,
    codem_textui,
    okok_textui,
    eth_textUi
]]
Config.InteractionHandler    = "qb_target"
Config.DefaultProfilePicture = "https://r2.fivemanage.com/p0WfhJFBqn6SlWAIJkdTx/def.png"

--[[
    Show nearby players name true enable name false just show player id
]]
Config.ShowNearbyPlayersName = true

Config.CurrencyUnit = "$"
Config.TabletPropName = "codem_billing_tablet"

Config.EnableTaxes = {
    ['house'] = true,
    ['vehicles'] = true,
}

--[[
    qb-houses,
    0r-houses,
    origen-house
]]

Config.HouseScript = "qb-houses"


--[[
    just for qb
]]
Config.NewManagementSystem = true

--[[
    invoice due date
]]
Config.OverDueDate = 2 -- Days

--[[
    the bill to be doubled if the due invoices are not paid
]]
Config.DoubledDueInvoicesPaid = true

--[[
    if the invoice is overdue , after how many days the money is automatically taken back from the player
]]
Config.HowManyDaysInvoiceAutomaticallyCharged = 1


--[[
    How much tax will be applied to invoices
]]
Config.Tax = 0.18

--[[
    Distance range that checks people nearby when the player creates an invoice
]]
Config.BillingDistance = 5.0

--[[
    Should the tax paid when an invoice is issued be sent to the invoice holder?
]]
Config.TaxToInvoiceHolder = false

--[[
    Which jobs cannot apply
]]
Config.DisableJobs = {
    ['unemployed'] = true
    --- you can add more jobs
}

--[[
    The key to open the menu
]]
Config.OpenBillingMenuKey = 'F7'

--[[
    is necessary to avoid exploitation by cheaters
]]
Config.CoolDoownTimer = 1000

--[[
    The maximum amount of money that can be billed
]]
Config.MaxBillingAmount = 1000000

--[[
    If the money is transferred to the bank account
]]
Config.TransferToBank = true

Config.SqlSettings = {
    DeleteAdminLogTime = 1,   -- days  How many days after admin logs are deleted from sql
    DeletePaidBillingTime = 1 -- days  How many days after paid bills are deleted from sql
}


Config.DisableTaxesVehicles = {
    ['police'] = true,
    ['police2'] = true,
    ['police3'] = true,
    ['police4'] = true,
    ['police5'] = true,
    ['policet'] = true,
    ['tolpale'] = true,
    ['tolpbuff'] = true,
    ['tolpcru'] = true,
    ['tolpgaunt'] = true,
    ['tolpgrang2'] = true,
    ['ambulance'] = true,
    ['bmx'] = true,
    ['emstor'] = true,
    ['emsgranger'] = true,
    ['emscara'] = true,
    ['emsbuffalos'] = true,
    ['emsbuffalo4'] = true,
    ['emsaleutian'] = true
}

Config.DisableBusinessTaxJobName = {
    ['police'] = true,
    ['sheriff'] = true,
    ['ambulance'] = true
}


Config.ApprovalBilling = {
    NpcCoords = vector3(-545.12, -204.4, 38.22 - 0.98),
    NpcHeading = 206.46,
    NpcModel = "mp_f_boatstaff_01",
    Blip = {
        Show = true,
        Sprite = 540,
        Color = 5,
        Name = "Billing Approval",
        Scale = 0.7,
    },
}


Config.AdminPermissions = {
    'admin',
    'superadmin',
    'god',
}



Config.TaxTypes = {
    HOUSE = '532a268e',
    VEHICLE = '1919acba',
    OWNERSHIP = '14ba88cs'
}

Config.DefaultTaxes = {
    --- PERSONAL TAXES
    {
        label = 'House Ownership',
        hours = 01,
        minutes = 00,
        amount = 100,
        active = true,
        uniqueid = Config.TaxTypes.HOUSE,
        type = 'citizen',
        system = 'yes'
    },
    {
        label = 'Vehicle Ownership',
        hours = 02,
        minutes = 00,
        amount = 100,
        active = true,
        uniqueid = Config.TaxTypes.VEHICLE,
        type = 'citizen',
        system = 'yes'
    },


    --- BUSINESS TAXES
    {
        label = 'Business Ownership',
        hours = 02,
        minutes = 00,
        amount = 100,
        active = true,
        uniqueid = Config.TaxTypes.OWNERSHIP,
        type = 'business',
        system = 'yes'
    }
}
