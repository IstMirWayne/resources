function InitMenu()
    if Config.InteractionHandler == 'ox_target' then
        exports.ox_target:addBoxZone({
            name = 'approval-billing',
            coords = vector3(Config.ApprovalBilling.NpcCoords.x, Config.ApprovalBilling.NpcCoords.y,
                Config.ApprovalBilling.NpcCoords.z),
            size = vec3(3.6, 3.6, 3.6),
            drawSprite = true,
            options = {
                {
                    name = 'approval-billing-open',
                    onSelect = function()
                        TriggerEvent('codem-billing:openApprovalMenu')
                    end,
                    icon = 'fas fa-gears',
                    label = 'Billing Approval'
                }
            }
        })
    end
    if Config.InteractionHandler == 'qb_target' then
        exports['qb-target']:AddBoxZone(
            'approval-billing',
            vector3(Config.ApprovalBilling.NpcCoords.x, Config.ApprovalBilling.NpcCoords.y,
                Config.ApprovalBilling.NpcCoords.z),
            1.5, 1.6,
            {
                name = 'approval-billing',
                heading = 12.0,
                debugPoly = false,
                minZ = Config.ApprovalBilling.NpcCoords.z - 1,
                maxZ = Config.ApprovalBilling.NpcCoords.z + 2,
            },
            {
                options = {
                    {
                        num = 1,
                        type = "client",
                        icon = 'fas fa-gears',
                        label = 'Billing Approval',
                        targeticon = 'fas fa-gears',
                        action = function()
                            TriggerEvent('codem-billing:openApprovalMenu')
                        end
                    }
                },
                distance = 2.5,
            }
        )
    end
    local validHandlers = {
        qb_textui = true,
        esx_textui = true,
        drawtext = true,
        codem_textui = true,
        okok_textui = true,
        eth_textUi = true
    }

    if validHandlers[Config.InteractionHandler] then
        CreateThread(function()
            local textUiStates = false
            while true do
                local cd = 1500
                local plyCoords = GetEntityCoords(PlayerPedId())
                local PedCoords = vector3(Config.ApprovalBilling.NpcCoords.x, Config.ApprovalBilling.NpcCoords.y,
                    Config.ApprovalBilling.NpcCoords.z)

                local dist = #(PedCoords - plyCoords)

                if dist < 3.00 then
                    cd = 0

                    if not textUiStates then
                        OpenTextUI()
                        textUiStates = true
                    end

                    if Config.InteractionHandler == 'drawtext' then
                        DrawText3D(PedCoords.x, PedCoords.y, PedCoords.z + 1.0, Locales[Config.Language]['presse'])
                    end

                    if IsControlJustPressed(0, 38) then
                        TriggerEvent('codem-billing:openApprovalMenu')
                    end
                else
                    if textUiStates then
                        CloseTextUI()
                        textUiStates = false
                    end
                end
                Wait(cd)
            end
        end)
    end
end

RegisterNetEvent('codem-billing:openApprovalMenu', function()
    SetNuiFocus(true, true)
    NuiMessage('OPEN_APPROVAL_MENU')
end)

RegisterNUICallback('CloseApprovalMenu', function(body, resultCallback)
    SetNuiFocus(false, false)
end)


function OpenTextUI()
    local shopText = Locales[Config.Language]['presse']
    if Config.InteractionHandler == 'codem_textui' then
        print('codem_textui')
        exports["codem-textui"]:OpenTextUI(shopText, 'E', 'thema-1')
    elseif Config.InteractionHandler == 'okok_textui' then
        exports['okokTextUI']:Open(shopText, 'green', 'left')
    elseif Config.InteractionHandler == 'eth_textUi' then
        exports['eth-textUi']:Show('', shopText)
    elseif Config.InteractionHandler == 'qb_textui' then
        TriggerEvent('qb-core:client:DrawText', shopText, 'left')
    elseif Config.InteractionHandler == 'esx_textui' then
        TriggerEvent('ESX:TextUI', shopText)
    end
end

function CloseTextUI()
    if Config.InteractionHandler == 'codem_textui' then
        exports["codem-textui"]:CloseTextUI()
    end
    if Config.InteractionHandler == 'okok_textui' then
        exports['okokTextUI']:Close()
    end
    if Config.InteractionHandler == 'eth_textUi' then
        exports['eth-textUi']:Close()
    end
    if Config.InteractionHandler == 'esx_textui' then
        TriggerEvent('ESX:HideUI')
    end
    if Config.InteractionHandler == 'qb_textui' then
        TriggerEvent('qb-core:client:HideText')
    end
end
