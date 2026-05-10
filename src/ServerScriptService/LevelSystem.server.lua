-- LevelSystem.server.lua
-- Sistema de niveles basado en XP. Ganar rondas da XP.
-- Cada nivel desbloquea mapas, cosméticos y beneficios.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameEvents        = ReplicatedStorage:WaitForChild("GameEvents")

local UpdateLevel = Instance.new("RemoteEvent", GameEvents)
UpdateLevel.Name  = "UpdateLevel"

local xpData = {}  -- [userId] = { xp=0, level=1 }

local XP_TABLE = {}
for i = 1, 100 do
    XP_TABLE[i] = math.floor(100 * (i ^ 1.5))  -- curva de nivel exponencial
end

local function getXPForLevel(level)
    return XP_TABLE[math.min(level, 100)] or 99999
end

local function getData(player)
    if not xpData[player.UserId] then
        xpData[player.UserId] = { xp = 0, level = 1 }
    end
    return xpData[player.UserId]
end

local function addXP(player, amount)
    local data = getData(player)
    data.xp = data.xp + amount
    local leveledUp = false
    -- Verificar subida de nivel
    while data.xp >= getXPForLevel(data.level) do
        data.xp = data.xp - getXPForLevel(data.level)
        data.level = data.level + 1
        leveledUp = true
        print("[LevelSystem] " .. player.Name .. " subió al nivel " .. data.level .. "!")
    end
    player:SetAttribute("Level", data.level)
    player:SetAttribute("XP",    data.xp)
    player:SetAttribute("XPNeeded", getXPForLevel(data.level))
    UpdateLevel:FireClient(player, data.level, data.xp, getXPForLevel(data.level), leveledUp)
    return leveledUp
end

-- XP ganada al final de ronda
local XP_REWARDS = {
    mouseWin   = 50,
    mouseLose  = 20,
    hiderWin   = 40,  -- sobrevivir
    hiderLose  = 15,  -- ser capturado
    participate = 10, -- solo por jugar
}

local function processRoundXP(mousePlayer, survivors, caught)
    -- XP al Ratón
    local mouseWon = #survivors == 0
    addXP(mousePlayer, mouseWon and XP_REWARDS.mouseWin or XP_REWARDS.mouseLose)
    -- XP a sobrevivientes
    for _, p in ipairs(survivors) do
        addXP(p, XP_REWARDS.hiderWin)
    end
    -- XP a capturados
    for _, p in ipairs(caught) do
        addXP(p, XP_REWARDS.hiderLose)
    end
end

Players.PlayerAdded:Connect(function(player)
    xpData[player.UserId] = { xp = 0, level = 1 }
    player:SetAttribute("Level", 1)
    player:SetAttribute("XP", 0)
    player:SetAttribute("XPNeeded", getXPForLevel(1))
    -- TODO: cargar desde DataStore
end)

Players.PlayerRemoving:Connect(function(player)
    -- TODO: guardar en DataStore
    xpData[player.UserId] = nil
end)

_G.AddXP           = addXP
_G.ProcessRoundXP  = processRoundXP
_G.GetLevel        = function(player) return getData(player).level end

print("[LevelSystem] Sistema de niveles iniciado")
