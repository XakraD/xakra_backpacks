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
        local Character = VORPcore.getUser(source).getUsedCharacter
        Character.updateInvCapacity(Backpack.Weight)
    
        Player(source).state:set('Backpack', Backpack, true)
    
        exports.vorp_inventory:closeInventory(source)

        TriggerClientEvent('xakra_backpacks:CreateBackpack', source, Backpack)
    end
end)

AddEventHandler('vorp_inventory:Server:OnItemRemoved', function(data, source)
    local Backpack = GetBackpack(data.name)

    if Backpack and Player(source).state.Backpack then
        local Character = VORPcore.getUser(source).getUsedCharacter
        Character.updateInvCapacity(- Backpack.Weight)

        Player(source).state:set('Backpack', nil, true)

        exports.vorp_inventory:closeInventory(source)

        TriggerClientEvent('xakra_backpacks:DeleteBackpack', source)
    end
end)

RegisterServerEvent('xakra_backpacks:Connected')
AddEventHandler('xakra_backpacks:Connected', function()
	local _source = source

    local UserInventoryItems = exports.vorp_inventory:getUserInventoryItems(_source)

    local Backpack

    for k, v in pairs(UserInventoryItems) do
        Backpack = GetBackpack(v.name)

        if Backpack then
            break
        end
    end

    if Backpack and not Player(_source).state.Backpack then
        local Character = VORPcore.getUser(_source).getUsedCharacter
        Character.updateInvCapacity(Backpack.Weight)

        Player(_source).state:set('Backpack', Backpack, true)

        exports.vorp_inventory:closeInventory(_source)

        TriggerClientEvent('xakra_backpacks:CreateBackpack', _source, Backpack)
    end
end)

AddEventHandler('playerDropped', function(reason)
    local _source = source

    if Player(_source).state.Backpack then
        local Character = VORPcore.getUser(_source).getUsedCharacter
        Character.updateInvCapacity(- Player(_source).state.Backpack.Weight)
    end
end)

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