local visible, currentData = false, {}

function supv.showText2D(data)
    if visible then
        if not currentData.description then
            if currentData.title == data.title then
                return
            else
                goto skip
            end
        elseif data.description then
            if currentData.description == data.description then
                return
            else
                goto skip
            end
        else
            return
        end
    end

    ::skip::
    supv.sendReactMessage(true, {
        action = 'supv_core:hud:action',
        data = { visible = true, text = data.title, description = data.description, id = data.id }
    })

    currentData = data
    visible = true
end

function supv.hideText2D(force)
    if not visible and not force then return end
    supv.sendReactMessage(true, {
        action = 'supv_core:hud:action',
        data = { visible = false }
    })

    visible = false
end