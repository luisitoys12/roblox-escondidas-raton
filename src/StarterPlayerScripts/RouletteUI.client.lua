-- RouletteUI.client.lua
-- Tienda + animación de la ruleta de accesorios.
-- Se abre con botón flotante 🎰 o tecla R.

local Players            = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService       = game:GetService("TweenService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local playerGui = player.PlayerGui

local GameEvents       = ReplicatedStorage:WaitForChild("GameEvents")
local SpinResult       = GameEvents:WaitForChild("SpinResult")
local GetMyAccessories = GameEvents:WaitForChild("GetMyAccessories")

-- IDs Developer Products — actualiza con los tuyos
local SPIN_PRODUCTS = {
    { id=0, label="1 Giro",   price="30 R$",  count=1  },
    { id=0, label="3 Giros",  price="75 R$",  count=3  },
    { id=0, label="10 Giros", price="200 R$", count=10 },
}

local RARITY_COLORS = {
    ["Común"]      = Color3.fromRGB(180,180,180),
    ["Legendario"] = Color3.fromRGB(255,200,0),
    ["Máximo"]     = Color3.fromRGB(160,0,220),
    ["Ultra"]      = Color3.fromRGB(220,30,30),
    ["Dios"]       = Color3.fromRGB(255,100,255),
}

-- ==========================================
--  GUI BASE
-- ==========================================
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "RouletteUI" ; gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Panel principal tienda
local shopFrame = Instance.new("Frame", gui)
shopFrame.Size = UDim2.new(0,420,0,380)
shopFrame.Position = UDim2.new(0.5,-210,0.5,-190)
shopFrame.BackgroundColor3 = Color3.fromRGB(10,10,28)
shopFrame.BorderSizePixel = 0
shopFrame.Visible = false
Instance.new("UICorner", shopFrame).CornerRadius = UDim.new(0,16)

local titleL = Instance.new("TextLabel", shopFrame)
titleL.Size = UDim2.new(1,0,0,46) ; titleL.BackgroundTransparency = 1
titleL.Text = "🎰  Ruleta de Accesorios" ; titleL.Font = Enum.Font.GothamBold
titleL.TextSize = 20 ; titleL.TextColor3 = Color3.fromRGB(255,215,0)

local closeBtn = Instance.new("TextButton", shopFrame)
closeBtn.Size = UDim2.new(0,34,0,34) ; closeBtn.Position = UDim2.new(1,-40,0,6)
closeBtn.BackgroundColor3 = Color3.fromRGB(150,30,30)
closeBtn.Text = "✕" ; closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold ; closeBtn.TextSize = 16
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)
closeBtn.MouseButton1Click:Connect(function() shopFrame.Visible = false end)

-- Botones de compra de giros
local spinBtnRow = Instance.new("Frame", shopFrame)
spinBtnRow.Size = UDim2.new(1,-20,0,64)
spinBtnRow.Position = UDim2.new(0,10,0,52)
spinBtnRow.BackgroundTransparency = 1
local rowLayout = Instance.new("UIListLayout", spinBtnRow)
rowLayout.FillDirection = Enum.FillDirection.Horizontal
rowLayout.Padding = UDim.new(0,8)

for _, spinOpt in ipairs(SPIN_PRODUCTS) do
    local btn = Instance.new("TextButton", spinBtnRow)
    btn.Size = UDim2.new(0,118,1,0)
    btn.BackgroundColor3 = Color3.fromRGB(100,40,160)
    btn.Text = spinOpt.label .. "\n" .. spinOpt.price
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold ; btn.TextSize = 13
    btn.TextWrapped = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    local pid = spinOpt.id
    btn.MouseButton1Click:Connect(function()
        if pid ~= 0 then
            MarketplaceService:PromptProductPurchase(player, pid)
        else
            print("[RouletteUI] Configura el Developer Product ID para: " .. spinOpt.label)
        end
    end)
end

-- Separador
local sep = Instance.new("Frame", shopFrame)
sep.Size = UDim2.new(1,-20,0,2) ; sep.Position = UDim2.new(0,10,0,126)
sep.BackgroundColor3 = Color3.fromRGB(40,40,80) ; sep.BorderSizePixel = 0

-- Título sección probabilidades
local probTitle = Instance.new("TextLabel", shopFrame)
probTitle.Size = UDim2.new(1,0,0,28) ; probTitle.Position = UDim2.new(0,0,0,132)
probTitle.BackgroundTransparency = 1 ; probTitle.Text = "Probabilidades"
probTitle.Font = Enum.Font.GothamBold ; probTitle.TextSize = 14
probTitle.TextColor3 = Color3.fromRGB(180,180,220)

