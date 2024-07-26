
GAME_SESSION = {}

Citizen.CreateThread(function()

    for k, v in pairs(Config.Locations) do
        GAME_SESSION[k] = {
            STATUS = STATUS_WAITING,
            PLAYERS = {

                [1] = {
                    src = nil,
                    status = nil,
                    score = nil,
                },
    
                [2] = {
                    src = nil,
                    status = nil,
                    score = nil,
                },

            },
        }
    end

    local waitTime = 2000
    while true do
        if next(GAME_SESSION) ~= nil then
            if next(GAME_SESSION) ~= nil then
                
                for k, SESSION in pairs(GAME_SESSION) do
                    
                    print(
                        'GAME_SESSION:' .. tostring(k) .. '\n' .. 
                        (SESSION.PLAYERS[1] ~= nil and 'PLAYER[1] = ' .. tostring(SESSION.PLAYERS[1].src) .. ' ' .. tostring(SESSION.PLAYERS[1].status) or '')  .. ' ' .. 'SCORE[1] = ' .. tostring(SESSION.PLAYERS[1].score) or '' .. '\n' .. 
                        (SESSION.PLAYERS[2] ~= nil and 'PLAYER[2] = ' .. tostring(SESSION.PLAYERS[2].src) .. ' ' .. tostring(SESSION.PLAYERS[2].status) or '')  .. ' ' .. 'SCORE[2] = ' .. tostring(SESSION.PLAYERS[2].score) or '' .. '\n'
                    )

                    if SESSION.STATUS == STATUS_WAITING then
                        if ALL_PLAYER_STATUS_IS(SESSION, STATUS_WAITING) then

                            for index, player in pairs(SESSION.PLAYERS) do
                                GAME_SESSION[k].PLAYERS[index].status = STATUS_PLAYING
                                TriggerClientEvent(resName..':client:StartSetup', player.src, k, index)
                            end

                            GAME_SESSION[k].STATUS = STATUS_SETUPING
                        end
 
                    elseif SESSION.STATUS == STATUS_SETUPING then
                        
                        if ALL_PLAYER_STATUS_IS(SESSION, STATUS_FINISHED_SETUPING) then
                            for index, player in pairs(SESSION.PLAYERS) do
                                GAME_SESSION[k].PLAYERS[index].status = STATUS_PLAYING
                                TriggerClientEvent(resName..':client:StartTheGame', player.src, k, index)
                            end

                            GAME_SESSION[k].STATUS = STATUS_PLAYING
                        end
                    
                    elseif SESSION.STATUS == STATUS_PLAYING then
                        
                        if ALL_PLAYER_STATUS_IS(SESSION, STATUS_FINISHED) then

                            JUDGE_WINNER(SESSION)

                            for index, player in pairs(SESSION.PLAYERS) do
                                
                                TriggerClientEvent(resName..':client:SessionAction', player.src)

                                GAME_SESSION[k].PLAYERS[index].src = nil
                                GAME_SESSION[k].PLAYERS[index].status = nil
                                GAME_SESSION[k].PLAYERS[index].score = nil
                                
                                GAME_SESSION[k].STATUS = STATUS_WAITING
                            end

                        end

                    end
                    
                end
            end

            waitTime = 1000
        else

            waitTime = 2000
        end
        
        Citizen.Wait(waitTime)
    end
end)

RegisterNetEvent(resName..':server:SetPlayerStatus', function(playerStatus)
    local src = source
    local key, index = GET_JOINING_SESSION(src)

    if key ~= nil and index ~= nil then
        GAME_SESSION[key].PLAYERS[index].status = playerStatus
    end
end)

RegisterNetEvent(resName..':server:SetScore', function(playerScore)
    local src = source
    local key, index = GET_JOINING_SESSION(src)

    if key ~= nil and index ~= nil then
        GAME_SESSION[key].PLAYERS[index].score = tonumber(playerScore)
    end
end)

