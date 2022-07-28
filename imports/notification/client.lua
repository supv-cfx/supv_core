local function SimpleNotification(txt, flash, saveToBrief, color)
	TriggerEvent('supv_core:client:notification:simple', txt, flash, saveToBrief, color)
end

local function AdvancedNotifiaction(title, subtitle, txt, textureDict, iconType, flash, saveToBrief, color)
	TriggerEvent('supv_core:client:notification:advanced', title, subtitle, txt, textureDict, iconType, flash, saveToBrief, color)
end

local function HelpNotification(txt, thisFrame, beep, duration)
	TriggerEvent('supv_core:client:notification:help', txt, thisFrame, beep, duration)
end

local function FloatNotification(txt, coords)
	TriggerEvent('supv_core:client:notification:float', txt, coords)
end

return {
	simple = SimpleNotification,
	advanced = AdvancedNotifiaction,
	help = HelpNotification,
	float = FloatNotification
}