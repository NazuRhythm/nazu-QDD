
GAME_SESSION = {}

-- Citizen.CreateThread(function()
--     for k, v in pairs(Config.Locations) do
--         GAME_SESSION[k] = { [1] = nil, [2] = nil, }
--     end
-- end)

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
                end
            end

            waitTime = 1000
        else

            waitTime = 2000
        end
        
        Citizen.Wait(waitTime)
    end
end)

RegisterNetEvent(resName..':server:RequestJoinGameSession', function(PlayerZone)
    local src = source

    if GAME_SESSION[PlayerZone] then
        if GAME_SESSION[PlayerZone][1].player == nil then

            GAME_SESSION[PlayerZone][1].player = src
            GAME_SESSION[PlayerZone][1].status = STATUS_WAITING

            if GAME_SESSION[PlayerZone][1].player == src then
                TriggerClientEvent('nazu-bridge:client:GTAMissionMessage', src, 'CHAR_HUNTER', 'Notify', 'Quick Draw Duel', 'You have Joined!', { "Text_Arrive_Tone", "Phone_SoundSet_Default" })
            end

        elseif GAME_SESSION[PlayerZone][2].player == nil then

            GAME_SESSION[PlayerZone][2].player = src
            GAME_SESSION[PlayerZone][2].status = STATUS_WAITING

            if GAME_SESSION[PlayerZone][2].player == src then
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

    print(key, index)

    GAME_SESSION[key][index].player = nil
    GAME_SESSION[key][index].status = nil

    if GAME_SESSION[key][index].player == nil then
        TriggerClientEvent('nazu-bridge:client:GTAMissionMessage', src, 'CHAR_HUNTER', 'Notify', 'Quick Draw Duel', 'You have qited!', { "Text_Arrive_Tone", "Phone_SoundSet_Default" })
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