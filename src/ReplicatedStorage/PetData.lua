-- PetData.lua v2.0 — 15 mascotas con 5 rarezas
local PetData = {
    -- ══ COMÚN (60%) ══
    { id="mini_mouse",   name="Mini Ratón",     rarity="Común",      price=100,  icon="rbxassetid://0", bonus={ type="speed",          value=1   }, description="Un ratoncito veloz." },
    { id="pollito",      name="Pollito",        rarity="Común",      price=80,   icon="rbxassetid://0", bonus={ type="coinBonus",       value=2   }, description="+2 monedas por ronda." },
    { id="tortuguita",   name="Tortuguita",     rarity="Común",      price=90,   icon="rbxassetid://0", bonus={ type="defense",        value=1   }, description="Reduce cooldown de herramientas 5%." },
    -- ══ LEGENDARIO (25%) ══
    { id="golden_owl",   name="Búho Dorado",    rarity="Legendario", price=500,  icon="rbxassetid://0", bonus={ type="coinMultiplier",  value=2.0 }, description="x2 monedas ganadas." },
    { id="silver_wolf",  name="Lobo Plateado",  rarity="Legendario", price=450,  icon="rbxassetid://0", bonus={ type="speed",          value=3   }, description="+3 velocidad permanente." },
    { id="shadow_fox",   name="Zorro Sombra",   rarity="Legendario", price=480,  icon="rbxassetid://0", bonus={ type="stealth",        value=0.7 }, description="30% menos visible en radar." },
    -- ══ MÁXIMO (10%) ══
    { id="baby_dragon",  name="Dragón Bebé",    rarity="Máximo",     price=1200, icon="rbxassetid://0", bonus={ type="speed",          value=5   }, description="+5 velocidad." },
    { id="phoenix",      name="Fénix Carmesí",  rarity="Máximo",     price=1400, icon="rbxassetid://0", bonus={ type="revive",         value=1   }, description="Revive 1 vez por partida." },
    { id="ghost_shark",  name="Tiburón Fantasma",rarity="Máximo",    price=1100, icon="rbxassetid://0", bonus={ type="coinMultiplier",  value=2.5 }, description="x2.5 monedas." },
    -- ══ ULTRA (4%) ══
    { id="cosmic_lion",  name="León Cósmico",   rarity="Ultra",      price=3000, icon="rbxassetid://0", bonus={ type="aura",           value=1   }, description="Aura visual único + x3 monedas." },
    { id="thunder_snake",name="Serpiente Rayo", rarity="Ultra",      price=2800, icon="rbxassetid://0", bonus={ type="stun",           value=2   }, description="Aturde al Ratón 2s al tocarte." },
    { id="mech_bear",    name="Oso Mecánico",   rarity="Ultra",      price=3200, icon="rbxassetid://0", bonus={ type="shield",         value=1   }, description="Absorbe 1 captura por ronda." },
    -- ══ DIOS (1%) ══
    { id="divine_uni",   name="Unicornio Divino",rarity="Dios",      price=9999, icon="rbxassetid://0", bonus={ type="godMode",        value=1   }, description="x5 monedas + velocidad máxima." },
    { id="celestial_dragon",name="Dragón Celestial",rarity="Dios",   price=9999, icon="rbxassetid://0", bonus={ type="omnibus",        value=1   }, description="Todos los bonuses activos." },
    { id="void_cat",     name="Gato del Vacío", rarity="Dios",       price=9999, icon="rbxassetid://0", bonus={ type="invisible",      value=1   }, description="Invisible en el radar siempre." },
}
return PetData
