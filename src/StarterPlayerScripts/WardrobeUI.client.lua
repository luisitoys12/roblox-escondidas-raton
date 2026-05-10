-- WardrobeUI.client.lua
-- Tienda completa: Mascotas, Accesorios, Ropa
-- Tecla: Tab o botón flotante 👗

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local playerGui = player.PlayerGui
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local PurchaseItem    = GameEvents:WaitForChild("PurchaseItem")
local EquipAccessory  = GameEvents:WaitForChild("EquipAccessory")
local EquipClothing   = GameEvents:WaitForChild("EquipClothing")
local PromptProduct   = GameEvents:WaitForChild("PromptProduct")
local PetRolled       = GameEvents:WaitForChild("PetRolled")

local PetData       = require(ReplicatedStorage:WaitForChild("PetData"))
local AccessoryData = require(ReplicatedStorage:WaitForChild("AccessoryData"))
local ClothingData  = require(ReplicatedStorage:WaitForChild("ClothingData"))

local RARITY_COLORS = {
    ["Común"]      = Color3.fromRGB(180,180,180),
    ["Legendario"] = Color3.fromRGB(255,200,0),
    ["Máximo"]     = Color3.fromRGB(160,0,220),
    ["Ultra"]      = Color3.fromRGB(220,30,30),
    ["Dios"]       = Color3.fromRGB(255,100,255),
}

-- ══ GUI principal ══
local wardGui   = Instance.new("ScreenGui", playerGui)
wardGui.Name    = "WardrobeUI"
wardGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", wardGui)
mainFrame.Size             = UDim2.new(0.85,0,0.85,0)
mainFrame.Position         = UDim2.new(0.075,0,0.075,0)
mainFrame.BackgroundColor3 = Color3.fromRGB(12,12,24)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel  = 0
mainFrame.Visible           = false

-- Título
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size           = UDim2.new(1,0,0,50)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3     = Color3.fromRGB(255,215,0)
titleLabel.Text           = "🛍️ Tienda & Guardarropa"
titleLabel.Font           = Enum.Font.GothamBold
titleLabel.TextSize       = 26

-- Cerrar
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size           = UDim2.new(0,40,0,40)
closeBtn.Position       = UDim2.new(1,-45,0,5)
closeBtn.BackgroundColor3 = Color3.fromRGB(180,30,30)
closeBtn.Text           = "✕"
closeBtn.TextColor3     = Color3.fromRGB(255,255,255)
closeBtn.Font           = Enum.Font.GothamBold
closeBtn.TextSize       = 18
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

-- ══ Tabs ══
local tabNames = { "🐾 Mascotas", "🎩 Accesorios", "👕 Ropa", "🎲 Gacha" }
local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size             = UDim2.new(1,0,0,40)
tabFrame.Position         = UDim2.new(0,0,0,50)
tabFrame.BackgroundTransparency = 1

local tabs = {}
for i, tabName in ipairs(tabNames) do
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size             = UDim2.new(0.25,0,1,0)
    btn.Position         = UDim2.new((i-1)*0.25,0,0,0)
    btn.BackgroundColor3 = i==1 and Color3.fromRGB(40,80,160) or Color3.fromRGB(30,30,55)
    btn.Text             = tabName
    btn.TextColor3       = Color3.fromRGB(255,255,255)
    btn.Font             = Enum.Font.GothamBold
    btn.TextSize         = 13
    btn.BorderSizePixel  = 0
    tabs[i] = btn
end

-- Scroll de items
local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size             = UDim2.new(1,-20,1,-110)
scroll.Position         = UDim2.new(0,10,0,100)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 5
scroll.CanvasSize       = UDim2.new(0,0,0,0)

local gridLayout = Instance.new("UIGridLayout", scroll)
gridLayout.CellSize    = UDim2.new(0,160,0,200)
gridLayout.CellPadding = UDim2.new(0,10,0,10)

