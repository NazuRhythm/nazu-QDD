CURRENT_PROPS = {}

STATUS = STATUS_NORMAL
QDW_LOCATIONS = {}
PLAYER_ZONE_NAME = nil

function START_MONITOR_PLAYER()
    Citizen.CreateThread(function()
        while PLAYER_ZONE_NAME ~= nil and STATUS == STATUS_NORMAL do
            Citizen.Wait(0)
            local playerCoords = GetEntityCoords(PlayerPedId())
            
            for k, v in pairs(Config.Locations) do
                local distance = #(playerCoords - v.coords)
                
                if distance <= 2.5 then
                    if not QDW_LOCATIONS[k] then
                        SHOW_HELP(Loc.HelpMsg)
                        QDW_LOCATION_NAME = k
                        QDW_LOCATIONS[k] = true
    
                        if IsControlJustPressed(0, 38) then
                            SHOW_ALERT_DIALOG(Loc.JoinMenu.header, Loc.JoinMenu.message)
                        end
                    end
                else
                    QDW_LOCATION_NAME = nil
                    QDW_LOCATIONS[k] = false
                end
            end
        end
    end)
end

-- Create Blip
Citizen.CreateThread(function()
    for k, v in pairs(Config.Locations) do
        local coords = v.coords
        v.blip.coords = coords
        CREATE_BLIP(v.blip)
    end
end)
