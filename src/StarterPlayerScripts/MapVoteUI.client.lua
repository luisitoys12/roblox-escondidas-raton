-- MapVoteUI.client.lua
-- Muestra la votación de mapas entre rondas

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local player    = Players.LocalPlayer
local playerGui = player.PlayerGui
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local ShowMapVote = GameEvents:WaitForChild("ShowMapVote")
local SubmitVote  = GameEvents:WaitForChild("SubmitVote")
local MapSelected = GameEvents:WaitForChild("MapSelected")

local voted = false

local voteGui = Instance.new("ScreenGui", playerGui)
voteGui.Name = "MapVoteUI"
voteGui.ResetOnSpawn = false

local voteFrame = Instance.new("Frame", voteGui)
voteFrame.Size             = UDim2.new(0.8, 0, 0.5, 0)
voteFrame.Position         = UDim2.new(0.1, 0, 0.25, 0)
voteFrame.BackgroundColor3 = Color3.fromRGB(10,10,25)
voteFrame.BackgroundTransparency = 0.1
voteFrame.BorderSizePixel  = 0
voteFrame.Visible           = false

local title = Instance.new("TextLabel", voteFrame)
title.Size           = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.TextColor3     = Color3.fromRGB(255,230,80)
title.Text           = "🗺️ ¡Vota el siguiente mapa!"
title.Font           = Enum.Font.GothamBold
title.TextSize       = 24

local timerLabel = Instance.new("TextLabel", voteFrame)
timerLabel.Size           = UDim2.new(1,0,0,30)
timerLabel.Position       = UDim2.new(0,0,0,45)
timerLabel.BackgroundTransparency = 1
timerLabel.TextColor3     = Color3.fromRGB(200,200,200)
timerLabel.Text           = "Tiempo: 20s"
timerLabel.Font           = Enum.Font.Gotham
timerLabel.TextSize       = 16

local mapButtonFrame = Instance.new("Frame", voteFrame)
mapButtonFrame.Size             = UDim2.new(1,-20,1,-90)
mapButtonFrame.Position         = UDim2.new(0,10,0,80)
mapButtonFrame.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", mapButtonFrame)
layout.FillDirection = Enum.FillDirection.Horizontal
layout.Padding       = UDim.new(0,10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

ShowMapVote.OnClientEvent:Connect(function(options, voteTime)
    voted = false
    voteFrame.Visible = true
    -- Limpiar botones anteriores
    for _, c in ipairs(mapButtonFrame:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("Frame") then c:Destroy() end
    end
    -- Crear botón por cada opción
    for _, opt in ipairs(options) do
        local btn = Instance.new("TextButton", mapButtonFrame)
        btn.Size             = UDim2.new(0.3,0,1,0)
        btn.BackgroundColor3 = Color3.fromRGB(25,35,60)
        btn.BorderSizePixel  = 0
        btn.Text             = opt.icon .. "\n" .. opt.name .. "\n[" .. opt.difficulty .. "]"
        btn.TextColor3       = Color3.fromRGB(255,255,255)
        btn.Font             = Enum.Font.GothamBold
        btn.TextSize         = 14
        btn.TextWrapped      = true
        btn.MouseButton1Click:Connect(function()
            if voted then return end
            voted = true
            SubmitVote:FireServer(opt.id)
            -- Resaltar botón seleccionado
            btn.BackgroundColor3 = Color3.fromRGB(40,120,60)
            btn.Text = "✓ " .. btn.Text
        end)
    end
    -- Countdown
    task.spawn(function()
        for t = voteTime, 1, -1 do
            if not voteFrame.Visible then break end
            timerLabel.Text = "Tiempo: " .. t .. "s"
            task.wait(1)
        end
    end)
end)

MapSelected.OnClientEvent:Connect(function(mapData)
    -- Mostrar mapa ganador brevemente
    for _, c in ipairs(mapButtonFrame:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("Frame") then c:Destroy() end
    end
    title.Text = "🗺️ Mapa elegido: " .. mapData.icon .. " " .. mapData.name
    timerLabel.Text = ""
    task.delay(3, function()
        voteFrame.Visible = false
    end)
end)

print("[MapVoteUI] UI de votación de mapas cargada")
