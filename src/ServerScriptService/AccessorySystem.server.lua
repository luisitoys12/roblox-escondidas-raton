-- AccessorySystem.server.lua
-- Maneja equipar/desequipar accesorios y ropa en el personaje.
-- Valida que el jugador posea el item antes de equiparlo.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AccessoryData     = require(ReplicatedStorage:WaitForChild("AccessoryData"))
local ClothingData      = require(ReplicatedStorage:WaitForChild("ClothingData"))
local GameEvents        = ReplicatedStorage:WaitForChild("GameEvents")

-- Inventarios en memoria [userId] = { accessories={}, clothing={} }
local inventories = {}

local function getInventory(player)
    if not inventories[player.UserId] then
        inventories[player.UserId] = { accessories = {}, clothing = {} }
    end
    return inventories[player.UserId]
end

local function hasItem(player, itemId)
    local inv = getInventory(player)
    for _, id in ipairs(inv.accessories) do
        if id == itemId then return true end
    end
    for _, id in ipairs(inv.clothing) do
        if id == itemId then return true end
    end
    return false
end

-- Equipar accesorio en el personaje
local function equipAccessory(player, accessoryId)
    local char = player.Character
    if not char then return false, "Sin personaje" end

    for _, acc in ipairs(AccessoryData) do
        if acc.id == accessoryId then
            if acc.slot == "Trail" then
                -- Manejar estelas con ParticleEmitter en HRP
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- Remover estela anterior del mismo slot
                    for _, child in ipairs(hrp:GetChildren()) do
                        if child:GetAttribute("TrailEffect") then child:Destroy() end
                    end
                    local particle = Instance.new("ParticleEmitter", hrp)
                    particle:SetAttribute("TrailEffect", true)
                    particle.Texture = acc.particleId or "rbxasset://textures/particles/sparkles_main.dds"
                    particle.Rate = 50
                    particle.Lifetime = NumberRange.new(0.5, 1)
                    particle.Speed = NumberRange.new(5)
                end
            else
                -- Remover accesorio anterior del mismo slot
                for _, child in ipairs(char:GetChildren()) do
                    if child:IsA("Accessory") and child:GetAttribute("Slot") == acc.slot then
                        child:Destroy()
                    end
                end
                -- Equipar nuevo accesorio (assetId debe estar en la toolbox)
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid and acc.assetId and acc.assetId ~= "rbxassetid://0" then
                    local InsertService = game:GetService("InsertService")
                    local ok, result = pcall(function()
                        return InsertService:LoadAsset(tonumber(acc.assetId:match("%d+")))
                    end)
                    if ok and result then
                        local accModel = result:FindFirstChildOfClass("Accessory")
                        if accModel then
                            accModel:SetAttribute("Slot", acc.slot)
                            humanoid:AddAccessory(accModel)
                        end
                    end
                end
            end
            player:SetAttribute("EquippedAcc_" .. acc.slot, accessoryId)
            return true, "Accesorio equipado: " .. acc.name
        end
    end
    return false, "Accesorio no encontrado"
end

-- Equipar ropa (camisa/pantalón)
local function equipClothing(player, clothingId)
    local char = player.Character
    if not char then return false, "Sin personaje" end

    for _, cloth in ipairs(ClothingData) do
        if cloth.id == clothingId then
            if cloth.type == "Shirt" or cloth.type == "Outfit" then
                local shirt = char:FindFirstChildOfClass("Shirt")
                    or Instance.new("Shirt", char)
                shirt.ShirtTemplate = cloth.shirtId or ""
            end
            if cloth.type == "Pants" or cloth.type == "Outfit" then
                local pants = char:FindFirstChildOfClass("Pants")
                    or Instance.new("Pants", char)
                pants.PantsTemplate = cloth.pantsId or ""
            end
            player:SetAttribute("EquippedClothing", clothingId)
            return true, "Ropa equipada: " .. cloth.name
        end
    end
    return false, "Ropa no encontrada"
end

-- RemoteFunctions para el cliente
local EquipItem = Instance.new("RemoteFunction", GameEvents)
EquipItem.Name  = "EquipItem"
EquipItem.OnServerInvoke = function(player, itemType, itemId)
    if not hasItem(player, itemId) then
        -- Intentar comprar primero si tiene monedas
        return { success = false, message = "No posees este item. Cómpralo en la tienda." }
    end
    if itemType == "accessory" then
        local ok, msg = equipAccessory(player, itemId)
        return { success = ok, message = msg }
    elseif itemType == "clothing" then
        local ok, msg = equipClothing(player, itemId)
        return { success = ok, message = msg }
    end
    return { success = false, message = "Tipo desconocido" }
end

-- Exponer funciones globales
_G.EquipAccessory  = equipAccessory
_G.EquipClothing   = equipClothing
_G.GetInventory    = getInventory
_G.AddToInventory  = function(player, itemType, itemId)
    local inv = getInventory(player)
    local list = itemType == "accessory" and inv.accessories or inv.clothing
    for _, id in ipairs(list) do
        if id == itemId then return end  -- ya lo tiene
    end
    table.insert(list, itemId)
end

Players.PlayerAdded:Connect(function(player)
    inventories[player.UserId] = { accessories = {}, clothing = {} }
    -- TODO: cargar inventario desde DataStore
end)

Players.PlayerRemoving:Connect(function(player)
    -- TODO: guardar inventario en DataStore
    inventories[player.UserId] = nil
end)

print("[AccessorySystem] Sistema de accesorios y ropa iniciado")
