-- GameUI.client.lua
-- HUD principal: muestra rol, timer, monedas y rango del jugador.

local Players        = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService   = game:GetService("TweenService")

local player         = Players.LocalPlayer
local playerGui      = player.PlayerGui

local GameEvents     = ReplicatedStorage:WaitForChild("GameEvents")
local UpdateTimer    = GameEvents:WaitForChild("UpdateTimer")
local UpdateGameState = GameEvents:WaitForChild("UpdateGameState")
local AssignRole     = GameEvents:WaitForChild("AssignRole")
local UpdateCoins    = GameEvents:WaitForChild("UpdateCoins")
local ShowResults    = GameEvents:WaitForChild("ShowResults")

-- ══ Crear GUI ══
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "GameHUD"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- Frame HUD superior
local hudFrame = Instance.new("Frame", screenGui)
hudFrame.Size           = UDim2.new(1, 0, 0, 60)
hudFrame.Position       = UDim2.new(0, 0, 0, 0)
hudFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
hudFrame.BackgroundTransparency = 0.3
hudFrame.BorderSizePixel = 0

-- Label del Rol
local roleLabel = Instance.new("TextLabel", hudFrame)
roleLabel.Size           = UDim2.new(0.3, 0, 1, 0)
roleLabel.Position       = UDim2.new(0, 10, 0, 0)
roleLabel.BackgroundTransparency = 1
roleLabel.TextColor3     = Color3.fromRGB(255, 255, 255)
roleLabel.Text           = "Rol: —"
roleLabel.Font           = Enum.Font.GothamBold
roleLabel.TextSize       = 18
roleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Label del Timer
local timerLabel = Instance.new("TextLabel", hudFrame)
timerLabel.Size           = UDim2.new(0.4, 0, 1, 0)
timerLabel.Position       = UDim2.new(0.3, 0, 0, 0)
timerLabel.BackgroundTransparency = 1
timerLabel.TextColor3     = Color3.fromRGB(255, 230, 100)
timerLabel.Text           = "⏱ 0"
timerLabel.Font           = Enum.Font.GothamBold
timerLabel.TextSize       = 22
timerLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Label de Monedas
local coinLabel = Instance.new("TextLabel", hudFrame)
coinLabel.Size           = UDim2.new(0.3, 0, 1, 0)
coinLabel.Position       = UDim2.new(0.7, 0, 0, 0)
coinLabel.BackgroundTransparency = 1
coinLabel.TextColor3     = Color3.fromRGB(255, 215, 0)
coinLabel.Text           = "🪙 0"
coinLabel.Font           = Enum.Font.GothamBold
coinLabel.TextSize       = 18
coinLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Frame de Estado de Juego (mensaje central)
local stateFrame = Instance.new("Frame", screenGui)
stateFrame.Size             = UDim2.new(0.5, 0, 0, 80)
stateFrame.Position         = UDim2.new(0.25, 0, 0.08, 0)
stateFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
stateFrame.BackgroundTransparency = 0.5
stateFrame.BorderSizePixel  = 0
stateFrame.Visible           = false

local stateLabel = Instance.new("TextLabel", stateFrame)
stateLabel.Size           = UDim2.new(1, 0, 1, 0)
stateLabel.BackgroundTransparency = 1
stateLabel.TextColor3     = Color3.fromRGB(255, 255, 255)
stateLabel.Text           = ""
stateLabel.Font           = Enum.Font.GothamBold
stateLabel.TextSize       = 26
stateLabel.TextXAlignment = Enum.TextXAlignment.Center

-- ══ Pantalla de Resultados ══
local resultsFrame = Instance.new("Frame", screenGui)
resultsFrame.Size             = UDim2.new(0.5, 0, 0.5, 0)
resultsFrame.Position         = UDim2.new(0.25, 0, 0.25, 0)
resultsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
resultsFrame.BackgroundTransparency = 0.1
resultsFrame.BorderSizePixel  = 0
resultsFrame.Visible           = false

local resultsLabel = Instance.new("TextLabel", resultsFrame)
resultsLabel.Size           = UDim2.new(1, 0, 0.4, 0)
resultsLabel.BackgroundTransparency = 1
resultsLabel.TextColor3     = Color3.fromRGB(255, 255, 255)
resultsLabel.Text           = ""
resultsLabel.Font           = Enum.Font.GothamBold
resultsLabel.TextSize       = 28
resultsLabel.TextXAlignment = Enum.TextXAlignment.Center

local resultsDetail = Instance.new("TextLabel", resultsFrame)
resultsDetail.Size           = UDim2.new(1, -20, 0.6, 0)
resultsDetail.Position       = UDim2.new(0, 10, 0.4, 0)
resultsDetail.BackgroundTransparency = 1
resultsDetail.TextColor3     = Color3.fromRGB(200, 200, 200)
resultsDetail.Text           = ""
resultsDetail.Font           = Enum.Font.Gotham
resultsDetail.TextSize       = 16
resultsDetail.TextXAlignment = Enum.TextXAlignment.Center
resultsDetail.TextWrapped    = true

-- ══ Eventos ══
UpdateTimer.OnClientEvent:Connect(function(timeLeft, label)
    timerLabel.Text = "⏱ " .. timeLeft .. "s"
    -- Poner rojo cuando quede poco tiempo
    if timeLeft <= 10 then
        timerLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    else
        timerLabel.TextColor3 = Color3.fromRGB(255, 230, 100)
    end
end)

UpdateGameState.OnClientEvent:Connect(function(state, message)
    stateLabel.Text   = message
    stateFrame.Visible = true

    -- Ocultar el mensaje después de 3 segundos
    task.delay(3, function()
        stateFrame.Visible = false
    end)
end)

AssignRole.OnClientEvent:Connect(function(role)
    if role == "Mouse" then
        roleLabel.Text       = "🐭 RATÓN"
        roleLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
    elseif role == "Hider" then
        roleLabel.Text       = "🙈 ESCONDIDO"
        roleLabel.TextColor3 = Color3.fromRGB(80, 180, 255)
    elseif role == "Caught" then
        roleLabel.Text       = "💀 CAPTURADO"
        roleLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    else
        roleLabel.Text       = "Rol: —"
        roleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

UpdateCoins.OnClientEvent:Connect(function(amount)
    coinLabel.Text = "🪙 " .. tostring(amount)
    -- Animación pequeña
    local tween = TweenService:Create(
        coinLabel,
        TweenInfo.new(0.2, Enum.EasingStyle.Bounce),
        { TextSize = 24 }
    )
    tween:Play()
    tween.Completed:Connect(function()
        coinLabel.TextSize = 18
    end)
end)

ShowResults.OnClientEvent:Connect(function(data)
    resultsFrame.Visible = true

    if data.mouseWon then
        resultsLabel.Text       = "🐭 ¡El Ratón ganó!"
        resultsLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
    else
        resultsLabel.Text       = "🎉 ¡Los Escondidos ganaron!"
        resultsLabel.TextColor3 = Color3.fromRGB(80, 220, 80)
    end

    local detail = "Ratón: " .. data.mousePlayer .. "\n"
    detail = detail .. "Sobrevivientes: " .. table.concat(data.survivors, ", ") .. "\n"
    detail = detail .. "Capturados: " .. table.concat(data.caught, ", ")
    resultsDetail.Text = detail

    -- Ocultar pantalla de resultados después del tiempo configurado
    task.delay(10, function()
        resultsFrame.Visible = false
    end)
end)

print("[GameUI] HUD cargado para " .. player.Name)
