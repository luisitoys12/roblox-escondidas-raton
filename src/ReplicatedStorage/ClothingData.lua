-- ClothingData.lua
-- Ropa comprable para el mono del jugador (camisas y pantalones)

local ClothingData = {
    -- ══ CAMISAS ══
    { id="shirt_default",    name="Camisa Base",         type="Shirt",  price=0,    rarity="Común",      shirtTemplate="rbxassetid://0", description="La camisa que todos tienen." },
    { id="shirt_mouse",      name="Camisa del Ratón",    type="Shirt",  price=150,  rarity="Común",      shirtTemplate="rbxassetid://0", description="Diseño del personaje principal." },
    { id="shirt_ghost",      name="Camisa Fantasma",     type="Shirt",  price=200,  rarity="Legendario", shirtTemplate="rbxassetid://0", description="Blanca con estampado de calavera." },
    { id="shirt_dragon",     name="Camisa Dragón",       type="Shirt",  price=500,  rarity="Máximo",     shirtTemplate="rbxassetid://0", description="Escamas de dragón estampadas." },
    { id="shirt_vip",        name="Camisa VIP",          type="Shirt",  price=0,    rarity="Ultra",      shirtTemplate="rbxassetid://0", description="Solo para VIP. No se vende.", requiresGamepass=true },
    { id="shirt_god",        name="Túnica Celestial",    type="Shirt",  price=9999, rarity="Dios",       shirtTemplate="rbxassetid://0", description="La ropa más exclusiva del juego." },
    -- ══ PANTALONES ══
    { id="pants_default",    name="Pantalón Base",       type="Pants",  price=0,    rarity="Común",      pantsTemplate="rbxassetid://0", description="El pantalón de todos." },
    { id="pants_camo",       name="Pantalón Camuflaje",  type="Pants",  price=120,  rarity="Común",      pantsTemplate="rbxassetid://0", description="Perfecto para esconderse." },
    { id="pants_fire",       name="Pantalón Llamas",     type="Pants",  price=350,  rarity="Legendario", pantsTemplate="rbxassetid://0", description="Llamas en los bordes." },
    { id="pants_void",       name="Pantalón del Vacío",  type="Pants",  price=9999, rarity="Dios",       pantsTemplate="rbxassetid://0", description="Galaxia animada en las piernas." },
    -- ══ OUTFITS COMPLETOS ══
    { id="outfit_ninja",     name="Outfit Ninja",        type="Outfit", price=400,  rarity="Legendario", description="Camisa + pantalón ninja negro.", items={"shirt_ninja","pants_ninja"} },
    { id="outfit_astronaut", name="Outfit Astronauta",   type="Outfit", price=600,  rarity="Máximo",     description="Traje espacial completo.",       items={"shirt_astro","pants_astro"} },
    { id="outfit_god",       name="Outfit Celestial",    type="Outfit", price=9999, rarity="Dios",       description="Set completo de Dios.",          items={"shirt_god","pants_void"} },
}
return ClothingData
