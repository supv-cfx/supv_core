local GetCurrentResourceName <const>, PerformHttpRequest <const>, GetResourceMetadata <const>, print <const> = GetCurrentResourceName, PerformHttpRequest, GetResourceMetadata, print
local version <const> = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)

local function findPattern(text, pattern, start)
    return string.sub(text, string.find(text, pattern, start)) 
end

local function Check(url, checker, error, types, link, timer)
    if #url < 10 and not version and not types then return end

    CreateThread(function()
        Wait(timer or 3000)

        PerformHttpRequest(url, function(code, res, headers)
            if code == 200 then
                local _gv = {}
                if types == 'json' then
                    _gv = json.decode(res)
                elseif types == 'lua' then
                    local chuck = res
                    if not _gv.version then
                        local str = findPattern(chuck, "version '...'", 1)
                        local v = string.gsub(findPattern(str, "'...'", 1), "'", '')
                        _gv.version = string.gsub(v, ',', '.')
                    end
                    if not _gv.link then _gv.link = link end
                    if not _gv.script then _gv.script = GetCurrentResourceName() end
                end

                if _gv.version == version then return end
                if _gv.version ~= version then
                    print('^9---------------------------------------------------------')
                    print(checker:format(_gv.script, version, _gv.version, _gv.link))
                    print('^9---------------------------------------------------------')
                end
            else
                print(error)
            end
        end)
    end)
end

return {
    check = Check
}