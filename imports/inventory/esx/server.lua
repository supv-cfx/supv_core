local Inventory = {}
local GetPlayerFromId in framework

function Inventory:AddItem(inv, itemName, itemCount, metadata)
    local player = GetPlayerFromId(inv)
    local can = player.canCarryItem(itemName, itemCount)
    if not can then
        return false
    end

    inv.addInventoryItem(itemName, itemCount, metadata)
    return true
end

function Inventory:RemoveItem(inv, itemName, itemCount, slot, metadata)
    local player = GetPlayerFromId(inv)
    player.removeInventoryItem(itemName, itemCount, slot, metadata)
    return true
end

function Inventory:HasItem(inv, itemName, itemCount, metadata)
    local player = GetPlayerFromId(inv)
    local items = player.getInventoryItem(itemName).count
    return items >= itemCount
end

return Inventory