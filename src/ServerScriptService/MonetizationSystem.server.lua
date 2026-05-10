-- MonetizationSystem.server.lua
-- Maneja Gamepasses y Developer Products (compras de monedas + gacha de mascotas)
-- IMPORTANTE: Reemplaza los IDs con los reales de tu juego en Roblox

local Players             = game:GetService("Players")
local MarketplaceService  = game:GetService("MarketplaceService")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local Config              = require(ReplicatedStorage:WaitForChild("GameConfig"))
local PetData             = require(ReplicatedStorage:WaitForChild("PetData"))

-- ══════════════════════════════════════════
-- IDs DE GAMEPASSES — reemplaza con los tuyos
-- Créalos en: create.roblox.com → tu juego → Monetization → Passes
-- ══════════════════════════════════════════
local GAMEPASSES = {
    VIP_MOUSE      = 0,   -- Ratón VIP (150 Robux) — prioridad de ser Ratón
    SPEED_BOOST    = 0,   -- Speed Boost (100 Robux) — +5 velocidad permanente
    SKIN_PACK      = 0,   -- Skin Pack (200 Robux) — skin exclusiva
    RADAR_PERM     = 0,   -- Radar Permanente (250 Robux) — herramienta radar gratis
    VIP_BADGE      = 0,   -- VIP Badge (75 Robux) — nombre dorado + x1.5 monedas
}

-- ══════════════════════════════════════════
-- IDs DE DEVELOPER PRODUCTS — reemplaza con los tuyos
-- Créalos en: create.roblox.com → tu juego → Monetization → Developer Products
-- ══════════════════════════════════════════
local PRODUCTS = {
    COINS_500      = 0,   -- Pack 500 monedas (25 Robux)
    COINS_1500     = 0,   -- Pack 1500 monedas (65 Robux)
    COINS_5000     = 0,   -- Pack 5000 monedas (180 Robux)
    PET_RANDOM     = 0,   -- Mascota Aleatoria Gacha (50 Robux)
    SHIELD_ROUND   = 0,   -- Escudo de ronda (30 Robux)
}

-- ══ Aplicar beneficios de Gamepass al unirse ══
local function applyGamepasses(player)
    -- VIP Badge
    local ok, ownsVIP = pcall(MarketplaceService.UserOwnsGamePassAsync,
        MarketplaceService, player.UserId, GAMEPASSES.VIP_BADGE)
    if ok and ownsVIP then
        player:SetAttribute("HasVIPBadge", true)
        player:SetAttribute("CoinMultiplier", 1.5)
        print("[Monetization] " .. player.Name .. " tiene VIP Badge")
    end

    -- Speed Boost
    local ok2, ownsSpeed = pcall(MarketplaceService.UserOwnsGamePassAsync,
        MarketplaceService, player.UserId, GAMEPASSES.SPEED_BOOST)
    if ok2 and ownsSpeed then
        player:SetAttribute("SpeedPassBonus", 5)
        print("[Monetization] " .. player.Name .. " tiene Speed Boost")
    end

    -- Radar Permanente
    local ok3, ownsRadar = pcall(MarketplaceService.UserOwnsGamePassAsync,
        MarketplaceService, player.UserId, GAMEPASSES.RADAR_PERM)
    if ok3 and ownsRadar then
        player:SetAttribute("HasRadarPass", true)
        print("[Monetization] " .. player.Name .. " tiene Radar Permanente")
    end

    -- VIP Mouse (prioridad de ser Ratón — se procesa en GameManager)
    local ok4, ownsVIPMouse = pcall(MarketplaceService.UserOwnsGamePassAsync,
        MarketplaceService, player.UserId, GAMEPASSES.VIP_MOUSE)
    if ok4 and ownsVIPMouse then
        player:SetAttribute("HasMousePass", true)
        print("[Monetization] " .. player.Name .. " tiene Ratón VIP")
    end
end

-- ══ Procesar Developer Products (compras repetibles) ══
MarketplaceService.ProcessReceipt = function(receiptInfo)
    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if not player then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    local productId = receiptInfo.ProductId

    -- Pack 500 monedas
    if productId == PRODUCTS.COINS_500 then
        if _G.AddCoins then _G.AddCoins(player, 500) end
        print("[Monetization] " .. player.Name .. " compró 500 monedas")
        return Enum.ProductPurchaseDecision.PurchaseGranted
    end

    -- Pack 1500 monedas
    if productId == PRODUCTS.COINS_1500 then
        if _G.AddCoins then _G.AddCoins(player, 1500) end
        print("[Monetization] " .. player.Name .. " compró 1500 monedas")
        return Enum.ProductPurchaseDecision.PurchaseGranted
    end

    -- Pack 5000 monedas
    if productId == PRODUCTS.COINS_5000 then
        if _G.AddCoins then _G.AddCoins(player, 5000) end
        print("[Monetization] " .. player.Name .. " compró 5000 monedas")
        return Enum.ProductPurchaseDecision.PurchaseGranted
    end

    -- Mascota Aleatoria Gacha
    if productId == PRODUCTS.PET_RANDOM then
        local pet, rarity = PetData.GetRandom()
        if pet then
            player:SetAttribute("EquippedPet", pet.id)
            -- Aplicar bonus de la mascota obtenida
            if pet.bonus.type == "coinMultiplier" then
                local current = player:GetAttribute("CoinMultiplier") or 1
                player:SetAttribute("CoinMultiplier", math.max(current, pet.bonus.value))
            elseif pet.bonus.type == "speed" then
                player:SetAttribute("PetSpeedBonus", pet.bonus.value)
            end
            -- Notificar al cliente qué mascota salió
            local GameEvents = ReplicatedStorage:FindFirstChild("GameEvents")
            if GameEvents then
                local evt = GameEvents:FindFirstChild("PetObtained")
                if not evt then
                    evt = Instance.new("RemoteEvent", GameEvents)
                    evt.Name = "PetObtained"
                end
                evt:FireClient(player, pet, rarity)
            end
            print("[Monetization] " .. player.Name .. " obtuvo mascota [" .. rarity .. "]: " .. pet.name)
        end
        return Enum.ProductPurchaseDecision.PurchaseGranted
    end

    -- Escudo de ronda
    if productId == PRODUCTS.SHIELD_ROUND then
        player:SetAttribute("ShieldRounds",
            (player:GetAttribute("ShieldRounds") or 0) + 1)
        print("[Monetization] " .. player.Name .. " compró Escudo de Ronda")
        return Enum.ProductPurchaseDecision.PurchaseGranted
    end

    return Enum.ProductPurchaseDecision.NotProcessedYet
end

-- Aplicar gamepasses al unirse
Players.PlayerAdded:Connect(function(player)
    task.wait(2)
    applyGamepasses(player)
end)

for _, player in ipairs(Players:GetPlayers()) do
    applyGamepasses(player)
end

print("[Monetization] Sistema de monetización iniciado")
