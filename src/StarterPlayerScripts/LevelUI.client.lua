-- LevelUI.client.lua
-- Barra de XP y nivel visible en el HUD inferior.
-- Muestra notificación animada al subir de nivel.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local player    = Players.LocalPlayer
local playerGui = player.PlayerGui
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local UpdateLevel = GameEvents:WaitForChild("UpdateLevel")

local lvlGui = Instance.new("ScreenGui", playerGui)
lvlGui.Name = "LevelUI"
lvlGui.ResetOnSpawn = false

-- Barra de XP en la parte inferior
local barBg = Instance.new("Frame", lvlGui)
barBg.Size             = UDim2.new(0.4, 0, 0, 24)
barBg.Position         = UDim2.new(0.3, 0, 1, -32)
barBg.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
barBg.BorderSizePixel  = 0
Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 12)

local barFill = Instance.new("Frame", barBg)
barFill.Size             = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
barFill.BorderSizePixel  = 0
Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 12)

local xpLabel = Instance.new("TextLabel", barBg)
xpLabel.Size           = UDim2.new(1, 0, 1, 0)
xpLabel.BackgroundTransparency = 1
xpLabel.TextColor3     = Color3.fromRGB(255, 255, 255)
xpLabel.Text           = "Nv.1 — 0 / 100 XP"
xpLabel.Font           = Enum.Font.GothamBold
xpLabel.TextSize       = 12

-- Panel de subida de nivel
local levelUpFrame = Instance.new("Frame", lvlGui)
levelUpFrame.Size             = UDim2.new(0.4, 0, 0, 70)
levelUpFrame.Position         = UDim2.new(0.3, 0, 1, 20)  -- fuera de pantalla
levelUpFrame.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
levelUpFrame.BackgroundTransparency = 0.1
levelUpFrame.BorderSizePixel  = 0
Instance.new("UICorner", levelUpFrame).CornerRadius = UDim.new(0, 14)

local lvlUpLabel = Instance.new("TextLabel", levelUpFrame)
lvlUpLabel.Size           = UDim2.new(1, 0, 1, 0)
lvlUpLabel.BackgroundTransparency = 1
lvlUpLabel.TextColor3     = Color3.fromRGB(20, 20, 20)
lvlUpLabel.Text           = "⬆️ ¡Subiste al nivel 2!"
lvlUpLabel.Font           = Enum.Font.GothamBold
lvlUpLabel.TextSize       = 20

UpdateLevel.OnClientEvent:Connect(function(level, xp, xpNeeded, leveledUp)
    -- Actualizar barra
    local pct = math.clamp(xp / xpNeeded, 0, 1)
    TweenService:Create(barFill, TweenInfo.new(0.5, Enum.EasingStyle.Quad),
        { Size = UDim2.new(pct, 0, 1, 0) }):Play()
    xpLabel.Text = "Nv." .. level .. " — " .. xp .. " / " .. xpNeeded .. " XP"
    -- Animación de subida de nivel
    if leveledUp then
        lvlUpLabel.Text = "⬆️ ¡Subiste al nivel " .. level .. "!"
        TweenService:Create(levelUpFrame,
            TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { Position = UDim2.new(0.3, 0, 0.4, 0) }):Play()
        task.delay(3, function()
            TweenService:Create(levelUpFrame,
                TweenInfo.new(0.3),
                { Position = UDim2.new(0.3, 0, 1, 20) }):Play()
        end)
    end
end)

print("[LevelUI] Barra de XP cargada")
