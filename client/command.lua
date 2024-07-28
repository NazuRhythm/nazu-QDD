

RegisterCommand('nzqddclick', function()
    if STATUS ~= STATUS_PLAYING then return end

    IS_PRESSED = true
end)

RegisterKeyMapping('nzqddclick', '', 'mouse_button', Config.Game.KeyMapping.Click)