-- AccessoryData.lua
-- Accesorios equipables en el personaje (sombreros, máscaras, alas, etc.)

local AccessoryData = {
    -- ══ SOMBREROS ══
    { id="top_hat",      name="Sombrero de Copa",  slot="Hat",   price=200,  rarity="Común",      icon="rbxassetid://0", meshId="rbxassetid://0", textureId="rbxassetid://0" },
    { id="crown",        name="Corona Real",        slot="Hat",   price=800,  rarity="Legendario", icon="rbxassetid://0", meshId="rbxassetid://0", textureId="rbxassetid://0" },
    { id="mouse_ears",   name="Orejas de Ratón",    slot="Hat",   price=150,  rarity="Común",      icon="rbxassetid://0", meshId="rbxassetid://0", textureId="rbxassetid://0" },
    { id="wizard_hat",   name="Sombrero Mago",      slot="Hat",   price=500,  rarity="Legendario", icon="rbxassetid://0", meshId="rbxassetid://0", textureId="rbxassetid://0" },
    { id="halo",         name="Halo Dorado",        slot="Hat",   price=2000, rarity="Ultra",      icon="rbxassetid://0", meshId="rbxassetid://0", textureId="rbxassetid://0" },
    { id="devil_horns",  name="Cuernos del Diablo", slot="Hat",   price=1500, rarity="Máximo",     icon="rbxassetid://0", meshId="rbxassetid://0", textureId="rbxassetid://0" },
    { id="god_crown",    name="Corona de Dios",     slot="Hat",   price=9999, rarity="Dios",       icon="rbxassetid://0", meshId="rbxassetid://0", textureId="rbxassetid://0" },
    -- ══ MÁSCARAS ══
    { id="mask_wolf",    name="Máscara Lobo",       slot="Face",  price=300,  rarity="Común",      icon="rbxassetid://0", meshId="rbxassetid://0", textureId="rbxassetid://0" },
    { id="mask_ghost",   name="Máscara Fantasma",   slot="Face",  price=400,  rarity="Legendario", icon="rbxassetid://0", meshId="rbxassetid://0", textureId="rbxassetid://0" },
    { id="mask_dragon",  name="Máscara Dragón",     slot="Face",  price=1000, rarity="Máximo",     icon="rbxassetid://0", meshId="rbxassetid://0", textureId="rbxassetid://0" },
    { id="void_mask",    name="Máscara del Vacío",  slot="Face",  price=5000, rarity="Dios",       icon="rbxassetid://0", meshId="rbxassetid://0", textureId="rbxassetid://0" },
    -- ══ ALAS ══
    { id="wings_angel",  name="Alas de Ángel",      slot="Back",  price=600,  rarity="Legendario", icon="rbxassetid://0", meshId="rbxassetid://0", textureId="rbxassetid://0" },
    { id="wings_bat",    name="Alas de Murciélago", slot="Back",  price=700,  rarity="Legendario", icon="rbxassetid://0", meshId="rbxassetid://0", textureId="rbxassetid://0" },
    { id="wings_dragon", name="Alas de Dragón",     slot="Back",  price=2500, rarity="Ultra",      icon="rbxassetid://0", meshId="rbxassetid://0", textureId="rbxassetid://0" },
    { id="wings_god",    name="Alas Celestiales",   slot="Back",  price=9999, rarity="Dios",       icon="rbxassetid://0", meshId="rbxassetid://0", textureId="rbxassetid://0" },
    -- ══ TRAILS (estelas) ══
    { id="trail_fire",   name="Estela de Fuego",    slot="Trail", price=400,  rarity="Legendario", icon="rbxassetid://0", particleId="rbxassetid://0" },
    { id="trail_ice",    name="Estela de Hielo",    slot="Trail", price=400,  rarity="Legendario", icon="rbxassetid://0", particleId="rbxassetid://0" },
    { id="trail_rainbow",name="Estela Arcoíris",    slot="Trail", price=1000, rarity="Máximo",     icon="rbxassetid://0", particleId="rbxassetid://0" },
    { id="trail_void",   name="Estela del Vacío",   slot="Trail", price=9999, rarity="Dios",       icon="rbxassetid://0", particleId="rbxassetid://0" },
}
return AccessoryData
