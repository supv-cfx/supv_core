local PerformHttpRequest <const>, GetResourceMetadata <const> = PerformHttpRequest, GetResourceMetadata
local version <const> = GetResourceMetadata(supv.env, 'version', 0)

local function Checker(url, webhook, timer, isBeta)
    local message = supv.json.load(('locales/%s'):format(supv.lang), supv.name)

    local from <const> = url
    url = from == 'tebex' and ("https://raw.githubusercontent.com/SUP2Ak/version-tebex-script/main/%s.json"):format(supv.env) or from == 'github' and ('https://api.github.com/repos/SUP2Ak/%s/releases/latest'):format(supv.env) or url

    CreateThread(function() 
        Wait(timer or 2500)
        
        PerformHttpRequest(url, function(status, resp)
            if status ~= 200 then return print(message.error_update) end

            resp = json.decode(resp)
            -- print(json.encode(resp, {indent=true}))

            if from == 'github' then
                local lastVersion = resp.tag_name
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
                            return print(message.need_update:format(supv.env, version, lastVersion, resp.html_url))
                        else break end
                    end
                end
            elseif from == 'tebex' then
                -- todo
            else
                -- todo
            end            
        end, 'GET')
    end)
end

return {
    check = Checker
}