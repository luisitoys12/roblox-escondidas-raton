-- RoundSystem.server.lua
-- Detecta cuando el Ratón toca a un Escondido y procesa la captura.
-- También aplica velocidades según el rol asignado.

local Players        = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config         = require(ReplicatedStorage:WaitForChild("GameConfig"))

local CoinSystem     -- referencia (se carga con _G)
local RankSystem

-- Esperar a que GameManager registre sus funciones globales
task.wait(2)

-- Aplicar velocidad según rol
local function applyRoleSpeed(player)
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end

    local role = player:GetAttribute("Role")
    if role == Config.MouseTag then
        hum.WalkSpeed = Config.MouseSpeed
    elseif role == Config.HiderTag then
        hum.WalkSpeed = Config.HiderSpeed
    else
        hum.WalkSpeed = Config.DefaultSpeed
    end
end

-- Cuando un personaje carga, aplicar su velocidad
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        applyRoleSpeed(player)
    end)
end)

-- También aplicar a los ya conectados
for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        applyRoleSpeed(player)
    end
end

-- Detectar colisión Ratón → Escondido
local function setupMouseTouch(mousePlayer)
    if not mousePlayer or not mousePlayer.Character then return end

    local mouseChar = mousePlayer.Character
    for _, part in ipairs(mouseChar:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Touched:Connect(function(otherPart)
                local otherChar = otherPart.Parent
                local otherPlayer = Players:GetPlayerFromCharacter(otherChar)

                if otherPlayer and otherPlayer ~= mousePlayer then
                    local role = otherPlayer:GetAttribute("Role")
                    if role == Config.HiderTag then
                        -- Capturar al escondido
                        if _G.CaptureHider then
                            _G.CaptureHider(otherPlayer)
                        end

                        -- Dar monedas al Ratón
                        if _G.AddCoins then
                            _G.AddCoins(mousePlayer, Config.CoinsPerCapture)
                        end

                        -- Detener al escondido capturado (efecto visual)
                        local hum = otherChar:FindFirstChild("Humanoid")
                        if hum then
                            hum.WalkSpeed = 0
                            hum.JumpHeight = 0
                        end

                        -- Cambiar apariencia visual del capturado
                        for _, p in ipairs(otherChar:GetDescendants()) do
                            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                                p.BrickColor = BrickColor.new("Medium stone grey")
                                p.Transparency = 0.4
                            end
                        end

                        print("[RoundSystem] Captura: " .. otherPlayer.Name)
                    end
                end
            end)
        end
    end
end

-- Observar cambios de rol para configurar la detección de toque del Ratón
Players.PlayerAdded:Connect(function(player)
    player:GetAttributeChangedSignal("Role"):Connect(function()
        if player:GetAttribute("Role") == Config.MouseTag then
            player.CharacterAdded:Connect(function()
                task.wait(0.5)
                setupMouseTouch(player)
            end)
            if player.Character then
                setupMouseTouch(player)
            end
        end
        applyRoleSpeed(player)
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    player:GetAttributeChangedSignal("Role"):Connect(function()
        if player:GetAttribute("Role") == Config.MouseTag then
            if player.Character then setupMouseTouch(player) end
        end
        applyRoleSpeed(player)
    end)
end

print("[RoundSystem] Sistema de rondas iniciado")
