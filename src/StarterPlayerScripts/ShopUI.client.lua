-- ShopUI.client.lua
-- Tienda de mascotas y herramientas. Se abre con una tecla o botón en el HUD.

local Players        = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player         = Players.LocalPlayer
local playerGui      = player.PlayerGui
local PetData        = require(ReplicatedStorage:WaitForChild("PetData"))
local ToolData       = require(ReplicatedStorage:WaitForChild("ToolData"))
local GameEvents     = ReplicatedStorage:WaitForChild("GameEvents")
local PurchaseItem   = GameEvents:WaitForChild("PurchaseItem")

-- ══ Crear GUI de tienda ══
local shopGui = Instance.new("ScreenGui", playerGui)
shopGui.Name = "ShopUI"
shopGui.ResetOnSpawn = false

local shopFrame = Instance.new("Frame", shopGui)
shopFrame.Size             = UDim2.new(0.7, 0, 0.75, 0)
shopFrame.Position         = UDim2.new(0.15, 0, 0.12, 0)
shopFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
shopFrame.BackgroundTransparency = 0.05
shopFrame.BorderSizePixel  = 0
shopFrame.Visible           = false

-- Título
local title = Instance.new("TextLabel", shopFrame)
title.Size           = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.TextColor3     = Color3.fromRGB(255, 215, 0)
title.Text           = "🛒 Tienda"
title.Font           = Enum.Font.GothamBold
title.TextSize       = 28

