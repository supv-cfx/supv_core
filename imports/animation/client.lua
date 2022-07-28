local animation = {}
local props

local function load_anim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
		Wait(1)
    end
end

local function Cancel(self)
    self.playing = false
    ClearPedTasks(self.player)
    StopAnimTask(self.player, self.dict, self.name, 1.0)
    RemoveAnimDict(self.dict)
    if self.prop then
       props = props:remove()
    end
    return nil, collectgarbage()
end

local function Play(self)
    if self.strict then
        if #animation > 1  then
            return
        end
        if not self.playing then
            if not self.dead and (DoesEntityExist(self.player) and  IsEntityDead(self.player)) then
                return false
            end
    
            if self.task then
                TaskStartScenarioInPlace(self.player, self.task, 0, true)
            elseif self.name and self.dict then
                if DoesEntityExist(self.player) then
                    load_anim(self.dict)
                    TaskPlayAnim(self.player, self.dict, self.name, 3.0, 1.0, -1, self.flags, 0, 0, 0, 0)
                end
            end
    
            if self.prop then
                props = supv.object.new(self.prop.model, self.prop)
            end
    
            self.playing = true
        end
    end
end

local function Strict(anim, prop)
    assert(type(anim) == 'table', "[ERROR] : animation.play => l'argument [1] (anim) est invalide")
    assert(type(prop) == 'table' or type(prop) == 'nil', "[ERROR] : animation.play => l'argument [2] (prop) est invalide")

    local self = {}

    self.strict = true

    self.player = anim.player or supv.oncache.pedid
    self.dict = anim.dict
    self.name = anim.name
    self.flags = anim.flags or 1
    self.task = anim.task or nil
    self.time = anim.time or nil
    self.dead = anim.dead or false
    self.playing = false

    self.prop = prop or nil

    -- func ref
    self.play = Play
    self.stop = Cancel

    return self
end


return {
    strict = Strict
}