local function makeItemCard(parent, item, itemType)
    local card = Instance.new("Frame", parent)
    card.BackgroundColor3 = Color3.fromRGB(20,20,40)
    card.BorderSizePixel  = 0

    local rarityColor = RARITY_COLORS[item.rarity] or Color3.fromRGB(180,180,180)

    -- Borde de rareza
    local stroke = Instance.new("UIStroke", card)
    stroke.Color     = rarityColor
    stroke.Thickness = 2

    -- Nombre
    local name = Instance.new("TextLabel", card)
    name.Size           = UDim2.new(1,0,0,30)
    name.Position       = UDim2.new(0,0,0,0)
    name.BackgroundTransparency = 1
    name.TextColor3     = Color3.fromRGB(255,255,255)
    name.Text           = item.name
    name.Font           = Enum.Font.GothamBold
    name.TextSize       = 13
    name.TextWrapped    = true

    -- Rareza
    local rarity = Instance.new("TextLabel", card)
    rarity.Size           = UDim2.new(1,0,0,20)
    rarity.Position       = UDim2.new(0,0,0,30)
    rarity.BackgroundTransparency = 1
    rarity.TextColor3     = rarityColor
    rarity.Text           = item.rarity
    rarity.Font           = Enum.Font.GothamBold
    rarity.TextSize       = 11

    -- Descripción
    local desc = Instance.new("TextLabel", card)
    desc.Size           = UDim2.new(1,-10,0,60)
    desc.Position       = UDim2.new(0,5,0,55)
    desc.BackgroundTransparency = 1
    desc.TextColor3     = Color3.fromRGB(180,180,200)
    desc.Text           = item.description or ""
    desc.Font           = Enum.Font.Gotham
    desc.TextSize       = 11
    desc.TextWrapped    = true

    -- Precio
    local price = Instance.new("TextLabel", card)
    price.Size           = UDim2.new(1,0,0,25)
    price.Position       = UDim2.new(0,0,0,125)
    price.BackgroundTransparency = 1
    price.TextColor3     = Color3.fromRGB(255,215,0)
    price.Text           = "🪙 " .. (item.price or 0)
    price.Font           = Enum.Font.GothamBold
    price.TextSize       = 14

    -- Botón
    local buyBtn = Instance.new("TextButton", card)
    buyBtn.Size           = UDim2.new(0.9,0,0,32)
    buyBtn.Position       = UDim2.new(0.05,0,0,158)
    buyBtn.BackgroundColor3 = Color3.fromRGB(30,130,60)
    buyBtn.Text           = "Comprar"
    buyBtn.TextColor3     = Color3.fromRGB(255,255,255)
    buyBtn.Font           = Enum.Font.GothamBold
    buyBtn.TextSize       = 13
    buyBtn.BorderSizePixel = 0

    buyBtn.MouseButton1Click:Connect(function()
        local result = PurchaseItem:InvokeServer(itemType, item.id)
        if result and result.success then
            buyBtn.BackgroundColor3 = Color3.fromRGB(20,200,80)
            buyBtn.Text = "✓ Comprado"
        else
            buyBtn.BackgroundColor3 = Color3.fromRGB(180,30,30)
            buyBtn.Text = result and result.message or "Error"
            task.delay(2, function()
                buyBtn.BackgroundColor3 = Color3.fromRGB(30,130,60)
                buyBtn.Text = "Comprar"
            end)
        end
    end)
end

