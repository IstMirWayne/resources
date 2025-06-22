function InsertAdminLog(logdata)
    table.insert(AdminData.AllLogs, json.encode(logdata))
    local query = [[
        INSERT INTO codem_billing_adminlog (log, last_update)
        VALUES (@log, @last_update)
    ]]

    local params = {
        ['@log'] = json.encode(logdata),
        ['@last_update'] = os.time()
    }

    local success, result = pcall(function()
        SQLQuery(query, params)
    end)

    if not success then
        print("Error Insert Admin Log: " .. result)
    end
end

function InsertAuthorized(tempdata, identifier)
    local query = [[
        INSERT INTO codem_billing_authorized (autdata, identifier)
        VALUES (@autdata, @identifier)
    ]]

    local params = {
        ['@autdata'] = json.encode(tempdata),
        ['@identifier'] = identifier
    }

    local success, result = pcall(function()
        SQLQuery(query, params)
    end)

    if not success then
        print("Error Insert Authorized: " .. result)
    end
end

function PayBill(src, invoiceid)
    local PlayerData, identifier = GetBillingPlayerData(src)
    if not PlayerData then
        return
    end
    local BillingData = AllPlayerData[identifier] and AllPlayerData[identifier].billing[invoiceid]
    if not BillingData then
        local found = false
        for k, v in pairs(AllPlayerData) do
            if v and v.billing then
                if v.billing[invoiceid] then
                    BillingData = v.billing[invoiceid]
                    found = true
                    break
                end
            end
        end
        if not found then
            local found = false
            for k, v in pairs(ApprovedJobs) do
                if v and v.billing and v.billing[invoiceid] then
                    BillingData = v.billing[invoiceid]
                    found = true
                    break
                end
            end
            if not found then
                SendNotificationPlayer(src, 'error', Locales[Config.Language]['billingnotfound'])
                TriggerClientEvent('codem-billing:client:clearshowbilling', src)
                return
            end
        end
    end
    if BillingData.billtype == 'job' then
        PaidJobBilling(src, BillingData)
        return
    end
    if BillingData.billtype == 'system' then
        PaidTaxesBilling(src, BillingData)
        return
    end

    local TargetPlayerData = AllPlayerData[BillingData.identifier] or false
    if not TargetPlayerData then
        SendNotificationPlayer(src, 'error', Locales[Config.Language]['playersdatanotfound'])
        return
    end
    if BillingData.status == 'paid' then
        SendNotificationPlayer(src, 'info', Locales[Config.Language]['alreadybeedpaid'])
        return
    end
    if BillingData.identifier == identifier then
        SendNotificationPlayer(src, 'info', Locales[Config.Language]['ownbilling'])
        return
    end
    local BillingAmount = 0
    for k, v in pairs(BillingData.reason) do
        if BillingData.overduestatus == 'true' then
            BillingAmount = BillingAmount + v.amount * 2
        else
            BillingAmount = BillingAmount + v.amount
        end
    end
    if tonumber(BillingAmount) <= 0 then
        SendNotificationPlayer(src, 'error',
            string.format(Locales[Config.Language]['invoiceamountcannotbezero'], Config.CurrencyUnit))
        return
    end
    local taxTotal = RoundToNearest(BillingAmount * Config.Tax)
    local TotalAmount = BillingAmount + taxTotal
    local GetMoney = GetPlayerMoney(src, 'bank')

    local LastAmount = Config.TaxToInvoiceHolder and TotalAmount or BillingAmount
    if tonumber(GetMoney) < tonumber(LastAmount) then
        SendNotificationPlayer(src, 'error', Locales[Config.Language]['notenoughmoney'])
        return
    end

    BillingData.status = 'paid'
    local BillingOwnerID = GetPlayerIDFromIdentifier(BillingData.identifier)
    local OrjinalBillingReciver = BillingData.targetidentifier
    local formatDay = GetFormattedDay()
    RemoveMoney(src, 'bank', LastAmount)
    UpdatePlayerMoney(src)
    SendNotificationPlayer(src, 'info', Locales[Config.Language]['billpaid'])

    AllPlayerData[identifier].spenddata.outgoing[formatDay] =
        AllPlayerData[identifier].spenddata.outgoing[formatDay] + LastAmount
    AllPlayerData[BillingData.identifier].spenddata.incoming[formatDay] =
        AllPlayerData[BillingData.identifier].spenddata.incoming[formatDay] + LastAmount
    UpdateClientSpendData(src, 'outgoing', formatDay, LastAmount)

    if IsPlayerInGame(BillingOwnerID) then
        UpdateClientSpendData(BillingOwnerID, 'incoming', formatDay, LastAmount)
        AddMoney(BillingOwnerID, 'bank', LastAmount)
        UpdatePlayerMoney(BillingOwnerID)
        SendNotificationPlayer(BillingOwnerID, 'info',
            string.format(Locales[Config.Language]['billpaidedby'], GetName(src), LastAmount, Config.CurrencyUnit))
        TriggerClientEvent('codem-billing:client:paidedownerbilling', BillingOwnerID, BillingData.invoiceid)
    else
        CheckSqlAndPaidBilling(BillingData.identifier, LastAmount)
    end

    local OrjinalBillingReciverID = GetPlayerIDFromIdentifier(OrjinalBillingReciver)
    if IsPlayerInGame(OrjinalBillingReciverID) then
        if tonumber(src) == tonumber(OrjinalBillingReciverID) then
            TriggerClientEvent('codem-billing:client:paidedbilling', src, BillingData.invoiceid)
        else
            TriggerClientEvent('codem-billing:client:paidedbilling', tonumber(OrjinalBillingReciverID),
                BillingData.invoiceid)
        end
    end

    UpdateSQLPaid(BillingData.invoiceid)
    UpdateSQLSpendData(identifier, AllPlayerData[identifier].spenddata)
    UpdateSQLSpendData(BillingData.identifier, AllPlayerData[BillingData.identifier].spenddata)

    if AdminData.AllBilling[invoiceid] then
        AdminData.AllBilling[invoiceid].status = 'paid'
        SendAdminData({
            events = {
                { name = 'codem-billing:admin:updatebillstatus', data = { billingid = invoiceid } },
            }
        })
    end
