local PerformHttpRequest <const>, GetResourceMetadata <const>, print <const> = PerformHttpRequest, GetResourceMetadata
local version <const> = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)

local function Checker(url, webhook, timer)
    local message = supv.getTranslation({
        'need_update',
        'error'
    })

    url = 'tebex' and ("https://raw.githubusercontent.com/SUP2Ak/version-tebex-script/main/%s.json"):format(supv.env) or 'github' and ('https://api.github.com/repos/%s/releases/latest'):format(supv.env) or url

    CreateThread(function() 
        Wait(timer or 2500)

        PerformHttpRequest(url, function(status, resp)
            if status ~= 200 then return end

            resp = json.decode(resp)

            print(json.encode(resp, {indent=true}))
        end)
    end)
end

return {
    check = Checker
}

-- "https://raw.githubusercontent.com/SUP2Ak/version-tebex-script/main/supv_esx.json"