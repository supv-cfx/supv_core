local LoadResourceFile <const> = LoadResourceFile

--- supv.json.load
---@param filePath string
---@param resourceName? string
---@return string
local function Loadjson(filePath, resourceName)
    local resource <const> = resourceName or supv.env or GetCurrentResourceName()
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