local Inventory = {}

function Inventory:AddItem(inv, itemName, itemCount, metadata)
    local can = inv.canCarryItem(itemName, itemCount)
    if not can then
        return false
    end

    inv.addInventoryItem(itemName, itemCount, metadata)
    return true
end

function Inventory:RemoveItem(inv, itemName, itemCount, slot, metadata)
    inv.removeInventoryItem(itemName, itemCount, slot, metadata)
    return true
end

function Inventory:HasItem(inv, itemName, itemCount, metadata)
    local items = inv.getInventoryItem(itemName).count
    return items >= itemCount
end

return Inventory