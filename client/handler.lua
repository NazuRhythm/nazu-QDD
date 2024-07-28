
AddEventHandler('onResourceStart', function(resourceName)
    if (resourceName ~= resName) then return end
    CREATE_PROPS_AND_ZONE()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (resourceName ~= resName) then return end
    DELETE_PROPS_AND_ZONE()
end)

AddEventHandler('playerSpawned', function()
    REMOVE_SELECTED_WEAPON()
    CREATE_PROPS_AND_ZONE()
end)

AddEventHandler('playerDropped', function ()
    REMOVE_SELECTED_WEAPON()
end)
