local LoadResourceFile <const> = LoadResourceFile
local SaveResourceFile <const> = SaveResourceFile

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

--- json.write
---
---@param resourceName string|nil
---@param filePath string
---@param data table
---@param dataLength integer
---@return boolean
local function Writejson(resourceName, filePath, data, dataLength)
    local resource <const> = resourceName or GetCurrentResourceName()
    local lenght <const> = dataLength or -1
    local filename <const> = filePath
    local writeFile <const> = SaveResourceFile(resource, ("%s.json"):format(filename), json.encode(data, {indent = true}), lenght)
    if not writeFile then
        error(('[ERROR] : Le fichier (%s) dans la ressource => %s, n\'a pas pu être sauvegardé'):format(filename, resource), 2)
    end
    return true
end

return {
    load = Loadjson,
    write = Writejson
}