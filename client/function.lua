
function CREATE_BLIP(v)
    local blip = AddBlipForCoord(v.coords)
    SetBlipAsShortRange(blip, true)
    SetBlipSprite(blip, v.sprite or 1)
    SetBlipColour(blip, v.color or 0)
    SetBlipScale(blip, v.scale or 0.7)
	SetBlipDisplay(blip, (6))
    BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(tostring(v.label))
    EndTextCommandSetBlipName(blip)
end

function CREATE_PROPS()
    local model = `nz_prop_arm_wrestle_01`
    if Config.Locations ~= nil then
        for k, v in pairs(Config.Locations) do
            local coords = v.coords
            local CreatedProp = CreateObject(
                model,
                coords.x, coords.y, coords.z - 0.98,
                false,
                true,
                false
            )
            
            FreezeEntityPosition(CreatedProp, true)
            CURRENT_PROPS[k] = CreatedProp
        end
    else
        print('not founded some locations....')
    end
end

function DELETE_PROPS()
    if next(CURRENT_PROPS) ~= nil then
        for _, v in pairs(CURRENT_PROPS) do
            DeleteEntity(v)
        end
    end
end