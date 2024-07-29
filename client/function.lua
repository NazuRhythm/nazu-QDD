
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

    if Config.Locations ~= nil then
        for k, v in pairs(Config.Locations) do
            local coords = v.coords
            local CreatedProp = CreateObject(
                Config.PropModel,
                coords.x, coords.y, coords.z - 0.98,
                false,
                true,
                false
            )
            SetEntityHeading(CreatedProp, v.heading)
            FreezeEntityPosition(CreatedProp, true)
            
            local radius = v.radius
            local createdPoly = CREATE_PROP_POLYZONE(k, coords, radius)
            
            CURRENT_PROPS[k] = {
                prop = CreatedProp,
                poly = createdPoly
            }
        end
    else
        -- print('not founded some locations....')
    end
end

function START_MONITOR_PLAYER()
    Citizen.CreateThread(function()
        local coords = Config.Locations[PLAYER_ZONE_NAME].coords
        local radius = Config.Locations[PLAYER_ZONE_NAME].radius
        while PLAYER_ZONE_NAME ~= nil and not STATUS ~= STATUS_PLAYING do
            Citizen.Wait(0)
            
            if STATUS == STATUS_NORMAL then
                SHOW_HELP(Loc.HelpMsg.you_wana_join)
            elseif STATUS == STATUS_WAITING then
                SHOW_HELP(Loc.HelpMsg.you_wana_quit)

                DRAW_MAIN_MARKER(21, coords.x, coords.y, coords.z + 2.0, 2.0, 2.0, 71, 249, 255, 155)
                DRAW_UNDER_MARKER(1, coords.x, coords.y, coords.z - 0.98, radius + 4.0, 0.6, 71, 249, 255, 155)
            end
            
            if IsControlJustPressed(0, 38) then
                SHOW_ALERT_DIALOG()
            end
        end
    end)
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

            if JOINED_SESSION_NAME ~= nil and STATUS == STATUS_WAITING then
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

function DISPLAY_SUBTITLE_FRAME(msg)
    SetTextEntry_2("STRING")
    AddTextComponentString(msg)
    DrawSubtitleTimed(1010, 1)
end

function CALCULATE_OFFSET_POSITIONS(position, heading, offsetDistance)
    local headingRad = math.rad(heading)
    
    local forwardX = math.sin(headingRad)
    local forwardY = -math.cos(headingRad)
    
    local rightX = -forwardY
    local rightY = forwardX
    
    local leftPosition = vector3(
        position.x + (rightX * -offsetDistance),
        position.y + (rightY * -offsetDistance),
        position.z
    )
    
    local rightPosition = vector3(
        position.x + (rightX * offsetDistance),
        position.y + (rightY * offsetDistance),
        position.z
    )
    
    return leftPosition, rightPosition
end

function SET_WEAPON(pId, currentWeapon)
    local weaponHash = GetHashKey(WEAPON_NZQDD)

    if currentWeapon ~= weaponHash then

        if not HasPedGotWeapon(pId, weaponHash, false) then
            
            GiveWeaponToPed(pId, weaponHash, 0, false, true)
        else

            SetCurrentPedWeapon(pId, weaponHash, true)
        end
    end
end

function CHECK_IS_UNARMED(pId, MAP_NAME, currentWeapon)
    local weaponHash = GetHashKey(WEAPON_NZ_UNARMED)
    if currentWeapon ~= weaponHash then
        SetCurrentPedWeapon(pId, weaponHash, true)
    end
end

function CHECK_IS_NZQDD(pId, MAP_NAME, currentWeapon)
    local weaponHash = GetHashKey(WEAPON_NZQDD)
    if currentWeapon ~= weaponHash then
        SetCurrentPedWeapon(pId, weaponHash, true)
    end
end

function REMOVE_SELECTED_WEAPON()
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    local unarmed = GetHashKey(WEAPON_NZ_UNARMED)

    if weapon ~= unarmed then
        SetCurrentPedWeapon(ped, unarmed, true)
    end

    RemoveWeaponFromPed(ped, GetHashKey(WEAPON_NZQDD))
end

function DRAW_MAIN_MARKER(marker, coord_x, coord_y, coord_z, scale, height, rgba_1, rgba_2, rgba_3, rgba_4)
    DrawMarker(
        marker,  -- kind of marker
        coord_x,
        coord_y,
        coord_z,
        0.0,
        0.0,
        0.0,
        0.0,
        180.0,
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

function DRAW_UNDER_MARKER(marker, coord_x, coord_y, coord_z, scale, height, rgba_1, rgba_2, rgba_3, rgba_4)
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