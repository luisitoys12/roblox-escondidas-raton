-- ClosetUI.client.lua
-- Armario del jugador: equipa accesorios y ropa.
-- Se abre con tecla T o desde la tienda.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")

local player    = Players.LocalPlayer
local playerGui = player.PlayerGui
local AccessoryData = require(ReplicatedStorage:WaitForChild("AccessoryData"))
local ClothingData  = require(ReplicatedStorage:WaitForChild("ClothingData"))
local GameEvents    = ReplicatedStorage:WaitForChild("GameEvents")
local EquipItem     = GameEvents:WaitForChild("EquipItem")

-- GUI principal
local closetGui = Instance.new("ScreenGui", playerGui)
closetGui.Name = "ClosetUI"
closetGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", closetGui)
mainFrame.Size             = UDim2.new(0.75, 0, 0.8, 0)
mainFrame.Position         = UDim2.new(0.125, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel  = 0
mainFrame.Visible          = false

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)

-- Título
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size           = UDim2.new(1, 0, 0, 55)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size           = UDim2.new(0.8, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3     = Color3.fromRGB(255, 255, 255)
titleLabel.Text           = "👔 Mi Armario"
titleLabel.Font           = Enum.Font.GothamBold
titleLabel.TextSize       = 22

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size           = UDim2.new(0, 40, 0, 40)
closeBtn.Position       = UDim2.new(1, -48, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.Text           = "✕"
closeBtn.TextColor3     = Color3.fromRGB(255, 255, 255)
closeBtn.Font           = Enum.Font.GothamBold
closeBtn.TextSize       = 18
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

-- Tabs
local TABS = { "Accesorios", "Ropa" }
local tabHolder = Instance.new("Frame", mainFrame)
tabHolder.Size             = UDim2.new(1, 0, 0, 40)
tabHolder.Position         = UDim2.new(0, 0, 0, 58)
tabHolder.BackgroundTransparency = 1

local currentTab = "Accesorios"
local tabButtons = {}

for i, tabName in ipairs(TABS) do
    local btn = Instance.new("TextButton", tabHolder)
    btn.Size             = UDim2.new(0.5, 0, 1, 0)
    btn.Position         = UDim2.new((i-1)*0.5, 0, 0, 0)
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(50,100,200) or Color3.fromRGB(30,30,60)
    btn.Text             = tabName
    btn.TextColor3       = Color3.fromRGB(255,255,255)
    btn.Font             = Enum.Font.GothamBold
    btn.TextSize         = 15
    tabButtons[tabName]  = btn
end

-- Scroll de items
local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size             = UDim2.new(1, -20, 1, -110)
scroll.Position         = UDim2.new(0, 10, 0, 100)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 5
scroll.CanvasSize       = UDim2.new(0, 0, 0, 0)

local grid = Instance.new("UIGridLayout", scroll)
grid.CellSize    = UDim2.new(0, 120, 0, 140)
grid.CellPadding = UDim2.new(0, 10, 0, 10)

local RARITY_COLORS = {
    ["Común"]      = Color3.fromRGB(180,180,180),
    ["Legendario"] = Color3.fromRGB(255,200,0),
    ["Máximo"]     = Color3.fromRGB(160,0,220),
    ["Ultra"]      = Color3.fromRGB(220,30,30),
    ["Dios"]       = Color3.fromRGB(255,100,255),
}

local function populateCloset(tabName)
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local data = tabName == "Accesorios" and AccessoryData or ClothingData
    for _, item in ipairs(data) do
        local card = Instance.new("Frame", scroll)
        card.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
        card.BorderSizePixel  = 0
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

        -- Borde de rareza
        local stroke = Instance.new("UIStroke", card)
        stroke.Color     = RARITY_COLORS[item.rarity] or Color3.fromRGB(100,100,100)
        stroke.Thickness = 2

        -- Icono
        local icon = Instance.new("ImageLabel", card)
        icon.Size            = UDim2.new(1, -10, 0, 80)
        icon.Position        = UDim2.new(0, 5, 0, 5)
        icon.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
        icon.Image           = item.icon or ""
        Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 6)

        local nameL = Instance.new("TextLabel", card)
        nameL.Size           = UDim2.new(1, 0, 0, 20)
        nameL.Position       = UDim2.new(0, 0, 0, 87)
        nameL.BackgroundTransparency = 1
        nameL.TextColor3     = Color3.fromRGB(255,255,255)
        nameL.Text           = item.name
        nameL.Font           = Enum.Font.GothamBold
        nameL.TextSize       = 10
        nameL.TextScaled     = true

        local equipBtn = Instance.new("TextButton", card)
        equipBtn.Size           = UDim2.new(1, -10, 0, 25)
        equipBtn.Position       = UDim2.new(0, 5, 0, 110)
        equipBtn.BackgroundColor3 = Color3.fromRGB(40,160,80)
        equipBtn.Text           = "Equipar"
        equipBtn.TextColor3     = Color3.fromRGB(255,255,255)
        equipBtn.Font           = Enum.Font.GothamBold
        equipBtn.TextSize       = 12
        Instance.new("UICorner", equipBtn).CornerRadius = UDim.new(0, 5)

        local itemType = tabName == "Accesorios" and "accessory" or "clothing"
        equipBtn.MouseButton1Click:Connect(function()
            local result = EquipItem:InvokeServer(itemType, item.id)
            if result and result.success then
                equipBtn.BackgroundColor3 = Color3.fromRGB(30,200,100)
                equipBtn.Text = "✓"
            else
                equipBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
                equipBtn.Text = result and result.message or "Error"
            end
            task.delay(2, function()
                equipBtn.BackgroundColor3 = Color3.fromRGB(40,160,80)
                equipBtn.Text = "Equipar"
            end)
        end)
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, grid.AbsoluteContentSize.Y + 20)
end

-- Conectar tabs
for _, tabName in ipairs(TABS) do
    tabButtons[tabName].MouseButton1Click:Connect(function()
        currentTab = tabName
        for _, t in ipairs(TABS) do
            tabButtons[t].BackgroundColor3 = t == tabName
                and Color3.fromRGB(50,100,200)
                or  Color3.fromRGB(30,30,60)
        end
        populateCloset(tabName)
    end)
end

-- Abrir con tecla T
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.T then
        mainFrame.Visible = not mainFrame.Visible
        if mainFrame.Visible then populateCloset(currentTab) end
    end
end)

-- Botón flotante armario
local openBtn = Instance.new("TextButton", closetGui)
openBtn.Size           = UDim2.new(0, 50, 0, 50)
openBtn.Position       = UDim2.new(0, 10, 0.58, -25)
openBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 160)
openBtn.Text           = "👔"
openBtn.Font           = Enum.Font.GothamBold
openBtn.TextSize       = 24
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 12)
openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then populateCloset(currentTab) end
end)

print("[ClosetUI] Armario cargado")
