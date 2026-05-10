-- GachaUI.client.lua
-- Botones de caja gacha + pantalla animada de resultado.

local Players            = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local playerGui = player.PlayerGui

-- Actualiza estos IDs cuando crees los Developer Products
local GACHA_COMMON_ID  = 0
local GACHA_PREMIUM_ID = 0

local GameEvents  = ReplicatedStorage:WaitForChild("GameEvents")
local GachaResult = GameEvents:WaitForChild("GachaResult")

local RARITY_COLORS = {
    ["Común"]      = Color3.fromRGB(180,180,180),
    ["Legendario"] = Color3.fromRGB(255,200,0),
    ["Máximo"]     = Color3.fromRGB(160,0,220),
    ["Ultra"]      = Color3.fromRGB(220,30,30),
    ["Dios"]       = Color3.fromRGB(255,100,255),
}

-- GUI
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "GachaUI" ; gui.ResetOnSpawn = false

-- Botones flotantes
local btnFrame = Instance.new("Frame", gui)
btnFrame.Size = UDim2.new(0,130,0,110)
btnFrame.Position = UDim2.new(1,-140,0.5,-55)
btnFrame.BackgroundTransparency = 1

local function makeBtn(text, color, posY)
    local b = Instance.new("TextButton", btnFrame)
    b.Size = UDim2.new(1,0,0,48)
    b.Position = UDim2.new(0,0,0,posY)
    b.BackgroundColor3 = color
    b.Text = text ; b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold ; b.TextSize = 13
    b.TextWrapped = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

local btnCommon  = makeBtn("🎲 Caja Común\n30 Robux",  Color3.fromRGB(60,60,90),  0)
local btnPremium = makeBtn("✨ Caja Premium\n80 Robux", Color3.fromRGB(100,30,140), 58)

-- Panel de resultado
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0,360,0,280)
panel.Position = UDim2.new(0.5,-180,0.5,-140)
panel.BackgroundColor3 = Color3.fromRGB(10,10,25)
panel.BorderSizePixel = 0
panel.Visible = false
Instance.new("UICorner", panel).CornerRadius = UDim.new(0,16)

local banner = Instance.new("Frame", panel)
banner.Size = UDim2.new(1,0,0,55)
banner.BackgroundColor3 = Color3.fromRGB(255,200,0)
banner.BorderSizePixel = 0
Instance.new("UICorner", banner).CornerRadius = UDim.new(0,16)

local rarityLbl = Instance.new("TextLabel", banner)
rarityLbl.Size = UDim2.new(1,0,1,0)
rarityLbl.BackgroundTransparency = 1
rarityLbl.Font = Enum.Font.GothamBold
rarityLbl.TextSize = 22
rarityLbl.TextColor3 = Color3.fromRGB(20,20,20)

local nameLbl = Instance.new("TextLabel", panel)
nameLbl.Size = UDim2.new(1,-20,0,44)
nameLbl.Position = UDim2.new(0,10,0,62)
nameLbl.BackgroundTransparency = 1
nameLbl.Font = Enum.Font.GothamBold
nameLbl.TextSize = 26
nameLbl.TextColor3 = Color3.new(1,1,1)
nameLbl.TextXAlignment = Enum.TextXAlignment.Center

local bonusLbl = Instance.new("TextLabel", panel)
bonusLbl.Size = UDim2.new(1,-20,0,36)
bonusLbl.Position = UDim2.new(0,10,0,112)
bonusLbl.BackgroundTransparency = 1
bonusLbl.Font = Enum.Font.Gotham
bonusLbl.TextSize = 16
bonusLbl.TextColor3 = Color3.fromRGB(180,255,160)
bonusLbl.TextXAlignment = Enum.TextXAlignment.Center

local okBtn = Instance.new("TextButton", panel)
okBtn.Size = UDim2.new(0.6,0,0,44)
okBtn.Position = UDim2.new(0.2,0,1,-56)
okBtn.BackgroundColor3 = Color3.fromRGB(40,160,80)
okBtn.Text = "¡Genial!"
okBtn.TextColor3 = Color3.new(1,1,1)
okBtn.Font = Enum.Font.GothamBold
okBtn.TextSize = 18
Instance.new("UICorner", okBtn).CornerRadius = UDim.new(0,8)
okBtn.MouseButton1Click:Connect(function() panel.Visible = false end)

-- Lógica botones
btnCommon.MouseButton1Click:Connect(function()
    if GACHA_COMMON_ID ~= 0 then
        MarketplaceService:PromptProductPurchase(player, GACHA_COMMON_ID)
    end
end)
btnPremium.MouseButton1Click:Connect(function()
    if GACHA_PREMIUM_ID ~= 0 then
        MarketplaceService:PromptProductPurchase(player, GACHA_PREMIUM_ID)
    end
end)

-- Mostrar resultado
GachaResult.OnClientEvent:Connect(function(pet)
    local color = RARITY_COLORS[pet.rarity] or Color3.fromRGB(200,200,200)
    banner.BackgroundColor3 = color
    rarityLbl.Text = string.upper(pet.rarity)
    nameLbl.Text   = pet.name
    local b = "Bonus: "
    if     pet.bonus.type == "coinMultiplier" then b = b.."x"..pet.bonus.value.." Monedas 🪙"
    elseif pet.bonus.type == "speed"          then b = b.."+"..pet.bonus.value.." Velocidad ⚡"
    elseif pet.bonus.type == "stealth"        then b = b.."Invisibilidad "..math.floor((1-pet.bonus.value)*100).."% 👻"
    elseif pet.bonus.type == "allBonus"       then b = b.."TODO x"..pet.bonus.value.." 🌟"
    elseif pet.bonus.type == "godMode"        then b = b.."¡MODO DIOS! 💫" end
    bonusLbl.Text = b
    panel.Visible = true
    panel:TweenPosition(UDim2.new(0.5,-180,0.5,-140),
        Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)
end)

print("[GachaUI] Listo")
