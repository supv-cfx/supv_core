local active <const> = true -- or nil

if not active then return end
local loadjson <const> = require 'imports.json.server'.load
return loadjson('data.shared.handlers')