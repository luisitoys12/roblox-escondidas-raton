-- MapVoteUI.client.lua
-- UI de votación de mapas que aparece en el lobby.
-- Muestra 3 opciones de mapa con thumbnail, nombre y contador de votos.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local player    = Players.LocalPlayer
local playerGui = player.PlayerGui
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local ShowMapVote   = GameEvents:WaitForChild("ShowMapVote")
local MapVoteEvent  = GameEvents:WaitForChild("MapVote")
local MapResultEvent = GameEvents:WaitForChild("MapResult")

-- Crear GUI
local voteGui = Instance.new("ScreenGui", playerGui)
voteGui.Name = "MapVoteUI"
voteGui.ResetOnSpawn = false

local frame = Instance.new("Frame", voteGui)
frame.Size             = UDim2.new(0.8, 0, 0.35, 0)
frame.Position         = UDim2.new(0.1, 0, 0.6, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel  = 0
frame.Visible          = false

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size           = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3     = Color3.fromRGB(255, 215, 0)
title.Text           = "🗺️ VOTA EL MAPA"
title.Font           = Enum.Font.GothamBold
title.TextSize       = 22

local timerLabel = Instance.new("TextLabel", frame)
timerLabel.Size           = UDim2.new(1, 0, 0, 25)
timerLabel.Position       = UDim2.new(0, 0, 0, 40)
timerLabel.BackgroundTransparency = 1
timerLabel.TextColor3     = Color3.fromRGB(200, 200, 200)
timerLabel.Text           = ""
timerLabel.Font           = Enum.Font.Gotham
timerLabel.TextSize       = 14

local cardContainer = Instance.new("Frame", frame)
cardContainer.Size             = UDim2.new(1, -20, 1, -80)
cardContainer.Position         = UDim2.new(0, 10, 0, 70)
cardContainer.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", cardContainer)
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Padding = UDim.new(0, 10)

local myVote = nil
local voteStartTime = 0
local voteDuration  = 15

-- Crear una card de mapa
local function createMapCard(mapData)
    local card = Instance.new("TextButton", cardContainer)
    card.Size             = UDim2.new(0.3, 0, 1, 0)
    card.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    card.BorderSizePixel  = 0
    card.Text             = ""
    card.AutoButtonColor  = false

    local cardCorner = Instance.new("UICorner", card)
    cardCorner.CornerRadius = UDim.new(0, 8)

    local thumb = Instance.new("ImageLabel", card)
    thumb.Size           = UDim2.new(1, 0, 0.6, 0)
    thumb.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    thumb.Image          = mapData.thumbnail or ""
    thumb.ScaleType      = Enum.ScaleType.Crop

    local nameLabel = Instance.new("TextLabel", card)
    nameLabel.Size           = UDim2.new(1, 0, 0.2, 0)
    nameLabel.Position       = UDim2.new(0, 0, 0.6, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3     = Color3.fromRGB(255, 255, 255)
    nameLabel.Text           = mapData.name
    nameLabel.Font           = Enum.Font.GothamBold
    nameLabel.TextSize       = 13
    nameLabel.TextScaled     = true

    local themeLabel = Instance.new("TextLabel", card)
    themeLabel.Size           = UDim2.new(1, 0, 0.2, 0)
    themeLabel.Position       = UDim2.new(0, 0, 0.8, 0)
    themeLabel.BackgroundTransparency = 1
    themeLabel.TextColor3     = Color3.fromRGB(160, 160, 200)
    themeLabel.Text           = mapData.theme or ""
    themeLabel.Font           = Enum.Font.Gotham
    themeLabel.TextSize       = 11

    -- Votar al hacer click
    card.MouseButton1Click:Connect(function()
        myVote = mapData.id
        MapVoteEvent:FireServer(mapData.id)
        -- Resaltar card seleccionada
        card.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        TweenService:Create(card, TweenInfo.new(0.1), { Size = UDim2.new(0.32, 0, 1, 0) }):Play()
        task.delay(0.1, function()
            TweenService:Create(card, TweenInfo.new(0.1), { Size = UDim2.new(0.3, 0, 1, 0) }):Play()
        end)
    end)

    return card
end

-- Mostrar votación
ShowMapVote.OnClientEvent:Connect(function(options, duration)
    -- Limpiar cards anteriores
    for _, child in ipairs(cardContainer:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then child:Destroy() end
    end
    myVote      = nil
    voteStartTime = tick()
    voteDuration  = duration
    -- Crear cards
    for _, mapOption in ipairs(options) do
        createMapCard(mapOption)
    end
    -- Mostrar con animación
    frame.Position = UDim2.new(0.1, 0, 1, 0)
    frame.Visible  = true
    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back), { Position = UDim2.new(0.1, 0, 0.6, 0) }):Play()
    -- Countdown del timer
    task.spawn(function()
        for t = duration, 1, -1 do
            if not frame.Visible then break end
            timerLabel.Text = "Votando... " .. t .. "s"
            task.wait(1)
        end
    end)
end)

-- Resultado del mapa ganador
MapResultEvent.OnClientEvent:Connect(function(winnerMapId)
    timerLabel.Text = "¡Mapa seleccionado!"
    task.delay(2, function()
        TweenService:Create(frame, TweenInfo.new(0.3), { Position = UDim2.new(0.1, 0, 1, 0) }):Play()
        task.delay(0.3, function() frame.Visible = false end)
    end)
end)

print("[MapVoteUI] UI de votación de mapas cargada")
