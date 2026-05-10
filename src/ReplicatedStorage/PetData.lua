-- PetData.lua
-- Tabla de mascotas disponibles en la tienda.
-- Cada mascota tiene un bonus pasivo que se aplica al portador.

local PetData = {
    {
        id         = "mini_mouse",
        name       = "Mini Ratón",
        price      = 100,
        icon       = "rbxassetid://0",  -- reemplaza con tu asset ID
        rarity     = "Común",
        bonus      = { type = "speed",    value = 1 },   -- +1 velocidad
        description = "Un ratoncito pequeño que te da algo de velocidad.",
    },
    {
        id         = "ghost_cat",
        name       = "Gato Fantasma",
        price      = 300,
        icon       = "rbxassetid://0",
        rarity     = "Raro",
        bonus      = { type = "coinMultiplier", value = 1.5 }, -- x1.5 monedas
        description = "Un gato espectral que duplica casi tus ganancias.",
    },
    {
        id         = "shadow_fox",
        name       = "Zorro Sombra",
        price      = 600,
        icon       = "rbxassetid://0",
        rarity     = "Épico",
        bonus      = { type = "stealth",   value = 0.7 }, -- 30% menos visible en el radar
        description = "Un zorro que te vuelve difícil de detectar.",
    },
    {
        id         = "golden_owl",
        name       = "Búho Dorado",
        price      = 1500,
        icon       = "rbxassetid://0",
        rarity     = "Legendario",
        bonus      = { type = "coinMultiplier", value = 2.0 }, -- x2 monedas
        description = "El búho más poderoso. Duplica todas tus monedas ganadas.",
    },
    {
        id         = "baby_dragon",
        name       = "Dragón Bebé",
        price      = 2500,
        icon       = "rbxassetid://0",
        rarity     = "Mítico",
        bonus      = { type = "speed", value = 3 }, -- +3 velocidad
        description = "Un dragoncito que corre contigo a toda velocidad.",
    },
}

return PetData
