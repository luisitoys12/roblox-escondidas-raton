-- RankSystem.server.lua
-- Sistema de rangos ELO simple.
-- Ganadores suben ELO, perdedores bajan.

local Players        = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config         = require(ReplicatedStorage:WaitForChild("GameConfig"))

local GameEvents     = ReplicatedStorage:WaitForChild("GameEvents")

-- Almacenamiento en memoria
local eloData = {}  -- [userId] = eloValue

local function getElo(player)
    return eloData[player.UserId] or Config.StartingElo
end

local function getRankName(elo)
    local rank = Config.Ranks[1].name
    for _, r in ipairs(Config.Ranks) do
        if elo >= r.minElo then
            rank = r.name
        end
    end
    return rank
end

local function setElo(player, elo)
    eloData[player.UserId] = math.max(0, math.floor(elo))
    local rankName = getRankName(eloData[player.UserId])
    player:SetAttribute("Elo", eloData[player.UserId])
    player:SetAttribute("RankName", rankName)
    print("[RankSystem] " .. player.Name .. " ELO: " .. eloData[player.UserId] .. " (" .. rankName .. ")")
end

-- Procesar ELO al terminar una ronda
-- mouseWon: boolean
-- mousePlayer: instancia del jugador Ratón
-- survivors: lista de jugadores que sobrevivieron
-- caught: lista de jugadores capturados
local function processRoundElo(mouseWon, mousePlayer, survivors, caught)
    if mouseWon then
        -- Ratón gana ELO, escondidos pierden
        setElo(mousePlayer, getElo(mousePlayer) + Config.EloGainWin)
        for _, p in ipairs(caught) do
            setElo(p, getElo(p) - Config.EloLoseLose)
        end
    else
        -- Escondidos sobrevivientes ganan ELO, Ratón pierde
        setElo(mousePlayer, getElo(mousePlayer) - Config.EloLoseLose)
        for _, p in ipairs(survivors) do
            setElo(p, getElo(p) + Config.EloGainWin)
        end
        -- Los capturados no ganan ni pierden tanto
        for _, p in ipairs(caught) do
            setElo(p, getElo(p) - math.floor(Config.EloLoseLose / 2))
        end
    end
end

-- Inicializar ELO al unirse
Players.PlayerAdded:Connect(function(player)
    eloData[player.UserId] = Config.StartingElo
    -- TODO: cargar desde DataStore
    player:SetAttribute("Elo", Config.StartingElo)
    player:SetAttribute("RankName", getRankName(Config.StartingElo))
end)

Players.PlayerRemoving:Connect(function(player)
    -- TODO: guardar ELO en DataStore
    eloData[player.UserId] = nil
end)

-- RemoteFunction para consultar ELO propio
local GetMyElo = Instance.new("RemoteFunction", GameEvents)
GetMyElo.Name  = "GetMyElo"
GetMyElo.OnServerInvoke = function(player)
    return getElo(player), getRankName(getElo(player))
end

-- Exponer globalmente
_G.GetElo          = getElo
_G.SetElo          = setElo
_G.GetRankName     = getRankName
_G.ProcessRoundElo = processRoundElo

print("[RankSystem] Sistema de rangos iniciado")
