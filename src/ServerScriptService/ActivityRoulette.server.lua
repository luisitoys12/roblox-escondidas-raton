-- ActivityRoulette.server.lua
-- Ruleta de actividades: cada X segundos mid-round se activa un evento aleatorio.
-- Eventos: Niebla, Turbo, Monedas x2, Trampa Masiva, Apagon, Super Raton, Teletransporte

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting          = game:GetService("Lighting")
local TweenService      = game:GetService("TweenService")

local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")

-- Remote para anunciar la ruleta al cliente
local SpinRoulette  = Instance.new("RemoteEvent", GameEvents)
SpinRoulette.Name   = "SpinRoulette"     -- servidor -> todos los clientes
local RouletteResult = Instance.new("RemoteEvent", GameEvents)
RouletteResult.Name = "RouletteResult"   -- resultado final -> todos

-- ==========================================
--  CATÁLOGO DE ACTIVIDADES
-- ==========================================
local ACTIVITIES = {
    {
        id       = "fog",
        name     = "🌫️ Niebla Espesa",
        desc     = "Visibilidad reducida por 20 seg",
        duration = 20,
        color    = Color3.fromRGB(160,180,200),
        onStart  = function()
            Lighting.FogStart = 0
            Lighting.FogEnd   = 40
            Lighting.FogColor = Color3.fromRGB(180,195,210)
        end,
        onEnd = function()
            Lighting.FogStart = 0
            Lighting.FogEnd   = 100000
        end,
    },
    {
        id       = "turbo",
        name     = "⚡ Turbo Todos",
        desc     = "Todos corren el doble por 15 seg",
        duration = 15,
        color    = Color3.fromRGB(255,220,0),
        onStart  = function()
            for _, p in ipairs(Players:GetPlayers()) do
                local char = p.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.WalkSpeed = hum.WalkSpeed * 2
                        p:SetAttribute("TurboActive", true)
                    end
                end
            end
        end,
        onEnd = function()
            for _, p in ipairs(Players:GetPlayers()) do
                local char = p.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and p:GetAttribute("TurboActive") then
                        hum.WalkSpeed = hum.WalkSpeed / 2
                        p:SetAttribute("TurboActive", false)
                    end
                end
            end
        end,
    },
    {
        id       = "coins_x2",
        name     = "🪙 Monedas x2",
        desc     = "Monedas dobles por 25 seg",
        duration = 25,
        color    = Color3.fromRGB(255,180,0),
        onStart  = function()
            for _, p in ipairs(Players:GetPlayers()) do
                local cur = p:GetAttribute("CoinMultiplier") or 1
                p:SetAttribute("CoinMultiplier", cur * 2)
                p:SetAttribute("CoinX2Active", true)
            end
        end,
        onEnd = function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p:GetAttribute("CoinX2Active") then
                    local cur = p:GetAttribute("CoinMultiplier") or 2
                    p:SetAttribute("CoinMultiplier", math.max(1, cur / 2))
                    p:SetAttribute("CoinX2Active", false)
                end
            end
        end,
    },
    {
        id       = "blackout",
        name     = "🌑 Apagón",
        desc     = "Oscuridad total por 12 seg",
        duration = 12,
        color    = Color3.fromRGB(30,30,40),
        onStart  = function()
            Lighting.Brightness   = 0
            Lighting.Ambient      = Color3.fromRGB(0,0,0)
            Lighting.OutdoorAmbient = Color3.fromRGB(0,0,0)
        end,
        onEnd = function()
            Lighting.Brightness   = 1
            Lighting.Ambient      = Color3.fromRGB(70,70,70)
            Lighting.OutdoorAmbient = Color3.fromRGB(100,100,100)
        end,
    },
    {
        id       = "super_mouse",
        name     = "🐭 Super Ratón",
        desc     = "El Ratón es invisible por 10 seg",
        duration = 10,
        color    = Color3.fromRGB(100,200,255),
        onStart  = function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p:GetAttribute("Role") == "Mouse" then
                    local char = p.Character
                    if char then
                        for _, part in ipairs(char:GetDescendants()) do
                            if part:IsA("BasePart") or part:IsA("Decal") then
                                part.Transparency = 0.85
                            end
                        end
                        p:SetAttribute("SuperMouseActive", true)
                    end
                end
            end
        end,
        onEnd = function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p:GetAttribute("SuperMouseActive") then
                    local char = p.Character
                    if char then
                        for _, part in ipairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.Transparency = 0
                            elseif part:IsA("Decal") then
                                part.Transparency = 0
                            end
                        end
                    end
                    p:SetAttribute("SuperMouseActive", false)
                end
            end
        end,
    },
    {
        id       = "teleport",
        name     = "🌀 Teletransporte",
        desc     = "¡Todos se teletransportan a lugar random!",
        duration = 0,
        color    = Color3.fromRGB(180,100,255),
        onStart  = function()
            local spawnParts = workspace:FindFirstChild("HiderSpawns")
            local positions  = {}
            if spawnParts then
                for _, part in ipairs(spawnParts:GetChildren()) do
                    if part:IsA("BasePart") then
                        table.insert(positions, part.Position + Vector3.new(0,3,0))
                    end
                end
            end
            if #positions == 0 then return end
            for _, p in ipairs(Players:GetPlayers()) do
                local char = p.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame =
                        CFrame.new(positions[math.random(#positions)])
                end
            end
        end,
        onEnd = function() end,
    },
    {
        id       = "freeze",
        name     = "❄️ Congelados",
        desc     = "Los Escondidos no pueden moverse por 8 seg",
        duration = 8,
        color    = Color3.fromRGB(130,220,255),
        onStart  = function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p:GetAttribute("Role") == "Hider" then
                    local char = p.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum.WalkSpeed = 0
                            hum.JumpPower = 0
                            p:SetAttribute("FrozenActive", true)
                        end
                    end
                end
            end
        end,
        onEnd = function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p:GetAttribute("FrozenActive") then
                    local char = p.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum.WalkSpeed = 16
                            hum.JumpPower = 50
                        end
                    end
                    p:SetAttribute("FrozenActive", false)
                end
            end
        end,
    },
    {
        id       = "golden_coins",
        name     = "💰 Lluvia de Monedas",
        desc     = "Monedas caen del cielo por 20 seg",
        duration = 20,
        color    = Color3.fromRGB(255,215,0),
        onStart  = function()
            -- Spawnea partes doradas que dan monedas al tocarlas
            task.spawn(function()
                for i = 1, 15 do
                    task.wait(math.random()*2)
                    local coin = Instance.new("Part", workspace)
                    coin.Name = "RainCoin"
                    coin.Size = Vector3.new(1.5,0.3,1.5)
                    coin.BrickColor = BrickColor.new("Bright yellow")
                    coin.Material   = Enum.Material.SmoothPlastic
                    coin.CFrame = CFrame.new(
                        math.random(-30,30), 50, math.random(-30,30))
                    local bodyVel = Instance.new("BodyVelocity", coin)
                    bodyVel.Velocity = Vector3.new(0,-20,0)
                    bodyVel.MaxForce = Vector3.new(0,1e5,0)
                    coin.Touched:Connect(function(hit)
                        local p = Players:GetPlayerFromCharacter(hit.Parent)
                        if p and _G.AddCoins then
                            _G.AddCoins(p, 25)
                            coin:Destroy()
                        end
                    end)
                    game:GetService("Debris"):AddItem(coin, 10)
                end
            end)
        end,
        onEnd = function()
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj.Name == "RainCoin" then obj:Destroy() end
            end
        end,
    },
}

-- ==========================================
--  MOTOR DE LA RULETA
-- ==========================================
local rouletteActive = false

local function spinAndActivate()
    if rouletteActive then return end
    rouletteActive = true

    -- 1. Avisar al cliente que empieza la animación de ruleta
    SpinRoulette:FireAllClients(ACTIVITIES)

    task.wait(3.5) -- tiempo que tarda la animación en el cliente

    -- 2. Elegir actividad aleatoria
    local chosen = ACTIVITIES[math.random(#ACTIVITIES)]
    print("[Ruleta] Actividad elegida: " .. chosen.name)

    -- 3. Notificar resultado
    RouletteResult:FireAllClients(chosen)

    -- 4. Activar efecto servidor
    task.spawn(chosen.onStart)

    -- 5. Esperar duración y desactivar
    if chosen.duration > 0 then
        task.wait(chosen.duration)
        task.spawn(chosen.onEnd)
    end

    task.wait(5) -- cooldown antes de la próxima ruleta
    rouletteActive = false
end

-- Escucha el evento del GameManager para disparar la ruleta
local TriggerRoulette = Instance.new("BindableEvent", GameEvents)
TriggerRoulette.Name  = "TriggerRoulette"
TriggerRoulette.Event:Connect(spinAndActivate)

-- Loop automático durante la partida (cada 45 seg)
-- El GameManager puede llamar TriggerRoulette:Fire() también manualmente
task.spawn(function()
    while true do
        task.wait(45)
        local inGame = _G.GameState == "Playing"
        if inGame then
            spinAndActivate()
        end
    end
end)

print("[Ruleta] Sistema de actividades iniciado — " .. #ACTIVITIES .. " eventos disponibles")
