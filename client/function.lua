
function SHOW_HELP(msg, duration)
    BeginTextCommandDisplayHelp("THREESTRINGS")
    AddTextComponentSubstringPlayerName(msg)

    EndTextCommandDisplayHelp(0, false, true)
end

function CREATE_BLIP(v)
    local blip = AddBlipForCoord(v.coords)
    SetBlipAsShortRange(blip, true)
    SetBlipSprite(blip, v.sprite or 1)
    SetBlipColour(blip, v.color or 0)
    SetBlipScale(blip, v.scale or 0.7)
	SetBlipDisplay(blip, (6))
    BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(tostring(v.label))
    EndTextCommandSetBlipName(blip)
end

function CREATE_PROPS_AND_ZONE()
    -- local model = `nz_prop_arm_wrestle_01`
    local model = `prop_arm_wrestle_01`
    if Config.Locations ~= nil then
        for k, v in pairs(Config.Locations) do
            local coords = v.coords
            local CreatedProp = CreateObject(
                model,
                coords.x, coords.y, coords.z - 0.98,
                false,
                true,
                false
            )
            FreezeEntityPosition(CreatedProp, true)
            
            local radius = v.radius
            local createdPoly = CREATE_PROP_POLYZONE(k, coords, radius)
            
            CURRENT_PROPS[k] = {
                prop = CreatedProp,
                poly = createdPoly
            }
        end
    else
        print('not founded some locations....')
    end
end

function CREATE_PROP_POLYZONE(key, coords, radius) 

    local polyZone = CircleZone:Create(coords, radius, 
        {
            name = key,
            useZ = true,
            debugPoly = Config.DebugMode.ShowPolyZone or false
        })

    polyZone:onPlayerInOut(function(isInside)
        if isInside then
            print('[PolyZone Log] PlayerIn ', key)

            PLAYER_ZONE_NAME = key
            START_MONITOR_PLAYER()
        else
            print('[PolyZone Log] PlayerOut', key)

            PLAYER_ZONE_NAME = nil
        end
    end)

    return polyZone
end

function DELETE_PROPS_AND_ZONE()
    if next(CURRENT_PROPS) ~= nil then
        for k, v in pairs(CURRENT_PROPS) do
            DeleteEntity(v.prop)
            v.poly:destroy()
        end
    end
end