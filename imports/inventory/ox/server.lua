local export <const> = exports.ox_inventory
local Inventory = {}

function Inventory:AddItem(inv, itemName, itemCount, metadata)
    return export:AddItem(inv, itemName, itemCount, metadata)
end

function Inventory:RemoveItem(inv, itemName, itemCount, slot, metadata)
    return export:RemoveItem(inv, itemName, itemCount, slot, metadata)
end

function Inventory:HasItem(inv, itemName, itemCount, metadata)
    local items = export:GetItemCount(inv, itemName, metadata)
    return items >= itemCount
end

return Inventory