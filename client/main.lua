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

                DRAW_MAIN_MARKER(22, coords.x, coords.y, coords.z + 2.0, 2.0, 2.0, 71, 249, 255, 155)
                DRAW_UNDER_MARKER(1, coords.x, coords.y, coords.z - 0.98, radius + 4.0, 0.6, 71, 249, 255, 155)
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

RegisterNetEvent(resName..':client:StartSetup', function()
    STATUS = STATUS_SETUPING
    local pedId = PlayerPedId()
    local anim = 'misschinese2_bank5'

    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Citizen.Wait(10)
    end

    TaskPlayAnim(pedId, anim, 'peds_shootcans_a', 1.0, -1.0, 5500, 0, 1, false, false, false)

    TriggerServerEvent(resName..':server:SetPlayerStatus', STATUS_FINISHED)
end)

RegisterNetEvent(resName..':client:StartTheGame', function()
    STATUS = STATUS_PLAYING
    local pedId = PlayerPedId()
    local anim = 'misschinese2_bank5'
    local animName = 'peds_shootcans_a'

    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Citizen.Wait(10)
    end

    Citizen.CreateThread(function()
        TaskPlayAnim(pedId, anim, animName, 1.0, -1.0, 5500, 0, 1, false, false, false)
    
        while IsEntityPlayingAnim(pedId, anim, animName, 3) do
            Citizen.Wait(100)
        end
    end)

    TriggerServerEvent(resName..':server:SetPlayerStatus', STATUS_FINISHED)
end)

RegisterNetEvent(resName..':client:SetJoiningSessionName', function(ZoneName)
    if ZoneName ~= nil then
        JOINED_SESSION_NAME = ZoneName
    else
        RESET_PLAYER_INFO()
    end
end)