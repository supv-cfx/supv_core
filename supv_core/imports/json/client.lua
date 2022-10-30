local LoadResourceFile <const> = LoadResourceFile

--- json.load
---
---@param resourceName string|nil
---@param filePath string
---@return string
local function Loadjson(resourceName, filePath)
    local resource <const> = resourceName or GetCurrentResourceName()
    local filename <const> = filePath
    local str <const> = json.decode(LoadResourceFile(resource, ("%s.json"):format(filename)))
    if not str then
        error(('[ERROR] : Le fichier (%s) dans la ressource => %s, n\'a pas pu être chargé'):format(filename, resource), 2)
    end
    return str
end
return {
    load = Loadjson
}