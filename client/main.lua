CURRENT_PROPS = {}

STATUS = STATUS_NORMAL
PLAYER_ZONE_NAME = nil
JOINED_SESSION_NAME = nil

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

                DrawMainMarker(42, coords.x, coords.y, coords.z + 2.0, 2.0, 2.0, 71, 249, 255, 155)
                DrawUnderMarker(1, coords.x, coords.y, coords.z - 0.98, radius + 4.0, 0.6, 71, 249, 255, 155)

            end
            
            if IsControlJustPressed(0, 38) then
                SHOW_ALERT_DIALOG()
            end
        end
    end)
end

function RESET_PLAYER_INFO()
    STATUS = STATUS_NORMAL
    PLAYER_ZONE_NAME = nil
    JOINED_SESSION_NAME = nil
end

-- Create Blip
Citizen.CreateThread(function()
    for k, v in pairs(Config.Locations) do
        local coords = v.coords
        v.blip.coords = coords
        CREATE_BLIP(v.blip)
    end
end)


RegisterNetEvent(resName..':client:SetJoiningSessionName', function(ZoneName)
    if ZoneName ~= nil then
        JOINED_SESSION_NAME = ZoneName
    else
        RESET_PLAYER_INFO()
    end
end)