end

function PaidPersonalBillingPayAll(v, src, LastAmount, identifier)
    v.status = 'paid'
    local BillingOwnerID = GetPlayerIDFromIdentifier(v.identifier)
    local formatDay = GetFormattedDay()
    TriggerClientEvent('codem-billing:client:paidedbilling', src, v.invoiceid)
    UpdatePlayerMoney(src)
    if IsPlayerInGame(BillingOwnerID) then
        AllPlayerData[identifier].spenddata.outgoing[formatDay] =
            AllPlayerData[identifier].spenddata.outgoing[formatDay] + LastAmount
        AllPlayerData[v.identifier].spenddata.incoming[formatDay] =
            AllPlayerData[v.identifier].spenddata.incoming[formatDay] + LastAmount

        UpdateSQLSpendData(v.identifier, AllPlayerData[v.identifier].spenddata)
        UpdateSQLSpendData(identifier, AllPlayerData[identifier].spenddata)

        UpdateClientSpendData(BillingOwnerID, 'incoming', formatDay, LastAmount)
        UpdateClientSpendData(src, 'outgoing', formatDay, LastAmount)

        AddMoney(BillingOwnerID, 'bank', LastAmount)
        UpdatePlayerMoney(BillingOwnerID)

        TriggerClientEvent('codem-billing:client:paidedbilling', src, v.invoiceid)
        TriggerClientEvent('codem-billing:client:paidedownerbilling', BillingOwnerID, v.invoiceid)
    else
        CheckSqlAndPaidBilling(v.identifier, LastAmount)
    end
    UpdateSQLPaid(v.invoiceid)
end

