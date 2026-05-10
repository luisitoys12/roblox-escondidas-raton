-- GamepassSystem.server.lua
-- Verifica gamepasses al unirse y aplica beneficios permanentes.
-- Procesa Developer Products (monedas, mascota aleatoria, escudo).

local Players           = game:GetService("Players")
local MarketplaceService= game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GamepassData = require(ReplicatedStorage:WaitForChild("GamepassData"))
local PetData      = require(ReplicatedStorage:WaitForChild("PetData"))

task.wait(2) -- esperar sistemas

-- Verificar todos los gamepasses del jugador al unirse
local function checkGamepasses(player)
    for _, pass in ipairs(GamepassData.Passes) do
        if pass.gamepassId == 0 then continue end
        local ok, owns = pcall(MarketplaceService.UserOwnsGamePassAsync,
                               MarketplaceService, player.UserId, pass.gamepassId)
        if ok and owns then
            player:SetAttribute("GP_" .. pass.id, true)
            -- Aplicar beneficio inmediato
            if pass.benefit == "permanentSpeed" then
                local bonus = (player:GetAttribute("PetSpeedBonus") or 0) + (pass.value or 5)
                player:SetAttribute("PetSpeedBonus", bonus)
            elseif pass.benefit == "vipBadge" then
                player:SetAttribute("IsVIP", true)
                player:SetAttribute("CoinMultiplier",
                    math.max(player:GetAttribute("CoinMultiplier") or 1, 1.5))
            elseif pass.benefit == "doubleCoinsPerm" then
                player:SetAttribute("CoinMultiplier",
                    math.max(player:GetAttribute("CoinMultiplier") or 1, 2.0))
            elseif pass.benefit == "unlockAllMaps" then
                player:SetAttribute("AllMapsUnlocked", true)
            elseif pass.benefit == "freeRadar" then
                player:SetAttribute("HasFreeRadar", true)
            end
            print("[GamepassSystem] " .. player.Name .. " tiene gamepass: " .. pass.name)
        end
    end
end

-- Gacha de mascotas por rareza
local rarityWeights = {
    { rarity="Común",      weight=60 },
    { rarity="Legendario", weight=25 },
    { rarity="Máximo",     weight=10 },
    { rarity="Ultra",      weight=4  },
    { rarity="Dios",       weight=1  },
}

local function rollRandomPet(player)
    local roll = math.random(100)
    local cumulative = 0
    local chosenRarity = "Común"
    for _, r in ipairs(rarityWeights) do
        cumulative += r.weight
        if roll <= cumulative then
            chosenRarity = r.rarity
            break
        end
    end
    -- Filtrar mascotas de esa rareza
    local pool = {}
    for _, pet in ipairs(PetData) do
        if pet.rarity == chosenRarity then
            table.insert(pool, pet)
        end
    end
    if #pool == 0 then return nil end
    local pet = pool[math.random(#pool)]
    -- Equipar mascota
    player:SetAttribute("EquippedPet", pet.id)
    if pet.bonus.type == "coinMultiplier" then
        player:SetAttribute("CoinMultiplier", pet.bonus.value)
    elseif pet.bonus.type == "speed" then
        player:SetAttribute("PetSpeedBonus", pet.bonus.value)
    elseif pet.bonus.type == "allBonus" then
        player:SetAttribute("CoinMultiplier", pet.bonus.value)
        player:SetAttribute("PetSpeedBonus", pet.bonus.value)
    end
    print("[GamepassSystem] " .. player.Name .. " obtuvo mascota [" .. chosenRarity .. "]: " .. pet.name)
    return pet
end

-- Procesar Developer Products
MarketplaceService.ProcessReceipt = function(receiptInfo)
    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if not player then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    for _, prod in ipairs(GamepassData.Products) do
        if prod.productId == receiptInfo.ProductId then
            if prod.coins and prod.coins > 0 then
                if _G.AddCoins then _G.AddCoins(player, prod.coins) end
                print("[GamepassSystem] +" .. prod.coins .. " monedas para " .. player.Name)
            elseif prod.id == "pet_random" then
                rollRandomPet(player)
            elseif prod.id == "shield" then
                player:SetAttribute("HasShield", true)
                print("[GamepassSystem] Escudo activado para " .. player.Name)
            end
            return Enum.ProductPurchaseDecision.PurchaseGranted
        end
    end
    return Enum.ProductPurchaseDecision.NotProcessedYet
end

Players.PlayerAdded:Connect(function(player)
    task.wait(3)
    checkGamepasses(player)
end)

-- Exponer función de gacha globalmente
_G.RollRandomPet = rollRandomPet

print("[GamepassSystem] Sistema de gamepasses iniciado")
