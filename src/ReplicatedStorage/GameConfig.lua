-- GameConfig.lua
-- Configuración central del juego. Modifica estos valores para balancear.

local Config = {}

-- ══ Tiempos (segundos) ══
Config.LobbyTime       = 30    -- Tiempo de espera en lobby
Config.HideTime        = 15    -- Tiempo que tienen los escondidos para ocultarse
Config.RoundTime       = 120   -- Duración de la ronda de juego
Config.ResultsTime     = 10    -- Pantalla de resultados

-- ══ Jugadores ══
Config.MinPlayers      = 2     -- Mínimo para iniciar partida
Config.MaxPlayers      = 12    -- Máximo por servidor

-- ══ Economía ══
Config.CoinsPerCapture = 10    -- Monedas que gana el Ratón por capturar
Config.CoinsPerSurvive = 20    -- Monedas que gana el Escondido al sobrevivir
Config.CoinsPerRound   = 5     -- Monedas base por participar en una ronda

-- ══ Rangos ELO ══
Config.EloGainWin      = 25    -- Puntos ELO ganados al ganar
Config.EloLoseLose     = 15    -- Puntos ELO perdidos al perder
Config.StartingElo     = 1000  -- ELO inicial de nuevo jugador

Config.Ranks = {
    { name = "Ratoncillo",  minElo = 0    },
    { name = "Ratón",       minElo = 1000 },
    { name = "Rata Ágil",   minElo = 1200 },
    { name = "Cazador",     minElo = 1500 },
    { name = "Depredador",  minElo = 1800 },
    { name = "Leyenda",     minElo = 2100 },
}

-- ══ Velocidades ══
Config.MouseSpeed      = 20    -- Velocidad del Ratón
Config.HiderSpeed      = 16    -- Velocidad del Escondido
Config.DefaultSpeed    = 16    -- Velocidad base

-- ══ Roles ══
Config.MouseTag        = "Mouse"   -- Tag del rol Ratón
Config.HiderTag        = "Hider"   -- Tag del rol Escondido
Config.CaughtTag       = "Caught"  -- Tag de capturado

-- ══ Efectos ══
Config.MouseColor      = Color3.fromRGB(220, 50, 50)   -- Color del nombre del Ratón
Config.HiderColor      = Color3.fromRGB(50, 180, 255)  -- Color del nombre del Escondido
Config.CaughtColor     = Color3.fromRGB(150, 150, 150) -- Color del nombre de capturado

return Config