function PaidJobBilling(source, billingdata)
    local Jobname = billingdata.identifier
    local extractedString = string.match(Jobname, "^job_(.+)$")
    local identifier = GetIdentifier(source)
    if ApprovedJobs[extractedString] then
        if billingdata.status == 'paid' then
            SendNotificationPlayer(source, 'error', Locales[Config.Language]['alreadybeedpaid'])
            return
        end
        local BillingAmount = 0
        for k, v in pairs(billingdata.reason) do
            if billingdata.overduestatus == 'true' then
                BillingAmount = BillingAmount + v.amount * 2
            else
                BillingAmount = BillingAmount + v.amount
            end
        end
        if tonumber(BillingAmount) <= 0 then
            SendNotificationPlayer(source, 'error',
                string.format(Locales[Config.Language]['invoiceamountcannotbezero'], Config.CurrencyUnit))
            return
        end
        local taxTotal = RoundToNearest(BillingAmount * Config.Tax)
        local TotalAmount = BillingAmount + taxTotal
        local GetMoney = GetPlayerMoney(source, 'bank')
        if tonumber(GetMoney) < tonumber(TotalAmount) then
            SendNotificationPlayer(source, 'error', Locales[Config.Language]['notenoughmoney'])
            return
        end
        billingdata.status = 'paid'
        local formatDay = GetFormattedDay()
        RemoveMoney(source, 'bank', TotalAmount)
        local JobsPlayers = ApprovedJobs[extractedString].personels
        local AllTotalAmount = Config.TaxToInvoiceHolder and TotalAmount or BillingAmount

        AddMoneyJobVault(extractedString, AllTotalAmount)
        UpdateClientSpendData(source, 'outgoing', formatDay, AllTotalAmount)
        AllPlayerData[identifier].spenddata.outgoing[formatDay] =
            AllPlayerData[identifier].spenddata.outgoing[formatDay] + AllTotalAmount
        ApprovedJobs[extractedString].spenddata.incoming[formatDay] =
            ApprovedJobs[extractedString].spenddata.incoming[formatDay] + AllTotalAmount
        UpdateJobSpendData(extractedString, 'incoming', formatDay, AllTotalAmount)
        UpdateJobSqlSpendData(extractedString, ApprovedJobs[extractedString].spenddata)
        for kk, v in pairs(JobsPlayers) do
            if v and v.identifier then
                local TargetID = GetPlayerIDFromIdentifier(v.identifier)
                if IsPlayerInGame(TargetID) then
                    TriggerClientEvent('codem-billing:client:paidedjobbilling', TargetID, extractedString,
                        billingdata.invoiceid)
                    TriggerClientEvent('codem-billing:client:jobupdatemoney', TargetID, extractedString,
                        ApprovedJobs[extractedString].vault)
                    SendNotificationPlayer(TargetID, 'info',
                        string.format(Locales[Config.Language]['billpaidedby'], GetName(source), AllTotalAmount,
                            Config.CurrencyUnit))
                end
            end
        end
        local OrjinalBillingReciver = billingdata.targetidentifier
        local OrjinalBillingReciverID = GetPlayerIDFromIdentifier(OrjinalBillingReciver)
        if IsPlayerInGame(OrjinalBillingReciverID) then
            if tonumber(source) == tonumber(OrjinalBillingReciverID) then
                TriggerClientEvent('codem-billing:client:paidedbilling', source, billingdata.invoiceid)
            else
                TriggerClientEvent('codem-billing:client:paidedbilling', tonumber(OrjinalBillingReciverID),
                    billingdata.invoiceid)
            end
        end

        if AdminData.AllBilling[billingdata.invoiceid] then
            AdminData.AllBilling[billingdata.invoiceid].status = 'paid'
            SendAdminData({
                events = {
                    { name = 'codem-billing:admin:updatebillstatus', data = { billingid = billingdata.invoiceid } },
                }
            })
        end


        UpdateSQLPaid(billingdata.invoiceid)
    end
end

function UpdateJobSqlSpendData(jobname, spenddata)
    local query = [[
        UPDATE codem_billing_job
        SET spenddata = @spenddata
        WHERE jobname = @jobname
    ]]

    local params = {
        ['@spenddata'] = json.encode(spenddata),
        ['@jobname'] = jobname
    }

    local success, result = pcall(function()
        SQLQuery(query, params)
    end)

    if not success then
        print("Error Update Job Spend Data: " .. result)
    end
end

