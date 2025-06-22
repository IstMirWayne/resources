function ExecuteSql(query, parameters)
    local IsBusy = true
    local result = nil

    local function handleCallback(data)
        result = data
        IsBusy = false
    end

    if Config.SQL == "oxmysql" then
        if parameters then
            exports.oxmysql:execute(query, parameters, handleCallback)
        else
            exports.oxmysql:execute(query, {}, handleCallback)
        end
    elseif Config.SQL == "ghmattimysql" then
        if parameters then
            exports.ghmattimysql:execute(query, parameters, handleCallback)
        else
            exports.ghmattimysql:execute(query, {}, handleCallback)
        end
    elseif Config.SQL == "mysql-async" then
        if parameters then
            MySQL.Async.fetchAll(query, parameters, handleCallback)
        else
            MySQL.Async.fetchAll(query, {}, handleCallback)
        end
    end

    while IsBusy do
        Citizen.Wait(0)
    end

    return result
end

function SQLQuery(query, parameters)
    if Config.SQL == "oxmysql" then
        exports.oxmysql:execute(query, parameters)
    elseif Config.SQL == "ghmattimysql" then
        exports.ghmattimysql:execute(query, parameters)
    elseif Config.SQL == "mysql-async" then
        MySQL.Async.fetchAll(query, parameters)
    end
end

function RegisterCallback(name, cbFunc)
    while not Core do
        Wait(0)
    end
    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        Core.RegisterServerCallback(name, function(source, cb, data)
            cbFunc(source, cb, data)
        end)
    else
        Core.Functions.CreateCallback(name, function(source, cb, data)
            cbFunc(source, cb, data)
        end)
    end
end

function WaitCore()
    while Core == nil do
        Wait(0)
    end
end

function IsPlayerInGame(serverId)
    if (serverId == nil) then
        return false
    end
    if not serverId then
        return false
    end

    if (tonumber(serverId) == 0) then
        return false
    end
    local playerId = tonumber(serverId)
    if not playerId then
        return false
    end
    local endpoint = GetPlayerEndpoint(playerId)

    if endpoint and endpoint ~= "" then
        return true
    else
        return false
    end
end

function RemoveMoney(source, type, value)
    local Player = GetPlayer(source)
    if Player then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            if type == 'bank' then
                Player.removeAccountMoney('bank', value)
            end
            if type == 'cash' then
                Player.removeMoney(value)
            end
        elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' or Config.Framework == 'qbox' then
            if type == 'bank' then
                Player.Functions.RemoveMoney('bank', value)
            end
            if type == 'cash' then
                Player.Functions.RemoveMoney('cash', value)
            end
        end
    end
end

function AddMoney(source, type, value)
    local Player = GetPlayer(source)
    if Player then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            if type == 'bank' then
                Player.addAccountMoney('bank', value)
            end
            if type == 'cash' then
                Player.addMoney(value)
            end
        elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' or Config.Framework == 'qbox' then
            if type == 'bank' then
                Player.Functions.AddMoney('bank', value)
            end
            if type == 'cash' then
                Player.Functions.AddMoney('cash', value)
            end
        end
    end
end

function GetPlayer(source)
    local Player = false
    while Core == nil do
        Citizen.Wait(0)
    end
    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        Player = Core.GetPlayerFromId(source)
    elseif Config.Framework == 'oldqb' or Config.Framework == 'qb' then
        Player = Core.Functions.GetPlayer(source)
    elseif Config.Framework == 'qbox' then
        Player = Core.Functions.GetPlayer(source)
    end
    return Player
end

function GetIdentifier(source)
    local Player = GetPlayer(source)
    if Player then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            return Player.getIdentifier() or nil
        elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' then
            return Player.PlayerData.citizenid or nil
        elseif Config.Framework == 'qbox' then
            return Player.PlayerData.citizenid or nil
        end
    end
end

function GetName(source)
    if Config.Framework == "oldesx" or Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(tonumber(source))
        if xPlayer then
            return xPlayer.getName()
        else
            return "0"
        end
    elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' or Config.Framework == 'qbox' then
        local Player = Core.Functions.GetPlayer(tonumber(source))
        if Player then
            return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        else
            return "0"
        end
    end
end

function GetPlayerMoney(source, value)
    local Player = GetPlayer(source)
    if Player then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            if value == 'bank' then
                return Player.getAccount('bank').money
            end
            if value == 'cash' then
                return Player.getMoney()
            end
        elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' then
            if value == 'bank' then
                return Player.PlayerData.money['bank']
            end
            if value == 'cash' then
                return Player.Functions.GetMoney('cash')
            end
        elseif Config.Framework == 'qbox' then
            if value == 'bank' then
                return Player.PlayerData.money['bank']
            end
            if value == 'cash' then
                return Player.Functions.GetMoney('cash')
            end
        end
    end
end

