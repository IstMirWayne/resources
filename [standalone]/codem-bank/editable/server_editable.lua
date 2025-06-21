bot_Token = ""
bot_logo = "https://cdn.discordapp.com/attachments/1025789416456867961/1106324039808594011/512x512_Logo.png"
bot_name = "Codem Store"

discord_webhook = {
    ['bitcoin']         = "",
    ['withdraw']        = "",
    ['deposit']         = "",
    ['transfer']        = "",
    ['transferiban']    = "",
    ['loan']            = "",
    ['paybill']         = "",
    ['saving']          = "",
    ['changeiban']      = "",
    ['societydeposit']  = "",
    ['societywithdraw'] = "",

}

local cooldowns = {}

Citizen.CreateThread(function()
    while Core == nil do
        Citizen.Wait(0)
    end

    RegisterCallback('codem-bank:server:getPlayerBilling', function(source, cb)
        local src = source
        local identifier = GetIdentifier(src)
        local billTable = {}
        if Config.BillingScript == 'codem-billing' then
            local result = ExecuteSql("SELECT * FROM `codem_billing` WHERE `targetidentifier` = ?", { identifier })
            if result then
                for i = 1, #result do
                    if result[i].status == 'unpaid' then
                        local data = {}
                        data.id = result[i].id or '-'
                        data.identifier = result[i].identifier or '-'
                        data.name = result[i].name or '-'
                        data.targetname = result[i].targetname or '-'
                        data.targetidentifier = result[i].targetidentifier or '-'
                        data.amount = result[i].amount or '-'
                        data.invoicelabel = result[i].invoicelabel or '-'
                        data.status = result[i].status or '-'
                        data.uniqueid = result[i].uniqueid or '-'
                        data.date = result[i].date or '-'
                        data.societyname = Config.BillingJob[result[i].societyname] or result[i].societyname
                        data.tax = Config.Tax or
                            '-'                                                                    -- just for codem billing
                        data.seconddate = addDaysToDateCodemBilling(data.date, Config.HowManyDays) -- just for codem billing
                        table.insert(billTable, data)
                    end
                end
                cb(billTable)
            end
        elseif Config.BillingScript == 'qbdefault' then
            local result = ExecuteSql("SELECT * FROM `phone_invoices` WHERE `citizenid` = ?", { identifier })
            if result then
                for i = 1, #result do
                    local playerData = ExecuteSql("SELECT * FROM players WHERE citizenid LIKE ?",
                        { '%' .. result[i].sendercitizenid .. '%' })
                    local playerCharinfo = json.decode(playerData[1].charinfo)
                    local data = {}
                    data.id = result[i].id or '-'
                    data.identifier = result[i].citizenid or '-'
                    data.targetname = result[i].name or playerCharinfo.firstname .. ' ' .. playerCharinfo.lastname
                    data.name = result[i].sender or '-'
                    data.targetidentifier = result[i].sendercitizenid or '-'
                    data.amount = result[i].amount or '-'
                    data.invoicelabel = result[i].invoicelabel or '-'
                    data.status = result[i].status or '-'
                    data.uniqueid = result[i].uniqueid or '-'
                    data.date = result[i].date or '-'
                    data.societyname = Config.BillingJob[result[i].society] or result[i].society
                    data.tax = Config.Tax or '-'
                    data.seconddate = '-'
                    table.insert(billTable, data)
                end
                cb(billTable)
            end
        elseif Config.BillingScript == 'okok' then
            local result = ExecuteSql("SELECT * FROM `okokbilling` WHERE `receiver_identifier` = ?", { identifier })
            if result then
                for i = 1, #result do
                    if result[i].status == 'unpaid' then
                        local data = {}
                        data.id = result[i].id or '-'
                        data.identifier = result[i].author_identifier or '-'
                        data.name = result[i].author_name or '-'
                        data.targetname = result[i].receiver_name or '-'
                        data.targetidentifier = result[i].receiver_identifier or '-'
                        data.amount = result[i].invoice_value or '-'
                        data.invoicelabel = result[i].notes .. ' - ' .. result[i].item
                        data.status = result[i].status or '-'
                        data.uniqueid = result[i].uniqueid or '-'
                        data.date = result[i].sent_date or '-'
                        data.societyname = Config.BillingJob[result[i].society] or result[i].society
                        data.tax = result[i].fees_amount or '-'
                        data.seconddate = result[i].limit_pay_date or '-'
                        table.insert(billTable, data)
                    end
                end
                cb(billTable)
            end
        elseif Config.BillingScript == 'esxdefault' then
            local result = ExecuteSql("SELECT * FROM `billing` WHERE `identifier` = ?", { identifier })
            local Playerx = GetPlayer(source)
            if result then
                for i = 1, #result do
                    local playerData = ExecuteSql("SELECT * FROM users WHERE identifier LIKE ?",
                        { '%' .. result[i].sender .. '%' })
                    local playerCharinfo = json.decode(playerData[1].firstname .. ' ' .. playerData[1].lastname)
                    local data = {}
                    data.id = result[i].id or '-'
                    data.identifier = result[i].identifier or '-'
                    data.targetname = result[i].name or Playerx.getName()
                    data.name = result[i].sendername or playerCharinfo
                    data.targetidentifier = result[i].sender or '-'
                    data.amount = result[i].amount or '-'
                    data.invoicelabel = result[i].label or '-'
                    data.status = result[i].status or '-'
                    data.uniqueid = result[i].uniqueid or '-'
                    data.date = result[i].date or '-'
                    data.societyname = Config.BillingJob[result[i].target] or result[i].target
                    data.tax = Config.Tax or '-'
                    data.seconddate = '-'
                    table.insert(billTable, data)
                end
                cb(billTable)
            end
        elseif Config.BillingScript == 'codem-billingv2' then
            local result = ExecuteSql("SELECT * FROM `codem_billing_data` WHERE `targetidentifier` = ?", { identifier })
            if result then
                for i = 1, #result do
                    if result[i].status == "unpaid" then
                        local data = {}
                        data.id = result[i].invoiceid or '-'
                        data.identifier = result[i].identifier or '-'
                        data.name = result[i].identifiername or '-'
                        data.targetname = result[i].targetname or '-'
                        data.targetidentifier = result[i].targetidentifier or '-'
                        data.amount = result[i].amount or '-'
                        data.invoicelabel = result[i].reason['reason'] or '-'
                        data.status = result[i].status or '-'
                        data.uniqueid = result[i].invoiceid or '-'
                        data.date = formatTimestamp(result[i].date) or '-'
                        data.societyname = result[i].identifiername or '-'
                        data.tax = Config.Tax or '-'
                        data.seconddate = formatTimestamp(result[i].overduedate) or '-'
                        table.insert(billTable, data)
                    end
                end
                cb(billTable)
            else
                cb(false)
            end
        end
    end)


    RegisterCallback('codem-bank:server:payBilling', function(source, cb, billData)
        local src = source
        if billData then
            if Config.BillingScript == 'codem-billing' then
                billData.amount = math.floor(tonumber(billData.amount) +
                    (tonumber(billData.amount) * tonumber(billData.tax)))
                local BankMoney = GetPlayerMoney(src, 'bank')

                if tonumber(BankMoney) < tonumber(billData.amount) then
                    TriggerClientEvent('codem-bank:client:sendNotification', src, Config.Locales['notmoneybank'])
                    cb(false)
                    return
                end
                cb(true)
            elseif Config.BillingScript == 'qbdefault' then
                local BankMoney = GetPlayerMoney(src, 'bank')

                if tonumber(BankMoney) < tonumber(billData.amount) then
                    TriggerClientEvent('codem-bank:client:sendNotification', src, Config.Locales['notmoneybank'])
                    cb(false)
                    return
                end
                cb(true)
            elseif Config.BillingScript == 'okok' then
                local BankMoney = GetPlayerMoney(src, 'bank')

                if tonumber(BankMoney) < tonumber(billData.amount) then
                    TriggerClientEvent('codem-bank:client:sendNotification', src, Config.Locales['notmoneybank'])
                    cb(false)
                    return
                end
                cb(true)
            elseif Config.BillingScript == 'esxdefault' then
                local BankMoney = GetPlayerMoney(src, 'bank')
                if tonumber(BankMoney) < tonumber(billData.amount) then
                    TriggerClientEvent('codem-bank:client:sendNotification', src, Config.Locales['notmoneybank'])
                    cb(false)
                    return
                end
                cb(true)
            elseif Config.BillingScript == 'codem-billingv2' then
                local BankMoney = GetPlayerMoney(src, 'bank')
                if tonumber(BankMoney) < tonumber(billData.amount) then
                    TriggerClientEvent('codem-bank:client:sendNotification', src, Config.Locales['notmoneybank'])
                    cb(false)
                    return
                end
                cb(true)
            end
        end
    end)

    RegisterCallback('codem-bank:server:payBill', function(source, cb, billData)
        local src = source
        if billData then
            if cooldowns[source] and (os.time() - cooldowns[source] < 5) then
                Config.Notification(Config.NotificationText['beforewait'].text,
                    Config.NotificationText['beforewait'].type, true,
                    src)
                return
            end
            cooldowns[source] = os.time()

            if Config.BillingScript == 'codem-billing' then
                TriggerEvent('codem-billing:server:PayBillBankV2', src, tonumber(billData.id))
                cb(true)
                local BankMoney = GetPlayerMoney(src, 'bank')
                TriggerClientEvent('codem-bank:client:updatePlayerMoney', src, BankMoney)
                return
            elseif Config.BillingScript == 'qbdefault' then
                local defaultbilldata = ExecuteSql("SELECT * FROM `phone_invoices` WHERE `id` = ?", { billData.id })
                if defaultbilldata then
                    RemoveMoney(src, 'bank', tonumber(billData.amount))
                  
                    if Config.newManagementSystem then
                        local account_money = exports["qb-banking"]:GetAccount(defaultbilldata[1].society)
                        if account_money and account_money.account_balance then
                            exports["qb-banking"]:AddMoney(defaultbilldata[1].society, tonumber(billData.amount))
                        else
                            if Config.CreateJobAccount then
                                exports["qb-banking"]:CreateJobAccount(defaultbilldata[1].society, 0)
                                Wait(350)
                                exports["qb-banking"]:AddMoney(defaultbilldata[1].society, tonumber(billData.amount))
                            end
                        end
                    else
                        exports['qb-management']:AddMoney(defaultbilldata[1].society, tonumber(billData.amount))
                    end
                    ExecuteSql("DELETE FROM `phone_invoices` WHERE `id` = '" .. billData.id .. "'")
                    cb(true)
                    local BankMoney = GetPlayerMoney(src, 'bank')
                    TriggerClientEvent('codem-bank:client:updatePlayerMoney', src, BankMoney)
                end
            elseif Config.BillingScript == 'okok' then
                TriggerEvent('okokBilling:PayInvoiceBank', src, billData.id)
                cb(true)
                Wait(1000)
                local BankMoney = GetPlayerMoney(src, 'bank')
                TriggerClientEvent('codem-bank:client:updatePlayerMoney', src, BankMoney)
            elseif Config.BillingScript == 'esxdefault' then
                TriggerEvent('esx_billing:payBill', src, billData.id)
                cb(true)
                Wait(1000)
                local BankMoney = GetPlayerMoney(src, 'bank')
                TriggerClientEvent('codem-bank:client:updatePlayerMoney', src, BankMoney)
            elseif Config.BillingScript == 'codem-billingv2' then
                exports['codem-billingv2']:PayBilling(src, billData.id)
                cb(true)
                local BankMoney = GetPlayerMoney(src, 'bank')
                TriggerClientEvent('codem-bank:client:updatePlayerMoney', src, BankMoney)
            end
            local data = {
                amount = billData.amount,
            }
            local disordLog = discordPayBillData(src, data)
            sendDiscordLogPayBill(disordLog)
        end
        cb(false)
    end)

    RegisterCallback('codem-bank:server:GetPlayerIban', function(source, cb)
        local src = source
        local identifier = GetIdentifier(src)

        if not identifier then
            cb(false)
        end
        if not playerAllData[identifier] then
            cb(GetPlayerIban(src))
        else
            cb(playerAllData[identifier].profiledata.iban)
        end
        cb(false)
    end)

    RegisterCallback('codem-bank:server:GetBlockAccount', function(source, cb)
        local src = source
        local identifier = GetIdentifier(src)

        if not identifier then
            cb(false)
        end
        if not playerAllData[identifier] then
            cb(false)
        else
            cb(playerAllData[identifier].profiledata.block)
        end
    end)

    RegisterCallback('codem-bank:server:SetBlockAccount', function(source, cb, bool)
        local src = source
        local identifier = GetIdentifier(src)

        if not identifier then
            cb(false)
        end
        if not playerAllData[identifier] then
            cb(false)
        else
            playerAllData[identifier].profiledata.block = bool
            cb(true)
        end
    end)

    RegisterCallback('codem-bank:server:addTransaction', function(source, cb, dataTable)
        local src = source
        if not dataTable then
            cb(false)
        end
        exportsTransaction(src, dataTable.value, tonumber(dataTable.payment))
    end)
end)

