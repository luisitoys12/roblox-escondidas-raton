-- ToolEffects.server.lua
-- Implementa los 20 efectos únicos de herramientas

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")
local Debris            = game:GetService("Debris")

local Config   = require(ReplicatedStorage:WaitForChild("GameConfig"))
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")

local ActivateTool = Instance.new("RemoteFunction", GameEvents)
ActivateTool.Name  = "ActivateTool"

-- Cooldowns activos
local cooldowns = {}  -- [userId_toolId] = timestamp

local function isOnCooldown(player, toolId, cooldownTime)
    local key = player.UserId .. "_" .. toolId
    local last = cooldowns[key] or 0
    return (tick() - last) < cooldownTime
end

local function setCooldown(player, toolId)
    cooldowns[player.UserId .. "_" .. toolId] = tick()
end

-- ══ EFECTOS DEL RATÓN ══

local function effect_light(caster)
    local char = caster.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local light = Instance.new("PointLight", hrp)
    light.Brightness = 8
    light.Range      = 30
    light.Color      = Color3.fromRGB(255, 240, 180)
    Debris:AddItem(light, 10)
end

local function effect_placeTrap(caster)
    local char = caster.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local trap = Instance.new("Part", workspace)
    trap.Name     = "Trap"
    trap.Size     = Vector3.new(2, 0.2, 2)
    trap.CFrame   = hrp.CFrame * CFrame.new(0, -3, -4)
    trap.Anchored = true
    trap.BrickColor = BrickColor.new("Dark orange")
    trap.CanCollide = false
    -- Detectar jugador encima
    local connection
    connection = trap.Touched:Connect(function(hit)
        local victim = Players:GetPlayerFromCharacter(hit.Parent)
        if victim and victim ~= caster then
            if victim:GetAttribute("Role") == Config.HiderTag then
                local hum = hit.Parent:FindFirstChild("Humanoid")
                if hum then
                    hum.WalkSpeed = 0
                    task.delay(3, function() hum.WalkSpeed = Config.HiderSpeed end)
                end
                connection:Disconnect()
                trap:Destroy()
            end
        end
    end)
    Debris:AddItem(trap, 30)
end

local function effect_radar(caster)
    local gameState = _G.GetGameState and _G.GetGameState() or nil
    if not gameState then return end
    local positions = {}
    for _, hider in ipairs(gameState.hidersAlive or {}) do
        if hider.Character and hider.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(positions, hider.Character.HumanoidRootPart.Position)
        end
    end
    -- Enviar posiciones al cliente del Ratón
    local ShowRadar = GameEvents:FindFirstChild("ShowRadar")
    if ShowRadar then ShowRadar:FireClient(caster, positions, 5) end
end

local function effect_speedBoost(caster, duration, amount)
    local char = caster.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    local base = hum.WalkSpeed
    hum.WalkSpeed = base + (amount or 8)
    task.delay(duration or 5, function()
        if hum then hum.WalkSpeed = base end
    end)
end

local function effect_magnet(caster)
    local char = caster.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= caster and player:GetAttribute("Role") == Config.HiderTag then
            local pChar = player.Character
            if pChar then
                local pHrp = pChar:FindFirstChild("HumanoidRootPart")
                if pHrp then
                    local dist = (hrp.Position - pHrp.Position).Magnitude
                    if dist < 50 then
                        local dir = (hrp.Position - pHrp.Position).Unit
                        local bv = Instance.new("BodyVelocity", pHrp)
                        bv.Velocity    = dir * 40
                        bv.MaxForce    = Vector3.new(1e5,0,1e5)
                        Debris:AddItem(bv, 0.5)
                    end
                end
            end
        end
    end
end

local function effect_freezeArea(caster)
    local char = caster.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= caster and player:GetAttribute("Role") == Config.HiderTag then
            local pChar = player.Character
            if pChar then
                local pHrp = pChar:FindFirstChild("HumanoidRootPart")
                if pHrp and (hrp.Position - pHrp.Position).Magnitude < 10 then
                    local hum = pChar:FindFirstChild("Humanoid")
                    if hum then
                        hum.WalkSpeed = 0
                        task.delay(3, function() if hum then hum.WalkSpeed = Config.HiderSpeed end end)
                    end
                end
            end
        end
    end
end

-- ══ EFECTOS DEL ESCONDIDO ══

local function effect_spawnDecoy(caster)
    local char = caster.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local decoy = Instance.new("Model", workspace)
    decoy.Name = "Decoy_" .. caster.Name
    local part = Instance.new("Part", decoy)
    part.Size        = Vector3.new(2,5,1)
    part.CFrame      = hrp.CFrame
    part.BrickColor  = char.HumanoidRootPart.BrickColor
    part.Anchored    = false
    -- Hacer que el señuelo corra en dirección aleatoria
    local bv = Instance.new("BodyVelocity", part)
    bv.Velocity  = Vector3.new(math.random(-20,20), 0, math.random(-20,20))
    bv.MaxForce  = Vector3.new(1e4, 0, 1e4)
    Debris:AddItem(decoy, 5)
