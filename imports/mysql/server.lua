local LoadResourceFile <const>, load <const> = LoadResourceFile, load

function supv.mysql()
    local file = 'lib/MySQL.lua'
	local import = LoadResourceFile('oxmysql', file)
	local func, err = load(import, ('@@%s/%s'):format('oxmysql', file))
	if not func or err then
		return error(err or ("unable to load module '%s'"):format(file), 3)
	end

	func()
end

return supv.mysql