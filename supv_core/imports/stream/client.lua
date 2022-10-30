local function Request(model)
    model = (type(model) == 'number' and model or GetHashKey(model))

    if not HasModelLoaded(model) and IsModelInCdimage(model) then
		RequestModel(model)

		while not HasModelLoaded(model) do
			Wait(0)
		end
	end
end

return {
    request = Request
}