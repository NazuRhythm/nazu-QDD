CURRENT_PROPS = {}

STATUS = STATUS_NORMAL
PLAYER_ZONE_NAME = nil
JOINED_SESSION_NAME = nil
MY_SCORE = nil
IS_PRESSED = false
IS_SUBTITLE_DISPLAYED = false
LAST_SUBTITLE_TIME = 0

function RESET_PLAYER_INFO()
    STATUS = STATUS_NORMAL
    PLAYER_ZONE_NAME = nil
    JOINED_SESSION_NAME = nil
    MY_SCORE = nil
    IS_PRESSED = false
    IS_SUBTITLE_DISPLAYED = false
    LAST_SUBTITLE_TIME = 0
end

function DISPLAY_SUBTITLE_FRAME(msg, duration)
    duration = duration or 1010

    local currentTime = GetGameTimer()

    if not IS_SUBTITLE_DISPLAYED or (currentTime - LAST_SUBTITLE_TIME > duration) then
        BeginTextCommandPrint("STRING")
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandPrint(duration, true)

        IS_SUBTITLE_DISPLAYED = true
        LAST_SUBTITLE_TIME = currentTime

        Citizen.SetTimeout(duration, function()
            IS_SUBTITLE_DISPLAYED = false
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
                    SetGameplayCamRelativeHeading(0)

                    SET_WEAPON(pedId, GetCurrentPedWeapon(pedId))

                    break
                end
            else
                markerColor = { 245, 66, 117 }
                DISPLAY_SUBTITLE_FRAME(Loc.DisplayText.go_to_your_position)
            end

            DRAW_MAIN_MARKER(20, MyPosition.x, MyPosition.y, MyPosition.z + 1.2, 1.0, 1.0, markerColor[1], markerColor[2], markerColor[3], 157)
            DRAW_UNDER_MARKER(23, MyPosition.x, MyPosition.y, MyPosition.z - 0.98, 2.0, 0.4, markerColor[1], markerColor[2], markerColor[3], 157)

        end

        TriggerServerEvent(resName..':server:SetPlayerStatus', STATUS_FINISHED_SETUPING)
    end)
end)

RegisterNetEvent(resName..':client:StartTheGame', function(ZoneName, index)
    
    local pedId = PlayerPedId()
    local playerId = PlayerId()
    local MyCoords = GetEntityCoords(pedId)
    local LeftCoords, RightCoords = 
        CALCULATE_OFFSET_POSITIONS(
            Config.Locations[ZoneName].coords,
            Config.Locations[ZoneName].heading,
            5.0
        )

    local MyPosition = index == 1 and LeftCoords or index == 2 and RightCoords or nil
    local MyPositionHeading = index == 1 and (Config.Locations[ZoneName].heading + 90) or index == 2 and (Config.Locations[ZoneName].heading - 90) or nil

    local BaseTimeOut = Config.Game.GameTimeOut
    local RondomChangeTime = BaseTimeOut / 2

    local CountDown = 3

    exports['nazu-bridge']:ShowCountDown(97, 235, 242, CountDown)
    Citizen.Wait(1000 * CountDown + 1500)

    STATUS = STATUS_PLAYING

    Citizen.CreateThread(function()
        while JOINED_SESSION_NAME ~= nil do

            DisablePlayerFiring(playerId, true)
    
            DISPLAY_SUBTITLE_FRAME(Loc.DisplayText.if_red_sphere_turns_green)
    
            if BaseTimeOut <= RondomChangeTime then
                DRAW_MAIN_MARKER(28, MyPosition.x, MyPosition.y, MyPosition.z + 1.2, 1.0, 1.0, 50, 250, 120, 157) 
            else
                DRAW_MAIN_MARKER(28, MyPosition.x, MyPosition.y, MyPosition.z + 1.2, 1.0, 1.0, 250, 50, 110, 157) 
            end
            
            if IS_PRESSED or BaseTimeOut <= 0.0 then
                
                if BaseTimeOut <= 0.0 then
                    MY_SCORE = Config.Game.GameTimeOut
                elseif BaseTimeOut >= RondomChangeTime then
                    MY_SCORE = Config.Game.GameTimeOut
                else
                    MY_SCORE = Config.Game.GameTimeOut - BaseTimeOut
                end
    
                TriggerServerEvent(resName..':server:SetScore', MY_SCORE)
    
                break
            end
    
            BaseTimeOut = BaseTimeOut - 1
    
            Citizen.Wait(1)
        end
    
        TriggerServerEvent(resName..':server:SetPlayerStatus', STATUS_FINISHED)
    end)
end)

RegisterNetEvent(resName..':client:FinishTheGame', function(IsWinner, score)
    local anim = 'misschinese2_bank5'
    local animName = 'peds_shootcans_a'
    local pedId = PlayerPedId()

    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Citizen.Wait(10)
    end

    SetEntityHeading(pedId, GetEntityHeading(pedId) + 180)
    TaskPlayAnim(pedId, anim, animName, 1.0, -1.0, 3000, 0, 1, false, false, false)
    Citizen.Wait(2800)

    local time = Config.DisplayScoreTime == 'sec' and tostring(score / 1000) .. ' SEC' or tostring(score) .. ' MS'

    if IsWinner == 'DRAW' then
        
        Citizen.CreateThread(function()
            exports['nazu-bridge']:ShowBanner(Loc.ScaleForm.draw, 'Time: ' .. tostring(time), 4)
        end)
        PlaySoundFrontend(-1, "Score_Up", "DLC_IE_PL_Player_Sounds", 1)

    else
        if IsWinner then
            Citizen.CreateThread(function()
                exports['nazu-bridge']:ShowBanner(Loc.ScaleForm.you_win, 'Time: ' .. tostring(time), 4)
            end)
            PlaySoundFrontend(-1, "Score_Up", "DLC_IE_PL_Player_Sounds", 1)
        else
            Citizen.CreateThread(function()
                exports['nazu-bridge']:ShowBanner(Loc.ScaleForm.you_lose, 'Time: ' .. tostring(time), 4)
            end)
        end 
    end

    FreezeEntityPosition(pedId, false)
    REMOVE_SELECTED_WEAPON()
    RESET_PLAYER_INFO()
end)

RegisterNetEvent(resName..':client:ForceFinishTheGame', function()

    FreezeEntityPosition(PlayerPedId(), false)
    REMOVE_SELECTED_WEAPON()
    RESET_PLAYER_INFO()

    Citizen.CreateThread(function()
        exports['nazu-bridge']:ShowBanner(Loc.ScaleForm.not_enough_players, '', 4)
    end)

    PlaySoundFrontend(-1, "Score_Up", "DLC_IE_PL_Player_Sounds", 1)
end)

RegisterNetEvent(resName..':client:SessionAction', function(ZoneName)
    if ZoneName ~= nil then
        JOINED_SESSION_NAME = ZoneName
    else
        RESET_PLAYER_INFO()
    end
end)