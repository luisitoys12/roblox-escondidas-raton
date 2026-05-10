-- CoinSystem.server.lua
-- Gestiona la economía de monedas: agregar, quitar, consultar.
-- Los datos se sincronizan con el cliente vía RemoteEvent.

local Players        = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config         = require(ReplicatedStorage:WaitForChild("GameConfig"))

local GameEvents     = ReplicatedStorage:WaitForChild("GameEvents")
local UpdateCoins    = GameEvents:WaitForChild("UpdateCoins")

-- Almacenamiento en memoria (se reemplaza con DataStore en producción)
local coinBalances = {}  -- [userId] = amount

local function getCoins(player)
    return coinBalances[player.UserId] or 0
end

local function setCoins(player, amount)
    coinBalances[player.UserId] = math.max(0, math.floor(amount))
    UpdateCoins:FireClient(player, coinBalances[player.UserId])
end

local function addCoins(player, amount)
    -- Aplicar multiplicador de mascota si tiene una equipada
    local multiplier = player:GetAttribute("CoinMultiplier") or 1
    local total = math.floor(amount * multiplier)
    setCoins(player, getCoins(player) + total)
    print("[CoinSystem] +" .. total .. " monedas para " .. player.Name .. " (total: " .. getCoins(player) .. ")")
end

local function removeCoins(player, amount)
    local current = getCoins(player)
    if current < amount then
        return false  -- No hay suficientes monedas
    end
    setCoins(player, current - amount)
    return true
end

-- Inicializar monedas al unirse
Players.PlayerAdded:Connect(function(player)
    coinBalances[player.UserId] = 0
    -- TODO: cargar desde DataStore
    task.wait(2)
    UpdateCoins:FireClient(player, 0)
end)

-- Limpiar al salir
Players.PlayerRemoving:Connect(function(player)
    -- TODO: guardar en DataStore antes de limpiar
    coinBalances[player.UserId] = nil
end)

-- Exponer funciones globales para otros scripts del servidor
_G.GetCoins    = getCoins
_G.AddCoins    = addCoins
_G.RemoveCoins = removeCoins
_G.SetCoins    = setCoins

-- RemoteFunction para que el cliente pueda consultar su saldo
local GetCoinBalance = Instance.new("RemoteFunction", GameEvents)
GetCoinBalance.Name  = "GetCoinBalance"
GetCoinBalance.OnServerInvoke = function(player)
    return getCoins(player)
end

-- RemoteFunction para comprar en la tienda
local PurchaseItem = Instance.new("RemoteFunction", GameEvents)
PurchaseItem.Name   = "PurchaseItem"
PurchaseItem.OnServerInvoke = function(player, itemType, itemId)
    -- itemType: "pet" | "tool"
    if itemType == "pet" then
        local PetData = require(ReplicatedStorage:WaitForChild("PetData"))
        for _, pet in ipairs(PetData) do
            if pet.id == itemId then
                if removeCoins(player, pet.price) then
                    player:SetAttribute("EquippedPet", itemId)
                    -- Aplicar bonus de la mascota
                    if pet.bonus.type == "coinMultiplier" then
                        player:SetAttribute("CoinMultiplier", pet.bonus.value)
                    elseif pet.bonus.type == "speed" then
                        player:SetAttribute("PetSpeedBonus", pet.bonus.value)
                    end
                    print("[CoinSystem] " .. player.Name .. " compró mascota: " .. pet.name)
                    return { success = true, message = "¡Mascota equipada!" }
                else
                    return { success = false, message = "Monedas insuficientes" }
                end
            end
        end
    elseif itemType == "tool" then
        local ToolData = require(ReplicatedStorage:WaitForChild("ToolData"))
        for _, tool in ipairs(ToolData) do
            if tool.id == itemId then
                if removeCoins(player, tool.price) then
                    -- Guardar herramienta comprada en atributos
                    local owned = player:GetAttribute("OwnedTools") or ""
                    if not string.find(owned, itemId) then
                        player:SetAttribute("OwnedTools", owned .. "|" .. itemId)
                    end
                    print("[CoinSystem] " .. player.Name .. " compró herramienta: " .. tool.name)
                    return { success = true, message = "¡Herramienta comprada!" }
                else
                    return { success = false, message = "Monedas insuficientes" }
                end
            end
        end
    end
    return { success = false, message = "Item no encontrado" }
end

print("[CoinSystem] Sistema de monedas iniciado")
