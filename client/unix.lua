local p, Await <const> = nil, Citizen.Await

RegisterNUICallback('supv:convert:return', function(data, cb)
    if p then p:resolve(data) end
    p = nil
    cb({})
end)

---@todo implement & re write with react
function supv.convertUnixTime(unix_time, format_date)

    if type(unix_time) ~= 'number' then return end
    if p then return end

    SendNUIMessage({
        action = 'setVisible',
        data = true
    })

    SendNUIMessage({
        action = 'supv:convert:unix',
        data = {
            unix = unix_time,
            format_date = format_date or 'DD/MM/YYYY'
        }
    })

    p = promise.new()
    return Await(p)
end