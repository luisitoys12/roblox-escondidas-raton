-- MapData.lua
-- Mapas disponibles para jugar. Cada mapa tiene un nombre, descripción,
-- thumbnail y el nombre del Model en Workspace que se activa al seleccionarlo.

local MapData = {
    {
        id          = "alley_night",
        name        = "Callejón Nocturno",
        description = "Un oscuro callejón de ciudad con niebla y lámparas naranjas. ¡Perfecta para esconderse!",
        thumbnail   = "rbxassetid://0",
        modelName   = "Map_AlleyNight",
        minPlayers  = 2,
        maxPlayers  = 12,
        theme       = "Horror",
        unlockLevel = 0,  -- disponible desde el inicio
    },
    {
        id          = "forest_dark",
        name        = "Bosque Oscuro",
        description = "Un bosque denso de noche. Los árboles son perfectos para esconderse.",
        thumbnail   = "rbxassetid://0",
        modelName   = "Map_ForestDark",
        minPlayers  = 2,
        maxPlayers  = 16,
        theme       = "Nature",
        unlockLevel = 5,
    },
    {
        id          = "school",
        name        = "Escuela Abandonada",
        description = "Salones, casilleros y pasillos llenos de escondites.",
        thumbnail   = "rbxassetid://0",
        modelName   = "Map_School",
        minPlayers  = 4,
        maxPlayers  = 20,
        theme       = "Urban",
        unlockLevel = 10,
    },
    {
        id          = "sewer",
        name        = "Las Alcantarillas",
        description = "Laberinto húmedo y oscuro bajo la ciudad. El hogar natural del Ratón.",
        thumbnail   = "rbxassetid://0",
        modelName   = "Map_Sewer",
        minPlayers  = 4,
        maxPlayers  = 16,
        theme       = "Horror",
        unlockLevel = 15,
    },
    {
        id          = "space_station",
        name        = "Estación Espacial",
        description = "Gravedad cero, pasillos metálicos y oscuridad total. ¿Dónde estás?",
        thumbnail   = "rbxassetid://0",
        modelName   = "Map_SpaceStation",
        minPlayers  = 6,
        maxPlayers  = 20,
        theme       = "SciFi",
        unlockLevel = 25,
    },
    {
        id          = "candy_world",
        name        = "Mundo de Dulces",
        description = "¡Colorido y enorme! Perfecto para partidas caóticas con muchos jugadores.",
        thumbnail   = "rbxassetid://0",
        modelName   = "Map_CandyWorld",
        minPlayers  = 6,
        maxPlayers  = 24,
        theme       = "Fun",
        unlockLevel = 20,
    },
}

return MapData
