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
    local _source = source
    local Backpack = GetBackpack(data.name)

    if Backpack and not Player(_source).state.Backpack then
        CreateBackpack(_source, Backpack)
    elseif Backpack and Player(_source).state.Backpack then
        RefreshBackpack(_source)
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

    for k, v in ipairs(UserInventoryItems) do
        if v.count >= 1 then
            local tempBackpack = GetBackpack(v.name)

            if tempBackpack then
                if not Backpack or tempBackpack.Weight > Backpack.Weight then
                    Backpack = tempBackpack
                end
            end
        end
    end

    if Backpack and not Player(_source).state.Backpack then
        CreateBackpack(_source, Backpack)
    end

    if Config.Overweight then
        CheckOverweight(_source)
    end
end)

function CreateBackpack(source, Backpack)
    if not Player(source).state.Backpack then
        local Character = VORPcore.getUser(source).getUsedCharacter
        Character.updateInvCapacity(Backpack.Weight)

        TriggerClientEvent('xakra_backpacks:CreateBackpack', source, Backpack)
    end
end

function RefreshBackpack(player)
    local UserInventoryItems = exports.vorp_inventory:getUserInventoryItems(player)
    local Backpack = nil

    for k, v in ipairs(UserInventoryItems) do
        if v.count >= 1 then
            local tempBackpack = GetBackpack(v.name)

            if tempBackpack then
                if not Backpack or tempBackpack.Weight > Backpack.Weight then
                    Backpack = tempBackpack
                end
            end
        end
    end

    if Player(player).state.Backpack then
        DeleteBackpack(player)
    end

    if Backpack then
        CreateBackpack(player, Backpack)
    end

    if Config.Overweight then
        CheckOverweight(player)
    end
end

AddEventHandler('vorp_inventory:Server:OnItemRemoved', function(data, source)
    local _source = source
    local Backpack = GetBackpack(data.name)

    if Backpack and Player(_source).state.Backpack and Player(_source).state.Backpack.Item == data.name then
		local backpackCount = exports.vorp_inventory:getItemCount(_source, nil, data.name)
		if backpackCount == 0 then
			DeleteBackpack(_source)
            RefreshBackpack(_source)
		end
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

if Config.Overweight then
    AddEventHandler('vorp_inventory:Server:OnItemCreated', function(data, source)
        CheckOverweight(source)
    end)

    AddEventHandler('vorp_inventory:Server:OnItemRemoved', function(data, source)
        CheckOverweight(source)
    end)
end

RegisterServerEvent('xakra_backpacks:CheckOverweight')
AddEventHandler('xakra_backpacks:CheckOverweight', function()
    local _source = source
    CheckOverweight(_source)
end)

function CheckOverweight(source)
    local Weight = 0

    local InventoryItems = exports.vorp_inventory:getUserInventoryItems(source)

    for i, v in pairs(InventoryItems) do
        Weight = Weight + (v.weight * v.count)
    end

    local InventoryWeapons = exports.vorp_inventory:getUserInventoryWeapons(source)

    for i, v in pairs(InventoryWeapons) do
        Weight = Weight + v.weight
    end

    local Character = VORPcore.getUser(source).getUsedCharacter

    TriggerClientEvent('xakra_backpacks:Overweight', source, Weight, Character.invCapacity)
end

RegisterCommand("ruck1", function(source --[[ this is the player ID (on the server): a number ]], args --[[ this is a table of the arguments provided ]], rawCommand --[[ this is what the user entered ]])
    exports.vorp_inventory:addItem(source, "rucksack2", 1, {}, nil)
end, false)

RegisterCommand("ruck2", function(source --[[ this is the player ID (on the server): a number ]], args --[[ this is a table of the arguments provided ]], rawCommand --[[ this is what the user entered ]])
    exports.vorp_inventory:addItem(source, "rucksack3", 1, {}, nil)
end, false)