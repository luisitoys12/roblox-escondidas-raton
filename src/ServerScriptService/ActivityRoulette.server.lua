-- AccessoryRoulette.server.lua
-- Ruleta de ACCESORIOS cosméticos. Se activa comprando con Robux.
-- NO es evento automático. El jugador paga → gira → gana un accesorio.
-- Accesorios son puramente cosméticos (sombreros, alas, capas, trails, etc.)

local Players            = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")

local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")

-- RemoteEvents
local SpinResult   = Instance.new("RemoteEvent", GameEvents)
SpinResult.Name    = "SpinResult"     -- resultado accesorio -> cliente
local SpinRequest  = Instance.new("RemoteFunction", GameEvents)
SpinRequest.Name   = "SpinRequest"    -- cliente pide girar (después de compra)

-- ==========================================
--  DEVELOPER PRODUCTS para la ruleta
--  Reemplaza los 0 con tus IDs reales
-- ==========================================
local ROULETTE_PRODUCTS = {
    SPIN_1   = 0,   -- 1 giro   — 30 Robux
    SPIN_3   = 0,   -- 3 giros  — 75 Robux
    SPIN_10  = 0,   -- 10 giros — 200 Robux (mejor valor)
}

-- ==========================================
--  CATÁLOGO DE ACCESORIOS
--  icon = rbxassetid del accesorio en el catálogo
--  applyId = ID del accesorio para WearAccessory
-- ==========================================
local ACCESSORIES = {
    -- COMÚN (gris)
    { id="hat_cap",      name="Gorra Ratón",       rarity="Común",      weight=35, icon="rbxassetid://0", applyId=0 },
    { id="trail_smoke",  name="Estela de Humo",    rarity="Común",      weight=30, icon="rbxassetid://0", applyId=0 },
    { id="tag_cheese",   name="Tag Queso",          rarity="Común",      weight=25, icon="rbxassetid://0", applyId=0 },
    -- LEGENDARIO (dorado)
    { id="wings_bat",    name="Alas de Murciélago",rarity="Legendario", weight=12, icon="rbxassetid://0", applyId=0 },
    { id="cape_shadow",  name="Capa Sombra",        rarity="Legendario", weight=10, icon="rbxassetid://0", applyId=0 },
    { id="trail_stars",  name="Estela Estelar",    rarity="Legendario", weight=8,  icon="rbxassetid://0", applyId=0 },
    -- MÁXIMO (morado)
    { id="crown_neon",   name="Corona Neón",        rarity="Máximo",     weight=4,  icon="rbxassetid://0", applyId=0 },
    { id="aura_fire",    name="Aura de Fuego",      rarity="Máximo",     weight=3,  icon="rbxassetid://0", applyId=0 },
    { id="trail_rainbow",name="Estela Arcoíris",    rarity="Máximo",     weight=2,  icon="rbxassetid://0", applyId=0 },
    -- ULTRA (rojo)
    { id="mask_phantom", name="Máscara Fantasma",   rarity="Ultra",      weight=1,  icon="rbxassetid://0", applyId=0 },
    -- DIOS (multicolor)
    { id="halo_god",     name="Halo Divino",        rarity="Dios",       weight=0.5,icon="rbxassetid://0", applyId=0 },
}

-- ==========================================
--  FUNCIÓN GACHA
-- ==========================================
local function rollAccessory()
    local total = 0
    for _, a in ipairs(ACCESSORIES) do total += a.weight end
    local roll = math.random() * total
    local acc = 0
    for _, a in ipairs(ACCESSORIES) do
        acc += a.weight
        if roll <= acc then return a end
    end
    return ACCESSORIES[1]
end

-- Guardar accesorios del jugador en atributos (lista separada por coma)
local function saveAccessory(player, accId)
    local current = player:GetAttribute("OwnedAccessories") or ""
    if not string.find(current, accId) then
        player:SetAttribute("OwnedAccessories",
            current == "" and accId or current .. "," .. accId)
    end
end

local function doSpin(player, count)
    local results = {}
    for i = 1, count do
        local acc = rollAccessory()
        saveAccessory(player, acc.id)
        table.insert(results, acc)
        print("[Ruleta] " .. player.Name .. " ganó: " .. acc.name .. " (" .. acc.rarity .. ")")
    end
    SpinResult:FireClient(player, results)
end

-- ==========================================
--  PROCESAR COMPRAS
-- ==========================================
local purchaseHistory = {}

-- Integrar con ProcessReceipt global
-- Si ya tienes MonetizationSystem, mueve estos casos ahí
-- Este sistema registra un handler de fallback
local existingHandler = MarketplaceService.ProcessReceipt
MarketplaceService.ProcessReceipt = function(receiptInfo)
    -- Intentar con el handler existente primero
    if existingHandler and existingHandler ~= MarketplaceService.ProcessReceipt then
        local res = existingHandler(receiptInfo)
        if res == Enum.ProductPurchaseDecision.PurchaseGranted then
            return res
        end
    end

    local key = receiptInfo.PurchaseId
    if purchaseHistory[key] then
        return Enum.ProductPurchaseDecision.PurchaseGranted
    end

    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if not player then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    local pid = receiptInfo.ProductId
    if     pid == ROULETTE_PRODUCTS.SPIN_1  then doSpin(player, 1)
    elseif pid == ROULETTE_PRODUCTS.SPIN_3  then doSpin(player, 3)
    elseif pid == ROULETTE_PRODUCTS.SPIN_10 then doSpin(player, 10)
    else
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    purchaseHistory[key] = true
    return Enum.ProductPurchaseDecision.PurchaseGranted
end

-- RemoteFunction: cliente solicita lista de accesorios propios
local GetMyAccessories = Instance.new("RemoteFunction", GameEvents)
GetMyAccessories.Name = "GetMyAccessories"
GetMyAccessories.OnServerInvoke = function(player)
    local owned = player:GetAttribute("OwnedAccessories") or ""
    local list = {}
    for _, a in ipairs(ACCESSORIES) do
        a.owned = string.find(owned, a.id) ~= nil
        table.insert(list, a)
    end
    return list
end

print("[Ruleta Accesorios] Iniciada — " .. #ACCESSORIES .. " accesorios disponibles")
print("[Ruleta Accesorios] Reemplaza ROULETTE_PRODUCTS con tus Developer Product IDs")
