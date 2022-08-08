local data, syncData = {}, {}

function syncData.set(key, value)
    assert(type(key) == 'string', 'La clé doit être impérativement un string!')
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

function syncData.remove(key, value)
    if not data[key] then return nil end
    if type(data[key]) ~= 'table' then
        data[key] = nil
    else
        for i,v in ipairs(data[key]) do
            for k,x in pairs(v)do
                --print(k, x, value)
                if x == value then
                    table.remove(data[key], i)
                    return true
                end
            end
        end
    end
    return false
end

RegisterNetEvent('supv_core:server:insert:data', function(key, value)
    syncData.set(key, value)
    TriggerClientEvent('supv_core:client:sync-from-server:data', -1, key, value)
    return TriggerEvent('supv_core:sync:data', data)
end)

RegisterNetEvent('supv_core:server:remove:data', function(key, value)
    if Config.DevMod then
        print(syncData.remove(key,value), 'result')
    else
        syncData.remove(key,value)
    end
    TriggerClientEvent('supv_core:client:sync-from-server:data-onRemove', -1, data)
    return TriggerEvent('supv_core:sync:data', data)
end)

RegisterNetEvent('supv_core:server:get:data', function(cb)
    cb(data)
end)

if Config.DevMod then
    RegisterCommand('syncData:server', function()
        print(json.encode(data, {indent=true}), 'data')
    end, false)
end

RegisterNetEvent('supv_core:server:player-connected', function()
    local _src = source
    if not data['players'] then data['players'] = {} end
    if not data['players'][_src] then data['players'][_src] = _src end
    return TriggerEvent('supv_core:sync:data', data)
end)

AddEventHandler('playerDropped', function (reason)
    local _src = source
    if data['players'][_src] then
        data['players'][_src] = nil
    end
    return TriggerEvent('supv_core:sync:data', data)
end)