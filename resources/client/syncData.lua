local data, syncData = {}, {}

function syncData.set(key, value)
    assert(type(key) == 'string', 'La clé doit être impérativement un string!')
    --
    if data[key] then
        if type(data[key]) == 'table' then
            data[key][#data[key]+1] = value
        else
            data[key] = value
        end
    else
        if type(value) == 'table' then
            data[key] = {}
            data[key][1] = value
        else
            data[key] = value
        end
    end
end

RegisterNetEvent('supv_core:client:sync-from-server:data', function(key, value)
    syncData.set(key, value)
    return TriggerEvent('supv_core:sync:data', data)
end)

RegisterNetEvent('supv_core:client:get:data', function(cb)
    cb(data)
end)

RegisterNetEvent('supv_core:client:sync-from-server:data-onRemove', function(newData)
    data = newData
    return TriggerEvent('supv_core:sync:data', data)
end)

RegisterCommand('syncData:client', function()
    print(json.encode(data, {indent=true}), 'data')
end)