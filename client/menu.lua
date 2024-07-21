
function SHOW_ALERT_DIALOG()
    if STATUS == STATUS_NORMAL then
        local result = lib.alertDialog({
            header = Loc.JoinMenu.header or '',
            content = Loc.JoinMenu.message or '',
            centered = true,
            cancel = true
        })

        if result == 'confirm' then
            if PLAYER_ZONE_NAME ~= nil then
                Citizen.CreateThread(function()
                    STATUS = STATUS_WAITING
                    TriggerServerEvent(resName..':server:RequestJoinGameSession', PLAYER_ZONE_NAME)
                end)
            end
        end
    elseif STATUS == STATUS_WAITING then
        local result = lib.alertDialog({
            header = Loc.QuitMenu.header or '',
            content = Loc.QuitMenu.message or '',
            centered = true,
            cancel = true
        }) 

        if result == 'confirm' then
            Citizen.CreateThread(function()
                STATUS = STATUS_NORMAL
                TriggerServerEvent(resName..':server:RequestQuitGameSession', PLAYER_ZONE_NAME)
            end)
        end
    end
end