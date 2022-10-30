local SetNotificationTextEntry <const> = SetNotificationTextEntry
local AddTextComponentString <const> = AddTextComponentString
local ThefeedNextPostBackgroundColor <const> = ThefeedNextPostBackgroundColor
local EndTextCommandThefeedPostTicker <const> = EndTextCommandThefeedPostTicker
local BeginTextCommandThefeedPost <const> = BeginTextCommandThefeedPost
local AddTextEntry <const> = AddTextEntry
local AddTextComponentSubstringPlayerName <const> = AddTextComponentSubstringPlayerName
local EndTextCommandThefeedPostMessagetext <const> = EndTextCommandThefeedPostMessagetext
local DisplayHelpTextThisFrame <const> = DisplayHelpTextThisFrame
local BeginTextCommandDisplayHelp <const> = BeginTextCommandDisplayHelp
local EndTextCommandDisplayHelp <const> = EndTextCommandDisplayHelp
local SetFloatingHelpTextWorldPosition <const> = SetFloatingHelpTextWorldPosition
local SetFloatingHelpTextStyle <const> = SetFloatingHelpTextStyle

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
	AddTextEntry('supv_core:AdvancedNotification', txt)
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
	AddTextEntry('supv_core:HelpNotification', txt)
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
	AddTextEntry('supv_coreFloatingHelpNotification', txt)
	SetFloatingHelpTextWorldPosition(1, coords)
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
	BeginTextCommandDisplayHelp('supv_coreFloatingHelpNotification')
	EndTextCommandDisplayHelp(2, false, false, -1)
end

return {
	simple = SimpleNotification,
	advanced = AdvancedNotifiaction,
	help = HelpNotification,
	float = FloatNotification
}