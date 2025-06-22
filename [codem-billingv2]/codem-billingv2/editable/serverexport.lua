--[[
	What will this code send back ?
	{
		invoiceid = 'string',
		amount = 'number',
		reason = 'string',
		id = 'string',
	}
]]
function GetPlayerUnpaidBillings(source)
	local billings = {}
	local src = source
	local PlayerData, identifier = GetBillingPlayerData(src)
	if not PlayerData then
		return
	end

	for k, v in pairs(PlayerData.billing) do
		if v.status == 'unpaid' then
			local billingamount = 0
			for i, j in pairs(v.reason) do
				billingamount = billingamount + tonumber(j.amount)
			end
			local taxTotal = RoundToNearest(tonumber(billingamount) * tonumber(Config.Tax))
			local AllTotalAmount = billingamount + taxTotal
			local templatedata = {
				invoiceid = k,
				amount = AllTotalAmount,
				reason = v.reason[1].reason,
				id = v.invoiceid,
			}
			table.insert(billings, templatedata)
		end
	end
	return billings
end

exports("GetPlayerUnpaidBillings", GetPlayerUnpaidBillings)

--[[
	source = 'number',
	invoiceid = 'string',
]]
function PayBilling(source, invoiceid)
	local src = source
	local PlayerData, identifier = GetBillingPlayerData(src)
	if not PlayerData then
		return
	end

	if not PlayerData.billing[invoiceid] then
		return
	end

	PayBill(src, invoiceid)
end

exports("PayBilling", PayBilling)

--[[
	source = 'number',
	invoiceid = 'string',
]]
function GetBillingDetails(source, invoiceid)
	local src = source
	local PlayerData, identifier = GetBillingPlayerData(src)
	if not PlayerData then
		return
	end

	return PlayerData.billing[invoiceid].reason or {}
end

exports("GetBillingDetails", GetBillingDetails)

--[[
	source = 'number',
	invoiceid = 'string',
]]
function CancelBillingID(source, invoiceid)
	local src = source
	local PlayerData, identifier = GetBillingPlayerData(src)
	if not PlayerData then
		return
	end

	CancelAdminAwaitingBill(src, invoiceid)
end

exports("CancelBillingID", CancelBillingID)

--[[
	source = 'number',
	amount = 'number',
	reason = 'string',
	isShowBilling = 'boolean', -- if true, it will show the billing ui
]]
function CreateBillingSystem(source, amount, reason, isShowBilling)
	if isShowBilling == nil then
		isShowBilling = false
	end
	local src = source
	local PlayerData, identifier = GetBillingPlayerData(src)
	if not PlayerData then
		return
	end
	CreateSystemBilling(src, amount, reason, isShowBilling)
end

exports("CreateBillingSystem", CreateBillingSystem)


--[[
	source = 'number',
	targetplayerid = 'number',
	amount = 'number',
	reason = 'string',
]]

function CreateBillingJob(source, targetplayerid, amount, reason)
	local reaonstable = {
		{
			amount = amount,
			reason = reason,
		}
	}
	CreateBillingForJob(source, {
		targetplayerdata = {
			id = targetplayerid
		},
		reasons = reaonstable,
	})
end

exports("CreateBillingJob", CreateBillingJob)



function CheckBilling(source)
	local src = source
	local PlayerData, identifier = GetBillingPlayerData(src)
	if not PlayerData then
		return
	end
	local found = false
	for k, v in pairs(PlayerData.billing) do
		if v.status == 'unpaid' then
			found = true
			break
		end
	end
	return found
end

exports("CheckBilling", CheckBilling)