function GetJob(source)
    local Player = GetPlayer(source)
    if Player then
        if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
            return {
                name = Player.getJob().name or nil,
                grade = Player.getJob().grade or nil,
                label = Player.getJob().label or nil,
                grade_label = Player.getJob().grade_label or nil
            }
        elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' or Config.Framework == 'qbox' then
            return {
                name = Player.PlayerData.job.name or nil,
                grade = Player.PlayerData.job.grade.level or nil,
                label = Player.PlayerData.job.label or nil,
                grade_label = Player.PlayerData.job.grade.name or nil
            }
        end
    end
    return false
end

function CheckSqlAndPaidBilling(identifier, amount)
    if Config.Framework == 'qb' or Config.Framework == 'oldqb' or Config.Framework == 'qbox' then
        local result = ExecuteSql('SELECT money FROM players WHERE citizenid = @citizenid', {
            ['@citizenid'] = identifier
        })


        if not next(result) then
        else
            local PlayerMoney = json.decode(result[1].money)
            PlayerMoney.bank = PlayerMoney.bank + amount

            local query = 'UPDATE players SET money = @money WHERE citizenid = @citizenid'

            local parameters = {
                ['@money'] = json.encode(PlayerMoney),
                ['@citizenid'] = identifier
            }
            ExecuteSql(query, parameters)
        end
    end

    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        local result = ExecuteSql('SELECT accounts FROM users WHERE identifier = @identifier', {
            ['@identifier'] = identifier
        })

        if not next(result) then
        else
            local PlayerMoney = json.decode(result[1].accounts)
            PlayerMoney.bank = PlayerMoney.bank + amount

            local query = 'UPDATE users SET accounts = @accounts WHERE identifier = @identifier'
            local parameters = {
                ['@accounts'] = json.encode(PlayerMoney),
                ['@identifier'] = identifier
            }

            ExecuteSql(query, parameters)
        end
    end
end

function TransferToBusinessVault(jobname, amount)
    if Config.UsingCodemBossmenuv2 then
        local result = exports["codem-bossmenuv2"]:AddMoneyJob(jobname, amount)
        return result
    end


    if Config.Framework == 'qb' or Config.Framework == 'oldqb' or Config.Framework == 'qbox' then
        local accountName = jobname
        if Config.NewManagementSystem then
            local account_money = exports["qb-banking"]:GetAccount(accountName)
            if account_money.account_balance then
                if amount < 0 then
                    print('ERROR SOCIETY MONEY IS NOT ENOUGH')
                    return false
                else
                    exports["qb-banking"]:AddMoney(jobname, amount)
                    return true
                end
            end
        else
            local societyAccountMoney = ExecuteSql("SELECT * FROM `management_funds` WHERE `job_name` = '" ..
                accountName .. "'")
            if societyAccountMoney and societyAccountMoney[1] then
                local currentAmount = societyAccountMoney[1].amount
                local newAmount = currentAmount + amount
                if newAmount < 0 then
                    print('ERROR SOCIETY MONEY IS NOT ENOUGH')
                    return false
                else
                    ExecuteSql("UPDATE `management_funds` SET `amount` = ? WHERE `job_name` = ?",
                        { newAmount, accountName })
                    return true
                end
            else
                print('ERROR SOCIETY NOT FOUND')
                return false
            end
        end
    else
        TriggerEvent("esx_addonaccount:getSharedAccount", 'society_' .. jobname, function(account)
            account.addMoney(amount)
            Wait(500)
        end)
        return true
    end
end

AllFrameworkJobs = {}

Citizen.CreateThread(function()
    while Core == nil do
        Wait(0)
    end
    if Config.Framework == 'qb' or Config.Framework == 'oldqb' or Config.Framework == 'qbox' then
        AllFrameworkJobs = Core.Shared.Jobs
    end

    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        while not next(Core.Jobs) do
            Wait(500)
            Core.Jobs = Core.GetJobs()
        end
        AllFrameworkJobs = Core.Jobs
    end
end)

function CheckPlayerJob(job, grade)
    if Config.DisableJobs[job] then
        return false
    end

    if AllFrameworkJobs[job] then
        local AllGrades = AllFrameworkJobs[job].grades
        local highestGrade = -1
        for key, _ in pairs(AllGrades) do
            local gradeNum = tonumber(key)
            if gradeNum and gradeNum > highestGrade then
                highestGrade = gradeNum
            end
        end
        if grade == highestGrade then
            return true
        else
            return false
        end
    else
        return false
    end
end

function GetFormattedDay()
    local day = os.date("*t").wday
    local days = {
        "sun",
        "mon",
        "tue",
        "wed",
        "thu",
        "fri",
        "sat"
    }
    return days[day]
end

function GetPlayerIDFromIdentifier(identifier)
    local Player = false
    WaitCore()
    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        Player = Core.GetPlayerFromIdentifier(identifier)
        if Player and Player.source then
            return Player.source
        else
            print('Player Source Not Found')
            return false
        end
    else
        local PData = Core.Functions.GetPlayerByCitizenId(identifier)
        if PData and PData.PlayerData and PData.PlayerData.source then
            Player = PData.PlayerData.source
        else
            Player = false
        end
    end
    return Player
