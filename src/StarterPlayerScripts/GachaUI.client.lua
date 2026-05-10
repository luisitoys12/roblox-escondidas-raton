-- GachaUI.client.lua
-- Pantalla de resultado al obtener mascota por gacha.
-- Muestra animación con rareza y nombre de la mascota obtenida.

local Players         = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService    = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

local player          = Players.LocalPlayer
local playerGui       = player.PlayerGui

local GameEvents      = ReplicatedStorage:WaitForChild("GameEvents")

-- Colores por rareza
local RARITY_COLORS = {
    ["Común"]      = Color3.fromRGB(180, 180, 180),
    ["Legendario"] = Color3.fromRGB(255, 200, 0),
    ["Máximo"]     = Color3.fromRGB(160, 0, 220),
    ["Ultra"]      = Color3.fromRGB(220, 30, 30),
    ["Dios"]       = Color3.fromRGB(255, 100, 255),
}

-- Crear GUI
local gachaGui = Instance.new("ScreenGui", playerGui)
gachaGui.Name = "GachaUI"
gachaGui.ResetOnSpawn = false
gachaGui.DisplayOrder = 99  -- Encima de todo

local overlay = Instance.new("Frame", gachaGui)
overlay.Size             = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.3
overlay.Visible          = false

local card = Instance.new("Frame", overlay)
card.Size             = UDim2.new(0, 320, 0, 380)
card.Position         = UDim2.new(0.5, -160, 0.5, -190)
card.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
card.BorderSizePixel  = 0
card.AnchorPoint      = Vector2.new(0.5, 0.5)

local rarityBorder = Instance.new("UIStroke", card)
rarityBorder.Thickness = 3
rarityBorder.Color     = Color3.fromRGB(255, 255, 255)

local rarityLabel = Instance.new("TextLabel", card)
rarityLabel.Size           = UDim2.new(1, 0, 0, 50)
rarityLabel.BackgroundTransparency = 1
rarityLabel.TextColor3     = Color3.fromRGB(255, 255, 255)
rarityLabel.Text           = "LEGENDARIO"
rarityLabel.Font           = Enum.Font.GothamBold
rarityLabel.TextSize       = 22
rarityLabel.TextXAlignment = Enum.TextXAlignment.Center

local petIcon = Instance.new("ImageLabel", card)
petIcon.Size            = UDim2.new(0, 160, 0, 160)
petIcon.Position        = UDim2.new(0.5, -80, 0, 60)
petIcon.BackgroundTransparency = 1
petIcon.Image           = "rbxassetid://0"

local petName = Instance.new("TextLabel", card)
petName.Size           = UDim2.new(1, -20, 0, 40)
petName.Position       = UDim2.new(0, 10, 0, 230)
petName.BackgroundTransparency = 1
petName.TextColor3     = Color3.fromRGB(255, 255, 255)
petName.Text           = "Nombre"
petName.Font           = Enum.Font.GothamBold
petName.TextSize       = 20
petName.TextXAlignment = Enum.TextXAlignment.Center

local petDesc = Instance.new("TextLabel", card)
petDesc.Size           = UDim2.new(1, -20, 0, 50)
petDesc.Position       = UDim2.new(0, 10, 0, 275)
petDesc.BackgroundTransparency = 1
petDesc.TextColor3     = Color3.fromRGB(180, 180, 200)
petDesc.Text           = ""
petDesc.Font           = Enum.Font.Gotham
petDesc.TextSize       = 13
petDesc.TextXAlignment = Enum.TextXAlignment.Center
petDesc.TextWrapped    = true

local closeBtn = Instance.new("TextButton", card)
closeBtn.Size           = UDim2.new(0.6, 0, 0, 40)
closeBtn.Position       = UDim2.new(0.2, 0, 1, -50)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 80)
closeBtn.Text           = "¡Genial!"
closeBtn.TextColor3     = Color3.fromRGB(255, 255, 255)
closeBtn.Font           = Enum.Font.GothamBold
closeBtn.TextSize       = 16
closeBtn.MouseButton1Click:Connect(function()
    overlay.Visible = false
end)

-- Escuchar evento de mascota obtenida
local function waitForEvent()
    local evt = GameEvents:WaitForChild("PetObtained", 30)
    if not evt then return end

    evt.OnClientEvent:Connect(function(pet, rarity)
        local rarityColor = RARITY_COLORS[rarity] or Color3.fromRGB(255,255,255)

        rarityLabel.Text       = rarity:upper()
        rarityLabel.TextColor3 = rarityColor
        rarityBorder.Color     = rarityColor
        petIcon.Image          = pet.icon or "rbxassetid://0"
        petName.Text           = pet.name
        petDesc.Text           = pet.description

        overlay.Visible   = true
        card.Size         = UDim2.new(0, 0, 0, 0)
        card.Position     = UDim2.new(0.5, 0, 0.5, 0)

        -- Animación de entrada
        TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size     = UDim2.new(0, 320, 0, 380),
            Position = UDim2.new(0.5, -160, 0.5, -190),
        }):Play()
    end)
end

task.spawn(waitForEvent)
print("[GachaUI] Sistema gacha UI cargado")
