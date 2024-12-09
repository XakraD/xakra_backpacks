CreateThread(function()
	if not LocalPlayer.state.IsInSession then
		repeat Wait(0) until LocalPlayer.state.IsInSession and LocalPlayer.state.Character and not IsLoadingScreenVisible() and not IsScreenFadedOut()
	end

    TriggerServerEvent('xakra_backpacks:Connected', true)
end)

local Backpack

RegisterNetEvent('xakra_backpacks:CreateBackpack')
AddEventHandler('xakra_backpacks:CreateBackpack', function(data)
    Backpack = CreateObject(data.Model, GetEntityCoords(PlayerPedId()), true, true, false)

    SetEntityCompletelyDisableCollision(Backpack, false, false)
    
    local BoneIndex = GetEntityBoneIndexByName(PlayerPedId(), data.Bone or 'CP_Back')
    AttachEntityToEntity(Backpack, PlayerPedId(), BoneIndex, data.Position, data.Rotation, true, true, false, true, 1, true)

    data.NetworkId = NetworkGetNetworkIdFromEntity(Backpack)
    LocalPlayer.state:set('Backpack', data, true)

    while LocalPlayer.state.Backpack do
        if not DoesEntityExist(Backpack) or not IsEntityAttached(Backpack) then
            TriggerServerEvent('xakra_backpacks:Connected')
            break
        end

        Wait(100)
    end
end)

RegisterNetEvent('xakra_backpacks:DeleteBackpack')
AddEventHandler('xakra_backpacks:DeleteBackpack', function(model)
    if DoesEntityExist(Backpack) then
        DeleteObject(Backpack)
        Backpack = nil
    end
end)

if Config.Overweight then
    AddEventHandler("vorp_inventory:Client:OnInvStateChange",function(boolean)
        if not boolean then
            TriggerServerEvent('xakra_backpacks:CheckOverweight')
        end
    end)
end

local Overweight = false

RegisterNetEvent('xakra_backpacks:Overweight')
AddEventHandler('xakra_backpacks:Overweight', function(Weight, invCapacity)
    if Overweight and Weight <= invCapacity then
        Overweight = false

    elseif not Overweight and Weight > invCapacity then
        Overweight = true

        while Overweight do
            -- DisableControlAction(0, joaat('INPUT_ENTER'), true)
            DisableControlAction(0, joaat('INPUT_SPRINT'), true)
            DisableControlAction(0, joaat('INPUT_VEH_ACCELERATE'), true)
            DisableControlAction(0, joaat('INPUT_VEH_BOAT_ACCELERATE'), true)
            SetPedMaxMoveBlendRatio(PlayerPedId(), 0.15)
            Wait(0)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    if DoesEntityExist(Backpack) then
        DeleteObject(Backpack)
    end
end)