-- Botón cerrar
local closeBtn = Instance.new("TextButton", shopFrame)
closeBtn.Size           = UDim2.new(0, 40, 0, 40)
closeBtn.Position       = UDim2.new(1, -45, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.Text           = "X"
closeBtn.TextColor3     = Color3.fromRGB(255, 255, 255)
closeBtn.Font           = Enum.Font.GothamBold
closeBtn.TextSize       = 18
closeBtn.MouseButton1Click:Connect(function()
    shopFrame.Visible = false
end)

-- Tabs (Mascotas / Herramientas)
local tabFrame = Instance.new("Frame", shopFrame)
tabFrame.Size             = UDim2.new(1, 0, 0, 40)
tabFrame.Position         = UDim2.new(0, 0, 0, 50)
tabFrame.BackgroundTransparency = 1

local petTab = Instance.new("TextButton", tabFrame)
petTab.Size             = UDim2.new(0.5, 0, 1, 0)
petTab.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
petTab.Text             = "🐾 Mascotas"
petTab.TextColor3       = Color3.fromRGB(255, 255, 255)
petTab.Font             = Enum.Font.GothamBold
petTab.TextSize         = 16

local toolTab = Instance.new("TextButton", tabFrame)
toolTab.Size             = UDim2.new(0.5, 0, 1, 0)
toolTab.Position         = UDim2.new(0.5, 0, 0, 0)
toolTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
toolTab.Text             = "🛠️ Herramientas"
toolTab.TextColor3       = Color3.fromRGB(200, 200, 200)
toolTab.Font             = Enum.Font.GothamBold
toolTab.TextSize         = 16

-- ScrollingFrame para items
local itemScroll = Instance.new("ScrollingFrame", shopFrame)
itemScroll.Size             = UDim2.new(1, -20, 1, -110)
itemScroll.Position         = UDim2.new(0, 10, 0, 100)
itemScroll.BackgroundTransparency = 1
itemScroll.ScrollBarThickness = 6
itemScroll.CanvasSize       = UDim2.new(0, 0, 0, 0)

local itemList = Instance.new("UIListLayout", itemScroll)
itemList.Padding     = UDim.new(0, 8)
itemList.FillDirection = Enum.FillDirection.Vertical

-- Función para limpiar y rellenar la lista
local function populateItems(itemType)
    for _, child in ipairs(itemScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local data = itemType == "pet" and PetData or ToolData

    for _, item in ipairs(data) do
        -- Solo mostrar herramientas del rol correcto (o todas en lobby)
        if itemType == "tool" then
            local myRole = player:GetAttribute("Role") or ""
            if myRole ~= "" and item.role ~= myRole then
                continue  -- Ocultar herramientas de otro rol durante la partida
            end
        end

        local card = Instance.new("Frame", itemScroll)
        card.Size             = UDim2.new(1, 0, 0, 70)
        card.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
        card.BorderSizePixel  = 0

        local nameLabel = Instance.new("TextLabel", card)
        nameLabel.Size           = UDim2.new(0.6, 0, 0.5, 0)
        nameLabel.Position       = UDim2.new(0, 10, 0, 5)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3     = Color3.fromRGB(255, 255, 255)
        nameLabel.Text           = item.name
        nameLabel.Font           = Enum.Font.GothamBold
        nameLabel.TextSize       = 15
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left

        local descLabel = Instance.new("TextLabel", card)
        descLabel.Size           = UDim2.new(0.6, 0, 0.5, 0)
        descLabel.Position       = UDim2.new(0, 10, 0.5, 0)
        descLabel.BackgroundTransparency = 1
        descLabel.TextColor3     = Color3.fromRGB(160, 160, 180)
        descLabel.Text           = item.description
        descLabel.Font           = Enum.Font.Gotham
        descLabel.TextSize       = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.TextWrapped    = true

        local priceLabel = Instance.new("TextLabel", card)
        priceLabel.Size           = UDim2.new(0.2, 0, 1, 0)
        priceLabel.Position       = UDim2.new(0.6, 0, 0, 0)
        priceLabel.BackgroundTransparency = 1
        priceLabel.TextColor3     = Color3.fromRGB(255, 215, 0)
        priceLabel.Text           = "🪙 " .. item.price
        priceLabel.Font           = Enum.Font.GothamBold
        priceLabel.TextSize       = 14

        local buyBtn = Instance.new("TextButton", card)
        buyBtn.Size           = UDim2.new(0.15, 0, 0.6, 0)
        buyBtn.Position       = UDim2.new(0.83, 0, 0.2, 0)
        buyBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 80)
        buyBtn.Text           = "Comprar"
        buyBtn.TextColor3     = Color3.fromRGB(255, 255, 255)
        buyBtn.Font           = Enum.Font.GothamBold
        buyBtn.TextSize       = 12

        buyBtn.MouseButton1Click:Connect(function()
            local result = PurchaseItem:InvokeServer(itemType, item.id)
            if result.success then
                buyBtn.BackgroundColor3 = Color3.fromRGB(30, 200, 100)
                buyBtn.Text = "✓"
            else
                buyBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
                buyBtn.Text = "✗"
            end
            task.delay(1.5, function()
                buyBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 80)
                buyBtn.Text = "Comprar"
            end)
        end)
    end

    -- Ajustar canvas
    itemScroll.CanvasSize = UDim2.new(0, 0, 0, itemList.AbsoluteContentSize.Y + 20)
end

-- Tabs
local currentTab = "pet"
petTab.MouseButton1Click:Connect(function()
    currentTab = "pet"
    petTab.BackgroundColor3  = Color3.fromRGB(40, 120, 200)
    toolTab.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    populateItems("pet")
end)

toolTab.MouseButton1Click:Connect(function()
    currentTab = "tool"
    petTab.BackgroundColor3  = Color3.fromRGB(60, 60, 80)
    toolTab.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
    populateItems("tool")
end)

-- Abrir tienda con tecla E
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then
        shopFrame.Visible = not shopFrame.Visible
        if shopFrame.Visible then
            populateItems(currentTab)
        end
    end
end)

-- Botón flotante para abrir tienda
local openBtn = Instance.new("TextButton", shopGui)
openBtn.Size           = UDim2.new(0, 50, 0, 50)
openBtn.Position       = UDim2.new(0, 10, 0.5, -25)
openBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
openBtn.Text           = "🛒"
openBtn.Font           = Enum.Font.GothamBold
openBtn.TextSize       = 24
openBtn.MouseButton1Click:Connect(function()
    shopFrame.Visible = not shopFrame.Visible
    if shopFrame.Visible then populateItems(currentTab) end
end)

print("[ShopUI] Tienda cargada")
