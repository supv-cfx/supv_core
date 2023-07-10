local function Async(func)
    local p = promise.new()
    CreateThread(function()
        func(function(value)
            p:resolve(value)
        end, function(err)
            p:reject(err)
        end)
    end)
    return p
end

local function PromiseNew(func)
    local p = Async(func)
    return setmetatable({}, {
        __index = {
            Then = function(self, fulfilled)
                p = p:next(fulfilled)
                return self
            end,
            Catch = function(self, rejected)
                p = p:next(nil, rejected)
                return self
            end
        }
    })
end

return {
    async = Async, -- credit: linden @overextended
    new = PromiseNew -- credit: SUP2Ak, for people love javascript x)
}

---@exemple supv.promise.async (you need to use `CreateThread` function and supv.await method)
---@important If method is reject then you got error: path/to/file.lua:line: `value you put in reject`
--[[ 
CreateThread(function()
    local v = supv.await(supv.promise.async(function(resolve, reject)
        local x = math.random(1, 100)
        if x > 50 then reject(":(") end
        resolve(":)")
    end))

    if v then -- only if resolve
        print(v)
    end
end)
--]]

---@exemple supv.promise.new (this method use callback when promise is resolve or reject)
---@important For this method you need to use `Then` and `Catch` methods, and you don't need to use this method in `CreateThread` function
--[[ 
supv.promise.new(function(resolve, reject)
    local v = math.random(1, 100)
    if v > 50 then reject(':(') end
    resolve(':)')
end):Then(function(result)
    print('then', result)
end):Catch(function(result)
    print('catch', result)
end)
--]]