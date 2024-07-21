
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