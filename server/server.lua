local VORPcore = exports.vorp_core:GetCore()

function GetBackpack(ItemName)
    for _, v in pairs(Config.Backpacks) do
        if ItemName == v.Item then
            return v
        end
    end

    return false
end

AddEventHandler('vorp_inventory:Server:OnItemCreated', function(data, source)
    local Backpack = GetBackpack(data.name)

    if Backpack and not Player(source).state.Backpack then
        CreateBackpack(source, Backpack)
    end
end)

RegisterServerEvent('xakra_backpacks:Connected')
AddEventHandler('xakra_backpacks:Connected', function(Connected)
	local _source = source

    if Connected and Config.initInvCapacity and type(Config.initInvCapacity) == 'number' then
        local Character = VORPcore.getUser(_source).getUsedCharacter
        local slots = Config.initInvCapacity - Character.invCapacity

        if slots < 0 then
            Character.updateInvCapacity(slots)
        end
    end

    DeleteBackpack(_source)

    local UserInventoryItems = exports.vorp_inventory:getUserInventoryItems(_source)

    local Backpack

    for k, v in pairs(UserInventoryItems) do
        Backpack = GetBackpack(v.name)

        if Backpack then
            break
        end
    end

    if Backpack and not Player(_source).state.Backpack then
        CreateBackpack(_source, Backpack)
    end
end)

function CreateBackpack(source, Backpack)
    if not Player(source).state.Backpack then
        local Character = VORPcore.getUser(source).getUsedCharacter
        Character.updateInvCapacity(Backpack.Weight)

        TriggerClientEvent('xakra_backpacks:CreateBackpack', source, Backpack)
    end
end

AddEventHandler('vorp_inventory:Server:OnItemRemoved', function(data, source)
    local Backpack = GetBackpack(data.name)

    if Backpack and Player(source).state.Backpack then
        DeleteBackpack(source)
    end
end)

AddEventHandler('playerDropped', function(reason)
    local _source = source

    DeleteBackpack(_source)
end)

function DeleteBackpack(source)
    if Player(source).state.Backpack then
        local Character = VORPcore.getUser(source).getUsedCharacter
        Character.updateInvCapacity(- Player(source).state.Backpack.Weight)

        local entity = NetworkGetEntityFromNetworkId(Player(source).state.Backpack.NetworkId)

        if DoesEntityExist(entity) then
            DeleteEntity(entity)
        end

        Player(source).state:set('Backpack', nil, true)
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    for _, source in pairs(GetPlayers()) do
        if Player(source).state.Backpack then
            local Character = VORPcore.getUser(source).getUsedCharacter
            Character.updateInvCapacity(- Player(source).state.Backpack.Weight)

            Player(source).state:set('Backpack', nil, true)
        end
    end
end)