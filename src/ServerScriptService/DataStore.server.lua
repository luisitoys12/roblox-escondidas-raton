-- DataStore.server.lua
-- Guardado y carga persistente de datos con DataStore2.
-- REQUIERE: DataStore2 instalado en ServerScriptService.

local Players        = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

-- Intentar cargar DataStore2 (debe estar instalado manualmente)
local DataStore2
local ok, err = pcall(function()
    DataStore2 = require(ServerScriptService:WaitForChild("DataStore2", 5))
end)

if not ok then
    warn("[DataStore] DataStore2 no encontrado. Usando almacenamiento en memoria solamente.")
    warn("[DataStore] Instala DataStore2 desde: https://www.roblox.com/library/1936396537")
    return  -- El juego funciona sin DataStore2, pero no guarda progreso
end

-- Combinar todas las keys en un solo DataStore (patrón recomendado de DataStore2)
DataStore2.Combine("UserData", "Coins", "Elo", "OwnedPets", "OwnedTools")

local DEFAULTS = {
    Coins      = 0,
    Elo        = 1000,
    OwnedPets  = {},
    OwnedTools = {},
}

local function loadPlayerData(player)
    local userId = player.UserId

    local coinsStore = DataStore2("Coins", player)
    local eloStore   = DataStore2("Elo",   player)

    local coins = coinsStore:Get(DEFAULTS.Coins)
    local elo   = eloStore:Get(DEFAULTS.Elo)

    -- Sincronizar con los sistemas en memoria
    if _G.SetCoins then _G.SetCoins(player, coins) end
    if _G.SetElo   then _G.SetElo(player, elo) end

    print("[DataStore] Datos cargados para " .. player.Name .. " — Monedas: " .. coins .. " | ELO: " .. elo)

    -- Guardar automáticamente cuando cambien las monedas
    coinsStore:OnUpdate(function(newCoins)
        -- ya se maneja en memoria, aquí solo persiste
    end)
end

local function savePlayerData(player)
    if not DataStore2 then return end

    local coins = _G.GetCoins and _G.GetCoins(player) or 0
    local elo   = _G.GetElo   and _G.GetElo(player)   or 1000

    DataStore2("Coins", player):Set(coins)
    DataStore2("Elo",   player):Set(elo)

    print("[DataStore] Datos guardados para " .. player.Name)
end

Players.PlayerAdded:Connect(function(player)
    task.wait(3)  -- Esperar a que los sistemas estén listos
    loadPlayerData(player)
end)

Players.PlayerRemoving:Connect(function(player)
    savePlayerData(player)
end)

-- Guardar todos los datos cuando el servidor cierre
game:BindToClose(function()
    for _, player in ipairs(Players:GetPlayers()) do
        savePlayerData(player)
    end
end)

print("[DataStore] Sistema de guardado iniciado con DataStore2")
