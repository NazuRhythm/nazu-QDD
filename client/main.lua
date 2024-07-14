CURRENT_PROPS = {}

Citizen.CreateThread(function()
    
end)

-- Create Blip
Citizen.CreateThread(function()
    for k, v in pairs(Config.Locations) do
        local coords = v.coords
        v.blip.coords = coords
        CREATE_BLIP(v.blip)
    end
end)

