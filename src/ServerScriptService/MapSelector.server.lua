-- MapSelector.server.lua
-- Sistema de votación y selección de mapas entre rondas

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting          = game:GetService("Lighting")

local Config  = require(ReplicatedStorage:WaitForChild("GameConfig"))
local MapData = require(ReplicatedStorage:WaitForChild("MapData"))

local GameEvents  = ReplicatedStorage:WaitForChild("GameEvents")

-- RemoteEvents para votación
local ShowMapVote   = Instance.new("RemoteEvent", GameEvents)
ShowMapVote.Name    = "ShowMapVote"
local SubmitVote    = Instance.new("RemoteEvent", GameEvents)
SubmitVote.Name     = "SubmitVote"
local MapSelected   = Instance.new("RemoteEvent", GameEvents)
MapSelected.Name    = "MapSelected"

local currentMap = nil
local votes      = {}  -- [userId] = mapId

-- Obtener 3 mapas aleatorios para votar
local function getRandomMaps(count)
    local available = {}
    for _, m in ipairs(MapData) do
        table.insert(available, m)
    end
    -- Barajar
    for i = #available, 2, -1 do
        local j = math.random(i)
        available[i], available[j] = available[j], available[i]
    end
    local result = {}
    for i = 1, math.min(count, #available) do
        table.insert(result, available[i])
    end
    return result
end

-- Contar votos y elegir ganador
local function countVotes(options)
    local tally = {}
    for _, opt in ipairs(options) do
        tally[opt.id] = 0
    end
    for _, mapId in pairs(votes) do
        if tally[mapId] ~= nil then
            tally[mapId] = tally[mapId] + 1
        end
    end
    -- Encontrar el más votado
    local winner = options[1]
    local maxVotes = -1
    for _, opt in ipairs(options) do
        if tally[opt.id] > maxVotes then
            maxVotes = tally[opt.id]
            winner = opt
        end
    end
    return winner
end

-- Aplicar configuración del mapa al Lighting
local function applyMapLighting(mapConfig)
    Lighting.ClockTime      = mapConfig.timeOfDay * 24
    Lighting.FogColor       = mapConfig.fogColor
    Lighting.FogEnd         = mapConfig.fogEnd
    Lighting.Ambient        = mapConfig.ambientColor
    Lighting.OutdoorAmbient = mapConfig.ambientColor
    print("[MapSelector] Iluminación aplicada para: " .. mapConfig.name)
end

-- Proceso completo de votación
function RunMapVote()
    local options = getRandomMaps(3)
    votes = {}

    -- Mostrar votación a todos
    local optionData = {}
    for _, m in ipairs(options) do
        table.insert(optionData, { id=m.id, name=m.name, icon=m.icon, difficulty=m.difficulty })
    end
    ShowMapVote:FireAllClients(optionData, Config.IntermissionTime)

    -- Recibir votos
    SubmitVote.OnServerEvent:Connect(function(player, mapId)
        votes[player.UserId] = mapId
        print("[MapSelector] " .. player.Name .. " votó por: " .. mapId)
    end)

    -- Esperar tiempo de votación
    task.wait(Config.IntermissionTime)

    -- Contar y anunciar ganador
    currentMap = countVotes(options)
    applyMapLighting(currentMap)
    MapSelected:FireAllClients(currentMap)
    print("[MapSelector] Mapa seleccionado: " .. currentMap.name)

    return currentMap
end

-- Getter global
_G.RunMapVote    = RunMapVote
_G.GetCurrentMap = function() return currentMap end

print("[MapSelector] Sistema de selección de mapas iniciado")
