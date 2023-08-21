local GetShapeTestResultIncludingMaterial <const> = GetShapeTestResultIncludingMaterial
local GetWorldCoordFromScreenCoord <const> = GetWorldCoordFromScreenCoord
local StartShapeTestLosProbe <const> = StartShapeTestLosProbe

---@alias Flags
---| 0 None
---| 1 Intersect world
---| 2 Intersect vehicles
---| 4 Intersect peds simple collision
---| 8 Intersect peds
---| 16 Intersect objects
---| 32 Intersect water
---| 128 Unknown
---| 256 Intersect foliage (trees, plants, etc.)
---| 511 Intersect everything
---| 4294967295 Intersect everything

---@alias TestIgnore
---| 1 GLASS
---| 2 SEE_THROUGH
---| 3 GLASS | SEE_THROUGH
---| 4 NO_COLLISION
---| 7 GLASS | SEE_THROUGH | NO_COLLISION

---@class Raycast
---@field hit boolean
---@field entityHit number
---@field endCoords vector3
---@field surfaceNormal vector3
---@field materialHash number

---@param distance number-10? defaults to 10.
---@param flags number-511? defaults to 511 (https://docs.fivem.net/natives/?_0x377906D8A31E5586).
---@param ignore TestIgnore-4? TestIgnore.NO_COLLISION
---@return table Raycast { hit: boolean, entityHit: number, endCoords: vector3, surfaceNormal: vector3, materialHash: number}
return function(distance, flags, ignore)
    local worldVector <const>, normalVector <const> = GetWorldCoordFromScreenCoord(.5, .5) -- Center of the screenX and screenY
    local destinationVector <const> = (worldVector + normalVector) * (distance or 10)
    local handle <const> = StartShapeTestLosProbe(worldVector.x, worldVector.y, worldVector.z, destinationVector.x, destinationVector.y, destinationVector.z, flags or 511, supv.cache.ped or 0, ignore or 4)

    while true do
        Wait(0)
        local retval <const>, hit <const>, endCoords <const>, surfaceNormal <const>, materialHash <const>, entityHit <const> = GetShapeTestResultIncludingMaterial(handle)

        if retval ~= 1 then
            return {
                hit = hit,
                entityHit = entityHit,
                endCoords = endCoords,
                surfaceNormal = surfaceNormal,
                materialHash = materialHash
            }
        end
    end
end