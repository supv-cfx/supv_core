local p, Await <const> = nil, Citizen.Await

RegisterNUICallback('returnConvert', function(data, cb)
    if p then p:resolve(data) end
    p = nil
    cb({})
end)

function supv.convertUnixTime(unix_time, format_date)

    if type(unix_time) ~= 'number' then return end
    if p then return end

    SendNUIMessage({
        action = 'setVisible',
        data = true
    })

    SendNUIMessage({
        action = 'convertUnix',
        data = {
            unix = unix_time,
            format_date = format_date or 'DD/MM/YYYY'
        }
    })

    p = promise.new()
    return Await(p)
end