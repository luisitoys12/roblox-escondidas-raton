-- GamepassData.lua
-- IDs y beneficios de los gamepasses. Reemplaza los IDs con los reales de Roblox.

local GamepassData = {
    {
        id          = "vip_mouse",
        name        = "Ratón VIP",
        gamepassId  = 0,   -- reemplaza con tu ID real
        price       = 150, -- Robux
        description = "1 de cada 3 rondas serás el Ratón de forma garantizada.",
        benefit     = "guaranteedMouse",
        icon        = "rbxassetid://0",
    },
    {
        id          = "speed_boost",
        name        = "Speed Boost",
        gamepassId  = 0,
        price       = 100,
        description = "+5 de velocidad permanente en todas las partidas.",
        benefit     = "permanentSpeed",
        value       = 5,
        icon        = "rbxassetid://0",
    },
    {
        id          = "vip_badge",
        name        = "VIP Badge",
        gamepassId  = 0,
        price       = 75,
        description = "Nombre dorado en el HUD + x1.5 monedas siempre.",
        benefit     = "vipBadge",
        icon        = "rbxassetid://0",
    },
    {
        id          = "radar_perm",
        name        = "Radar Permanente",
        gamepassId  = 0,
        price       = 250,
        description = "Herramienta Radar disponible gratis en cada partida.",
        benefit     = "freeRadar",
        icon        = "rbxassetid://0",
    },
    {
        id          = "all_maps",
        name        = "Todos los Mapas",
        gamepassId  = 0,
        price       = 200,
        description = "Desbloquea todos los mapas sin importar tu nivel.",
        benefit     = "unlockAllMaps",
        icon        = "rbxassetid://0",
    },
    {
        id          = "double_coins",
        name        = "Monedas x2",
        gamepassId  = 0,
        price       = 300,
        description = "Todas tus monedas ganadas se duplican permanentemente.",
        benefit     = "doubleCoinsPerm",
        icon        = "rbxassetid://0",
    },
}

-- Developer Products (compras repetidas)
local DevProducts = {
    { id="coins_500",   name="500 Monedas",    productId=0, price=25,  coins=500  },
    { id="coins_1500",  name="1500 Monedas",   productId=0, price=65,  coins=1500 },
    { id="coins_5000",  name="5000 Monedas",   productId=0, price=175, coins=5000 },
    { id="pet_random",  name="Mascota Aleatoria", productId=0, price=50,  coins=0 },
    { id="shield",      name="Escudo de Ronda",productId=0, price=30,  coins=0   },
}

return { Passes = GamepassData, Products = DevProducts }
