-- AccessoryData.lua
-- Accesorios equipables en el personaje (sombrero, lentes, cola, alas, etc.)
-- Cada accesorio tiene un slot: Head, Back, Face, Shoulder

local AccessoryData = {
    -- HEAD
    { id="cap_mouse",     name="Gorra del Ratón",    slot="Head",     price=200,  rarity="Común",      icon="rbxassetid://0", assetId="rbxassetid://0" },
    { id="crown_gold",    name="Corona Dorada",       slot="Head",     price=800,  rarity="Legendario", icon="rbxassetid://0", assetId="rbxassetid://0" },
    { id="halo",          name="Halo Divino",         slot="Head",     price=5000, rarity="Dios",       icon="rbxassetid://0", assetId="rbxassetid://0" },
    { id="skull_mask",    name="Máscara Calavera",    slot="Face",     price=300,  rarity="Común",      icon="rbxassetid://0", assetId="rbxassetid://0" },
    { id="glasses_cool", name="Lentes Cool",          slot="Face",     price=150,  rarity="Común",      icon="rbxassetid://0", assetId="rbxassetid://0" },
    -- BACK
    { id="wings_angel",  name="Alas de Ángel",       slot="Back",     price=1200, rarity="Máximo",     icon="rbxassetid://0", assetId="rbxassetid://0" },
    { id="wings_demon",  name="Alas Demoníacas",     slot="Back",     price=1500, rarity="Máximo",     icon="rbxassetid://0", assetId="rbxassetid://0" },
    { id="jetpack",      name="Mochila Jet",          slot="Back",     price=2500, rarity="Ultra",      icon="rbxassetid://0", assetId="rbxassetid://0" },
    { id="cape_royal",   name="Capa Real",            slot="Back",     price=600,  rarity="Legendario", icon="rbxassetid://0", assetId="rbxassetid://0" },
    -- SHOULDER
    { id="parrot",       name="Loro en el Hombro",   slot="Shoulder", price=400,  rarity="Común",      icon="rbxassetid://0", assetId="rbxassetid://0" },
    { id="mini_dragon",  name="Dragón Miniatura",    slot="Shoulder", price=3000, rarity="Ultra",      icon="rbxassetid://0", assetId="rbxassetid://0" },
    -- TRAILS (efecto de estela al correr)
    { id="trail_fire",   name="Estela de Fuego",     slot="Trail",    price=700,  rarity="Legendario", icon="rbxassetid://0", particleId="rbxassetid://0" },
    { id="trail_rainbow",name="Estela Arcoíris",     slot="Trail",    price=8000, rarity="Dios",       icon="rbxassetid://0", particleId="rbxassetid://0" },
    { id="trail_void",   name="Estela del Vacío",    slot="Trail",    price=6000, rarity="Dios",       icon="rbxassetid://0", particleId="rbxassetid://0" },
}

return AccessoryData
