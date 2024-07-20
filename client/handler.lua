
AddEventHandler('onResourceStart', function(resourceName)
    if (resourceName ~= resName) then return end
    CREATE_PROPS_AND_ZONE()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (resourceName ~= resName) then return end
    DELETE_PROPS_AND_ZONE()
end)

AddEventHandler('playerSpawned', function()
    CREATE_PROPS_AND_ZONE()
end)

AddEventHandler('playerDropped', function ()

end)
