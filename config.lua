Config = Config or {}

Config.Language = 'en' -- 'en' or 'ja'

Config.Notify = 'ox' -- 'ox' or 'okok' or 'custom'

Config.PropModel = joaat('nz_prop_arm_wrestle_01')

Config.DisplayScoreTime = 'sec' -- 'sec' or 'ms'

Config.Game = { 

    GameTimeOut = 500, -- Do not touch

    KeyMapping = {
        Click = 'MOUSE_LEFT',
    },
}

Config.Locations = {

    ['wdd_1'] = {
        coords = vector3(1771.94, 3274.95, 41.51),
        heading = 342.88,
        radius = 5.0,
        blip = {
            label = 'Quick Draw Duel',
            sprite = 458,
            scale = 0.8,
            color = 60,
        },
    },

    ['wdd_2'] = {
        coords = vector3(192.1, -847.36, 30.96),
        heading = 336.16,
        radius = 5.0,
        blip = {
            label = 'Quick Draw Duel',
            sprite = 458,
            scale = 0.8,
            color = 60,
        },
    },

    ['wdd_3'] = {
        coords = vector3(1844.71, 3665.97, 33.87),
        heading = 216.21,
        radius = 5.0,
        blip = {
            label = 'Quick Draw Duel',
            sprite = 458,
            scale = 0.8,
            color = 60,
        },
    },

    ['wdd_4'] = {
        coords = vector3(-198.87, 6218.2, 31.49),
        heading = 355.14,
        radius = 5.0,
        blip = {
            label = 'Quick Draw Duel',
            sprite = 458,
            scale = 0.8,
            color = 60,
        },
    },

    ['wdd_5'] = {
        coords = vector3(-1259.03, -1480.19, 4.34),
        heading = 304.45,
        radius = 5.0,
        blip = {
            label = 'Quick Draw Duel',
            sprite = 458,
            scale = 0.8,
            color = 60,
        },
    },
}

Config.DebugMode = {
    ShowPolyZone = false,
}
