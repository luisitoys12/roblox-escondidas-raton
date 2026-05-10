-- ClothingData.lua
-- Ropa vendible: camisas, pantalones y paquetes de outfit
-- shirtId / pantsId = AssetId de la ropa subida a Roblox

local ClothingData = {
    -- CAMISAS
    { id="shirt_mouse_basic",  name="Camisa del Ratón",       type="Shirt",  price=150,  rarity="Común",      shirtId="rbxassetid://0" },
    { id="shirt_hider",        name="Camisa Escondido",        type="Shirt",  price=150,  rarity="Común",      shirtId="rbxassetid://0" },
    { id="shirt_camo",         name="Camisa Camuflaje",        type="Shirt",  price=300,  rarity="Legendario", shirtId="rbxassetid://0" },
    { id="shirt_galaxy",       name="Camisa Galaxia",          type="Shirt",  price=800,  rarity="Máximo",     shirtId="rbxassetid://0" },
    { id="shirt_dios",         name="Camisa Divina",           type="Shirt",  price=5000, rarity="Dios",       shirtId="rbxassetid://0" },
    -- PANTALONES
    { id="pants_mouse_basic",  name="Pantalón del Ratón",     type="Pants",  price=100,  rarity="Común",      pantsId="rbxassetid://0" },
    { id="pants_cargo",        name="Pantalón Cargo",         type="Pants",  price=200,  rarity="Común",      pantsId="rbxassetid://0" },
    { id="pants_galaxy",       name="Pantalón Galaxia",       type="Pants",  price=700,  rarity="Máximo",     pantsId="rbxassetid://0" },
    -- OUTFITS COMPLETOS (camisa + pantalón juntos)
    { id="outfit_mouse_vip",   name="Outfit Ratón VIP",        type="Outfit", price=500,  rarity="Legendario", shirtId="rbxassetid://0", pantsId="rbxassetid://0" },
    { id="outfit_ninja",       name="Outfit Ninja",            type="Outfit", price=600,  rarity="Legendario", shirtId="rbxassetid://0", pantsId="rbxassetid://0" },
    { id="outfit_dios",        name="Outfit Divino",           type="Outfit", price=12000,rarity="Dios",       shirtId="rbxassetid://0", pantsId="rbxassetid://0" },
}

return ClothingData
