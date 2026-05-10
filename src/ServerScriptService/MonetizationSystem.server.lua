-- MonetizationSystem.server.lua
-- Gamepasses, Developer Products y sistema Gacha

local Players             = game:GetService("Players")
local MarketplaceService  = game:GetService("MarketplaceService")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")

local Config    = require(ReplicatedStorage:WaitForChild("GameConfig"))
local PetData   = require(ReplicatedStorage:WaitForChild("PetData"))
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")

-- RemoteFunction para abrir la tienda Robux desde el cliente
local PromptGamepass  = Instance.new("RemoteEvent", GameEvents)
PromptGamepass.Name   = "PromptGamepass"
local PromptProduct   = Instance.new("RemoteEvent", GameEvents)
PromptProduct.Name    = "PromptProduct"

-- El cliente pide abrir un prompt de compra
PromptGamepass.OnServerEvent:Connect(function(player, passId)
    MarketplaceService:PromptGamePassPurchase(player, passId)
end)
PromptProduct.OnServerEvent:Connect(function(player, productId)
    MarketplaceService:PromptProductPurchase(player, productId)
end)

-- ══ Verificar Gamepasses al unirse ══
local function checkGamepasses(player)
    local gp = Config.Gamepasses
    local function check(id, attr)
        if id == 0 then return end
        local ok, owns = pcall(MarketplaceService.UserOwnsGamePassAsync, MarketplaceService, player.UserId, id)
        if ok and owns then
            player:SetAttribute(attr, true)
        end
    end
    check(gp.VIP,         "HasVIP")
    check(gp.SpeedBoost,  "HasSpeedBoost")
    check(gp.SkinPack,    "HasSkinPack")
    check(gp.RadarPerm,   "HasRadarPerm")
    check(gp.DoubleCoins, "HasDoubleCoins")
    check(gp.MouseAlways, "HasMouseAlways")
    check(gp.ExtraSlots,  "HasExtraSlots")
    -- Aplicar beneficios inmediatos
    if player:GetAttribute("HasDoubleCoins") then
        player:SetAttribute("CoinMultiplier", 2)
    end
    if player:GetAttribute("HasSpeedBoost") then
        player:SetAttribute("PetSpeedBonus", (player:GetAttribute("PetSpeedBonus") or 0) + 3)
    end
end

-- ══ Gacha — Mascota Aleatoria ══
local function rollPet()
    local roll = math.random(100)
    local cumulative = 0
    -- Agrupar mascotas por rareza
    local rarityPets = {}
    for _, pet in ipairs(PetData) do
        if not rarityPets[pet.rarity] then rarityPets[pet.rarity] = {} end
        table.insert(rarityPets[pet.rarity], pet)
    end
    -- Rarezas ordenadas por probabilidad
    local order = { "Común", "Legendario", "Máximo", "Ultra", "Dios" }
    local chances = { Común=60, Legendario=25, Máximo=10, Ultra=4, Dios=1 }
    for _, rarityName in ipairs(order) do
        cumulative = cumulative + (chances[rarityName] or 0)
        if roll <= cumulative then
            local pets = rarityPets[rarityName] or {}
            if #pets > 0 then
                return pets[math.random(#pets)]
            end
        end
    end
    return PetData[1]  -- fallback
end

-- ══ Procesar compras de Developer Products ══
local receiptHandlers = {}

receiptHandlers[Config.Products.Coins500]  = function(player) if _G.AddCoins then _G.AddCoins(player, 500)  end end
receiptHandlers[Config.Products.Coins1500] = function(player) if _G.AddCoins then _G.AddCoins(player, 1500) end end
receiptHandlers[Config.Products.Coins5000] = function(player) if _G.AddCoins then _G.AddCoins(player, 5000) end end
receiptHandlers[Config.Products.Shield]    = function(player)
    player:SetAttribute("ShieldActive", true)
    task.delay(300, function() player:SetAttribute("ShieldActive", false) end)
end
receiptHandlers[Config.Products.RandomPet] = function(player)
    local pet = rollPet()
    player:SetAttribute("EquippedPet", pet.id)
    -- Notificar al cliente qué mascota salió
    local PetRolled = GameEvents:FindFirstChild("PetRolled")
    if PetRolled then PetRolled:FireClient(player, pet) end
    print("[Monetization] " .. player.Name .. " obtuvo: " .. pet.name .. " (" .. pet.rarity .. ")")
end
receiptHandlers[Config.Products.RandomAccess] = function(player)
    local AccessoryData = require(ReplicatedStorage:WaitForChild("AccessoryData"))
    local acc = AccessoryData[math.random(#AccessoryData)]
    local owned = player:GetAttribute("OwnedAccessories") or ""
    player:SetAttribute("OwnedAccessories", owned .. "|" .. acc.id)
    print("[Monetization] " .. player.Name .. " obtuvo accesorio: " .. acc.name)
end

-- Notificación de mascota ganada
local PetRolled = Instance.new("RemoteEvent", GameEvents)
PetRolled.Name  = "PetRolled"

MarketplaceService.ProcessReceipt = function(receiptInfo)
    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if player then
        local handler = receiptHandlers[receiptInfo.ProductId]
        if handler then
            local ok, err = pcall(handler, player)
            if not ok then
                warn("[Monetization] Error procesando producto: " .. tostring(err))
                return Enum.ProductPurchaseDecision.NotProcessedYet
            end
        end
    end
    return Enum.ProductPurchaseDecision.PurchaseGranted
end

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, purchased)
    if purchased then
        checkGamepasses(player)
        print("[Monetization] " .. player.Name .. " compró gamepass: " .. passId)
    end
end)

Players.PlayerAdded:Connect(function(player)
    task.wait(2)
    checkGamepasses(player)
end)

print("[Monetization] Sistema de monetización iniciado")
