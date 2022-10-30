local IsOpen = false


local function CreateMenu(title, subtitle, options)

    if IsOpen then return end
    
    local self = {}

    self.title = title
    self.subtitle = subtitle
    self.options = options

    return self
end

RegisterNetEvent('supv_core:nativeui:menuIsShow', function(open)
    IsOpen = open
end)

return {
    menu = CreateMenu
}