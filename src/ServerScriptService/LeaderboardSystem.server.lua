-- LeaderboardSystem.server.lua
-- Tabla de líderes global con OrderedDataStore.
-- Muestra Top 10 por: Monedas totales, ELO, y Nivel.

local Players           = game:GetService("Players")
local DataStoreService  = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameEvents        = ReplicatedStorage:WaitForChild("GameEvents")

-- OrderedDataStores para ranking global
local eloStore   = DataStoreService:GetOrderedDataStore("GlobalELO")
local coinsStore = DataStoreService:GetOrderedDataStore("GlobalCoins")
local levelStore = DataStoreService:GetOrderedDataStore("GlobalLevel")

local RequestLeaderboard = Instance.new("RemoteFunction", GameEvents)
RequestLeaderboard.Name  = "RequestLeaderboard"

-- Obtener top 10 de un OrderedDataStore
local function getTop10(store)
    local ok, pages = pcall(function()
        return store:GetSortedAsync(false, 10)
    end)
    if not ok then return {} end
    local result = {}
    local data = pages:GetCurrentPage()
    for _, entry in ipairs(data) do
        table.insert(result, { userId = entry.key, value = entry.value })
    end
    return result
end

-- Actualizar score de un jugador en los leaderboards
local function updateLeaderboard(player)
    local userId = tostring(player.UserId)
    pcall(function()
        local elo   = _G.GetElo   and _G.GetElo(player)   or 1000
        local coins = _G.GetCoins and _G.GetCoins(player) or 0
        local level = _G.GetLevel and _G.GetLevel(player) or 1
        eloStore:SetAsync(userId, elo)
        coinsStore:SetAsync(userId, coins)
        levelStore:SetAsync(userId, level)
    end)
end

-- Responder solicitudes del cliente
RequestLeaderboard.OnServerInvoke = function(player, boardType)
    local store = boardType == "elo"   and eloStore
              or boardType == "coins" and coinsStore
              or levelStore
    return getTop10(store)
end

-- Actualizar leaderboard cada 5 minutos
task.spawn(function()
    while true do
        task.wait(300)
        for _, player in ipairs(Players:GetPlayers()) do
            updateLeaderboard(player)
        end
        print("[LeaderboardSystem] Leaderboards actualizados")
    end
end)

Players.PlayerRemoving:Connect(function(player)
    updateLeaderboard(player)
end)

print("[LeaderboardSystem] Sistema de tabla de líderes iniciado")
