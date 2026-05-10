-- GameConfig.lua v2.0 — Configuración central expandida
local Config = {}

-- ══ Tiempos ══
Config.LobbyTime        = 30
Config.HideTime         = 15
Config.RoundTime        = 120
Config.ResultsTime      = 10
Config.IntermissionTime = 20

-- ══ Jugadores ══
Config.MinPlayers       = 2
Config.MaxPlayers       = 12

-- ══ Economía ══
Config.CoinsPerCapture  = 10
Config.CoinsPerSurvive  = 20
Config.CoinsPerRound    = 5
Config.DailyLoginBonus  = 100

-- ══ ELO ══
Config.EloGainWin       = 25
Config.EloLoseLose      = 15
Config.StartingElo      = 1000

Config.Ranks = {
    { name="Ratoncillo",  minElo=0,    icon="⚪" },
    { name="Ratón",       minElo=1000, icon="🐭" },
    { name="Rata Ágil",   minElo=1200, icon="⚡" },
    { name="Cazador",     minElo=1500, icon="🔍" },
    { name="Depredador",  minElo=1800, icon="🔥" },
    { name="Leyenda",     minElo=2100, icon="👑" },
    { name="Dios",        minElo=2500, icon="✨" },
}

-- ══ Velocidades ══
Config.MouseSpeed       = 20
Config.HiderSpeed       = 16
Config.DefaultSpeed     = 16
Config.CrouchSpeed      = 8
Config.SprintMultiplier = 1.4

-- ══ Roles ══
Config.MouseTag         = "Mouse"
Config.HiderTag         = "Hider"
Config.CaughtTag        = "Caught"
Config.SpectatorTag     = "Spectator"

-- ══ Colores de rol ══
Config.MouseColor       = Color3.fromRGB(220,50,50)
Config.HiderColor       = Color3.fromRGB(50,180,255)
Config.CaughtColor      = Color3.fromRGB(150,150,150)

-- ══ Mapas disponibles ══
Config.Maps = {
    { id="city_night",   name="Ciudad Nocturna", minPlayers=2,  icon="🌆" },
    { id="sewer",        name="Las Alcantarillas", minPlayers=3, icon="🐀" },
    { id="haunted",      name="Casa Embrujada",  minPlayers=2,  icon="👻" },
    { id="rooftops",     name="Azoteas",         minPlayers=4,  icon="🏙️" },
    { id="forest",       name="Bosque Oscuro",   minPlayers=2,  icon="🌲" },
    { id="lab",          name="Laboratorio",     minPlayers=3,  icon="🔬" },
}

-- ══ Rarezas ══
Config.Rarities = {
    { name="Común",      color=Color3.fromRGB(180,180,180), chance=60 },
    { name="Legendario", color=Color3.fromRGB(255,200,0),   chance=25 },
    { name="Máximo",     color=Color3.fromRGB(160,0,220),   chance=10 },
    { name="Ultra",      color=Color3.fromRGB(220,30,30),   chance=4  },
    { name="Dios",       color=Color3.fromRGB(255,100,255), chance=1  },
}

-- ══ Gamepass IDs (reemplazar con IDs reales) ══
Config.Gamepasses = {
    VIP           = 0,
    SpeedBoost    = 0,
    SkinPack      = 0,
    RadarPerm     = 0,
    DoubleCoins   = 0,
    MouseAlways   = 0,
    ExtraSlots    = 0,
}

-- ══ Developer Product IDs ══
Config.Products = {
    Coins500      = 0,
    Coins1500     = 0,
    Coins5000     = 0,
    RandomPet     = 0,
    RandomAccess  = 0,
    Shield        = 0,
}

return Config
