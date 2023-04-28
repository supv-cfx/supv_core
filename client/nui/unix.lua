local p, nui <const> = nil, require 'client.modules.nui'

---@param data string
nui.RegisterReactCallback('supv:convert:return-unix', function(data, cb)
    if p then p:resolve(data) end p = nil
    cb(1)
end, true)


--- supv.convertUnixTime
---@param unix number
---@param date? string
---@return string
function supv.convertUnixTime(unix, date)
    if type(unix) ~= 'number' then return end
    if p then return end

    nui.SendReactMessage(true, {
        action = 'supv:convert:unix',
        data = {
            unix_time = unix,
            format_date = date or 'DD/MM/YYYY'
        }
    })

    p = promise.new()
    return supv.await(p)
end