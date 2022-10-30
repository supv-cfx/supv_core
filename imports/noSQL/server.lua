-- Méthode
local function FileExist(self, fileName, fromOtherPath)
    local file
    if self.dirFile == nil then
        if type(fromOtherPath) == "string" then
            if GetResourcePath(fromOtherPath) then
                self.filePath = GetResourcePath(fromOtherPath) 
                file = io.open(("%s/%s"):format(self.filePath, fileName), "r")
            end
        else
            file = io.open(("%s/%s"):format(self.filePath, fileName), "r")
        end
    else
        file = io.open(self.dirFile, "r")
    end
    if file then
        if not self.dirFile then
            self.dirFile = ("%s/%s"):format(self.filePath, fileName)
        end
        io.close(file)
        return true
    end
    return false
end

local function CreateFile(self, content, resourceName, fileName)
    if not self:exist(fileName) then
        local filePath <const> = resourceName
        local dir <const> = ("%s/%s.json"):format(filePath, fileName) 
        local file = io.open(dir, "w")
        if file then
            if content then
                file:write(json.encode(content))
            end
            return true
        end
    end
    return false
end

local function ReadFile(self, ...)
    local dir
    if not self.dirFile then
        dir = ...
    else
        dir = self.dirFile
    end
    if not self:exist(dir) then
        error(("[ERROR] Impossible de lire un fichier qui n'existe pas... : %"):format(dir), 2)
        return nil
    end
    local file = io.open(dir, "r")
    if file then
        local content = file:read("*a")
        io.close(file)
        return content
    end
end

local function WriteFile(self, content, ...)
    local dir
    if not self.dirFile then
        dir = ...
    else
        dir = self.dirFile
    end
    assert(self.dirFile, "[ERROR] Le chemin d'accès n'est pas définit!")
    local file = io.open(dir, "w")
    if file then
        file:write(content)
        io.close(file)
        return true
    end
    return false
end

local function SetContent(self, content)
    return self:writeFile(json.encode(content), self.dirFile)
end

local function GetContent(self)
    assert(self.dirFile, "[ERROR] Le chemin d'accès n'est pas définit!")
    local result <const> = self:readFile(self.dirFile)
    if result ~= nil then
        return json.decode(result)
    end
    error(("[ERROR] de la récupération du fichier %s"):format(self.filePath), 2)
    return nil
end

-- Constructor
local function Define(resourceName)
    local self = {}
    self.dirFile = nil
    self.GlobalDir = io.popen("cd"):read()
    self.filePath = GetResourcePath(resourceName)
    self.exist = FileExist
    self.setContent = SetContent
    self.getContent = GetContent
    self.readFile = ReadFile
    self.writeFile = WriteFile
    self.createFile = CreateFile
    return self
end

return {
    define = Define
}