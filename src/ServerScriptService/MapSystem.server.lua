-- MapSystem.server.lua
-- Gestiona la carga, descarga y votación de mapas entre rondas.
-- Los jugadores votan en el lobby y se carga el mapa más votado.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MapData           = require(ReplicatedStorage:WaitForChild("MapData"))

local GameEvents        = ReplicatedStorage:WaitForChild("GameEvents")

-- RemoteEvents para el selector de mapas
local MapVoteEvent  = Instance.new("RemoteEvent", GameEvents)
MapVoteEvent.Name   = "MapVote"
local MapResultEvent = Instance.new("RemoteEvent", GameEvents)
MapResultEvent.Name  = "MapResult"
local ShowMapVote   = Instance.new("RemoteEvent", GameEvents)
ShowMapVote.Name    = "ShowMapVote"

local currentMap    = nil
local votes         = {}  -- [userId] = mapId

-- Obtener mapas que el jugador puede usar
local function getAvailableMaps(player)
    local level = player:GetAttribute("Level") or 0
    local allUnlocked = player:GetAttribute("AllMapsUnlocked") or false
    local available = {}
    for _, map in ipairs(MapData) do
        if allUnlocked or level >= map.unlockLevel then
            table.insert(available, map)
        end
    end
    -- Siempre incluir al menos el primer mapa
    if #available == 0 then
        table.insert(available, MapData[1])
    end
    return available
end

-- Seleccionar 3 mapas aleatorios para votar
local function pickVoteMaps()
    local pool = {}
    -- Mezclar MapData
    local shuffled = {table.unpack(MapData)}
    for i = #shuffled, 2, -1 do
        local j = math.random(i)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    end
    for i = 1, math.min(3, #shuffled) do
        table.insert(pool, shuffled[i])
    end
    return pool
end

-- Fase de votación (se llama desde GameManager en el lobby)
local function startMapVote(duration)
    duration = duration or 15
    votes = {}
    local options = pickVoteMaps()
    -- Enviar opciones a todos los jugadores
    ShowMapVote:FireAllClients(options, duration)
    print("[MapSystem] Votación iniciada por " .. duration .. " segundos")
    task.wait(duration)
    -- Contar votos
    local count = {}
    for _, mapId in pairs(votes) do
        count[mapId] = (count[mapId] or 0) + 1
    end
    -- Encontrar el ganador
    local winner = options[1].id
    local maxVotes = 0
    for _, option in ipairs(options) do
        local v = count[option.id] or 0
        if v > maxVotes then
            maxVotes = v
            winner = option.id
        end
    end
    -- Si nadie votó, mapa aleatorio
    if maxVotes == 0 then
        winner = options[math.random(#options)].id
    end
    -- Notificar resultado
    MapResultEvent:FireAllClients(winner)
    print("[MapSystem] Mapa ganador: " .. winner)
    return winner
end

-- Cargar un mapa en Workspace
local function loadMap(mapId)
    -- Ocultar mapa anterior
    if currentMap then
        local old = workspace:FindFirstChild(currentMap)
        if old then old.Parent = ReplicatedStorage end
    end
    -- Activar nuevo mapa
    for _, map in ipairs(MapData) do
        if map.id == mapId then
            local model = ReplicatedStorage:FindFirstChild(map.modelName)
                       or workspace:FindFirstChild(map.modelName)
            if model then
                model.Parent = workspace
                currentMap = mapId
                print("[MapSystem] Mapa cargado: " .. map.name)
            else
                warn("[MapSystem] Modelo no encontrado: " .. map.modelName)
            end
            break
        end
    end
end

-- Recibir votos de los clientes
MapVoteEvent.OnServerEvent:Connect(function(player, mapId)
    votes[player.UserId] = mapId
    print("[MapSystem] " .. player.Name .. " votó por: " .. mapId)
end)

-- Exponer funciones globalmente para GameManager
_G.StartMapVote = startMapVote
_G.LoadMap      = loadMap
_G.GetCurrentMap = function() return currentMap end

print("[MapSystem] Sistema de mapas iniciado")
