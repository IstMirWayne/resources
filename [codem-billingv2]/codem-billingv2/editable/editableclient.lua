local tabletProp = nil
local function LoadAnimDict(dict)
	if HasAnimDictLoaded(dict) then return end

	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Wait(10)
	end
end


Citizen.CreateThread(function()
	while not NuiLoaded and Core == nil do
		Citizen.Wait(0)
	end
	RegisterKeyMapping('openbillingmenu', 'Billing Menu', 'keyboard', Config.OpenBillingMenuKey)

	RegisterCommand('openbillingmenu', function()
		OpenBillingMenu()
	end, false)
end)

function OpenBillingMenu()
	if not Info.PlayerInfo then
		return
	end
	local PlayerMoney = TriggerCallback('codem-billing:getPlayerMoney')
	NuiMessage('UPDATE_MONEY', PlayerMoney)
	local playerPed = PlayerPedId()
	if not tabletProp then
		LoadAnimDict("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a")
		tabletProp = CreateObject(Config.TabletPropName, 0, 0, 0, true, true, true)
		AttachEntityToEntity(tabletProp, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, -0.02, 0.0, 90.0, -180.0, 0.0,
			true,
			true,
			false, true, 1, true)
		TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", 8.0, -8.0, -1,
			50,
			0, false, false, false)
		SetNuiFocus(true, true)
		NuiMessage("OPEN_BILLING_MENU")
	else
		SetNuiFocus(true, true)
		NuiMessage("OPEN_BILLING_MENU")
	end
end

function CloseBillingMenu()
	SetNuiFocus(false, false)
	if tabletProp then
		DeleteEntity(tabletProp)
	end
	tabletProp = nil
	ClearPedTasks(PlayerPedId())
end

AddEventHandler('onResourceStop', function(resourceName)
	if (resourceName == GetCurrentResourceName()) then
		CloseBillingMenu()
	end
end)