function discordPayBillData(source, data)
    local src = source
    local identifier = GetIdentifier(src)

    local dataInfo = {
        identifier = identifier,
        avatar = GetDiscordAvatar(src) or Config.ExampleProfilePicture,
        name = GetName(src),
        id = src,
        billMoney = data.amount or data.Amount,
    }
    return dataInfo
end

function formatTimestamp(timestamp)
    local formattedDate = os.date("%d.%m.%Y", timestamp)
    return formattedDate
end

function addDaysToDateCodemBilling(dateStr, daysToAdd)
    local pattern = "(%d+)-(%d+)-(%d+)"
    local year, month, day = dateStr:match(pattern)
    local originalTime = os.time({ year = year, month = month, day = day })
    local daysInSeconds = daysToAdd * 24 * 60 * 60
    local newTime = originalTime + daysInSeconds
    local newDateStr = os.date("%Y-%m-%d", newTime)

    return newDateStr
end

Citizen.CreateThread(function()
    if Config.Framework == 'qb' or Config.Framework == 'oldqb' then
        while Core == nil do
            Citizen.Wait(0)
        end
        Core.Commands.Add('changeiban', "Change Bank Iban (Admin Only)",
            { { name = "id", help = "Player ID" }, { name = "iban", help = "New Iban" },
            }, false, function(source, args)
                local id = tonumber(args[1])
                local Player = GetPlayer(id)
                if Player then
                    local newiban = args[2]
                    if tonumber(newiban) and string.len(newiban) == 6 then
                        if not IsIbanInUse(newiban) then
                            ChangeIban(source, id, newiban)
                        else
                            Config.Notification(Config.NotificationText['THISIBANISALREADYINUSE'].text,
                                Config.NotificationText['THISIBANISALREADYINUSE'].type, true,
                                source)
                        end
                    else
                        Config.Notification(Config.NotificationText['NEWIBANMUSTCONSISTOF6DIGITS'].text,
                            Config.NotificationText['NEWIBANMUSTCONSISTOF6DIGITS'].type, true,
                            source)
                    end
                else
                    Config.Notification(Config.NotificationText['playernotfound'].text,
                        Config.NotificationText['playernotfound'].type, true,
                        source)
                end
            end, "admin")
    elseif Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        while Core == nil do
            Citizen.Wait(0)
        end
        Core.RegisterCommand('changeiban', 'admin', function(xPlayer, args, showError)
            local source = xPlayer.source
            local id = tonumber(args.playerId.source)
            local Player = GetPlayer(id)
            if Player then
                local newiban = args.iban
                if tonumber(newiban) and string.len(newiban) == 6 then
                    if not IsIbanInUse(newiban) then
                        ChangeIban(source, id, newiban)
                    else
                        Config.Notification(Config.NotificationText['THISIBANISALREADYINUSE'].text,
                            Config.NotificationText['THISIBANISALREADYINUSE'].type, true,
                            source)
                    end
                else
                    Config.Notification(Config.NotificationText['NEWIBANMUSTCONSISTOF6DIGITS'].text,
                        Config.NotificationText['NEWIBANMUSTCONSISTOF6DIGITS'].type, true,
                        source)
                end
            else
                Config.Notification(Config.NotificationText['playernotfound'].text,
                    Config.NotificationText['playernotfound'].type, true,
                    source)
            end
            --args.playerId.addInventoryItem(args.item, args.count)
        end, true, {
            help = 'Give items to player',
            validate = true,
            arguments = {
                { name = 'playerId', help = 'playerid', type = 'player' },
                { name = 'iban',     help = 'IBAN',     type = 'number' },
            }
        })
    end
end)


