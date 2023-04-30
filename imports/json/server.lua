local LoadResourceFile <const> = LoadResourceFile
local SaveResourceFile <const> = SaveResourceFile

--- supv.json.load
---@param filePath string
---@param resourceName? string
---@return string
local function Loadjson(filePath, resourceName)
    local resource <const> = resourceName or supv.env
    local filename <const> = filePath
    local str <const> = json.decode(LoadResourceFile(resource, ("%s.json"):format(filename)))
    if not str then
        error(('[ERROR] : Le fichier (%s) dans la ressource => %s, n\'a pas pu être chargé'):format(filename, resource), 2)
    end
    return str
end

--- supv.json.write
---@param filePath string
---@param data table
---@param resourceName? string|nil
---@param dataLength? integer
---@return boolean
local function Writejson(filePath, data, resourceName, dataLength)
    local resource <const> = resourceName or supv.env
    local lenght <const> = dataLength or -1
    local filename <const> = filePath
    local writeFile <const> = SaveResourceFile(resource, ("%s.json"):format(filename), json.encode(data, {indent = true}), lenght)
    if not writeFile then
        error(('[ERROR] : Le fichier (%s) dans la ressource => %s, n\'a pas pu être sauvegardé'):format(filename, resource), 2)
        return false
    end
    return true
end

return {
    load = Loadjson,
    save = Writejson
}