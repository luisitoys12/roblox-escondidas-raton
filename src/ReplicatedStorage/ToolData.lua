-- ToolData.lua
-- Herramientas disponibles para Ratón y Escondidos.
-- Se pueden comprar con monedas antes de la partida.

local ToolData = {
    -- ══ Herramientas del RATÓN ══
    {
        id          = "lantern",
        name        = "Linterna",
        role        = "Mouse",
        price       = 50,
        cooldown    = 0,
        icon        = "rbxassetid://0",
        description = "Ilumina áreas oscuras para encontrar escondidos.",
        effect      = "light",  -- emite PointLight al activarse
    },
    {
        id          = "trap",
        name        = "Trampa",
        role        = "Mouse",
        price       = 150,
        cooldown    = 30,
        icon        = "rbxassetid://0",
        description = "Coloca una trampa en el suelo. Si un escondido la pisa, queda inmovilizado 3 seg.",
        effect      = "placeTrap",
    },
    {
        id          = "radar",
        name        = "Radar",
        role        = "Mouse",
        price       = 200,
        cooldown    = 45,
        icon        = "rbxassetid://0",
        description = "Muestra en el mapa la posición aproximada de todos los escondidos por 5 segundos.",
        effect      = "radar",
    },

    -- ══ Herramientas del ESCONDIDO ══
    {
        id          = "decoy",
        name        = "Señuelo",
        role        = "Hider",
        price       = 100,
        cooldown    = 25,
        icon        = "rbxassetid://0",
        description = "Lanza un señuelo que distrae al Ratón por 5 segundos.",
        effect      = "spawnDecoy",
    },
    {
        id          = "smoke",
        name        = "Bomba de Humo",
        role        = "Hider",
        price       = 120,
        cooldown    = 30,
        icon        = "rbxassetid://0",
        description = "Crea una nube de humo que bloquea la visión del Ratón por 4 segundos.",
        effect      = "smokeCloud",
    },
    {
        id          = "dash",
        name        = "Dash",
        role        = "Hider",
        price       = 80,
        cooldown    = 15,
        icon        = "rbxassetid://0",
        description = "Impulso rápido hacia adelante. Útil para escapar del Ratón.",
        effect      = "dash",
    },
}

return ToolData