function PaidTaxesJobBilling(jobname, billingdata, source)
    if billingdata.status == 'paid' then
        SendNotificationPlayer(source, 'error', Locales[Config.Language]['alreadybeedpaid'])
        return
    end
    local BillingAmount = 0
    for k, v in pairs(billingdata.reason) do
        if billingdata.overduestatus == 'true' then
            BillingAmount = BillingAmount + v.amount * 2
        else
            BillingAmount = BillingAmount + v.amount
        end
    end
    if tonumber(BillingAmount) <= 0 then
        SendNotificationPlayer(source, 'error',
            string.format(Locales[Config.Language]['invoiceamountcannotbezero'], Config.CurrencyUnit))
        return
    end
    local taxTotal = RoundToNearest(BillingAmount * Config.Tax)
    local TotalAmount = BillingAmount + taxTotal
    local GetMoney = GetPlayerMoney(source, 'bank')
    local AllTotalAmount = Config.TaxToInvoiceHolder and TotalAmount or BillingAmount
    if tonumber(GetMoney) < tonumber(AllTotalAmount) then
        SendNotificationPlayer(source, 'error', Locales[Config.Language]['notenoughmoney'])
        return
    end
    TriggerClientEvent('codem-billing:client:paidedbilling', source, billingdata.invoiceid)
    billingdata.status = 'paid'
    local formatDay = GetFormattedDay()
    RemoveMoney(source, 'bank', AllTotalAmount)
    UpdatePlayerMoney(source)


    ApprovedJobs[jobname].spenddata.outgoing[formatDay] =
        ApprovedJobs[jobname].spenddata.outgoing[formatDay] + AllTotalAmount
    UpdateJobSpendData(jobname, 'outgoing', formatDay, AllTotalAmount)
    UpdateJobSqlSpendData(jobname, ApprovedJobs[jobname].spenddata)
    UpdateAdminSqlSpendData(AllTotalAmount)
    local JobsPlayers = ApprovedJobs[jobname].personels or {}
    for k, v in pairs(JobsPlayers) do
        if v and v.identifier then
            local TargetID = GetPlayerIDFromIdentifier(v.identifier)
            if IsPlayerInGame(TargetID) then
                TriggerClientEvent('codem-billing:client:paidedjobbilling', TargetID, jobname,
                    billingdata.invoiceid)
                TriggerClientEvent('codem-billing:client:notification', TargetID, {
                    type = 'info',
                    label = Locales[Config.Language]['billhasbeedpaid']
                })
            end
        end
    end
    UpdateSQLPaid(billingdata.invoiceid)

    if AdminData.AllBilling[billingdata.invoiceid] then
        AdminData.AllBilling[billingdata.invoiceid].status = 'paid'
        SendAdminData({
            events = {
                { name = 'codem-billing:admin:updatebillstatus', data = { billingid = billingdata.invoiceid } },
            }
        })
    end
end

function PaidTaxesBilling(source, billingdata)
    if ApprovedJobs[billingdata.targetidentifier] then
        PaidTaxesJobBilling(billingdata.targetidentifier, billingdata, source)
        return
    end

    local identifier = GetIdentifier(source)
    if billingdata.status == 'paid' then
        SendNotificationPlayer(source, 'error', Locales[Config.Language]['alreadybeedpaid'])
        return
    end
    local BillingAmount = 0
    for k, v in pairs(billingdata.reason) do
        if billingdata.overduestatus == 'true' then
            BillingAmount = BillingAmount + v.amount * 2
        else
            BillingAmount = BillingAmount + v.amount
        end
    end
    if tonumber(BillingAmount) <= 0 then
        SendNotificationPlayer(source, 'error',
            string.format(Locales[Config.Language]['invoiceamountcannotbezero'], Config.CurrencyUnit))
        return
    end
    local taxTotal = RoundToNearest(BillingAmount * Config.Tax)
    local TotalAmount = BillingAmount + taxTotal
    local AllTotalAmount = Config.TaxToInvoiceHolder and TotalAmount or BillingAmount
    local GetMoney = GetPlayerMoney(source, 'bank')
    if tonumber(GetMoney) < tonumber(AllTotalAmount) then
        SendNotificationPlayer(source, 'error', Locales[Config.Language]['notenoughmoney'])
        return
    end
    TriggerClientEvent('codem-billing:client:paidedbilling', source, billingdata.invoiceid)
    billingdata.status = 'paid'
    local formatDay = GetFormattedDay()
    RemoveMoney(source, 'bank', AllTotalAmount)

    UpdatePlayerMoney(source)
    UpdateClientSpendData(source, 'outgoing', formatDay, AllTotalAmount)
    AllPlayerData[identifier].spenddata.outgoing[formatDay] =
        AllPlayerData[identifier].spenddata.outgoing[formatDay] + AllTotalAmount
    SendNotificationPlayer(source, 'info', Locales[Config.Language]['billpaid'])
    UpdateSQLPaid(billingdata.invoiceid)
    UpdateAdminSqlSpendData(AllTotalAmount)
    if AdminData.AllBilling[billingdata.invoiceid] then
        AdminData.AllBilling[billingdata.invoiceid].status = 'paid'
        SendAdminData({
            events = {
                { name = 'codem-billing:admin:updatebillstatus', data = { billingid = billingdata.invoiceid } },
            }
        })
    end
