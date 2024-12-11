Config = {}

Config.Backpacks = {
    {
        Item = 'backpack1',
        Weight = 100,
        Model = 'p_ambpack01x',
        Position = vector3(-0.5, 0.0, 0.08),
        Rotation = vector3(-80.0, 0.0, -90.0),
    },
    {
        Item = 'backpack2',
        Weight = 50,
        Model = 'p_ambpack02x',
        Position = vector3(-0.35, 0.0, 0.12),
        Rotation = vector3(-70.0, 0.0, -90.0),
    },
    {
        Item = 'backpack4',
        Weight = 20,
        Model = 'p_ambpack04x',
        Position = vector3(-0.2, -0.1, 0.06),
        Rotation = vector3(20.0, 0.0, -90.0),
    },
    {
        Item = 'knapsack1',
        Weight = 20,
        Model = 's_knapsack01x',
        Position = vector3(-0.13, 0.0, 0.01),
        Rotation = vector3(0.0, -100.0, 0.0),
    },
    {
        Item = 'backpack5',
        Weight = 20,
        Model = 'p_bag01x',
        Position = vector3(0.45, 0.0, 0.0),
        Rotation = vector3(0.0, -90.0, -65.0),
        Bone = 'skel_l_hand',
    },
}

-- You can use any of these images for the items: https://github.com/TankieTwitch/FREE-RedM-Image-Library/tree/main/images/%5Bbackpacks-storage%5D

-- Set initial weight when a player connects to the server. It will avoid weight gain bugs but by default.
Config.initInvCapacity = 35.0 -- number or false

-- Slow down the character if it exceeds the weight of the inventory
Config.Overweight = true    -- true or false