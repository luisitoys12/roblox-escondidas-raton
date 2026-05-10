-- MouseMovement.client.lua
-- Efectos de cámara y movimiento especial para el jugador con rol Ratón.
-- Solo se activa si el jugador local tiene el rol Mouse.

local Players        = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService     = game:GetService("RunService")
local Config         = require(ReplicatedStorage:WaitForChild("GameConfig"))

local player         = Players.LocalPlayer
local character      = script.Parent
local humanoid       = character:WaitForChild("Humanoid")

-- Solo aplicar si somos el Ratón
local function isMousePlayer()
    return player:GetAttribute("Role") == Config.MouseTag
end

-- Escuchar cambio de rol
player:GetAttributeChangedSignal("Role"):Connect(function()
    if isMousePlayer() then
        humanoid.WalkSpeed = Config.MouseSpeed
        -- Efecto de nombre rojo
        local nameTag = character:FindFirstChildOfClass("Model")
        if nameTag then
            -- Roblox maneja el nombre automáticamente, el color lo gestiona el servidor
        end
        print("[MouseMovement] Eres el Ratón — velocidad: " .. Config.MouseSpeed)
    end
end)

-- Aplicar al inicio si ya somos el Ratón
if isMousePlayer() then
    humanoid.WalkSpeed = Config.MouseSpeed
end

-- Efecto visual: campo de visión más amplio cuando corres
local camera = workspace.CurrentCamera
local baseFOV = 70

RunService.RenderStepped:Connect(function()
    if not isMousePlayer() then return end

    local speed = humanoid.MoveDirection.Magnitude * humanoid.WalkSpeed
    local targetFOV = baseFOV + (speed > 0.1 and 8 or 0)
    camera.FieldOfView = camera.FieldOfView + (targetFOV - camera.FieldOfView) * 0.1
end)