local function populateTab(tabIndex)
    for _, c in ipairs(scroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    if tabIndex == 1 then
        for _, pet in ipairs(PetData) do makeItemCard(scroll, pet, "pet") end
    elseif tabIndex == 2 then
        for _, acc in ipairs(AccessoryData) do makeItemCard(scroll, acc, "accessory") end
    elseif tabIndex == 3 then
        for _, cloth in ipairs(ClothingData) do makeItemCard(scroll, cloth, "clothing") end
    elseif tabIndex == 4 then
        -- Gacha UI especial
        local gachaCard = Instance.new("Frame", scroll)
        gachaCard.Size           = UDim2.new(0,320,0,200)
        gachaCard.BackgroundColor3 = Color3.fromRGB(30,0,60)
        gachaCard.BorderSizePixel = 0
        local gachaTitle = Instance.new("TextLabel", gachaCard)
        gachaTitle.Size = UDim2.new(1,0,0,40)
        gachaTitle.BackgroundTransparency = 1
        gachaTitle.TextColor3 = Color3.fromRGB(255,100,255)
        gachaTitle.Text = "🎲 ¡Mascota Aleatoria!"
        gachaTitle.Font = Enum.Font.GothamBold
        gachaTitle.TextSize = 18
        local gachaDesc = Instance.new("TextLabel", gachaCard)
        gachaDesc.Size = UDim2.new(1,-10,0,80)
        gachaDesc.Position = UDim2.new(0,5,0,45)
        gachaDesc.BackgroundTransparency = 1
        gachaDesc.TextColor3 = Color3.fromRGB(200,200,220)
        gachaDesc.Text = "Probabilidades:\n⚪ Común 60% | 🟡 Legendario 25%\n🟣 Máximo 10% | 🔴 Ultra 4% | ✨ Dios 1%"
        gachaDesc.Font = Enum.Font.Gotham
        gachaDesc.TextSize = 12
        gachaDesc.TextWrapped = true
        local gachaBtn = Instance.new("TextButton", gachaCard)
        gachaBtn.Size = UDim2.new(0.8,0,0,40)
        gachaBtn.Position = UDim2.new(0.1,0,0,145)
        gachaBtn.BackgroundColor3 = Color3.fromRGB(120,0,200)
        gachaBtn.Text = "🎲 Abrir por 50 Robux"
        gachaBtn.TextColor3 = Color3.fromRGB(255,255,255)
        gachaBtn.Font = Enum.Font.GothamBold
        gachaBtn.TextSize = 14
        gachaBtn.BorderSizePixel = 0
        gachaBtn.MouseButton1Click:Connect(function()
            PromptProduct:FireServer(0)  -- reemplazar con ID real del producto
        end)
    end
    scroll.CanvasSize = UDim2.new(0,0,0,gridLayout.AbsoluteContentSize.Y+20)
end

for i, tab in ipairs(tabs) do
    tab.MouseButton1Click:Connect(function()
        for _, t in ipairs(tabs) do t.BackgroundColor3 = Color3.fromRGB(30,30,55) end
        tab.BackgroundColor3 = Color3.fromRGB(40,80,160)
        populateTab(i)
    end)
end

-- Botón flotante 👗
local openBtn = Instance.new("TextButton", wardGui)
openBtn.Size           = UDim2.new(0,50,0,50)
openBtn.Position       = UDim2.new(0,10,0.45,-25)
openBtn.BackgroundColor3 = Color3.fromRGB(100,60,180)
openBtn.Text           = "👗"
openBtn.Font           = Enum.Font.GothamBold
openBtn.TextSize       = 24
openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then populateTab(1) end
end)

-- Notificación de mascota ganada por gacha
PetRolled.OnClientEvent:Connect(function(pet)
    local notif = Instance.new("ScreenGui", playerGui)
    notif.Name = "PetNotif"
    local frame = Instance.new("Frame", notif)
    frame.Size = UDim2.new(0.4,0,0.2,0)
    frame.Position = UDim2.new(0.3,0,0.4,0)
    frame.BackgroundColor3 = Color3.fromRGB(20,0,40)
    frame.BorderSizePixel = 0
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    local rarityColor = RARITY_COLORS[pet.rarity] or Color3.fromRGB(255,255,255)
    label.TextColor3 = rarityColor
    label.Text = "🎉 ¡Obtuviste!\n" .. pet.name .. "\n[" .. pet.rarity .. "]"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 20
    label.TextWrapped = true
    game:GetService("Debris"):AddItem(notif, 4)
end)

print("[WardrobeUI] Tienda & Guardarropa cargada")
