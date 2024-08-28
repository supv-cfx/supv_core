if not supv or not supv.service then return error("Cannot load init modules", 3) end
local folders = require 'modules.starter.modules'

for i = 1, #folders do
    local folder <const> = folders[i]
    local files <const> = require(('modules.%s.index'):format(folder))

    if files.shared then
        local t <const> = files.shared
        for j = 1, #t do
            local file <const> = t[j]
            require(('modules.%s.%s.%s'):format(folder, 'shared', file))
        end
    end

    if files[supv.service] then
        local t <const> = files[supv.service]
        for j = 1, #t do
            local file <const> = t[j]
            require(('modules.%s.%s.%s'):format(folder, supv.service, file))
        end
    end
end

folders = nil