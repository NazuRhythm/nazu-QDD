
function SHOW_HELP(msg, duration)
    BeginTextCommandDisplayHelp("THREESTRINGS")
    AddTextComponentSubstringPlayerName(msg)

    EndTextCommandDisplayHelp(0, false, true, 2000)
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

            PLAYER_ZONE_NAME = key
            START_MONITOR_PLAYER()
        else

            PLAYER_ZONE_NAME = nil

            if JOINED_SESSION_NAME ~= nil then
                TriggerServerEvent(resName..':server:RequestForceQuitPlayer')
                Citizen.CreateThread(function()
                    exports['nazu-bridge']:ShowScreenEffect('SwitchOpenMichaelOut', 1000)
                end)
                PlaySoundFrontend(-1, "Signal_On", "DLC_GR_Ambushed_Sounds", 1)
            end

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

function DrawMainMarker(marker, coord_x, coord_y, coord_z, scale, height, rgba_1, rgba_2, rgba_3, rgba_4)
    DrawMarker(
        marker,  -- kind of marker
        coord_x,
        coord_y,
        coord_z,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        scale,
        scale,
        height,
        rgba_1,
        rgba_2,
        rgba_3,
        rgba_4,
        false,
        true,
        2,
        true,
        nil,
        false
    )
end

function DrawUnderMarker(marker, coord_x, coord_y, coord_z, scale, height, rgba_1, rgba_2, rgba_3, rgba_4)
    DrawMarker(
        marker,  -- kind of marker
        coord_x,
        coord_y,
        coord_z,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        scale,
        scale,
        height,
        rgba_1,
        rgba_2,
        rgba_3,
        rgba_4,
        false,
        true,
        2,
        nil,
        nil,
        false
    )
end