-- Barras de probabilidad
local PROBS = {
    { rarity="Común",      pct=60, color=Color3.fromRGB(180,180,180) },
    { rarity="Legendario", pct=25, color=Color3.fromRGB(255,200,0)   },
    { rarity="Máximo",     pct=9,  color=Color3.fromRGB(160,0,220)   },
    { rarity="Ultra",      pct=5,  color=Color3.fromRGB(220,30,30)   },
    { rarity="Dios",       pct=1,  color=Color3.fromRGB(255,100,255) },
}

for i, prob in ipairs(PROBS) do
    local row = Instance.new("Frame", shopFrame)
    row.Size = UDim2.new(1,-20,0,26)
    row.Position = UDim2.new(0,10,0,162 + (i-1)*30)
    row.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0,90,1,0) ; lbl.BackgroundTransparency = 1
    lbl.Text = prob.rarity ; lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12 ; lbl.TextColor3 = prob.color
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local barBg = Instance.new("Frame", row)
    barBg.Size = UDim2.new(1,-100,0,10) ; barBg.Position = UDim2.new(0,94,0.5,-5)
    barBg.BackgroundColor3 = Color3.fromRGB(30,30,55) ; barBg.BorderSizePixel = 0
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(0,5)

    local barFill = Instance.new("Frame", barBg)
    barFill.Size = UDim2.new(prob.pct/100,0,1,0)
    barFill.BackgroundColor3 = prob.color ; barFill.BorderSizePixel = 0
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(0,5)

    local pctLbl = Instance.new("TextLabel", row)
    pctLbl.Size = UDim2.new(0,36,1,0) ; pctLbl.Position = UDim2.new(1,-36,0,0)
    pctLbl.BackgroundTransparency = 1 ; pctLbl.Text = prob.pct .. "%"
    pctLbl.Font = Enum.Font.Gotham ; pctLbl.TextSize = 11
    pctLbl.TextColor3 = Color3.fromRGB(180,180,200)
    pctLbl.TextXAlignment = Enum.TextXAlignment.Right
end

-- ==========================================
--  PANEL ANIMACIÓN DE GIRO
-- ==========================================
local spinPanel = Instance.new("Frame", gui)
spinPanel.Size = UDim2.new(0,460,0,200)
spinPanel.Position = UDim2.new(0.5,-230,0.5,-100)
spinPanel.BackgroundColor3 = Color3.fromRGB(8,8,22)
spinPanel.BorderSizePixel = 0 ; spinPanel.Visible = false
Instance.new("UICorner", spinPanel).CornerRadius = UDim.new(0,16)

local spinTitle = Instance.new("TextLabel", spinPanel)
spinTitle.Size = UDim2.new(1,0,0,36) ; spinTitle.BackgroundTransparency = 1
spinTitle.Text = "🎰  GIRANDO..." ; spinTitle.Font = Enum.Font.GothamBold
spinTitle.TextSize = 18 ; spinTitle.TextColor3 = Color3.fromRGB(255,215,0)

local slotOuter = Instance.new("Frame", spinPanel)
slotOuter.Size = UDim2.new(1,-20,0,100)
slotOuter.Position = UDim2.new(0,10,0,42)
slotOuter.BackgroundColor3 = Color3.fromRGB(18,18,40)
slotOuter.BorderSizePixel = 0 ; slotOuter.ClipsDescendants = true
Instance.new("UICorner", slotOuter).CornerRadius = UDim.new(0,10)

-- Indicador central
local pointer = Instance.new("Frame", spinPanel)
pointer.Size = UDim2.new(0,3,0,100)
pointer.Position = UDim2.new(0.5,-1.5,0,42)
pointer.BackgroundColor3 = Color3.fromRGB(255,60,60)
pointer.ZIndex = 6 ; pointer.BorderSizePixel = 0

local strip = Instance.new("Frame", slotOuter)
strip.BackgroundTransparency = 1
strip.Size = UDim2.new(0,2000,1,0)
strip.Position = UDim2.new(0,0,0,0)

local SLOT_W, SLOT_GAP = 110, 8

-- Panel resultado individual
local resultPanel = Instance.new("Frame", spinPanel)
resultPanel.Size = UDim2.new(1,-20,0,46)
resultPanel.Position = UDim2.new(0,10,0,148)
resultPanel.BackgroundTransparency = 1
resultPanel.Visible = false

local resultLbl = Instance.new("TextLabel", resultPanel)
resultLbl.Size = UDim2.new(1,0,1,0) ; resultLbl.BackgroundTransparency = 1
resultLbl.Font = Enum.Font.GothamBold ; resultLbl.TextSize = 18
resultLbl.TextColor3 = Color3.new(1,1,1) ; resultLbl.TextXAlignment = Enum.TextXAlignment.Center