end

function GetBillingPlayerData(src)
    src = tonumber(src)
    local identifier = GetIdentifier(src)
    if not identifier then
        TriggerClientEvent('codem-billing:client:notification', src, {
            type = 'error',
            label = Locales[Config.Language]['identifiernotfound'],
        })
        return false
    end

    local PlayerData = AllPlayerData[identifier]

    if not PlayerData then
        TriggerClientEvent('codem-billing:client:notification', src, {
            type = 'error',
            label = Locales[Config.Language]['playersdatanotfound'],
        })
        return false
    end

    return PlayerData, identifier
end

function CheckCooldown(src)
    if CoolDown[src] then
        TriggerClientEvent('codem-billing:client:notification', src, {
            type = 'error',
            label = Locales[Config.Language]['cooldown'],
        })
        return false
    else
        CoolDown[src] = true

        SetTimeout(Config.CoolDoownTimer, function()
            CoolDown[src] = nil
        end)
        return true
    end
end

function SendDataJobPlayers(Players, eventname, data)
    for k, v in pairs(Players) do
        if v and v.identifier then
            local TargetID = GetPlayerIDFromIdentifier(v.identifier)
            TargetID = tonumber(TargetID) or 0
            if IsPlayerInGame(TargetID) then
                TriggerClientEvent(eventname, TargetID, data)
            end
        end
    end
end

function AddMoneyJobVault(jobname, amount)
    if ApprovedJobs[jobname] then
        ApprovedJobs[jobname].vault = ApprovedJobs[jobname].vault + amount
        local query = [[
            UPDATE codem_billing_job
            SET vault = @vault
            WHERE jobname = @jobname
        ]]

        local params = {
            ['@vault'] = ApprovedJobs[jobname].vault,
            ['@jobname'] = jobname
        }

        local success, result = pcall(function()
            SQLQuery(query, params)
        end)

        if not success then
            print("Error Add Money Job Vault: " .. result)
        end
    end
end

function GenerateId()
    local random = math.random
    local templates = {
        'xxxx4xyx',
        'xx2xxxyx',
        'xxxx8xyx',
        'xx1xxxyx',
        'xx6xxxyx',
    }
    local template = templates[random(1, #templates)]

    return template:gsub("[xy]", function(c)
        local v

        if c == 'x' then
            v = math.random(0, 15)
        else
            v = math.random(8, 11)
        end

        return string.format("%x", v)
    end)
end

AddEventHandler('playerDropped', function(reason)
    local src = source
end)


Citizen.CreateThread(function()
    if Config.VersionChecker then
        local resource_name = 'codem-billingv2'
        local current_version = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
        PerformHttpRequest('https://raw.githubusercontent.com/Aiakos232/versionchecker/main/version.json',
            function(error, result, headers)
                if not result then
                    print('^1Version check disabled because github is down.^0')
                    return
                end
                local result = json.decode(result)
                if tonumber(result[resource_name]) ~= nil then
                    if tonumber(result[resource_name]) > tonumber(current_version) then
                        print('\n')
                        print('^1======================================================================^0')
                        print('^1' .. resource_name ..
                            ' is outdated, new version is available: ' .. result[resource_name] .. '^0')
                        print('^1======================================================================^0')
                        print('\n')
                    elseif tonumber(result[resource_name]) == tonumber(current_version) then
                        print('^2' .. resource_name .. ' is up to date! -  ^4 Thanks for choose CodeM ^4 ^0')
                    elseif tonumber(result[resource_name]) < tonumber(current_version) then
                        print('^3' .. resource_name .. ' is a higher version than the official version!^0')
                    end
                else
                    print('^1' .. resource_name .. ' is not in the version database^0')
                end
            end, 'GET')
    end
end)



function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        discord = "",
        license = ""
    }
    if src == nil or src == 0 then
        return identifiers
    end
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "discord") then
            identifiers.discord = "<@" .. id:gsub("discord:", "") .. ">"
        elseif string.find(id, "license") then
            identifiers.license = id
        end
    end
    return identifiers
end

function CheckIfAdmin(source)
    local src = source
    local Player = GetPlayer(src)
    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        return CheckPermissions(Player.getGroup())
    elseif Config.Framework == 'oldqb' or Config.Framework == 'qb' then
        return CheckPermissions(source)
    elseif Config.Framework == 'qbox' then
        return CheckPermissions(source)
    end
    return false
end

function CheckPermissions(permission)
    if Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        for _, v in pairs(Config.AdminPermissions) do
            if v == permission then
                return true
            end
        end
        return false
    elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' then
        for _, v in pairs(Config.AdminPermissions) do
            if Core.Functions.HasPermission(permission, v) or IsPlayerAceAllowed(permission, 'command') then
                return true
            end
        end
        return false
    elseif Config.Framework == 'qbox' then
        for _, v in pairs(Config.AdminPermissions) do
            if Core.Functions.HasPermission(permission, v) or IsPlayerAceAllowed(permission, 'command') then
                return true
            end
        end
        return false
    end
end