end

function UpdateAdminSqlSpendData(totalamount)
    local formatDay = GetFormattedDay()
    AdminData.SpendData[formatDay] = AdminData.SpendData[formatDay] + totalamount

    SendAdminData({
        events = {
            { name = 'codem-billing:admin:updatespenddata', data = { formatday = formatDay, amount = totalamount } },
        }
    })
    local query = [[
        UPDATE codem_billing_adminspenddata
        SET spenddata = @spenddata
    ]]

    local params = {
        ['@spenddata'] = json.encode(AdminData.SpendData)
    }

    local success, result = pcall(function()
        SQLQuery(query, params)
    end)

    if not success then
        print("Error Update SQL Spend Data: " .. result)
    end
end

function UpdateJobSpendData(jobname, type, formatday, totalamount)
    local JobPlayers = ApprovedJobs[jobname].personels or {}
    SendDataJobPlayers(JobPlayers, 'codem-billing:client:job:UpdateSpenddata', {
        type = type,
        jobname = jobname,
        day = formatday,
        amount = totalamount
    })
end

function UpdateClientSpendData(playerid, type, day, amount)
    TriggerClientEvent('codem-billing:client:updateSpendData', playerid, type, day, amount)
end

function UpdatePlayerMoney(src)
    local PlayerMoney = GetPlayerMoney(src, 'bank')
    TriggerClientEvent('codem-billing:updateplayermoney', src, PlayerMoney)
end

function UpdateSQLSpendData(identifier, data)
    local query = [[
        UPDATE codem_billing_player
        SET spenddata = @spenddata
        WHERE identifier = @identifier
    ]]

    local params = {
        ['@spenddata'] = json.encode(data),
        ['@identifier'] = identifier
    }

    local success, result = pcall(function()
        SQLQuery(query, params)
    end)

    if not success then
        print("Error Update SQL Spend Data: " .. result)
    end
end

function SendNotificationPlayer(src, type, label)
    TriggerClientEvent('codem-billing:client:notification', src, {
        type = type,
        label = label,
    })
end

function SendAdminData(data)
    for admin, players in pairs(AdminPlayers) do
        if data.events and type(data.events == 'table') then
            for _, event in pairs(data.events) do
                if event.name and event.data then
                    if players and IsPlayerInGame(players) then
                        TriggerClientEvent(event.name, tonumber(players), event.data)
                    end
                end
            end
        end
    end
end

function UpdateSQLPaid(invoiceid)
    local query = [[
        UPDATE codem_billing_data
        SET status = @status
        WHERE invoiceid = @invoiceid
    ]]

    local params = {
        ['@status'] = 'paid',
        ['@invoiceid'] = invoiceid
    }

    local success, result = pcall(function()
        SQLQuery(query, params)
    end)

    if not success then
        print("Error Pay Bill: " .. result)
    end
end

function PlayerLastUpdate(identifier)
    local query = [[
        UPDATE codem_billing_player
        SET last_update = @last_update
        WHERE identifier = @identifier
    ]]

    local params = {
        ['@last_update'] = os.time(),
        ['@identifier'] = identifier
    }

    local success, result = pcall(function()
        SQLQuery(query, params)
    end)

    if not success then
        print("Error Player Last Update: " .. result)
    end
end

