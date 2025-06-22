ServerVehicles = {}
ServerHouses = {}

local function InitializeVehicles()
    if Config.Framework == 'qb' or Config.Framework == 'oldqb' or Config.Framework == 'qbox' then
        local vehicles = ExecuteSql('SELECT * FROM player_vehicles')
        if vehicles then
            for i = 1, #vehicles do
                local data = vehicles[i]
                if not ServerVehicles[data.citizenid] then
                    ServerVehicles[data.citizenid] = {}
                end
                if data.vehicle then
                    if not Config.DisableTaxesVehicles[data.vehicle] then
                        ServerVehicles[data.citizenid][data.plate] = true
                    end
                end
            end
        end
    end

    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        local vehicles = ExecuteSql('SELECT * FROM owned_vehicles')
        if vehicles then
            for i = 1, #vehicles do
                local data = vehicles[i]
                if not ServerVehicles[data.owner] then
                    ServerVehicles[data.owner] = {}
                end
                if data.vehicle then
                    if not Config.DisableTaxesVehicles[data.vehicle] then
                        ServerVehicles[data.owner][data.plate] = true
                    end
                end
            end
        end
    end
end

local function InitializeHouses()
    if Config.HouseScript == "qb-houses" then
        local houses = ExecuteSql('SELECT * FROM player_houses')
        if houses then
            for i = 1, #houses do
                local data = houses[i]
                if not ServerHouses[data.citizenid] then
                    ServerHouses[data.citizenid] = {}
                end
                ServerHouses[data.citizenid][data.house] = true
            end
        end
    elseif Config.HouseScript == "oringe-house" then
        local houses = ExecuteSql('SELECT * FROM origen_housing')
        if houses then
            for i = 1, #houses do
                local data = houses[i]
                if not ServerHouses[data.citizenid] then
                    ServerHouses[data.citizenid] = {}
                end
                ServerHouses[data.citizenid][data.name] = true
            end
        end
    end
end

Citizen.CreateThread(function()
    if Config.EnableTaxes['vehicles'] then
        InitializeVehicles()
    end
    if Config.EnableTaxes['house'] then
        InitializeHouses()
    end
end)

local function ProcessVehicleTax(source, identifier, taxData)
    if not ServerVehicles[identifier] then return end

    for plate, _ in pairs(ServerVehicles[identifier]) do
        AllTaxesData[identifier][taxData.uniqueid].amount = taxData.amount
        AllTaxesData[identifier][taxData.uniqueid].last_update = os.time()
        CreateSystemBilling(source, taxData.amount, plate .. ' ' .. Locales[Config.Language]['vehicletax'])
    end
end

local function ProcessHouseTax(source, identifier, taxData)
    if Config.HouseScript == "qb-houses" then
        if ServerHouses[identifier] then
            for house, _ in pairs(ServerHouses[identifier]) do
                AllTaxesData[identifier][taxData.uniqueid].amount = taxData.amount
                AllTaxesData[identifier][taxData.uniqueid].last_update = os.time()
                CreateSystemBilling(source, taxData.amount, house .. ' ' .. Locales[Config.Language]['housetax'])
            end
        end
    elseif Config.HouseScript == "origen-house" then
        if ServerHouses[identifier] then
            for house, _ in pairs(ServerHouses[identifier]) do
                AllTaxesData[identifier][taxData.uniqueid].amount = taxData.amount
                AllTaxesData[identifier][taxData.uniqueid].last_update = os.time()
                CreateSystemBilling(source, taxData.amount, house .. ' ' .. Locales[Config.Language]['housetax'])
            end
        end
    elseif Config.HouseScript == "0r-houses" then
        local playerHouses = exports["0r_houses"]:GetPlayerHouses(source)
        if playerHouses then
            for house, _ in pairs(playerHouses) do
                AllTaxesData[identifier][taxData.uniqueid].amount = taxData.amount
                AllTaxesData[identifier][taxData.uniqueid].last_update = os.time()
                CreateSystemBilling(source, taxData.amount, house .. ' ' .. Locales[Config.Language]['housetax'])
            end
        end
    elseif Config.HouseScript == 'tgiann-houses' then
        local result = exports["tgiann-house"]:getPlayerHouses(source)
        if result then
            for _, house in pairs(result) do
                local houseData = exports["tgiann-house"]:getHouseData(house.name)
                if houseData then
                    AllTaxesData[identifier][taxData.uniqueid].amount = taxData.amount
                    AllTaxesData[identifier][taxData.uniqueid].last_update = os.time()
                    CreateSystemBilling(source, taxData.amount,
                        houseData.label .. ' ' .. Locales[Config.Language]['housetax'])
                end
            end
        end
    end
end

local function UpdateTaxRecord(identifier, taxId)
    local query = [[
        UPDATE codem_billing_taxes
        SET last_update = @last_update
        WHERE identifier = @identifier AND taxesid = @taxesid
    ]]

    local params = {
        ['@last_update'] = os.time(),
        ['@identifier'] = identifier,
        ['@taxesid'] = taxId
    }

    local success = pcall(function()
        SQLQuery(query, params)
    end)

    if not success then
        print("Error updating tax record for identifier: " .. identifier .. ", taxId: " .. taxId)
    end
end

