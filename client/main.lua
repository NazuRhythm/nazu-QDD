CURRENT_PROPS = {}

STATUS = STATUS_NORMAL
PLAYER_ZONE_NAME = nil
JOINED_SESSION_NAME = nil

isSubtitleDisplayed = false
lastSubtitleTime = 0

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

function RESET_PLAYER_INFO()
    STATUS = STATUS_NORMAL
    PLAYER_ZONE_NAME = nil
    JOINED_SESSION_NAME = nil
end

function DISPLAY_SUBTITLE_FRAME(msg, duration)
    duration = duration or 1010

    local currentTime = GetGameTimer()

    if not isSubtitleDisplayed or (currentTime - lastSubtitleTime > duration) then
        BeginTextCommandPrint("STRING")
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandPrint(duration, true)

        isSubtitleDisplayed = true
        lastSubtitleTime = currentTime

        Citizen.SetTimeout(duration, function()
            isSubtitleDisplayed = false
        end)
    end
end

-- Create Blip
Citizen.CreateThread(function()
    for k, v in pairs(Config.Locations) do
        local coords = v.coords
        v.blip.coords = coords
        CREATE_BLIP(v.blip)
    end
end)

RegisterNetEvent(resName..':client:StartSetup', function(ZoneName, index)
    STATUS = STATUS_SETUPING
    local pedId = PlayerPedId()
    local MyCoords = GetEntityCoords(pedId)
    local LeftCoords, RightCoords = 
        CALCULATE_OFFSET_POSITIONS(
            Config.Locations[ZoneName].coords,
            Config.Locations[ZoneName].heading,
            2.0
        )

    local MyPosition = index == 1 and LeftCoords or index == 2 and RightCoords or nil
    local MyPositionHeading = index == 1 and (Config.Locations[ZoneName].heading + 90) or index == 2 and (Config.Locations[ZoneName].heading - 90) or nil
    local DistofPlayerBetweenPostion = GetDistanceBetweenCoords(MyCoords, MyPosition, false)

    local markerColor = {}
    
    Citizen.CreateThread(function()

        PlaySoundFrontend(-1, "Signal_On", "DLC_GR_Ambushed_Sounds", 1)

        while STATUS == STATUS_SETUPING do
            Citizen.Wait(0)

            MyCoords = GetEntityCoords(pedId)
            DistofPlayerBetweenPostion = GetDistanceBetweenCoords(MyCoords, MyPosition, true)

            if DistofPlayerBetweenPostion <= 0.7 then
                markerColor = { 3, 252, 152 }
                SHOW_HELP(Loc.HelpMsg.ready)
                DISPLAY_SUBTITLE_FRAME(Loc.DisplayText.press_button_to_ready)

                if IsControlJustPressed(0, 38) then

                    SetEntityCoords(pedId, MyPosition + vector3(0.0, 0.0, -0.98), true)
                    FreezeEntityPosition(pedId, true)
                    SetEntityHeading(pedId, MyPositionHeading)

                    Citizen.CreateThread(function()
                        Citizen.Wait(2000)

                        FreezeEntityPosition(pedId, false)
                    end)

                    STATUS = STATUS_FINISHED_SETUPING
                end
            else
                markerColor = { 245, 66, 117 }
                DISPLAY_SUBTITLE_FRAME(Loc.DisplayText.go_to_your_position)
            end

            DRAW_MAIN_MARKER(20, MyPosition.x, MyPosition.y, MyPosition.z + 1.2, 1.0, 1.0, markerColor[1], markerColor[2], markerColor[3], 157)
            DRAW_UNDER_MARKER(23, MyPosition.x, MyPosition.y, MyPosition.z - 0.98, 2.0, 0.4, markerColor[1], markerColor[2], markerColor[3], 157)

        end

        STATUS = STATUS_FINISHED_SETUPING
        TriggerServerEvent(resName..':server:SetPlayerStatus', STATUS_FINISHED_SETUPING)
    end)
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

RegisterNetEvent(resName..':client:ShowWinner', function(IsWinner)
    if IsWinner then
        
    else
        
    end

    RESET_PLAYER_INFO()
end)

RegisterNetEvent(resName..':client:SetJoiningSessionName', function(ZoneName)
    if ZoneName ~= nil then
        JOINED_SESSION_NAME = ZoneName
    else
        RESET_PLAYER_INFO()
    end
end)