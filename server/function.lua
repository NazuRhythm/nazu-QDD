
function GET_JOINING_SESSION(src)

    for k, v in pairs(GAME_SESSION) do
        if v[1].player == src then
            return k, 1
        elseif v[2].player == src then
            return k, 2
        end
    end

    return nil, nil
end

function ALL_PLAYER_STATUS_IS(session, status)
    if (session[1] ~= nil and session[1].status == status) and (session[2] ~= nil and session[2].status == status) then
        return true
    end

    return false
end