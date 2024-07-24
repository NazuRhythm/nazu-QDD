
GAME_SESSION = {}

Citizen.CreateThread(function()

    for k, v in pairs(Config.Locations) do
        GAME_SESSION[k] = {

            [1] = {
                player = nil,
                status = nil,
            },

            [2] = {
                player = nil,
                status = nil,
            },

            -- [2] = {
            --     player = 10,
            --     status = STATUS_WAITING,
            -- },
        }
    end

    local waitTime = 2000
    while true do
        if next(GAME_SESSION) ~= nil then
            
            if next(GAME_SESSION) ~= nil then
                for k, v in pairs(GAME_SESSION) do
                    print(
                        'GAME_SESSION:' .. tostring(k) .. '\n' .. 
                        (v[1] ~= nil and 'PLAYER[1] = ' .. tostring(v[1].player) .. ' ' .. tostring(v[1].status) or '') .. '\n' .. 
                        (v[2] ~= nil and 'PLAYER[2] = ' .. tostring(v[2].player) .. ' ' .. tostring(v[2].status) or '') .. '\n'
                    )

                    if ALL_PLAYER_STATUS_IS(v, STATUS_WAITING) then
                        print(k, 'Waiting!')
                        for index, table in pairs(v) do
                            GAME_SESSION[k][index].status = STATUS_PLAYING
                            TriggerClientEvent(resName..':client:StartTheGame', table.player)
                        end


                    elseif ALL_PLAYER_STATUS_IS(v, STATUS_SETUPING) then
                        print(k, 'SETUPING!')
                        for index, table in pairs(v) do
                            GAME_SESSION[k][index].status = STATUS_PLAYING
                            TriggerClientEvent(resName..':client:StartTheGame', table.player)
                        end

                    elseif ALL_PLAYER_STATUS_IS(v, STATUS_READY) then
                        print(k, 'READY!')
                        for index, table in pairs(v) do
                            GAME_SESSION[k][index].status = STATUS_PLAYING
                            TriggerClientEvent(resName..':client:StartTheGame', table.player)
                        end

                    elseif ALL_PLAYER_STATUS_IS(v, STATUS_FINISHED) then
                        print(k, 'Finished!')
                        for index, table in pairs(v) do
                            TriggerClientEvent(resName..':client:SetJoiningSessionName', table.player)
                            GAME_SESSION[k][index].player = nil
                            GAME_SESSION[k][index].status = nil
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
        GAME_SESSION[key][index].status = playerStatus
    end
end)

RegisterNetEvent(resName..':server:RequestJoinGameSession', function(PlayerZone)
    local src = source

    if GAME_SESSION[PlayerZone] then
        if GAME_SESSION[PlayerZone][1].player == nil then

            GAME_SESSION[PlayerZone][1].player = src
            GAME_SESSION[PlayerZone][1].status = STATUS_WAITING

            if GAME_SESSION[PlayerZone][1].player == src then
                TriggerClientEvent(resName..':client:SetJoiningSessionName', src, PlayerZone)
                TriggerClientEvent('nazu-bridge:client:GTAMissionMessage', src, 'CHAR_HUNTER', 'Notify', 'Quick Draw Duel', 'You have Joined!', { "Text_Arrive_Tone", "Phone_SoundSet_Default" })
            end

        elseif GAME_SESSION[PlayerZone][2].player == nil then

            GAME_SESSION[PlayerZone][2].player = src
            GAME_SESSION[PlayerZone][2].status = STATUS_WAITING

            if GAME_SESSION[PlayerZone][2].player == src then
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

    GAME_SESSION[key][index].player = nil
    GAME_SESSION[key][index].status = nil

    if GAME_SESSION[key][index].player == nil then
        TriggerClientEvent(resName..':client:SetJoiningSessionName', src, nil)
        TriggerClientEvent('nazu-bridge:client:GTAMissionMessage', src, 'CHAR_HUNTER', 'Notify', 'Quick Draw Duel', 'You have qited!', { "Text_Arrive_Tone", "Phone_SoundSet_Default" })
    end
end)

RegisterNetEvent(resName..':server:RequestForceQuitPlayer', function()
    local src = source
    local key, index = GET_JOINING_SESSION(src)

    GAME_SESSION[key][index].player = nil
    GAME_SESSION[key][index].status = nil

    if GAME_SESSION[key][index].player == nil then
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