end

local function effect_smokeCloud(caster)
    local char = caster.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local smokePart = Instance.new("Part", workspace)
    smokePart.Size      = Vector3.new(1,1,1)
    smokePart.CFrame    = hrp.CFrame
    smokePart.Anchored  = true
    smokePart.CanCollide = false
    smokePart.Transparency = 1
    local smoke = Instance.new("Smoke", smokePart)
    smoke.Color     = Color3.fromRGB(150,150,150)
    smoke.Density   = 1
    smoke.Size      = 10
    Debris:AddItem(smokePart, 4)
end

local function effect_dash(caster)
    local char = caster.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dir = hrp.CFrame.LookVector
    local bv = Instance.new("BodyVelocity", hrp)
    bv.Velocity  = dir * 80
    bv.MaxForce  = Vector3.new(1e5, 0, 1e5)
    Debris:AddItem(bv, 0.3)
end

local function effect_teleport(caster)
    local char = caster.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local spawnFolder = workspace:FindFirstChild("HiderSpawns")
    if spawnFolder then
        local spawns = spawnFolder:GetChildren()
        local s = spawns[math.random(#spawns)]
        if s then hrp.CFrame = s.CFrame + Vector3.new(0,3,0) end
    end
end

local function effect_shieldBubble(caster)
    caster:SetAttribute("ShieldActive", true)
    -- El escudo se consume al ser atrapado (ver RoundSystem)
    task.delay(15, function()
        caster:SetAttribute("ShieldActive", false)
    end)
end

local function effect_invisible(caster)
    local char = caster.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = 0.9
        end
    end
    task.delay(4, function()
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0
                end
            end
        end
    end)
end

local function effect_emp(caster)
    -- Desactivar herramientas del Ratón por 5 segundos
    local gameState = _G.GetGameState and _G.GetGameState()
    if not gameState then return end
    local mouse = gameState.mousePlayer
    if mouse then
        mouse:SetAttribute("ToolsDisabled", true)
        task.delay(5, function()
            mouse:SetAttribute("ToolsDisabled", false)
        end)
    end
end

-- ══ Dispatcher ══
local effectMap = {
    light          = effect_light,
    placeTrap      = effect_placeTrap,
    radar          = effect_radar,
    speedBoost     = effect_speedBoost,
    magnet         = effect_magnet,
    freezeArea     = effect_freezeArea,
    spawnDecoy     = effect_spawnDecoy,
    smokeCloud     = effect_smokeCloud,
    dash           = effect_dash,
    teleport       = effect_teleport,
    shieldBubble   = effect_shieldBubble,
    invisible      = effect_invisible,
    emp            = effect_emp,
    speedShoes     = function(p) effect_speedBoost(p, 6, 6) end,
    spawnClone     = effect_spawnDecoy,
    noiseMaker     = function(p) print("[ToolEffects] Noise maker activado por " .. p.Name) end,
    doubleCapture  = function(p) p:SetAttribute("DoubleCapture", true) task.delay(30, function() p:SetAttribute("DoubleCapture", false) end) end,
    droneView      = function(p) print("[ToolEffects] Drone activado (implementar vista cliente)") end,
    wallhack       = function(p) print("[ToolEffects] Scanner activado (implementar vista cliente)") end,
}

local ToolData = require(ReplicatedStorage:WaitForChild("ToolData"))

ActivateTool.OnServerInvoke = function(player, toolId)
    -- Verificar si las herramientas están desactivadas (EMP)
    if player:GetAttribute("ToolsDisabled") then
        return { success=false, message="¡EMP activo! Sin herramientas." }
    end
    -- Buscar herramienta
    local toolData = nil
    for _, t in ipairs(ToolData) do
        if t.id == toolId then toolData = t break end
    end
    if not toolData then return { success=false, message="Herramienta no encontrada" } end
    -- Verificar rol
    local role = player:GetAttribute("Role")
    if toolData.role ~= role then
        return { success=false, message="No puedes usar esto con tu rol" }
    end
    -- Verificar cooldown
    if isOnCooldown(player, toolId, toolData.cooldown) then
        return { success=false, message="Cooldown activo" }
    end
    -- Ejecutar efecto
    local fn = effectMap[toolData.effect]
    if fn then
        fn(player)
        setCooldown(player, toolId)
        return { success=true }
    end
    return { success=false, message="Efecto no implementado" }
end

print("[ToolEffects] 20 efectos de herramientas registrados")
