local function SimpleNotification(source, txt, flash, saveToBrief, color)
	TriggerServerEvent('supv_core:client:notification:simple', source, txt, flash, saveToBrief, color)
end

local function AdvancedNotifiaction(source, title, subtitle, txt, textureDict, iconType, flash, saveToBrief, color)
	TriggerServerEvent('supv_core:client:notification:advanced', source, title, subtitle, txt, textureDict, iconType, flash, saveToBrief, color)
end

local function HelpNotification(source, txt, thisFrame, beep, duration)
	TriggerServerEvent('supv_core:client:notification:help', source, txt, thisFrame, beep, duration)
end

local function FloatNotification(source, txt, coords)
	TriggerServerEvent('supv_core:client:notification:float', source, txt, coords)
end

return {
	simple = SimpleNotification,
	advanced = AdvancedNotifiaction,
	help = HelpNotification,
	float = FloatNotification
}