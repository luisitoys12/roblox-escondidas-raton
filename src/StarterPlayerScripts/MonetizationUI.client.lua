-- MonetizationUI.client.lua
-- Botones de compra rápida de Robux: packs de monedas, gacha, gamepasses.
-- Abre con tecla M o botón flotante.

local Players             = game:GetService("Players")
local MarketplaceService  = game:GetService("MarketplaceService")
local UserInputService    = game:GetService("UserInputService")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")

local player              = Players.LocalPlayer
local playerGui           = player.PlayerGui

-- ══ IDs — deben coincidir con MonetizationSystem.server.lua ══
local PRODUCTS = {
    { label = "💰 500 Monedas",       price = "25 R$",   id = 0, type = "product" },
    { label = "💰 1,500 Monedas",     price = "65 R$",   id = 0, type = "product" },
    { label = "💰 5,000 Monedas",     price = "180 R$",  id = 0, type = "product" },
    { label = "🎲 Mascota Aleatoria", price = "50 R$",   id = 0, type = "product" },
    { label = "🛡️ Escudo de Ronda",  price = "30 R$",   id = 0, type = "product" },
}

local GAMEPASSES = {
    { label = "🐭 Ratón VIP",         price = "150 R$",  id = 0 },
    { label = "⚡ Speed Boost",        price = "100 R$",  id = 0 },
    { label = "🎨 Skin Pack",          price = "200 R$",  id = 0 },
    { label = "🔍 Radar Permanente",   price = "250 R$",  id = 0 },
    { label = "💎 VIP Badge",          price = "75 R$",   id = 0 },
}

-- ══ Crear GUI ══
local shopGui = Instance.new("ScreenGui", playerGui)
shopGui.Name = "MonetizationUI"
shopGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", shopGui)
mainFrame.Size             = UDim2.new(0.65, 0, 0.78, 0)
mainFrame.Position         = UDim2.new(0.175, 0, 0.11, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 22)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel  = 0
mainFrame.Visible           = false

local title = Instance.new("TextLabel", mainFrame)
title.Size           = UDim2.new(1, 0, 0, 48)
title.BackgroundTransparency = 1
title.TextColor3     = Color3.fromRGB(255, 215, 0)
title.Text           = "🏪 Tienda Robux"
title.Font           = Enum.Font.GothamBold
title.TextSize       = 26

local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size           = UDim2.new(0, 38, 0, 38)
closeBtn.Position       = UDim2.new(1, -43, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(160, 30, 30)
closeBtn.Text           = "✕"
closeBtn.TextColor3     = Color3.fromRGB(255, 255, 255)
closeBtn.Font           = Enum.Font.GothamBold
closeBtn.TextSize       = 18
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

-- Tabs
local tabBar = Instance.new("Frame", mainFrame)
tabBar.Size             = UDim2.new(1, 0, 0, 38)
tabBar.Position         = UDim2.new(0, 0, 0, 48)
tabBar.BackgroundTransparency = 1

local productTab = Instance.new("TextButton", tabBar)
productTab.Size           = UDim2.new(0.5, 0, 1, 0)
productTab.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
productTab.Text           = "🔁 Productos"
productTab.TextColor3     = Color3.fromRGB(255, 255, 255)
productTab.Font           = Enum.Font.GothamBold
productTab.TextSize       = 14

local passTab = Instance.new("TextButton", tabBar)
passTab.Size           = UDim2.new(0.5, 0, 1, 0)
passTab.Position       = UDim2.new(0.5, 0, 0, 0)
passTab.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
passTab.Text           = "🎫 Gamepasses"
passTab.TextColor3     = Color3.fromRGB(200, 200, 200)
passTab.Font           = Enum.Font.GothamBold
passTab.TextSize       = 14

-- Lista de items
local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size             = UDim2.new(1, -16, 1, -100)
scroll.Position         = UDim2.new(0, 8, 0, 92)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 5
scroll.CanvasSize       = UDim2.new(0, 0, 0, 0)

local listLayout = Instance.new("UIListLayout", scroll)
listLayout.Padding     = UDim.new(0, 6)
listLayout.FillDirection = Enum.FillDirection.Vertical

local function populateList(items, isGamepass)
    for _, c in ipairs(scroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end

    for _, item in ipairs(items) do
        local row = Instance.new("Frame", scroll)
        row.Size             = UDim2.new(1, 0, 0, 58)
        row.BackgroundColor3 = Color3.fromRGB(20, 20, 38)
        row.BorderSizePixel  = 0

        local lbl = Instance.new("TextLabel", row)
        lbl.Size           = UDim2.new(0.55, 0, 1, 0)
        lbl.Position       = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3     = Color3.fromRGB(240, 240, 240)
        lbl.Text           = item.label
        lbl.Font           = Enum.Font.GothamBold
        lbl.TextSize       = 14
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local priceLbl = Instance.new("TextLabel", row)
        priceLbl.Size           = UDim2.new(0.2, 0, 1, 0)
        priceLbl.Position       = UDim2.new(0.55, 0, 0, 0)
        priceLbl.BackgroundTransparency = 1
        priceLbl.TextColor3     = Color3.fromRGB(100, 200, 255)
        priceLbl.Text           = item.price
        priceLbl.Font           = Enum.Font.GothamBold
        priceLbl.TextSize       = 13

        local buyBtn = Instance.new("TextButton", row)
        buyBtn.Size           = UDim2.new(0.18, 0, 0.6, 0)
        buyBtn.Position       = UDim2.new(0.79, 0, 0.2, 0)
        buyBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        buyBtn.Text           = isGamepass and "Comprar" or "Comprar"
        buyBtn.TextColor3     = Color3.fromRGB(255, 255, 255)
        buyBtn.Font           = Enum.Font.GothamBold
        buyBtn.TextSize       = 12

        buyBtn.MouseButton1Click:Connect(function()
            if isGamepass then
                MarketplaceService:PromptGamePassPurchase(player, item.id)
            else
                MarketplaceService:PromptProductPurchase(player, item.id)
            end
        end)
    end

    scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end

local currentIsGamepass = false
productTab.MouseButton1Click:Connect(function()
    currentIsGamepass = false
    productTab.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
    passTab.BackgroundColor3    = Color3.fromRGB(25, 25, 50)
    populateList(PRODUCTS, false)
end)
passTab.MouseButton1Click:Connect(function()
    currentIsGamepass = true
    passTab.BackgroundColor3    = Color3.fromRGB(40, 40, 80)
    productTab.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    populateList(GAMEPASSES, true)
end)

-- Abrir con tecla M
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.M then
        mainFrame.Visible = not mainFrame.Visible
        if mainFrame.Visible then populateList(PRODUCTS, false) end
    end
end)

-- Botón flotante
local openBtn = Instance.new("TextButton", shopGui)
openBtn.Size           = UDim2.new(0, 50, 0, 50)
openBtn.Position       = UDim2.new(0, 10, 0.5, 35)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
openBtn.Text           = "💎"
openBtn.Font           = Enum.Font.GothamBold
openBtn.TextSize       = 24
openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then populateList(PRODUCTS, false) end
end)

print("[MonetizationUI] UI de tienda Robux cargada (tecla M)")
