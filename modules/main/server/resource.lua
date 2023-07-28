local Manager = {
    resources = {},
    menu = {},
    path = {}
}

function Manager:edit(resource, file, key, value)
    -- print(self.resources[resource][file][key], value)
    -- print(resource, file, key, value)

    if not self.resources[resource] then
        return warn(('Resource "%s" not registered!'):format(resource))
    end

    if not self.resources[resource][file] then
        return warn(('File "%s" not registered!'):format(file))
    end

    if not self.resources[resource][file][key] or key == '?' then
        self.resources[resource][file] = value
    else
        self.resources[resource][file][key] = value
    end

    local menu = self.menu[resource].config[file]
    for k,v in pairs(menu) do
        if k then
            for i = 1, #v do
                local val = v[i]
                local s = val.id
                s = s:gsub(('%s.'):format(resource), '')
                if s == key then
                    val.value = value
                    if val.default then
                        val.default = value
                    end
                    break
                end
            end
        end
    end
end

function Manager:save(resource, file)
    if not self.resources[resource] or not self.resources[resource][file] then
        return warn(('Resource "%s" not registered!'):format(resource))
    end

    -- print('save', json.encode(self.resources[resource][file], { indent = true }))

    SaveResourceFile(resource, self.path[resource][file], json.encode(self.resources[resource][file], { indent = true }), -1)
end

function supv.addResourceManager(resource, value, menu, path)
    if Manager.resources[resource] or Manager.menu[resource] then
        return warn(('Resource "%s" already registered!'):format(resource))
    end

    Manager.resources[resource] = value
    Manager.menu[resource] = menu
    Manager.path[resource] = path

    --print(json.encode(Manager.resources, { indent = true }))
end

supv:onNet('rm:edit', function(source, data)
    if not IsPlayerAceAllowed(source, 'command.supv_core') then
        return warn(('Player %s is not allowed to edit resources!'):format(GetPlayerName(source)))
    end

    -- print(json.encode(data, { indent = true }))

    if not Manager.resources[data.resource] then
        return warn(('Resource "%s" not registered!'):format(data.resource))
    end

    if not Manager.resources[data.resource][data.file] then
        return warn(('File "%s" not registered!'):format(data.file))
    end

    Manager:edit(data.resource, data.file, data.key, data.value)
end)

supv:onNet('rm:action', function(source, data)
    if not IsPlayerAceAllowed(source, 'command.supv_core') then
        return warn(('Player %s is not allowed to make any action resources!'):format(GetPlayerName(source)))
    end

    if data.action == 'save' then
        for k in pairs(Manager.resources[data.resource]) do
            Manager:save(data.resource, k)
        end
        supv.notify(source, 'simple', {
            id = 'rm_save',
            title = 'supv_core',
            description = ('File(s) in resource (%s) are saved!'):format(data.resource),
            duration = 2500,
            type = 'success'
        })
    elseif data.action == 'start' then
        if GetResourceState(data.resource) == 'stopped' then
            if StartResource(data.resource) then
                supv.notify(source, 'simple', {
                    id = 'rm_start',
                    title = 'supv_core',
                    description = ('Resource (%s) is started!'):format(data.resource),
                    duration = 2500,
                    type = 'success'
                })
            else
                supv.notify(source, 'simple', {
                    id = 'rm_start',
                    title = 'supv_core',
                    description = ('Failed to start resource (%s)!'):format(data.resource),
                    duration = 2500,
                    type = 'error'
                })
            end
        else
            supv.notify(source, 'simple', {
                id = 'rm_start',
                title = 'supv_core',
                description = ('Resource (%s) is not stopped!'):format(data.resource),
                duration = 2500,
                type = 'error'
            })
        end
    elseif data.action == 'restart' then
        if GetResourceState(data.resource) == 'started' then
            if StopResource(data.resource) then
                Wait(1000)
                if StartResource(data.resource) then
                    supv.notify(source, 'simple', {
                        id = 'rm_restart',
                        title = 'supv_core',
                        description = ('Resource (%s) is restarted!'):format(data.resource),
                        duration = 2500,
                        type = 'success'
                    })
                end
            end
        else
            supv.notify(source, 'simple', {
                id = 'rm_restart',
                title = 'supv_core',
                description = ('Resource (%s) is not started!'):format(data.resource),
                duration = 2500,
                type = 'error'
            })
        end
    elseif data.action == 'stop' then
        if GetResourceState(data.resource) == 'started' then
            if StopResource(data.resource) then
                supv.notify(source, 'simple', {
                    id = 'rm_stop',
                    title = 'supv_core',
                    description = ('Resource (%s) is stopped!'):format(data.resource),
                    duration = 2500,
                    type = 'success'
                })
            else
                supv.notify(source, 'simple', {
                    id = 'rm_stop',
                    title = 'supv_core',
                    description = ('Failed to stop resource (%s)!'):format(data.resource),
                    duration = 2500,
                    type = 'error'
                })
            end
        end
    elseif data.action == 'refresh' then
        ExecuteCommand('refresh')
        supv.notify(source, 'simple', {
            id = 'rm_refresh',
            title = 'supv_core',
            description = 'Refreshed!',
            duration = 2500,
            type = 'success'
        })
    elseif data.action == 'reload' then ---@todo: need callback functionality to reload resource
        supv.notify(source, 'simple', {
            id = 'rm_reload',
            title = 'supv_core',
            description = 'Reload is not implemented yet!',
            duration = 2500,
            type = 'error'
        })
        return warn('Reload is not implemented yet!')
    end
end)

RegisterCommand('rm', function(source) ---@todo: renamed & rework soon
    if not next(Manager.resources) or not next(Manager.menu) then
        return warn('No resources registered!')
    end

    supv:emitNet('open:rm', source, Manager.menu)
end, true)