local function CreateNewTaxRecord(identifier, taxId, source, tax)
    local query = [[
        INSERT INTO codem_billing_taxes (identifier, taxesid, last_update)
        VALUES (@identifier, @taxesid, @last_update)
    ]]

    local params = {
        ['@identifier'] = identifier,
        ['@taxesid'] = taxId,
        ['@last_update'] = os.time()
    }

    local success = pcall(function()
        SQLQuery(query, params)
    end)

    if not success then
        print("Error creating new tax record for identifier: " .. identifier .. ", taxId: " .. taxId)
        return
    end

    if not source then
        AllTaxesData[identifier][tax.uniqueid].amount = tax.amount
        AllTaxesData[identifier][tax.uniqueid].last_update = os.time()
        CreateSystemBilling(identifier, tax.amount, tax.label)
    else
        if tax.uniqueid == Config.TaxTypes.VEHICLE then
            if Config.EnableTaxes['vehicles'] then
                ProcessVehicleTax(source, identifier, tax)
            end
        elseif tax.uniqueid == Config.TaxTypes.HOUSE then
            if Config.EnableTaxes['house'] then
                ProcessHouseTax(source, identifier, tax)
            end
        else
            AllTaxesData[identifier][tax.uniqueid].amount = tax.amount
            AllTaxesData[identifier][tax.uniqueid].last_update = os.time()
            CreateSystemBilling(source, tax.amount, tax.label)
        end
    end
end

function CheckTaxesData(source)
    if not source then return end

    local identifier = GetIdentifier(source)
    if not identifier then return end

    for _, tax in pairs(ServerTaxes) do
        if tax.active == 1 or tax.active == true or tax.active == '1' and tax.type == 'citizen' then
            if not AllTaxesData[identifier] then
                AllTaxesData[identifier] = {}
            end

            if not AllTaxesData[identifier][tax.uniqueid] then
                AllTaxesData[identifier][tax.uniqueid] = {}
            end

            local taxData = AllTaxesData[identifier][tax.uniqueid]
            local currentTime = os.time()
            local shouldProcessTax = false

            if taxData.last_update then
                local elapsedTimeInSeconds = os.difftime(currentTime, taxData.last_update)
                local thresholdInSeconds = (tax.hours * 3600) + (tax.minutes * 60)
                shouldProcessTax = elapsedTimeInSeconds >= thresholdInSeconds
            else
                shouldProcessTax = true
            end

            if shouldProcessTax then
                if taxData.last_update then
                    UpdateTaxRecord(identifier, tax.uniqueid)
                    AllTaxesData[identifier][tax.uniqueid].last_update = os.time()

                    if tax.uniqueid == Config.TaxTypes.VEHICLE then
                        if Config.EnableTaxes['vehicles'] then
                            ProcessVehicleTax(source, identifier, tax)
                        end
                    elseif tax.uniqueid == Config.TaxTypes.HOUSE then
                        if Config.EnableTaxes['house'] then
                            ProcessHouseTax(source, identifier, tax)
                        end
                    else
                        AllTaxesData[identifier][tax.uniqueid].amount = tax.amount
                        AllTaxesData[identifier][tax.uniqueid].last_update = os.time()
                        CreateSystemBilling(source, tax.amount, tax.label)
                    end
                else
                    CreateNewTaxRecord(identifier, tax.uniqueid, source, tax)
                end
            end
        end
    end
end

Citizen.CreateThread(function()
    Wait(1000)
    while true do
        Wait(Config.TaxCheckInterval)
        local players = GetPlayers()
        if #players > 0 then
            for _, playerSource in pairs(players) do
                local source = tonumber(playerSource)
                if source then
                    CheckTaxesData(source)
                end
            end
        end
    end
end)
Citizen.CreateThread(function()
    Wait(5000)
    while true do
        CheckBusinessTaxes()
        Wait(Config.TaxCheckInterval)
    end
end)


function CheckBusinessTaxes()
    for k, v in pairs(ServerTaxes) do
        if v.active == 1 or v.active == true or v.active == '1' and v.type == 'business' then
            for kk, vv in pairs(ApprovedJobs) do
                local identifier = 'job_' .. kk
                if not Config.DisableBusinessTaxJobName[kk] then
                    if not AllTaxesData[identifier] then
                        AllTaxesData[identifier] = {}
                    end

                    if not AllTaxesData[identifier][v.uniqueid] then
                        AllTaxesData[identifier][v.uniqueid] = {}
                    end

                    local taxData = AllTaxesData[identifier][v.uniqueid]
                    local currentTime = os.time()
                    local shouldProcessTax = false

                    if taxData.last_update then
                        local elapsedTimeInSeconds = os.difftime(currentTime, taxData.last_update)
                        local thresholdInSeconds = (v.hours * 3600) + (v.minutes * 60)
                        shouldProcessTax = elapsedTimeInSeconds >= thresholdInSeconds
                    else
                        shouldProcessTax = true
                    end

                    if shouldProcessTax then
                        if taxData.last_update then
                            UpdateTaxRecord(identifier, v.uniqueid)
                            AllTaxesData[identifier][v.uniqueid].last_update = os.time()
                            CreateSystemBilling(identifier, v.amount, v.label)
                        else
                            CreateNewTaxRecord(identifier, v.uniqueid, false, v)
                        end
                    end
                end
                break
            end
        end
    end
end
