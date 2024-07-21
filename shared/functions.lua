
function ShowNotify(title, description, type, src)
    local NotifySystem = Config.Notify

    if NotifySystem == 'ox' then
        if not src then exports.ox_lib:notify({title = title, description = description, type = type or 'success'})
		else TriggerClientEvent('ox_lib:notify', src, { type = type or 'success', title = title, description = description }) end
    elseif NotifySystem == 'okok' then
        if not src then exports['okokNotify']:Alert(title, description, 6000, type, true)
		else TriggerClientEvent('okokNotify:Alert', src, title, description, 6000, type, true) end
    elseif NotifySystem == 'qb' then
        if not src then	TriggerEvent('QBCore:Notify', description, type)
		else TriggerClientEvent('QBCore:Notify', src, description, type) end
    elseif NotifySystem == 'custom' then
        -- do something here.
    end
end