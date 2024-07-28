Config = Config or {}

Config.Language = 'en'

Config.Notify = 'ox' -- 'ox' or 'okok' or 'custom'

Config.Game = { 
    GameTimeOut = 2300,

    KeyMapping = {
        Click = 'MOUSE_LEFT',
    },
}

Config.Locations = {

    ['wdd_1'] = {
        coords = vector3(-420.88, 1196.73, 325.64),
        heading = 342.88,
        radius = 5.0,
        blip = {
            label = 'Quick Draw Duel',
            sprite = 160,
            scale = 0.7,
            color = 26,
        },
    },

    ['wdd_2'] = {
        coords = vector3(-392.66, 1186.59, 325.64),
        heading = 49.11,
        radius = 5.0,
        blip = {
            label = 'Quick Draw Duel',
            sprite = 160,
            scale = 0.7,
            color = 26,
        },
    },


}

Config.DebugMode = {
    ShowPolyZone = false,
}
