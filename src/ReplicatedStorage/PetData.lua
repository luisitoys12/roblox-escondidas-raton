-- PetData.lua
-- 15 mascotas organizadas en 5 rarezas: Común, Legendario, Máximo, Ultra, Dios
-- Sistema de gacha con probabilidades por rareza

local RARITY = {
    ["Común"]      = { color = Color3.fromRGB(180, 180, 180), chance = 60 },
    ["Legendario"] = { color = Color3.fromRGB(255, 200, 0),   chance = 25 },
    ["Máximo"]     = { color = Color3.fromRGB(160, 0, 220),   chance = 10 },
    ["Ultra"]      = { color = Color3.fromRGB(220, 30, 30),   chance = 4  },
    ["Dios"]       = { color = Color3.fromRGB(255, 100, 255), chance = 1  },
}

local PetData = {
    -- ══ COMÚN (60%) ══
    {
        id          = "mini_mouse",
        name        = "Mini Ratón",
        rarity      = "Común",
        price       = 100,
        icon        = "rbxassetid://0",
        bonus       = { type = "speed", value = 1 },
        description = "Un ratoncito tierno que te da algo de velocidad.",
    },
    {
        id          = "pollito",
        name        = "Pollito",
        rarity      = "Común",
        price       = 80,
        icon        = "rbxassetid://0",
        bonus       = { type = "coinMultiplier", value = 1.1 },
        description = "¡Pío pío! Te da un pequeño bonus de monedas.",
    },
    {
        id          = "tortuguita",
        name        = "Tortuguita",
        rarity      = "Común",
        price       = 90,
        icon        = "rbxassetid://0",
        bonus       = { type = "stealth", value = 0.9 },
        description = "Lenta pero sigilosa. Reduce un poco tu visibilidad.",
    },

    -- ══ LEGENDARIO (25%) ══
    {
        id          = "buho_dorado",
        name        = "Búho Dorado",
        rarity      = "Legendario",
        price       = 500,
        icon        = "rbxassetid://0",
        bonus       = { type = "coinMultiplier", value = 1.5 },
        description = "Ojos de oro que ven en la oscuridad. x1.5 monedas.",
    },
    {
        id          = "lobo_plateado",
        name        = "Lobo Plateado",
        rarity      = "Legendario",
        price       = 550,
        icon        = "rbxassetid://0",
        bonus       = { type = "speed", value = 2 },
        description = "Ágil como el viento del norte. +2 velocidad.",
    },
    {
        id          = "zorro_sombra",
        name        = "Zorro Sombra",
        rarity      = "Legendario",
        price       = 600,
        icon        = "rbxassetid://0",
        bonus       = { type = "stealth", value = 0.7 },
        description = "Se mueve entre sombras. -30% visibilidad en radar.",
    },

    -- ══ MÁXIMO (10%) ══
    {
        id          = "dragon_bebe",
        name        = "Dragón Bebé",
        rarity      = "Máximo",
        price       = 1200,
        icon        = "rbxassetid://0",
        bonus       = { type = "speed", value = 3 },
        description = "Un dragoncito con escamas de fuego. +3 velocidad.",
    },
    {
        id          = "fenix_carmesi",
        name        = "Fénix Carmesí",
        rarity      = "Máximo",
        price       = 1400,
        icon        = "rbxassetid://0",
        bonus       = { type = "coinMultiplier", value = 1.8 },
        description = "Renace de las llamas. x1.8 monedas ganadas.",
    },
    {
        id          = "tiburon_fantasma",
        name        = "Tiburón Fantasma",
        rarity      = "Máximo",
        price       = 1300,
        icon        = "rbxassetid://0",
        bonus       = { type = "stealth", value = 0.5 },
        description = "Translúcido e invisible al radar. -50% visibilidad.",
    },

    -- ══ ULTRA (4%) ══
    {
        id          = "leon_cosmico",
        name        = "León Cósmico",
        rarity      = "Ultra",
        price       = 3000,
        icon        = "rbxassetid://0",
        bonus       = { type = "coinMultiplier", value = 2.0 },
        description = "Melena de galaxia. Duplica todas tus monedas ganadas.",
    },
    {
        id          = "serpiente_rayo",
        name        = "Serpiente Rayo",
        rarity      = "Ultra",
        price       = 3200,
        icon        = "rbxassetid://0",
        bonus       = { type = "speed", value = 5 },
        description = "Rápida como un relámpago. +5 velocidad.",
    },
    {
        id          = "oso_mecanico",
        name        = "Oso Mecánico",
        rarity      = "Ultra",
        price       = 2800,
        icon        = "rbxassetid://0",
        bonus       = { type = "shield", value = 1 },
        description = "Blindaje de cromo. Absorbe 1 captura por ronda.",
    },

    -- ══ DIOS (1%) ══
    {
        id          = "unicornio_divino",
        name        = "Unicornio Divino",
        rarity      = "Dios",
        price       = 8000,
        icon        = "rbxassetid://0",
        bonus       = { type = "coinMultiplier", value = 3.0 },
        description = "Arcoíris y pureza. x3 a todas las monedas. Extremadamente raro.",
    },
    {
        id          = "dragon_celestial",
        name        = "Dragón Celestial",
        rarity      = "Dios",
        price       = 9000,
        icon        = "rbxassetid://0",
        bonus       = { type = "speed", value = 8 },
        description = "Nacido de la luz divina. +8 velocidad. El más veloz del juego.",
    },
    {
        id          = "gato_vacio",
        name        = "Gato del Vacío",
        rarity      = "Dios",
        price       = 10000,
        icon        = "rbxassetid://0",
        bonus       = { type = "invisible", value = 1 },
        description = "Existe fuera del tiempo. Invisible al Ratón por 5 seg/ronda.",
    },
}

-- Tabla de rareza exportada para uso en gacha y UI
PetData.RARITY = RARITY

-- Función auxiliar: obtener datos de mascota por id
function PetData.GetById(id)
    for _, pet in ipairs(PetData) do
        if type(pet) == "table" and pet.id == id then
            return pet
        end
    end
    return nil
end

-- Función auxiliar: obtener mascota aleatoria con probabilidades de rareza
function PetData.GetRandom()
    local roll = math.random(100)
    local rarity
    if roll <= 60 then
        rarity = "Común"
    elseif roll <= 85 then
        rarity = "Legendario"
    elseif roll <= 95 then
        rarity = "Máximo"
    elseif roll <= 99 then
        rarity = "Ultra"
    else
        rarity = "Dios"
    end

    -- Filtrar mascotas de esa rareza
    local pool = {}
    for _, pet in ipairs(PetData) do
        if type(pet) == "table" and pet.rarity == rarity then
            table.insert(pool, pet)
        end
    end

    -- Devolver una aleatoria del pool
    if #pool > 0 then
        return pool[math.random(#pool)], rarity
    end
    return PetData[1], "Común"  -- fallback
end

return PetData