function CreateSystemBilling(source, amount, label, isShowBilling)
    local extractedString = string.match(source, "^job_(.+)$")
    if extractedString then
        local BillingTotalAmount = 0
        local BillingData = {
            {
                amount = amount,
                reason = label
            }
        }
        for k, v in pairs(BillingData) do
            BillingTotalAmount = BillingTotalAmount + v.amount
        end
        if BillingTotalAmount <= 0 then
            return
        end

        if BillingTotalAmount > Config.MaxBillingAmount then
            return
        end
        local BillingID = GenerateId()
        local maxAttempts = 100
        local attempts = 0
        while UsingUniqueID[BillingID] do
            if attempts >= maxAttempts then
                print("Error: Unable to generate a unique BillingID after " .. maxAttempts .. " attempts.")
                return nil
            end

            BillingID = GenerateId()
            attempts = attempts + 1
            Citizen.Wait(0)
        end
        local OverdueDate = os.time() + (Config.OverDueDate * 24 * 60 * 60)
        local taxTotal = RoundToNearest(BillingTotalAmount * Config.Tax)
        local template = {
            identifier = 'systemtax',
            identifiername = 'System Tax',
            targetidentifier = extractedString,
            targetname = AllFrameworkJobs[extractedString].label,
            invoiceid = BillingID,
            status = 'unpaid',
            date = os.time(),
            formatdate = os.date('%d.%m.%Y', os.time()),
            overduedate = OverdueDate,
            formatoverduedate = os.date('%d.%m.%Y', OverdueDate),
            amount = BillingTotalAmount,
            reason = BillingData,
            overduestatus = 'false',
            billtype = 'system',
            totalAmount = BillingTotalAmount + taxTotal,
        }
        UsingUniqueID[BillingID] = BillingID
        ApprovedJobs[extractedString].billing[BillingID] = template
        local query = [[
            INSERT INTO codem_billing_data (identifier, identifiername, targetidentifier, targetname, invoiceid, status, date, overduedate, amount, reason, overduestatus, billtype, last_update)
            VALUES (@identifier, @identifiername, @targetidentifier, @targetname, @invoiceid, @status, @date, @overduedate, @amount, @reason, @overduestatus, @billtype, @last_update)
        ]]
        local params = {
            ['@identifier'] = template.identifier,
            ['@identifiername'] = template.identifiername,
            ['@targetidentifier'] = template.targetidentifier,
            ['@targetname'] = template.targetname,
            ['@invoiceid'] = template.invoiceid,
            ['@status'] = template.status,
            ['@date'] = template.date,
            ['@overduedate'] = template.overduedate,
            ['@amount'] = template.amount,
            ['@reason'] = json.encode(template.reason),
            ['@overduestatus'] = template.overduestatus,
            ['@billtype'] = template.billtype,
            ['@last_update'] = os.time()

        }
        local success, result = pcall(function()
            SQLQuery(query, params)
        end)

        if not success then
            print("Error Creating Personel Billing: " .. result)
        end
        local JobOnlinePlayers = ApprovedJobs[extractedString].personels
        for k, v in pairs(JobOnlinePlayers) do
            if v.id and IsPlayerInGame(v.id) then
                TriggerClientEvent('codem-billing:client:newjobbilling', v.id, extractedString, BillingID, template)
            end
        end

        AdminData.AllBilling[BillingID] = template
        SendAdminData({
            events = {
                { name = 'codem-billing:admin:newbilling', data = { billingid = BillingID, template = template } },
            }
        })
        return
    end
    local src = source
    src = tonumber(src)
    local PlayerData, identifier = GetBillingPlayerData(src)
    if not PlayerData then
        return
    end

    local BillingTotalAmount = 0
    local BillingData = {
        {
            amount = amount,
            reason = label
        }

    }
    for k, v in pairs(BillingData) do
        BillingTotalAmount = BillingTotalAmount + v.amount
    end
    if BillingTotalAmount <= 0 then
        return
    end

    if BillingTotalAmount > Config.MaxBillingAmount then
        return
    end
    local BillingID = GenerateId()
    local maxAttempts = 100
    local attempts = 0
    while UsingUniqueID[BillingID] do
        if attempts >= maxAttempts then
            print("Error: Unable to generate a unique BillingID after " .. maxAttempts .. " attempts.")
            return nil
        end

        BillingID = GenerateId()
        attempts = attempts + 1
        Citizen.Wait(0)
    end

    local OverdueDate = os.time() + (Config.OverDueDate * 24 * 60 * 60)
    local taxTotal = RoundToNearest(BillingTotalAmount * Config.Tax)
    local template = {
        identifier = 'systemtax',
        identifiername = Locales[Config.Language]['systemtax'],
        targetidentifier = identifier,
        targetname = GetName(src),
        invoiceid = BillingID,
        status = 'unpaid',
        date = os.time(),
        formatdate = os.date('%d.%m.%Y', os.time()),
        overduedate = OverdueDate,
        formatoverduedate = os.date('%d.%m.%Y', OverdueDate),
        amount = BillingTotalAmount,
        reason = BillingData,
        overduestatus = 'false',
        billtype = 'system',
        totalAmount = BillingTotalAmount + taxTotal,
    }
    UsingUniqueID[BillingID] = BillingID
    AllPlayerData[identifier].billing[BillingID] = template
    local query = [[
        INSERT INTO codem_billing_data (identifier, identifiername, targetidentifier, targetname, invoiceid, status, date, overduedate, amount, reason, overduestatus, billtype, last_update)
        VALUES (@identifier, @identifiername, @targetidentifier, @targetname, @invoiceid, @status, @date, @overduedate, @amount, @reason, @overduestatus, @billtype, @last_update)
    ]]
    local params = {
        ['@identifier'] = template.identifier,
        ['@identifiername'] = template.identifiername,
        ['@targetidentifier'] = template.targetidentifier,
        ['@targetname'] = template.targetname,
        ['@invoiceid'] = template.invoiceid,
        ['@status'] = template.status,
        ['@date'] = template.date,
        ['@overduedate'] = template.overduedate,
        ['@amount'] = template.amount,
        ['@reason'] = json.encode(template.reason),
        ['@overduestatus'] = template.overduestatus,
        ['@billtype'] = template.billtype,
        ['@last_update'] = os.time()

    }
    local success, result = pcall(function()
        SQLQuery(query, params)
    end)

    if not success then
        print("Error Creating Personel Billing: " .. result)
    end

    if IsPlayerInGame(src) then
        TriggerClientEvent('codem-billing:client:newbilling', src, BillingID, template, isShowBilling)
        SendNotificationPlayer(src, 'info', Locales[Config.Language]['youhaveanewbill'])
    end

    AdminData.AllBilling[BillingID] = template
    SendAdminData({
        events = {
            { name = 'codem-billing:admin:newbilling', data = { billingid = BillingID, template = template } },
        }
    })
