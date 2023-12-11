-- credit: ox_lib <https://github.com/overextended/ox_lib/blob/master/imports/require/shared.lua>
if lib then return lib.require end
local loaded = {}

package = {
    loaded = setmetatable({}, {
        __index = loaded,
        __newindex = function()  end,
        __metatable = false,
    }),
    path = './?.lua;'
}

local _require = require

---Loads the given module inside the current resource, returning any values returned by the file or `true` when `nil`.
---@param modname string
---@return unknown?
local function LoadModule(modname)
    if type(modname) ~= 'string' then return end

    local module = loaded[modname]

    if not module then
        if module == false then
            error(("^1circular-dependency occurred when loading module '%s'^0"):format(modname), 2)
        end

        if not modname:find('^@') then
            local success, result = pcall(_require, modname)

            if success then
                loaded[modname] = result
                return result
            end

            local modpath = modname:gsub('%.', '/')

            for path in package.path:gmatch('[^;]+') do
                local scriptPath = path:gsub('?', modpath):gsub('%.+%/+', '')
                local resourceFile = LoadResourceFile(supv.env, scriptPath)

                if resourceFile then
                    loaded[modname] = false
                    scriptPath = ('@@%s/%s'):format(supv.env, scriptPath)

                    local chunk, err = load(resourceFile, scriptPath)

                    if err or not chunk then
                        loaded[modname] = nil
                        return error(err or ("unable to load module '%s'"):format(modname), 3)
                    end

                    module = chunk(modname) or true
                    loaded[modname] = module

                    return module
                end
            end
        else
            local rss, dir = modname:gsub('%.', '/'):match('^(.-)/(.+)$')

            if not rss or not dir then return error('Invalid path format: '..modname, 2) end
            rss, dir = rss:gsub('^@', ''), dir..'.lua'
            local chunk = LoadResourceFile(rss, dir)

            if chunk then
                local scriptPath = ('@@%s/%s'):format(rss, dir)
                local func, err = load(chunk, scriptPath)

                if err or not func then
                    return error(err or ("unable to load module '%s'"):format(modname), 2)
                end

                module = func(modname) or true
                loaded[modname] = module

                return module
            end
        end

        return error(("module '%s' not found"):format(modname), 2)
    end

    return module
end

return LoadModule

--[[ old method, not working with zones module because need require (glm) to calculate vector
    
local moduleLoaded = {}

local function load_module(path)
    if moduleLoaded[path] then
        return moduleLoaded[path]
    end

    local module_path = ("%s.lua"):format(path)
    local module_file = LoadResourceFile(GetCurrentResourceName(), module_path)
    if not module_file then
        error("Impossible de chargé le module : "..path)
    end

    moduleLoaded[path] = load(module_file)()
    return moduleLoaded[path]
end

local function call_module(path)
    path = path:gsub('%.', '/')
    local module = load_module(path)
    if not module then
        return error("Le module n'a pas charger : "..path)
    end
    return module
end

return {
    load = call_module
}
--]]