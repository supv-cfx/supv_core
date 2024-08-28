local PerformHttpRequest <const>, GetResourceMetadata <const> = PerformHttpRequest, GetResourceMetadata
local version <const> = GetResourceMetadata(supv.env, 'version', 0)

--- supv.version
---@param url string
---@param webhook? table
---@param timer? number
---@param isBeta? boolean
---@param perso? fun(resp: table)
function supv.version(url, webhook, timer, isBeta, perso)
    local message = json.decode(LoadResourceFile(supv.name, ('locales/%s.json'):format(supv.lang)))

    local from <const> = url
    url = from == 'tebex' and ("https://raw.githubusercontent.com/SUP2Ak/version-tebex-script/main/%s.json"):format(supv.env) or from == 'github' and ('https://api.github.com/repos/SUP2Ak/%s/releases/latest'):format(supv.env) or url

    CreateThread(function() 
        Wait(timer or 2500)
        
        PerformHttpRequest(url, function(status, resp)
            if status ~= 200 then return print(message.error_update) end

            resp = json.decode(resp)
            -- print(json.encode(resp, {indent=true}))

            if from == 'github' or from == 'tebex' then
                local lastVersion = from == 'github' and resp.tag_name or from == 'tebex' and resp.version
                lastVersion = lastVersion:gsub('v', '')

                if isBeta then
                    lastVersion = lastVersion:gsub('b', '')
                end

                local _version = {('.'):strsplit(version)}
                local _lastVersion = {('.'):strsplit(lastVersion)}
    
                for i = 1, #_version do
                    local current, minimum = tonumber(_version[i]), tonumber(_lastVersion[i])
    
                    if current ~= minimum then
                        if current < minimum then
                            print('^9---------------------------------------------------------')
                            print(message.need_update:format(supv.env, version, lastVersion, from == 'github' and resp.html_url or from == 'tebex' and resp.link))
                            print('^9---------------------------------------------------------')
                            return
                        else break end
                    end
                end
            else
                if perso then
                    perso(resp)
                end
            end            
        end, 'GET')
    end)
end

return supv.version