-- ==========================================
--  FUNCIÓN ANIMACIÓN
-- ==========================================
local ACC_DISPLAY = {
    { name="Gorra Ratón",        color=Color3.fromRGB(180,180,180) },
    { name="Estela de Humo",     color=Color3.fromRGB(160,160,160) },
    { name="Tag Queso",          color=Color3.fromRGB(200,200,100) },
    { name="Alas Murciélago",    color=Color3.fromRGB(255,200,0)   },
    { name="Capa Sombra",        color=Color3.fromRGB(220,180,0)   },
    { name="Estela Estelar",     color=Color3.fromRGB(200,160,0)   },
    { name="Corona Neón",        color=Color3.fromRGB(160,0,220)   },
    { name="Aura de Fuego",      color=Color3.fromRGB(140,0,200)   },
    { name="Estela Arcoíris",    color=Color3.fromRGB(120,0,180)   },
    { name="Máscara Fantasma",   color=Color3.fromRGB(220,30,30)   },
    { name="Halo Divino",        color=Color3.fromRGB(255,100,255) },
}

local function buildStrip()
    for _, c in ipairs(strip:GetChildren()) do c:Destroy() end
    local items = {}
    for i = 1, 6 do
        for _, a in ipairs(ACC_DISPLAY) do table.insert(items, a) end
    end
    strip.Size = UDim2.new(0, #items*(SLOT_W+SLOT_GAP), 1, 0)
    for i, a in ipairs(items) do
        local slot = Instance.new("Frame", strip)
        slot.Size = UDim2.new(0,SLOT_W,1,-12)
        slot.Position = UDim2.new(0,(i-1)*(SLOT_W+SLOT_GAP)+4,0,6)
        slot.BackgroundColor3 = a.color ; slot.BorderSizePixel = 0
        Instance.new("UICorner", slot).CornerRadius = UDim.new(0,8)
        local lbl = Instance.new("TextLabel", slot)
        lbl.Size = UDim2.new(1,0,1,0) ; lbl.BackgroundTransparency = 1
        lbl.Text = a.name ; lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11 ; lbl.TextColor3 = Color3.fromRGB(20,20,20)
        lbl.TextWrapped = true ; lbl.TextXAlignment = Enum.TextXAlignment.Center
    end
    return #items
end

local spinQueue = {}
local isSpinning = false

local function animateSingle(accData, onDone)
    local containerW = slotOuter.AbsoluteSize.X
    local centerX    = (containerW / 2) - (SLOT_W / 2)
    buildStrip()
    strip.Position = UDim2.new(0,0,0,0)
    spinTitle.Text = "🎰  GIRANDO..."
    resultPanel.Visible = false

    local total = #ACC_DISPLAY * 6
    local targetIdx = math.random(3*#ACC_DISPLAY, 5*#ACC_DISPLAY)
    local targetX   = -(targetIdx * (SLOT_W+SLOT_GAP) - centerX)

    local t1 = TweenService:Create(strip,
        TweenInfo.new(2.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
        { Position = UDim2.new(0, targetX - 180, 0, 0) })
    local t2 = TweenService:Create(strip,
        TweenInfo.new(0.9, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Position = UDim2.new(0, targetX, 0, 0) })

    t1:Play()
    t1.Completed:Connect(function()
        t2:Play()
        t2.Completed:Connect(function()
            -- Mostrar resultado real del servidor
            local color = RARITY_COLORS[accData.rarity] or Color3.fromRGB(200,200,200)
            spinTitle.Text = "✨  " .. accData.rarity:upper()
            spinTitle.TextColor3 = color
            resultLbl.Text = accData.name
            resultLbl.TextColor3 = color
            resultPanel.Visible = true
            task.wait(2)
            if onDone then onDone() end
        end)
    end)
end

local function processQueue()
    if isSpinning or #spinQueue == 0 then return end
    isSpinning = true
    shopFrame.Visible = false
    spinPanel.Visible = true
    spinPanel.BackgroundColor3 = Color3.fromRGB(8,8,22)
    spinTitle.TextColor3 = Color3.fromRGB(255,215,0)

    local function nextSpin()
        if #spinQueue == 0 then
            task.wait(1.5)
            spinPanel.Visible = false
            isSpinning = false
            return
        end
        local acc = table.remove(spinQueue, 1)
        animateSingle(acc, nextSpin)
    end
    nextSpin()
end

-- ==========================================
--  EVENTOS
-- ==========================================
SpinResult.OnClientEvent:Connect(function(results)
    for _, acc in ipairs(results) do
        table.insert(spinQueue, acc)
    end
    processQueue()
end)

-- ==========================================
--  BOTÓN FLOTANTE Y TECLA R
-- ==========================================
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0,50,0,50)
openBtn.Position = UDim2.new(1,-62,1,-130)   -- encima del botón de gamepasses
openBtn.BackgroundColor3 = Color3.fromRGB(160,0,220)
openBtn.Text = "🎰" ; openBtn.Font = Enum.Font.GothamBold ; openBtn.TextSize = 22
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0,25)
openBtn.MouseButton1Click:Connect(function()
    shopFrame.Visible = not shopFrame.Visible
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.R then
        shopFrame.Visible = not shopFrame.Visible
    end
end)

print("[RouletteUI] Ruleta de accesorios lista — tecla R para abrir")