RegisterNetEvent(resName..':server:RequestJoinGameSession', function(PlayerZone)
    local src = source

    if GAME_SESSION[PlayerZone] then
        if GAME_SESSION[PlayerZone].PLAYERS[1].src == nil then

            GAME_SESSION[PlayerZone].PLAYERS[1].src = src
            GAME_SESSION[PlayerZone].PLAYERS[1].status = STATUS_WAITING

            if GAME_SESSION[PlayerZone].PLAYERS[1].src == src then
                TriggerClientEvent(resName..':client:SessionAction', src, PlayerZone)
                TriggerClientEvent('nazu-bridge:client:GTAMissionMessage', src, 'CHAR_HUNTER', 'Notify', 'Quick Draw Duel', 'You have Joined!', { "Text_Arrive_Tone", "Phone_SoundSet_Default" })
            end

        elseif GAME_SESSION[PlayerZone].PLAYERS[2].src == nil then

            GAME_SESSION[PlayerZone].PLAYERS[2].src = src
            GAME_SESSION[PlayerZone].PLAYERS[2].status = STATUS_WAITING

            if GAME_SESSION[PlayerZone].PLAYERS[2].src == src then
                TriggerClientEvent(resName..':client:SessionAction', src, PlayerZone)
                TriggerClientEvent('nazu-bridge:client:GTAMissionMessage', src, 'CHAR_HUNTER', 'Notify', 'Quick Draw Duel', 'You have Joined!', { "Text_Arrive_Tone", "Phone_SoundSet_Default" })
            end

        else
            ShowNotify('Quick Draw Duel', 'They are full.', 'error', src)
        end
    end

end)

RegisterNetEvent(resName..':server:RequestQuitGameSession', function()
    local src = source
    local key, index = GET_JOINING_SESSION(src)

    GAME_SESSION[key].PLAYERS[index].src = nil
    GAME_SESSION[key].PLAYERS[index].status = nil

    if GAME_SESSION[key].PLAYERS[index].src == nil then
        TriggerClientEvent(resName..':client:SessionAction', src, nil)
        TriggerClientEvent('nazu-bridge:client:GTAMissionMessage', src, 'CHAR_HUNTER', 'Notify', 'Quick Draw Duel', 'You have quited!', { "Text_Arrive_Tone", "Phone_SoundSet_Default" })
    end
end)

RegisterNetEvent(resName..':server:RequestForceQuitPlayer', function()
    local src = source
    local key, index = GET_JOINING_SESSION(src)

    GAME_SESSION[key].PLAYERS[index].src = nil
    GAME_SESSION[key].PLAYERS[index].status = nil

    if GAME_SESSION[key].PLAYERS[index].src == nil then
        TriggerClientEvent(resName..':client:SessionAction', src, nil)
        TriggerClientEvent('nazu-bridge:client:GTAMissionMessage', src, 'CHAR_HUNTER', 'Notify', 'Quick Draw Duel', 'Forced out for leaving the area.', { "Text_Arrive_Tone", "Phone_SoundSet_Default" })
    end
end)

-- Citizen.CreateThread(function()
--     print([[
--      ██████╗ ██╗   ██╗██╗ ██████╗██╗  ██╗    ██████╗ ██████╗  █████╗ ██╗    ██╗    ██████╗ ██╗   ██╗███████╗██╗     
--     ██╔═══██╗██║   ██║██║██╔════╝██║ ██╔╝    ██╔══██╗██╔══██╗██╔══██╗██║    ██║    ██╔══██╗██║   ██║██╔════╝██║     
--     ██║   ██║██║   ██║██║██║     █████╔╝     ██║  ██║██████╔╝███████║██║ █╗ ██║    ██║  ██║██║   ██║█████╗  ██║     
--     ██║▄▄ ██║██║   ██║██║██║     ██╔═██╗     ██║  ██║██╔══██╗██╔══██║██║███╗██║    ██║  ██║██║   ██║██╔══╝  ██║     
--     ╚██████╔╝╚██████╔╝██║╚██████╗██║  ██╗    ██████╔╝██║  ██║██║  ██║╚███╔███╔╝    ██████╔╝╚██████╔╝███████╗███████╗
--      ╚══▀▀═╝  ╚═════╝ ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚══╝╚══╝     ╚═════╝  ╚═════╝ ╚══════╝╚══════╝
--     ]])
-- end)