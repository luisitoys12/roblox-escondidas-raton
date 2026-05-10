-- LeaderboardUI.client.lua
-- Tabla de líderes global. Abre con tecla L.
-- Muestra Top 10 por ELO, Monedas o Nivel.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")

local player    = Players.LocalPlayer
local playerGui = player.PlayerGui
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local RequestLeaderboard = GameEvents:WaitForChild("RequestLeaderboard")

local lbGui = Instance.new("ScreenGui", playerGui)
lbGui.Name = "LeaderboardUI"
lbGui.ResetOnSpawn = false

local frame = Instance.new("Frame", lbGui)
frame.Size             = UDim2.new(0.35, 0, 0.75, 0)
frame.Position         = UDim2.new(0.325, 0, 0.12, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 22)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel  = 0
frame.Visible          = false
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local titleL = Instance.new("TextLabel", frame)
titleL.Size           = UDim2.new(1, 0, 0, 45)
titleL.BackgroundTransparency = 1
titleL.TextColor3     = Color3.fromRGB(255,215,0)
titleL.Text           = "🏆 Tabla de Líderes"
titleL.Font           = Enum.Font.GothamBold
titleL.TextSize       = 20

local closeBtn2 = Instance.new("TextButton", frame)
closeBtn2.Size           = UDim2.new(0, 35, 0, 35)
closeBtn2.Position       = UDim2.new(1,-42,0,5)
closeBtn2.BackgroundColor3 = Color3.fromRGB(180,40,40)
closeBtn2.Text           = "✕"
closeBtn2.TextColor3     = Color3.fromRGB(255,255,255)
closeBtn2.Font           = Enum.Font.GothamBold
closeBtn2.TextSize       = 16
Instance.new("UICorner", closeBtn2).CornerRadius = UDim.new(0,8)
closeBtn2.MouseButton1Click:Connect(function() frame.Visible = false end)

-- Tabs de categoría
local CATS = { {"🎯 ELO","elo"}, {"🪙 Monedas","coins"}, {"⭐ Nivel","level"} }
local catHolder = Instance.new("Frame", frame)
catHolder.Size             = UDim2.new(1,0,0,36)
catHolder.Position         = UDim2.new(0,0,0,47)
catHolder.BackgroundTransparency = 1
local catBtns = {}

for i, cat in ipairs(CATS) do
    local b = Instance.new("TextButton", catHolder)
    b.Size           = UDim2.new(1/#CATS,0,1,0)
    b.Position       = UDim2.new((i-1)*(1/#CATS),0,0,0)
    b.BackgroundColor3 = i==1 and Color3.fromRGB(50,100,200) or Color3.fromRGB(25,25,50)
    b.Text           = cat[1]
    b.TextColor3     = Color3.fromRGB(255,255,255)
    b.Font           = Enum.Font.GothamBold
    b.TextSize       = 13
    catBtns[cat[2]] = b
end

-- Lista de resultados
local listFrame = Instance.new("ScrollingFrame", frame)
listFrame.Size             = UDim2.new(1,-20,1,-100)
listFrame.Position         = UDim2.new(0,10,0,88)
listFrame.BackgroundTransparency = 1
listFrame.ScrollBarThickness = 4
listFrame.CanvasSize       = UDim2.new(0,0,0,0)
local listLayout = Instance.new("UIListLayout", listFrame)
listLayout.Padding = UDim.new(0,4)

local function loadBoard(category)
    for _, child in ipairs(listFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    local data = RequestLeaderboard:InvokeServer(category)
    for rank, entry in ipairs(data or {}) do
        local row = Instance.new("Frame", listFrame)
        row.Size           = UDim2.new(1,0,0,36)
        row.BackgroundColor3 = rank <= 3
            and Color3.fromRGB(40,35,10)
            or  Color3.fromRGB(20,20,40)
        row.BorderSizePixel = 0
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)

        local medal = rank==1 and "🥇" or rank==2 and "🥈" or rank==3 and "🥉" or tostring(rank).."."
        local lbl = Instance.new("TextLabel", row)
        lbl.Size           = UDim2.new(1,-10,1,0)
        lbl.Position       = UDim2.new(0,8,0,0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3     = Color3.fromRGB(220,220,220)
        lbl.Text           = medal .. "  ID:" .. entry.userId .. "  —  " .. entry.value
        lbl.Font           = Enum.Font.GothamBold
        lbl.TextSize       = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
    end
    listFrame.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y+10)
end

for _, cat in ipairs(CATS) do
    catBtns[cat[2]].MouseButton1Click:Connect(function()
        for _, c in ipairs(CATS) do
            catBtns[c[2]].BackgroundColor3 = c[2]==cat[2]
                and Color3.fromRGB(50,100,200)
                or  Color3.fromRGB(25,25,50)
        end
        loadBoard(cat[2])
    end)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.L then
        frame.Visible = not frame.Visible
        if frame.Visible then loadBoard("elo") end
    end
end)

-- Botón flotante
local lbBtn = Instance.new("TextButton", lbGui)
lbBtn.Size           = UDim2.new(0,50,0,50)
lbBtn.Position       = UDim2.new(0,10,0.66,-25)
lbBtn.BackgroundColor3 = Color3.fromRGB(180,140,0)
lbBtn.Text           = "🏆"
lbBtn.Font           = Enum.Font.GothamBold
lbBtn.TextSize       = 24
Instance.new("UICorner", lbBtn).CornerRadius = UDim.new(0,12)
lbBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    if frame.Visible then loadBoard("elo") end
end)

print("[LeaderboardUI] Tabla de líderes cargada")
