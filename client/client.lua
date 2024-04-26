CreateThread(function()
	if not LocalPlayer.state.IsInSession then
		repeat Wait(0) until LocalPlayer.state.IsInSession and LocalPlayer.state.Character and not IsLoadingScreenVisible() and not IsScreenFadedOut()
	end

    TriggerServerEvent('xakra_backpacks:Connected')
end)

local Backpack

RegisterNetEvent('xakra_backpacks:CreateBackpack')
AddEventHandler('xakra_backpacks:CreateBackpack', function(data)
    Backpack = CreateObject(data.Model, GetEntityCoords(PlayerPedId()), true, true, false)
    local BoneIndex = GetEntityBoneIndexByName(PlayerPedId(), 'CP_Back')
    AttachEntityToEntity(Backpack, PlayerPedId(), BoneIndex, data.Position, data.Rotation, true, true, false, true, 1, true)

    while LocalPlayer.state.Backpack do
        if not DoesEntityExist(Backpack) or not IsEntityAttached(Backpack) then

            if DoesEntityExist(Backpack) then
                DeleteObject(Backpack)
            end

            TriggerEvent('xakra_backpacks:CreateBackpack', data)
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

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    if DoesEntityExist(Backpack) then
        DeleteObject(Backpack)
    end
end)