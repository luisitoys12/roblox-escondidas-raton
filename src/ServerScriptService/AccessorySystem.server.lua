-- AccessorySystem.server.lua
-- Gestiona equipar/desequipar accesorios y ropa en el personaje

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AccessoryData = require(ReplicatedStorage:WaitForChild("AccessoryData"))
local ClothingData  = require(ReplicatedStorage:WaitForChild("ClothingData"))
local GameEvents    = ReplicatedStorage:WaitForChild("GameEvents")

-- RemoteFunctions
local EquipAccessory  = Instance.new("RemoteFunction", GameEvents)
EquipAccessory.Name   = "EquipAccessory"
local EquipClothing   = Instance.new("RemoteFunction", GameEvents)
EquipClothing.Name    = "EquipClothing"
local GetWardrobe     = Instance.new("RemoteFunction", GameEvents)
GetWardrobe.Name      = "GetWardrobe"

-- Guardar equipamiento en memoria
local playerWardrobe = {}  -- [userId] = { hat=id, face=id, back=id, trail=id, shirt=id, pants=id }

local function getWardrobe(player)
    if not playerWardrobe[player.UserId] then
        playerWardrobe[player.UserId] = {}
    end
    return playerWardrobe[player.UserId]
end

-- Aplicar accesorio al personaje
local function applyAccessory(player, accessoryId)
    local char = player.Character
    if not char then return false end

    -- Buscar data del accesorio
    local accData = nil
    for _, a in ipairs(AccessoryData) do
        if a.id == accessoryId then accData = a break end
    end
    if not accData then return false end

    -- Remover accesorio anterior del mismo slot
    local slot = accData.slot
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") and child:GetAttribute("Slot") == slot then
            child:Destroy()
        end
    end

    -- Crear nuevo accesorio
    local acc = Instance.new("Accessory")
    acc:SetAttribute("Slot", slot)
    acc.Name = accData.name

    local handle = Instance.new("Part", acc)
    handle.Name = "Handle"
    handle.Size = Vector3.new(1,1,1)

    if accData.meshId then
        local mesh = Instance.new("SpecialMesh", handle)
        mesh.MeshId    = accData.meshId
        mesh.TextureId = accData.textureId or ""
    end

    -- Trails como Attachment + Trail
    if slot == "Trail" and accData.particleId then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local att0 = Instance.new("Attachment", hrp)
            att0.Name = "TrailAtt0"
            local att1 = Instance.new("Attachment", hrp)
            att1.Name = "TrailAtt1"
            att1.Position = Vector3.new(0,-2,0)
            local trail = Instance.new("Trail", hrp)
            trail.Attachment0 = att0
            trail.Attachment1 = att1
            trail.Lifetime    = 0.5
            trail.MinLength   = 0
        end
        return true
    end

    acc.Parent = char
    return true
end

-- Aplicar ropa al personaje
local function applyClothing(player, clothingId)
    local char = player.Character
    if not char then return false end

    local clothData = nil
    for _, c in ipairs(ClothingData) do
        if c.id == clothingId then clothData = c break end
    end
    if not clothData then return false end

    -- Verificar gamepass si aplica
    if clothData.requiresGamepass then
        local hasPass = player:GetAttribute("HasVIP") or false
        if not hasPass then
            return false, "Requiere Gamepass VIP"
        end
    end

    if clothData.type == "Shirt" then
        local shirt = char:FindFirstChildOfClass("Shirt")
        if not shirt then
            shirt = Instance.new("Shirt", char)
        end
        shirt.ShirtTemplate = clothData.shirtTemplate
    elseif clothData.type == "Pants" then
        local pants = char:FindFirstChildOfClass("Pants")
        if not pants then
            pants = Instance.new("Pants", char)
        end
        pants.PantsTemplate = clothData.pantsTemplate
    elseif clothData.type == "Outfit" then
        -- Aplicar cada pieza del outfit
        for _, itemId in ipairs(clothData.items) do
            applyClothing(player, itemId)
        end
    end
    return true
end

-- Handlers remotos
EquipAccessory.OnServerInvoke = function(player, accessoryId)
    local owned = player:GetAttribute("OwnedAccessories") or ""
    if not string.find(owned, accessoryId) then
        return { success=false, message="No tienes este accesorio" }
    end
    local ok = applyAccessory(player, accessoryId)
    if ok then
        getWardrobe(player).hat = accessoryId
    end
    return { success=ok, message=ok and "¡Equipado!" or "Error al equipar" }
end

EquipClothing.OnServerInvoke = function(player, clothingId)
    local owned = player:GetAttribute("OwnedClothing") or ""
    if not string.find(owned, clothingId) then
        return { success=false, message="No tienes esta ropa" }
    end
    local ok, msg = applyClothing(player, clothingId)
    return { success=ok, message=msg or (ok and "¡Equipado!" or "Error") }
end

GetWardrobe.OnServerInvoke = function(player)
    return getWardrobe(player)
end

-- Re-aplicar equipo al respawnear
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        local wardrobe = getWardrobe(player)
        for slot, itemId in pairs(wardrobe) do
            if slot == "shirt" or slot == "pants" then
                applyClothing(player, itemId)
            else
                applyAccessory(player, itemId)
            end
        end
    end)
end)

-- Exponer globalmente
_G.ApplyAccessory = applyAccessory
_G.ApplyClothing  = applyClothing

print("[AccessorySystem] Sistema de accesorios y ropa iniciado")
