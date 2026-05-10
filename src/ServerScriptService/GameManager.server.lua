-- GameManager.server.lua
-- Controla el ciclo completo de la partida:
-- Lobby → Cuenta Regresiva (esconderse) → Juego → Resultados → Lobby

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Config = require(ReplicatedStorage:WaitForChild("GameConfig"))

-- RemoteEvents para comunicación con clientes
local GameEvents = Instance.new("Folder", ReplicatedStorage)
GameEvents.Name = "GameEvents"

local UpdateTimer    = Instance.new("RemoteEvent", GameEvents)
UpdateTimer.Name     = "UpdateTimer"

local UpdateGameState = Instance.new("RemoteEvent", GameEvents)
UpdateGameState.Name  = "UpdateGameState"

local AssignRole     = Instance.new("RemoteEvent", GameEvents)
AssignRole.Name      = "AssignRole"

local ShowResults    = Instance.new("RemoteEvent", GameEvents)
ShowResults.Name     = "ShowResults"

local UpdateCoins    = Instance.new("RemoteEvent", GameEvents)
UpdateCoins.Name     = "UpdateCoins"

-- Estado global
local GameState = {
    phase     = "Lobby",   -- Lobby | Hiding | Playing | Results
    mousePlayer = nil,
    hidersAlive = {},
    caughtPlayers = {},
}

print("[GameManager] Servidor iniciado correctamente")

-- Espera suficientes jugadores
local function waitForPlayers()
    print("[GameManager] Esperando jugadores... (mínimo " .. Config.MinPlayers .. ")")
    UpdateGameState:FireAllClients("Lobby", "Esperando jugadores...")

    while #Players:GetPlayers() < Config.MinPlayers do
        UpdateTimer:FireAllClients(0, "Esperando " .. Config.MinPlayers .. " jugadores")
        task.wait(1)
    end
end

-- Cuenta regresiva genérica
local function countdown(seconds, label)
    for t = seconds, 1, -1 do
        UpdateTimer:FireAllClients(t, label)
        task.wait(1)
    end
end

-- Asignar roles aleatoriamente
local function assignRoles()
    local players = Players:GetPlayers()
    -- Barajar
    for i = #players, 2, -1 do
        local j = math.random(i)
        players[i], players[j] = players[j], players[i]
    end

    GameState.mousePlayer   = players[1]
    GameState.hidersAlive   = {}
    GameState.caughtPlayers = {}

    for i, player in ipairs(players) do
        if i == 1 then
            player:SetAttribute("Role", Config.MouseTag)
            AssignRole:FireClient(player, Config.MouseTag)
            print("[GameManager] " .. player.Name .. " es el Ratón")
        else
            player:SetAttribute("Role", Config.HiderTag)
            AssignRole:FireClient(player, Config.HiderTag)
            table.insert(GameState.hidersAlive, player)
            print("[GameManager] " .. player.Name .. " es Escondido")
        end
    end
end

-- Mover al jugador al spawn
local function teleportToSpawn(player, spawnName)
    local spawnModel = workspace:FindFirstChild(spawnName)
    if spawnModel and player.Character then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = spawnModel.CFrame + Vector3.new(0, 3, 0)
        end
    end
end

-- Teleportar a todos al lobby
local function teleportAllToLobby()
    for _, player in ipairs(Players:GetPlayers()) do
        teleportToSpawn(player, "LobbySpawn")
        player:SetAttribute("Role", "")
    end
end

-- Teleportar al Ratón al spawn del Ratón, Escondidos al mapa
local function teleportForRound()
    for _, player in ipairs(Players:GetPlayers()) do
        local role = player:GetAttribute("Role")
        if role == Config.MouseTag then
            teleportToSpawn(player, "MouseSpawn")
        elseif role == Config.HiderTag then
            -- Spawn aleatorio entre varios puntos
            local spawnFolder = workspace:FindFirstChild("HiderSpawns")
            if spawnFolder then
                local spawns = spawnFolder:GetChildren()
                local s = spawns[math.random(#spawns)]
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp and s then
                    hrp.CFrame = s.CFrame + Vector3.new(0, 3, 0)
                end
            end
        end
    end
end

-- ══ Fase de esconderse ══
local function phaseHiding()
    GameState.phase = "Hiding"
    UpdateGameState:FireAllClients("Hiding", "¡Escóndete!")
    print("[GameManager] Fase: Esconderse")

    -- Congelar al Ratón
    local mouseChar = GameState.mousePlayer and GameState.mousePlayer.Character
    if mouseChar then
        local hum = mouseChar:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 0 end
    end

    countdown(Config.HideTime, "¡Escóndete!")

    -- Liberar al Ratón
    if mouseChar then
        local hum = mouseChar:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = Config.MouseSpeed end
    end
end

-- ══ Fase de juego ══
local function phasePlaying()
    GameState.phase = "Playing"
    UpdateGameState:FireAllClients("Playing", "¡A jugar!")
    print("[GameManager] Fase: Jugando")

    local timeLeft = Config.RoundTime

    -- Bucle principal de la ronda
    while timeLeft > 0 and #GameState.hidersAlive > 0 do
        UpdateTimer:FireAllClients(timeLeft, "Tiempo restante")
        task.wait(1)
        timeLeft -= 1
    end
end

-- ══ Fase de resultados ══
local function phaseResults()
    GameState.phase = "Results"
    local mouseWon = #GameState.hidersAlive == 0
    local resultData = {
        mouseWon      = mouseWon,
        mousePlayer   = GameState.mousePlayer and GameState.mousePlayer.Name or "?",
        survivors     = {},
        caught        = {},
    }

    for _, p in ipairs(GameState.hidersAlive) do
        table.insert(resultData.survivors, p.Name)
    end
    for _, p in ipairs(GameState.caughtPlayers) do
        table.insert(resultData.caught, p.Name)
    end

    ShowResults:FireAllClients(resultData)
    print("[GameManager] Resultados enviados. Ratón ganó: " .. tostring(mouseWon))
    task.wait(Config.ResultsTime)
end

-- ══ Ciclo principal ══
local function mainLoop()
    while true do
        teleportAllToLobby()
        waitForPlayers()

        -- Lobby countdown
        UpdateGameState:FireAllClients("Lobby", "Partida por comenzar...")
        countdown(Config.LobbyTime, "Comenzando en")

        -- Verificar mínimo de jugadores aún presente
        if #Players:GetPlayers() < Config.MinPlayers then
            print("[GameManager] Pocos jugadores, regresando al lobby")
            continue
        end

        assignRoles()
        teleportForRound()
        phaseHiding()
        phasePlaying()
        phaseResults()
    end
end

-- Manejar captura de escondidos (llamado desde RoundSystem)
local CaptureHider = Instance.new("RemoteFunction", GameEvents)
CaptureHider.Name  = "CaptureHider"

-- Solo el servidor puede llamar esto, pero lo dejamos como función global
_G.CaptureHider = function(hiderPlayer)
    if GameState.phase ~= "Playing" then return end

    for i, p in ipairs(GameState.hidersAlive) do
        if p == hiderPlayer then
            table.remove(GameState.hidersAlive, i)
            table.insert(GameState.caughtPlayers, hiderPlayer)
            hiderPlayer:SetAttribute("Role", Config.CaughtTag)
            AssignRole:FireClient(hiderPlayer, Config.CaughtTag)
            print("[GameManager] " .. hiderPlayer.Name .. " fue capturado")
            break
        end
    end
end

_G.GetGameState = function() return GameState end

task.spawn(mainLoop)
