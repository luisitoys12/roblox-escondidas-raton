-- RouletteUI.client.lua
-- Animación visual de la ruleta mid-round.
-- Gira las actividades y revela la ganadora con efecto de rebote.

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local playerGui = player.PlayerGui

local GameEvents     = ReplicatedStorage:WaitForChild("GameEvents")
local SpinRoulette   = GameEvents:WaitForChild("SpinRoulette")
local RouletteResult = GameEvents:WaitForChild("RouletteResult")

-- ==========================================
--  GUI PRINCIPAL
-- ==========================================
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "RouletteUI" ; gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Overlay oscuro
local overlay = Instance.new("Frame", gui)
overlay.Size = UDim2.new(1,0,1,0)
overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
overlay.BackgroundTransparency = 1
overlay.BorderSizePixel = 0
overlay.Visible = false

-- Panel central
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0,460,0,340)
panel.Position = UDim2.new(0.5,-230,0.5,-170)
panel.BackgroundColor3 = Color3.fromRGB(10,10,28)
panel.BorderSizePixel = 0
panel.Visible = false
Instance.new("UICorner", panel).CornerRadius = UDim.new(0,18)

local titleLbl = Instance.new("TextLabel", panel)
titleLbl.Size = UDim2.new(1,0,0,44)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "🎡  RULETA DE ACTIVIDADES"
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextSize = 20
titleLbl.TextColor3 = Color3.fromRGB(255,220,0)

-- Contenedor de slots (scroll horizontal)
local slotContainer = Instance.new("Frame", panel)
slotContainer.Size = UDim2.new(1,-20,0,130)
slotContainer.Position = UDim2.new(0,10,0,50)
slotContainer.BackgroundColor3 = Color3.fromRGB(18,18,40)
slotContainer.BorderSizePixel = 0
slotContainer.ClipsDescendants = true
Instance.new("UICorner", slotContainer).CornerRadius = UDim.new(0,10)

-- Indicador central (flecha)
local arrow = Instance.new("Frame", panel)
arrow.Size = UDim2.new(0,4,0,130)
arrow.Position = UDim2.new(0.5,-2,0,50)
arrow.BackgroundColor3 = Color3.fromRGB(255,80,80)
arrow.ZIndex = 5
arrow.BorderSizePixel = 0

-- Strip de slots
local strip = Instance.new("Frame", slotContainer)
strip.BackgroundTransparency = 1
strip.Size = UDim2.new(0,0,1,0) -- ancho dinámico
strip.Position = UDim2.new(0,0,0,0)

local SLOT_W = 120
local SLOT_GAP = 8

-- Resultado banner
local resultBanner = Instance.new("Frame", panel)
resultBanner.Size = UDim2.new(1,-20,0,100)
resultBanner.Position = UDim2.new(0,10,0,195)
resultBanner.BackgroundColor3 = Color3.fromRGB(20,20,50)
resultBanner.BorderSizePixel = 0
resultBanner.Visible = false
Instance.new("UICorner", resultBanner).CornerRadius = UDim.new(0,12)

local resultName = Instance.new("TextLabel", resultBanner)
resultName.Size = UDim2.new(1,0,0.55,0)
resultName.BackgroundTransparency = 1
resultName.Font = Enum.Font.GothamBold
resultName.TextSize = 22
resultName.TextColor3 = Color3.new(1,1,1)
resultName.TextXAlignment = Enum.TextXAlignment.Center

local resultDesc = Instance.new("TextLabel", resultBanner)
resultDesc.Size = UDim2.new(1,-16,0.45,0)
resultDesc.Position = UDim2.new(0,8,0.55,0)
resultDesc.BackgroundTransparency = 1
resultDesc.Font = Enum.Font.Gotham
resultDesc.TextSize = 14
resultDesc.TextColor3 = Color3.fromRGB(180,180,220)
resultDesc.TextXAlignment = Enum.TextXAlignment.Center
resultDesc.TextWrapped = true

