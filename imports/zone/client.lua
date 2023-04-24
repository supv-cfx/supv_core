local zones = {}

local function Remove(self)
    if zones[self.id] then
        table.remove(zones, self.id)
        return nil, collectgarbage()
    end
end

local function Create(coords, distance, options, data)
    local self = {}
    
    self.id = #zones + 1
    self.coords = coords
    self.maxDistance = distance.max or 10 -- onEnter / onExit
    self.distance = distance.nearby or 2

    self.inZone = false
    self.inside = false
    self.currentDistance = nil

    self.remove = Remove
    return self
end

CreateThread(function()
    local player = supv.player.get()
    while true do
        if #zones > 0 then
            for i = 1, #zones do
                local zone = zones[i]
                player:distance(zone.coords)

                if player.dist <= zone.maxDistance then
                    if not zone.inZone then
                        zone.inZone = true
                        if zone.onEnter then
                            zone:onEnter()
                        end
                    end
                    
                    if zone.inZone then
                        if player.dist <= zone.distance then
                            if not zone.inside then
                                zone.inside = true
                                if zone.onInside then
                                    zone:onInside()
                                end
                            end

                            if zone.inside then
                                if zone.nearby then

                                end
                            end
                        else
                            if zone.inside then
                                zone.inside = false
                                if zone.onOutside then
                                    zone:onOutside()
                                end
                            end
                        end
                    end
                elseif player.dist > zone.maxDistance then
                    if zone.inZone then
                        if zone.onExit then
                            zone:onExit()
                        end
                        zone.inZone = false
                    end
                end
            end
        end
        Wait(500)
    end
end)

return {
    new = Create
}