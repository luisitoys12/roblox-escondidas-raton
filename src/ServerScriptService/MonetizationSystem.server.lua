-- MonetizationSystem.server.lua
-- Gamepasses, Developer Products y sistema Gacha.
-- IMPORTANTE: reemplaza todos los IDs 0 con tus IDs reales de create.roblox.com

local Players            = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local PetData            = require(ReplicatedStorage:WaitForChild("PetData"))

-- ==========================================
-- CONFIG — reemplaza los 0 con tus IDs reales
-- ==========================================
local GAMEPASSES = {
    VIP_MOUSE   = 0,  -- Ratón VIP       (150 Robux)
    SPEED_BOOST = 0,  -- Speed Boost     (100 Robux)
    SKIN_PACK   = 0,  -- Skin Pack       (200 Robux)
    RADAR_PERM  = 0,  -- Radar Permanente(250 Robux)
    VIP_BADGE   = 0,  -- VIP Badge       (75 Robux)
}

local DEV_PRODUCTS = {
    COINS_500     = 0,  -- Pack 500 monedas  — 25 Robux
    COINS_1500    = 0,  -- Pack 1500 monedas — 65 Robux
    COINS_5000    = 0,  -- Pack 5000 monedas — 180 Robux
    GACHA_COMMON  = 0,  -- Caja Común        — 30 Robux
    GACHA_PREMIUM = 0,  -- Caja Premium      — 80 Robux
    SHIELD_ROUND  = 0,  -- Escudo de Ronda   — 30 Robux
}
-- ==========================================

-- Aplicar beneficios de gamepasses al unirse
local function applyGamepasses(player)
    local checks = {
        { id = GAMEPASSES.VIP_MOUSE,   attr = "VIPMouse",      val = true  },
        { id = GAMEPASSES.SPEED_BOOST, attr = "SpeedBonus",    val = 5     },
        { id = GAMEPASSES.RADAR_PERM,  attr = "RadarPerm",     val = true  },
        { id = GAMEPASSES.SKIN_PACK,   attr = "HasSkinPack",   val = true  },
        { id = GAMEPASSES.VIP_BADGE,   attr = "VIPBadge",      val = true  },
    }
    for _, check in ipairs(checks) do
        if check.id ~= 0 then
            local ok, owns = pcall(MarketplaceService.UserOwnsGamePassAsync,
                MarketplaceService, player.UserId, check.id)
            if ok and owns then
                player:SetAttribute(check.attr, check.val)
                if check.attr == "VIPBadge" then
                    player:SetAttribute("CoinMultiplier",
                        math.max(player:GetAttribute("CoinMultiplier") or 1, 1.5))
                end
                print("[Monetization] " .. player.Name .. " → " .. check.attr)
            end
        end
    end
end

-- ==========================================
-- GACHA — probabilidades por tipo de caja
-- ==========================================
local GACHA_POOLS = {
    common = {
        { rarity="Común",      weight=70 },
        { rarity="Legendario", weight=25 },
        { rarity="Máximo",     weight=5  },
    },
    premium = {
        { rarity="Legendario", weight=50 },
        { rarity="Máximo",     weight=30 },
        { rarity="Ultra",      weight=15 },
        { rarity="Dios",       weight=5  },
    },
}

local function rollGacha(poolName)
    local pool = GACHA_POOLS[poolName]
    local total = 0
    for _, e in ipairs(pool) do total += e.weight end
    local roll = math.random(total)
    local acc = 0
    local chosen = "Común"
    for _, e in ipairs(pool) do
        acc += e.weight
        if roll <= acc then chosen = e.rarity break end
    end
    local candidates = {}
    for _, pet in ipairs(PetData) do
        if pet.rarity == chosen then table.insert(candidates, pet) end
    end
    return candidates[math.random(math.max(1,#candidates))]
end

local function giveGachaPet(player, poolName)
    local pet = rollGacha(poolName)
    player:SetAttribute("EquippedPet", pet.id)
    if pet.bonus.type == "coinMultiplier" then
        player:SetAttribute("CoinMultiplier", pet.bonus.value)
    elseif pet.bonus.type == "speed" then
        player:SetAttribute("PetSpeedBonus", pet.bonus.value)
    elseif pet.bonus.type == "allBonus" then
        player:SetAttribute("CoinMultiplier", pet.bonus.value)
        player:SetAttribute("PetSpeedBonus",  pet.bonus.value)
    end
    print("[Gacha] " .. player.Name .. " → " .. pet.name .. " (" .. pet.rarity .. ")")
    return pet
end

-- ==========================================
-- PROCESAR DEVELOPER PRODUCTS
-- ==========================================
local purchaseHistory = {}

MarketplaceService.ProcessReceipt = function(receiptInfo)
    local key = receiptInfo.PurchaseId
    if purchaseHistory[key] then
        return Enum.ProductPurchaseDecision.PurchaseGranted
    end
    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if not player then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end
    local pid = receiptInfo.ProductId
    local GameEvents = ReplicatedStorage:FindFirstChild("GameEvents")

    if     pid == DEV_PRODUCTS.COINS_500  then _G.AddCoins and _G.AddCoins(player, 500)
    elseif pid == DEV_PRODUCTS.COINS_1500 then _G.AddCoins and _G.AddCoins(player, 1500)
    elseif pid == DEV_PRODUCTS.COINS_5000 then _G.AddCoins and _G.AddCoins(player, 5000)
    elseif pid == DEV_PRODUCTS.SHIELD_ROUND then
        player:SetAttribute("ShieldActive", true)
    elseif pid == DEV_PRODUCTS.GACHA_COMMON or pid == DEV_PRODUCTS.GACHA_PREMIUM then
        local pool = pid == DEV_PRODUCTS.GACHA_COMMON and "common" or "premium"
        local pet = giveGachaPet(player, pool)
        if GameEvents then
            local ev = GameEvents:FindFirstChild("GachaResult")
            if ev then ev:FireClient(player, pet) end
        end
    end

    purchaseHistory[key] = true
    return Enum.ProductPurchaseDecision.PurchaseGranted
end

Players.PlayerAdded:Connect(function(player)
    task.wait(2)
    applyGamepasses(player)
end)

-- RemoteEvent resultado gacha
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local GachaResult = Instance.new("RemoteEvent", GameEvents)
GachaResult.Name = "GachaResult"

print("[Monetization] Sistema iniciado — reemplaza IDs 0 en GAMEPASSES y DEV_PRODUCTS")