end

local Caches = {
    Avatars = {}
}
local FormattedToken = "Bot " .. bot_Token
function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest(
        "https://discordapp.com/api/" .. endpoint,
        function(errorCode, resultData, resultHeaders)
            data = { data = resultData, code = errorCode, headers = resultHeaders }
        end,
        method,
        #jsondata > 0 and json.encode(jsondata) or "",
        { ["Content-Type"] = "application/json", ["Authorization"] = FormattedToken }
    )
    while data == nil do
        Citizen.Wait(0)
    end
    return data
end

function GetDiscordAvatar(user)
    local discordId = nil
    local imgURL = nil
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    if discordId then
        if Caches.Avatars[discordId] == nil then
            local endpoint = ("users/%s"):format(discordId)
            local member = DiscordRequest("GET", endpoint, {})
            if member.code == 200 then
                local data = json.decode(member.data)
                if data ~= nil and data.avatar ~= nil then
                    if (data.avatar:sub(1, 1) and data.avatar:sub(2, 2) == "_") then
                        imgURL = "https://media.discordapp.net/avatars/" .. discordId .. "/" .. data.avatar .. ".gif"
                    else
                        imgURL = "https://media.discordapp.net/avatars/" .. discordId .. "/" .. data.avatar .. ".png"
                    end
                end
            end
            Caches.Avatars[discordId] = imgURL
        else
            imgURL = Caches.Avatars[discordId]
        end
    end
    return imgURL
end
