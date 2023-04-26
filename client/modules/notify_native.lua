local SetNotificationTextEntry <const> = SetNotificationTextEntry
local AddTextComponentString <const> = AddTextComponentString
local ThefeedNextPostBackgroundColor <const> = ThefeedNextPostBackgroundColor
local EndTextCommandThefeedPostTicker <const> = EndTextCommandThefeedPostTicker
local AddTextComponentSubstringPlayerName <const> = AddTextComponentSubstringPlayerName
local EndTextCommandThefeedPostMessagetext <const> = EndTextCommandThefeedPostMessagetext
local BeginTextCommandThefeedPost <const> = BeginTextCommandThefeedPost
local AddTextEntry <const> = AddTextEntry
local type <const>, math <const> = type, math

---@class notification_native
---@field description string
---@field flash? boolean
---@field save? boolean
---@field color? integer

---@class notification_native_advanced
---@field dict string
---@field name string
---@field icon integer
---@field title string
---@field subtitle string
---@field description string
---@field flash? boolean
---@field save? boolean
---@field color? integer

--- supv.notify
---@param select string
---@param data notification_native|notification_native_advanced
return function(select, data)
    if type(data) ~= 'table' then return end
    
    if select == 'simple' then ---@type notification_native
        if type(data.description) ~= 'string' then return end
        SetNotificationTextEntry('STRING')
        AddTextComponentString(data.description)
        if type(data.color) == 'number' and math.type(data.color) == 'integer' then
            ThefeedNextPostBackgroundColor(data.color)
        end
        EndTextCommandThefeedPostTicker(data.flash or false, data.save or true)

    elseif select == 'advanced' then ---@type notification_native_advanced
        BeginTextCommandThefeedPost('STRING')
        AddTextEntry('supv_core:notify:native_advanced', data.description)
        if type(data.color) == 'number' and math.type(data.color) == 'integer' then
            ThefeedNextPostBackgroundColor(data.color)
        end
        AddTextComponentSubstringPlayerName(data.description)
        EndTextCommandThefeedPostMessagetext(data.dict, data.name, data.flash or false, data.icon, data.title, data.subtitle)
        EndTextCommandThefeedPostTicker(data.flash or false, data.save or true)
    end
end