function IsIbanInUse(iban)
    if Config.Framework == 'qb' or Config.Framework == 'oldqb' then
        local query = "SELECT * FROM `players` WHERE `iban` = ?"
        local result = ExecuteSql(query, { iban })
        return #result > 0
    else
        local query = "SELECT * FROM `users` WHERE `iban` = ?"
        local result = ExecuteSql(query, { iban })
        return #result > 0
    end
end

function ChangeIban(source, tosrc, newiban)
    local src = source
    local toidentifier = GetIdentifier(tonumber(tosrc))
    local todata = playerAllData[toidentifier]
    if not todata then
        return
    end
    local discordlogData = {
        toplayer = tonumber(tosrc),
        oldiban = todata.profiledata.iban,
        newiban = newiban,
    }
    if todata.profiledata.iban == newiban then
        Config.Notification(Config.NotificationText['THISISALREADYTHEPLAYERSIBAN'].text,
            Config.NotificationText['USECORRECTLYCHANGEIBAN'].type, true,
            src)
        return
    else
        if Config.Framework == 'qb' or Config.Framework == 'oldqb' then
            ExecuteSql("UPDATE `players` SET `iban` = ? WHERE `citizenid` = ?", { newiban, toidentifier })
            todata.profiledata.iban = newiban
        else
            ExecuteSql("UPDATE `users` SET `iban` = ? WHERE `identifier` = ?", { newiban, toidentifier })
            todata.profiledata.iban = newiban
        end
        Config.Notification(Config.NotificationText['changeiban'].text, Config.NotificationText['changeiban'].type, true,
            src)
        local disordLog = discordChangeIbanData(src, discordlogData)
        sendDiscordLogChangeIban(disordLog)
    end
end

function discordChangeIbanData(source, data)
    local src = source
    local identifier = GetIdentifier(src)
    local toidentifier = GetIdentifier(data.toplayer)
    local dataInfo = {
        identifier = identifier,
        toidentifier = toidentifier,
        avatar = GetDiscordAvatar(data.toplayer) or Config.ExampleProfilePicture,
        name = GetName(src),
        toname = GetName(data.toplayer),
        id = src,
        oldiban = data.oldiban or '-',
        newiban = data.newiban or '-',
    }
    return dataInfo
end

Citizen.CreateThread(function()
    local resource_name = 'codem_bankv2'
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
end)