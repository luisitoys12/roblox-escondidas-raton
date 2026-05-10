-- PetData.lua v2 — 15 mascotas, 5 rarezas
local RARITY = {
    ["Común"]      = { color = Color3.fromRGB(180,180,180), chance = 60 },
    ["Legendario"] = { color = Color3.fromRGB(255,200,0),   chance = 25 },
    ["Máximo"]     = { color = Color3.fromRGB(160,0,220),   chance = 10 },
    ["Ultra"]      = { color = Color3.fromRGB(220,30,30),   chance = 4  },
    ["Dios"]       = { color = Color3.fromRGB(255,100,255), chance = 1  },
}

local PetData = {
    -- COMÚN
    { id="mini_mouse",   name="Mini Ratón",      rarity="Común",      price=100,  bonus={type="speed",value=1},           icon="rbxassetid://0" },
    { id="pollito",      name="Pollito",         rarity="Común",      price=80,   bonus={type="coinMultiplier",value=1.2}, icon="rbxassetid://0" },
    { id="tortuguita",   name="Tortuguita",      rarity="Común",      price=90,   bonus={type="stealth",value=0.9},        icon="rbxassetid://0" },
    -- LEGENDARIO
    { id="buho_dorado",  name="Búho Dorado",     rarity="Legendario", price=500,  bonus={type="coinMultiplier",value=2.0}, icon="rbxassetid://0" },
    { id="lobo_plateado",name="Lobo Plateado",   rarity="Legendario", price=600,  bonus={type="speed",value=3},            icon="rbxassetid://0" },
    { id="zorro_sombra", name="Zorro Sombra",    rarity="Legendario", price=550,  bonus={type="stealth",value=0.6},        icon="rbxassetid://0" },
    -- MÁXIMO
    { id="dragon_bebe",  name="Dragón Bebé",     rarity="Máximo",     price=1500, bonus={type="speed",value=5},            icon="rbxassetid://0" },
    { id="fenix",        name="Fénix Carmesí",   rarity="Máximo",     price=1800, bonus={type="coinMultiplier",value=3.0}, icon="rbxassetid://0" },
    { id="tiburon",      name="Tiburón Fantasma",rarity="Máximo",     price=2000, bonus={type="stealth",value=0.4},        icon="rbxassetid://0" },
    -- ULTRA
    { id="leon_cosmico", name="León Cósmico",    rarity="Ultra",      price=5000, bonus={type="coinMultiplier",value=5.0}, icon="rbxassetid://0" },
    { id="serpiente",    name="Serpiente Rayo",  rarity="Ultra",      price=4500, bonus={type="speed",value=8},            icon="rbxassetid://0" },
    { id="oso_mec",      name="Oso Mecánico",    rarity="Ultra",      price=4800, bonus={type="armor",value=0.5},          icon="rbxassetid://0" },
    -- DIOS
    { id="unicornio",    name="Unicornio Divino",rarity="Dios",       price=15000,bonus={type="godMode",value=1},          icon="rbxassetid://0" },
    { id="dragon_cel",   name="Dragón Celestial",rarity="Dios",       price=20000,bonus={type="coinMultiplier",value=10},  icon="rbxassetid://0" },
    { id="gato_vacio",   name="Gato del Vacío",  rarity="Dios",       price=25000,bonus={type="allBonus",value=2},         icon="rbxassetid://0" },
}

PetData.RARITY = RARITY
return PetData
