--- SimpleNotification
---
---@param txt string
---@param flash boolean
---@param saveToBrief boolean
---@param color number
local function SimpleNotification(txt, flash, saveToBrief, color)
    SetNotificationTextEntry('STRING')
	AddTextComponentString(txt)
	if saveToBrief == nil then saveToBrief = true end
	if color then ThefeedNextPostBackgroundColor(color) end
	EndTextCommandThefeedPostTicker(flash or false, saveToBrief)
end

--- AdvancedNotifiaction
---
---@param title string
---@param subtitle string
---@param txt string
---@param textureDict string
---@param iconType string
---@param flash boolean
---@param saveToBrief boolean
---@param color number
local function AdvancedNotifiaction(title, subtitle, txt, textureDict, iconType, flash, saveToBrief, color)
    BeginTextCommandThefeedPost("STRING")
	if saveToBrief == nil then saveToBrief = true end
	AddTextEntry('[F]:AdvancedNotification', txt)
	if color then ThefeedNextPostBackgroundColor(color) end
	AddTextComponentSubstringPlayerName(txt)
	EndTextCommandThefeedPostMessagetext(textureDict, textureDict, flash, iconType, title, subtitle)
	EndTextCommandThefeedPostTicker(flash or false, saveToBrief)
end

---  HelpNotification
---
---@param txt string
---@param thisFrame boolean
---@param beep boolean
---@param duration number
local function HelpNotification(txt, thisFrame, beep, duration) --> [Client]
	AddTextEntry('[F]:HelpNotification', txt)
	if thisFrame then
		DisplayHelpTextThisFrame('supv_core:HelpNotification', false)
	else
		BeginTextCommandDisplayHelp('supv_core:HelpNotification')
		if beep == nil then beep = true end
		EndTextCommandDisplayHelp(0, false, beep, duration or -1)
	end
end

--- FloatNotification
---
---@param txt string
---@param coords vector3
local function FloatNotification(txt, coords) --> [Client]
	AddTextEntry('supv_core:FloatingHelpNotification', txt)
	SetFloatingHelpTextWorldPosition(1, coords)
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
	BeginTextCommandDisplayHelp('supv_core:FloatingHelpNotification')
	EndTextCommandDisplayHelp(2, false, false, -1)
end

RegisterNetEvent('supv_core:client:notification:simple', function(txt, flash, saveToBrief, color)
    SimpleNotification(txt, flash, saveToBrief, color)
end)

RegisterNetEvent('supv_core:client:notification:advanced', function(title, subtitle, txt, textureDict, iconType, flash, saveToBrief, color)
    AdvancedNotifiaction(title, subtitle, txt, textureDict, iconType, flash, saveToBrief, color)
end)

RegisterNetEvent('supv_core:client:notification:help', function(txt, thisFrame, beep, duration)
    HelpNotification(txt, thisFrame, beep, duration)
end)

RegisterNetEvent('supv_core:client:notification:float', function(txt, coords)
    FloatNotification(txt, coords)
end)
