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
}

-- Set initial weight when a player connects to the server. It will avoid weight gain bugs but by default.
Config.initInvCapacity = 35.0 -- number or false