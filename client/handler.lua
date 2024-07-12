
AddEventHandler('onResourceStart', function(resourceName)
    if (resourceName ~= resName) then return end
    CREATE_PROPS()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (resourceName ~= resName) then return end
    DELETE_PROPS()
end)

AddEventHandler('playerSpawned', function()
    CREATE_PROPS()
end)

AddEventHandler('playerDropped', function ()
    if next(DECOI_ENTITYES) ~= nil then NzSLog('Disconnect running') DELETE_DECOI_ENTITY() end
    -- REMOVE_SELECTED_WEAPON()
end)
