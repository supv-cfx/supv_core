---@class Text2dProps
---@field title string
---@field description? string
---@field keybind? string | 'E'

local visible, currentTitle, currentDescription = false

---@param data Text2dProps
function supv.showText2D(data)
    if currentDescription and currentTitle == data.title then
        if data.description and currentDescription == data.description then
            return
        elseif not data.description and not currentDescription then
            return
        end
    end

    supv.sendReactMessage(true, {
        action = 'supv_core:action:send',
        data = { 
            title = data.title, 
            description = data.description,  
        }
    })

    visible, currentTitle, currentDescription = true, data.title, data.description
end

---@param force? boolean
function supv.hideText2D(force)
    if not visible and not force then return end

    supv.sendReactMessage(true, {
        action = 'supv_core:action:hide',
    })

    visible, currentTitle, currentDescription = false, nil, nil
end

---@return boolean
---@return string?
---@return string?
function supv.isText2D()
    return visible, currentTitle, currentDescription
end