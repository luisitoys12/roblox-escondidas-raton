-- GamepassUI.client.lua
-- Panel de compra de Gamepasses. Tecla G o botón 💎 para abrir.

local Players            = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService   = game:GetService("UserInputService")

local player    = Players.LocalPlayer
local playerGui = player.PlayerGui

-- Actualiza los IDs después de crear cada gamepass en create.roblox.com
local GAMEPASSES = {
    { id=0, name="🐭 Ratón VIP",        price="150 R$", desc="Sé el Ratón 1 de cada 3 rondas" },
    { id=0, name="⚡ Speed Boost",       price="100 R$", desc="+5 velocidad permanente" },
    { id=0, name="🎨 Skin Pack",         price="200 R$", desc="Skin exclusiva del personaje" },
    { id=0, name="🔍 Radar Permanente",  price="250 R$", desc="Herramienta Radar sin costo" },
    { id=0, name="💎 VIP Badge",         price="75 R$",  desc="Nombre dorado + x1.5 monedas" },
}

local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "GamepassUI" ; gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0,370,0,400)
mainFrame.Position = UDim2.new(0.5,-185,0.5,-200)
mainFrame.BackgroundColor3 = Color3.fromRGB(12,12,28)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,14)

local titleL = Instance.new("TextLabel", mainFrame)
titleL.Size = UDim2.new(1,0,0,48) ; titleL.BackgroundTransparency = 1
titleL.Text = "💎 Gamepasses" ; titleL.Font = Enum.Font.GothamBold
titleL.TextSize = 22 ; titleL.TextColor3 = Color3.fromRGB(255,215,0)

local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0,34,0,34)
closeBtn.Position = UDim2.new(1,-40,0,8)
closeBtn.BackgroundColor3 = Color3.fromRGB(150,30,30)
closeBtn.Text = "✕" ; closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold ; closeBtn.TextSize = 16
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size = UDim2.new(1,-16,1,-56) ; scroll.Position = UDim2.new(0,8,0,52)
scroll.BackgroundTransparency = 1 ; scroll.ScrollBarThickness = 4
scroll.CanvasSize = UDim2.new(0,0,0,#GAMEPASSES*76)
local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,8)

for _, gp in ipairs(GAMEPASSES) do
    local card = Instance.new("Frame", scroll)
    card.Size = UDim2.new(1,0,0,66)
    card.BackgroundColor3 = Color3.fromRGB(20,20,44)
    card.BorderSizePixel = 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,10)

    local nL = Instance.new("TextLabel", card)
    nL.Size = UDim2.new(0.62,0,0.5,0) ; nL.Position = UDim2.new(0,10,0,4)
    nL.BackgroundTransparency = 1 ; nL.Text = gp.name
    nL.Font = Enum.Font.GothamBold ; nL.TextSize = 14
    nL.TextColor3 = Color3.new(1,1,1) ; nL.TextXAlignment = Enum.TextXAlignment.Left

    local dL = Instance.new("TextLabel", card)
    dL.Size = UDim2.new(0.62,0,0.5,0) ; dL.Position = UDim2.new(0,10,0.5,0)
    dL.BackgroundTransparency = 1 ; dL.Text = gp.desc
    dL.Font = Enum.Font.Gotham ; dL.TextSize = 11
    dL.TextColor3 = Color3.fromRGB(150,150,190)
    dL.TextXAlignment = Enum.TextXAlignment.Left ; dL.TextWrapped = true

    local bBtn = Instance.new("TextButton", card)
    bBtn.Size = UDim2.new(0,96,0,38) ; bBtn.Position = UDim2.new(1,-104,0.5,-19)
    bBtn.BackgroundColor3 = Color3.fromRGB(40,160,80)
    bBtn.Text = gp.price ; bBtn.TextColor3 = Color3.new(1,1,1)
    bBtn.Font = Enum.Font.GothamBold ; bBtn.TextSize = 13
    Instance.new("UICorner", bBtn).CornerRadius = UDim.new(0,8)
    local gpId = gp.id
    bBtn.MouseButton1Click:Connect(function()
        if gpId ~= 0 then
            MarketplaceService:PromptGamePassPurchase(player, gpId)
        end
    end)
end

-- Botón flotante esquina inferior derecha
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0,50,0,50)
openBtn.Position = UDim2.new(1,-62,1,-70)
openBtn.BackgroundColor3 = Color3.fromRGB(255,215,0)
openBtn.Text = "💎" ; openBtn.Font = Enum.Font.GothamBold ; openBtn.TextSize = 24
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0,25)
openBtn.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

print("[GamepassUI] Listo — tecla G para abrir")
