-- HideMovement.client.lua
-- Mecánica de agacharse para los Escondidos.
-- Al presionar C el personaje se encoge (hitbox más pequeña y velocidad reducida).

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService     = game:GetService("TweenService")
local Config           = require(ReplicatedStorage:WaitForChild("GameConfig"))

local player           = Players.LocalPlayer
local character        = script.Parent
local humanoid         = character:WaitForChild("Humanoid")
local hrp              = character:WaitForChild("HumanoidRootPart")

local isCrouching = false

local function isHider()
    return player:GetAttribute("Role") == Config.HiderTag
end

local function crouch()
    if not isHider() then return end
    isCrouching = true
    humanoid.WalkSpeed = Config.HiderSpeed * 0.5  -- Más lento al agacharse
    humanoid.HipHeight = humanoid.HipHeight * 0.5
    -- Escalar el personaje visualmente
    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = Vector3.new(2, 1, 1) }  -- Más bajo
    )
    tween:Play()
end

local function standUp()
    isCrouching = false
    humanoid.WalkSpeed = Config.HiderSpeed
    humanoid.HipHeight = 0  -- Valor default de Roblox
    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = Vector3.new(2, 2, 1) }  -- Tamaño normal
    )
    tween:Play()
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.C and not isCrouching then
        crouch()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.C and isCrouching then
        standUp()
    end
end)

print("[HideMovement] Sistema de agacharse cargado")