-- ==========================================
--  ANIMACIÓN DE GIRO
-- ==========================================
local function buildStrip(activities)
    -- Limpiar slots anteriores
    for _, c in ipairs(strip:GetChildren()) do c:Destroy() end

    -- Repetimos la lista varias veces para simular giro largo
    local slots = {}
    for i = 1, 5 do
        for _, act in ipairs(activities) do
            table.insert(slots, act)
        end
    end

    local totalW = #slots * (SLOT_W + SLOT_GAP)
    strip.Size = UDim2.new(0, totalW, 1, 0)

    for i, act in ipairs(slots) do
        local slot = Instance.new("Frame", strip)
        slot.Size = UDim2.new(0, SLOT_W, 1, -12)
        slot.Position = UDim2.new(0, (i-1)*(SLOT_W+SLOT_GAP)+4, 0, 6)
        slot.BackgroundColor3 = act.color or Color3.fromRGB(40,40,80)
        slot.BorderSizePixel = 0
        Instance.new("UICorner", slot).CornerRadius = UDim.new(0,10)

        local lbl = Instance.new("TextLabel", slot)
        lbl.Size = UDim2.new(1,0,1,0)
        lbl.BackgroundTransparency = 1
        lbl.Text = act.name or "?"
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextColor3 = Color3.fromRGB(20,20,20)
        lbl.TextWrapped = true
        lbl.TextXAlignment = Enum.TextXAlignment.Center
    end
    return #slots
end

local function animateSpin(activities, chosenIndex, onDone)
    local numSlots = buildStrip(activities)
    -- Posición inicial: empezar desde el principio
    strip.Position = UDim2.new(0, 0, 0, 0)

    -- Centro del contenedor
    local containerCenter = (slotContainer.AbsoluteSize.X / 2) - (SLOT_W / 2)

    -- El ganador está en la vuelta 3 (índice 2*#activities + chosenIndex - 1)
    local targetIndex = 2 * #activities + (chosenIndex - 1)
    local targetX = -(targetIndex * (SLOT_W + SLOT_GAP) - containerCenter)

    -- Fase 1: aceleración rápida
    local tween1 = TweenService:Create(strip,
        TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        { Position = UDim2.new(0, targetX - 300, 0, 0) })

    -- Fase 2: frenazo con rebote
    local tween2 = TweenService:Create(strip,
        TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Position = UDim2.new(0, targetX, 0, 0) })

    tween1:Play()
    tween1.Completed:Connect(function()
        tween2:Play()
        tween2.Completed:Connect(function()
            if onDone then onDone() end
        end)
    end)
end

-- ==========================================
--  EVENTOS
-- ==========================================
SpinRoulette.OnClientEvent:Connect(function(activities)
    overlay.Visible = true
    overlay.BackgroundTransparency = 0.5
    panel.Visible = true
    resultBanner.Visible = false
    panel.Position = UDim2.new(0.5,-230,0.5,-200)
    panel:TweenPosition(UDim2.new(0.5,-230,0.5,-170),
        Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.4, true)
end)

RouletteResult.OnClientEvent:Connect(function(chosen)
    -- Encontrar índice del elegido
    local chosenIdx = 1
    -- chosen viene del servidor, buscamos por id
    -- (el servidor ya tiene la lista en el mismo orden)
    -- Usamos el nombre como fallback
    resultName.Text = chosen.name
    resultDesc.Text = chosen.desc
    resultBanner.BackgroundColor3 = chosen.color or Color3.fromRGB(40,40,80)

    -- Animación de resultado
    task.wait(0.2)
    resultBanner.Visible = true
    resultBanner.Size = UDim2.new(0,0,0,100)
    resultBanner.Position = UDim2.new(0.5,0,0,195)
    local tw = TweenService:Create(resultBanner,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(1,-20,0,100), Position = UDim2.new(0,10,0,195) })
    tw:Play()

    -- Cerrar panel después de 4 seg
    task.delay(4, function()
        panel:TweenPosition(UDim2.new(0.5,-230,1.2,0),
            Enum.EasingDirection.In, Enum.EasingStyle.Back, 0.4, true,
            function()
                panel.Visible = false
                overlay.Visible = false
            end)
    end)
end)

print("[RouletteUI] Animación de ruleta lista")
