Config = Config or {}

Config.Language = 'en'

Config.Notify = 'ox' -- 'ox' or 'okok' or 'custom'

Config.Locations = {

    ['wdd_1'] = {
        coords = vector3(-420.88, 1196.73, 325.64),
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
