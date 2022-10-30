local blacklist <const>, GetEntityModel <const>, CancelEvent <const> = Config.Blacklisted, GetEntityModel, CancelEvent

if blacklist.enable then
    AddEventHandler("entityCreating", function(entity)
        if blacklist.entity[GetEntityModel(entity)] then
            CancelEvent()
        end
    end)
end