
GAME_SESSION = {}

Citizen.CreateThread(function()

    for k, v in pairs(Config.Locations) do
        GAME_SESSION[k] = {
            STATUS = STATUS_WAITING,
            PLAYERS = {

                [1] = {
                    src = nil,
                    status = nil,
                    score = 0.0,
                },
    
                [2] = {
                    src = nil,
                    status = nil,
                    score = 0.0,
                },
    
                -- [2] = {
                --     player = 10,
                --     status = STATUS_WAITING,
                -- },

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
                        (v[1] ~= nil and 'PLAYER[1] = ' .. tostring(v[1].src) .. ' ' .. tostring(v[1].status) or '') .. '\n' .. 
                        (v[2] ~= nil and 'PLAYER[2] = ' .. tostring(v[2].src) .. ' ' .. tostring(v[2].status) or '') .. '\n'
                    )

                    if SESSION.STATUS == STATUS_WAITING then
                        if ALL_PLAYER_STATUS_IS(SESSION, STATUS_WAITING) then
                            print(k, 'Waiting!')
                            for index, position in pairs(SESSION) do
                                GAME_SESSION[k].PLAYERS[index].status = STATUS_PLAYING
                                TriggerClientEvent(resName..':client:StartSetup', position.src)
                            end

                            GAME_SESSION[k].STATUS = STATUS_SETUPING
                        end
                    elseif SESSION.STATUS == STATUS_SETUPING then
                        if ALL_PLAYER_STATUS_IS(SESSION, STATUS_FINISHED_SETUPING) then
                            print(k, 'Finished Setuping')
                            for index, position in pairs(SESSION) do
                                GAME_SESSION[k].PLAYERS[index].status = STATUS_PLAYING
                                TriggerClientEvent(resName..':client:StartTheGame', position.src)
                            end

                            GAME_SESSION[k].STATUS = STATUS_PLAYING
                        end
                    elseif SESSION.STATUS == STATUS_PLAYING then
                        if SESSION.PLAYERS[1].score > 0.0 and SESSION.PLAYERS[2].score > 0.0 then
                            JUDGE_WINNER(SESSION)
                        end
                    end

                    if ALL_PLAYER_STATUS_IS(SESSION, STATUS_WAITING) then
                        print(k, 'Waiting!')
                        for index, position in pairs(SESSION) do
                            GAME_SESSION[k].PLAYERS[index].status = STATUS_PLAYING
                            TriggerClientEvent(resName..':client:StartSetup', position.src)
                        end


                    elseif ALL_PLAYER_STATUS_IS(SESSION, STATUS_SETUPING) then
                        print(k, 'Setuping!')
                        for index, position in pairs(SESSION) do
                            GAME_SESSION[k].PLAYERS[index].status = STATUS_PLAYING
                            TriggerClientEvent(resName..':client:StartTheGame', position.src)
                        end

                    elseif ALL_PLAYER_STATUS_IS(SESSION, STATUS_READY) then
                        print(k, 'Ready!')
                        for index, position in pairs(SESSION) do
                            GAME_SESSION[k].PLAYERS[index].status = STATUS_PLAYING
                            TriggerClientEvent(resName..':client:StartTheGame', position.src)
                        end

                    elseif ALL_PLAYER_STATUS_IS(SESSION, STATUS_FINISHED) then
                        print(k, 'Finished!')
                        for index, position in pairs(SESSION) do
                            TriggerClientEvent(resName..':client:SetJoiningSessionName', position.src)
                            GAME_SESSION[k].PLAYERS[index].src = nil
                            GAME_SESSION[k].PLAYERS[index].status = nil
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

RegisterNetEvent(resName..':server:RequestJoinGameSession', function(PlayerZone)
    local src = source

    if GAME_SESSION[PlayerZone] then
        if GAME_SESSION[PlayerZone].PLAYERS[1].src == nil then

            GAME_SESSION[PlayerZone].PLAYERS[1].src = src
            GAME_SESSION[PlayerZone].PLAYERS[1].status = STATUS_WAITING

            if GAME_SESSION[PlayerZone].PLAYERS[1].src == src then
                TriggerClientEvent(resName..':client:SetJoiningSessionName', src, PlayerZone)
                TriggerClientEvent('nazu-bridge:client:GTAMissionMessage', src, 'CHAR_HUNTER', 'Notify', 'Quick Draw Duel', 'You have Joined!', { "Text_Arrive_Tone", "Phone_SoundSet_Default" })
            end

        elseif GAME_SESSION[PlayerZone].PLAYERS[2].src == nil then

            GAME_SESSION[PlayerZone].PLAYERS[2].src = src
            GAME_SESSION[PlayerZone].PLAYERS[2].status = STATUS_WAITING

            if GAME_SESSION[PlayerZone].PLAYERS[2].src == src then
                TriggerClientEvent(resName..':client:SetJoiningSessionName', src, PlayerZone)
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
        TriggerClientEvent(resName..':client:SetJoiningSessionName', src, nil)
        TriggerClientEvent('nazu-bridge:client:GTAMissionMessage', src, 'CHAR_HUNTER', 'Notify', 'Quick Draw Duel', 'You have qited!', { "Text_Arrive_Tone", "Phone_SoundSet_Default" })
    end
end)

RegisterNetEvent(resName..':server:RequestForceQuitPlayer', function()
    local src = source
    local key, index = GET_JOINING_SESSION(src)

    GAME_SESSION[key].PLAYERS[index].src = nil
    GAME_SESSION[key].PLAYERS[index].status = nil

    if GAME_SESSION[key].PLAYERS[index].src == nil then
        TriggerClientEvent(resName..':client:SetJoiningSessionName', src, nil)
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