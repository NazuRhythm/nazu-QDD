CURRENT_PROPS = {}

STATUS = STATUS_NORMAL
PLAYER_ZONE_NAME = nil
JOINED_SESSION_NAME = nil
MY_SCORE = nil

IS_PRESSED = false

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
    MY_SCORE = nil

    IS_PRESSED = false
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

        STATUS = STATUS_FINISHED_SETUPING
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
    local RondomChangeTime = math.random(BaseTimeOut / 2, BaseTimeOut)

    local CountDown = 3

    exports['nazu-bridge']:ShowCountDown(97, 235, 242, CountDown)
    Citizen.Wait(1000 * CountDown + 1500)

    -- local gunHash = GetHashKey("w_pi_wep1_gun")
    -- RequestModel(gunHash)
    -- while not HasModelLoaded(gunHash) do
    --     Wait(500)
    -- end

    -- local coords = GetEntityCoords(pedId)
    -- local gun = CreateObject(gunHash, coords.x, coords.y, coords.z, true, true, true)

    -- local boneIndex = GetPedBoneIndex(pedId, 57005)
    -- AttachEntityToEntity(gun, pedId, boneIndex, 0.13, 0.05, 0.02, 90.0, 90.0, 0.0, true, true, false, true, 1, true)

    STATUS = STATUS_PLAYING

    while true do
        Citizen.Wait(0)

        DisablePlayerFiring(playerId, true)

        DISPLAY_SUBTITLE_FRAME('~r~赤い球体~s~が~g~緑色~s~になったらマウス左クリック！！')

        if BaseTimeOut <= RondomChangeTime then
            DRAW_MAIN_MARKER(28, MyPosition.x, MyPosition.y, MyPosition.z + 1.2, 1.0, 1.0, 50, 250, 120, 157) 
        else
            DRAW_MAIN_MARKER(28, MyPosition.x, MyPosition.y, MyPosition.z + 1.2, 1.0, 1.0, 250, 50, 110, 157) 
        end
        
        if IS_PRESSED or BaseTimeOut <= 0.0 then
            
            if BaseTimeOut <= 0.0 then
                MY_SCORE = Config.Game.GameTimeOut
            elseif BaseTimeOut <= RondomChangeTime then
                MY_SCORE = 2.0
            else
                MY_SCORE = 100.0
            end

            TriggerServerEvent(resName..':server:SetScore', MY_SCORE)

            break
        end

        BaseTimeOut = BaseTimeOut - 1
    end

    TriggerServerEvent(resName..':server:SetPlayerStatus', STATUS_FINISHED)
end)

RegisterNetEvent(resName..':client:FinishTheGame', function(IsWinner)
    local anim = 'misschinese2_bank5'
    local animName = 'peds_shootcans_a'
    local pedId = PlayerPedId()

    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Citizen.Wait(10)
    end

    SetEntityHeading(pedId, GetEntityHeading(pedId) + 180)

    -- Citizen.CreateThread(function()

        TaskPlayAnim(pedId, anim, animName, 1.0, -1.0, 3000, 0, 1, false, false, false)

    -- end)

    Citizen.Wait(2800)


    if IsWinner then
        Citizen.CreateThread(function()
            exports['nazu-bridge']:ShowBanner('~g~YOU WIN!!~s~', 'Score: ', 4)
        end)
        PlaySoundFrontend(-1, "Score_Up", "DLC_IE_PL_Player_Sounds", 1)
    else
        Citizen.CreateThread(function()
            exports['nazu-bridge']:ShowBanner('~r~YOU LOSE!!~s~', 'Score: ', 4)
        end)
        -- Citizen.CreateThread(function()
        --     TaskPlayAnim(pedId, anim, animName, 1.0, -1.0, 5500, 0, 1, false, false, false)
        
        --     while IsEntityPlayingAnim(pedId, anim, animName, 3) do
        --         Citizen.Wait(100)
        --     end
        -- end)
    end


    FreezeEntityPosition(PlayerPedId(), false)

    REMOVE_SELECTED_WEAPON()
    RESET_PLAYER_INFO()
end)

RegisterNetEvent(resName..':client:SessionAction', function(ZoneName)
    if ZoneName ~= nil then
        JOINED_SESSION_NAME = ZoneName
    else
        RESET_PLAYER_INFO()
    end
end)