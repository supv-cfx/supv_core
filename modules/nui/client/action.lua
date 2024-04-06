---@class Text2dProps
---@field title string
---@field description? string
---@field keybind? string | 'E'
---@field title2? string
---@field description2? string
---@field keybind2? string

local visible, currentTitle, currentDescription, currentTitle2 = false

---@param data Text2dProps
function supv.showText2D(data)
    if currentDescription and currentTitle == data.title then
        if data.description and currentDescription == data.description then
            return
        elseif not data.description and not currentDescription then
            return
        end
    end

    if not data.title2 then
        currentTitle2 = nil
    end

    supv.sendReactMessage(true, {
        action = 'supv_core:action:send',
        data = { 
            title = data.title, 
            description = data.description,
            keybind = data.keybind or 'E',
            title2 = data.title2 or nil,
            description2 = data.title2 and data.description2 or nil,
            keybind2 = data.title2 and data.keybind2 or nil,
        }
    })

    visible, currentTitle, currentDescription, currentTitle2 = true, data.title, data.description, data.title2
end

---@param force? boolean
function supv.hideText2D(force)
    if not visible and not force then return end

    supv.sendReactMessage(true, {
        action = 'supv_core:action:hide',
    })

    visible, currentTitle, currentDescription, currentTitle2 = false, nil, nil, nil
end

---@return boolean
---@return string?
---@return string?
function supv.isText2D()
    return visible, currentTitle, currentDescription
end