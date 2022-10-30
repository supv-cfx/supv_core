local function SimpleNotification(source, txt, flash, saveToBrief, color)
	TriggerClientEvent('supv_core:client:notification:simple', source, txt, flash, saveToBrief, color)
end

local function AdvancedNotifiaction(source, title, subtitle, txt, textureDict, iconType, flash, saveToBrief, color)
	TriggerClientEvent('supv_core:client:notification:advanced', source, title, subtitle, txt, textureDict, iconType, flash, saveToBrief, color)
end

return {
	simple = SimpleNotification,
	advanced = AdvancedNotifiaction,
}