# 💰 Guía de Monetización

## Gamepasses (compra única)

| Nombre | Precio | Beneficio | ID en código |
|---|---|---|---|
| 🐭 Ratón VIP | 150 R$ | Prioridad de ser Ratón 1 de cada 3 rondas | `GAMEPASSES.VIP_MOUSE` |
| ⚡ Speed Boost | 100 R$ | +5 velocidad permanente | `GAMEPASSES.SPEED_BOOST` |
| 🎨 Skin Pack | 200 R$ | Skin exclusiva del personaje | `GAMEPASSES.SKIN_PACK` |
| 🔍 Radar Permanente | 250 R$ | Herramienta Radar gratis cada ronda | `GAMEPASSES.RADAR_PERM` |
| 💎 VIP Badge | 75 R$ | Nombre dorado en HUD + x1.5 monedas | `GAMEPASSES.VIP_BADGE` |

## Developer Products (compra repetible)

| Nombre | Precio | Beneficio | ID en código |
|---|---|---|---|
| 💰 Pack 500 Monedas | 25 R$ | +500 monedas al instante | `PRODUCTS.COINS_500` |
| 💰 Pack 1,500 Monedas | 65 R$ | +1500 monedas (mejor valor) | `PRODUCTS.COINS_1500` |
| 💰 Pack 5,000 Monedas | 180 R$ | +5000 monedas (mejor precio por moneda) | `PRODUCTS.COINS_5000` |
| 🎲 Mascota Aleatoria | 50 R$ | Gacha: abre 1 mascota aleatoria | `PRODUCTS.PET_RANDOM` |
| 🛡️ Escudo de Ronda | 30 R$ | No puedes ser capturado en la próxima ronda | `PRODUCTS.SHIELD_ROUND` |

## Probabilidades del Gacha

| Rareza | Probabilidad | Mascotas |
|---|---|---|
| Común | 60% | Mini Ratón, Pollito, Tortuguita |
| Legendario | 25% | Búho Dorado, Lobo Plateado, Zorro Sombra |
| Máximo | 10% | Dragón Bebé, Fénix Carmesí, Tiburón Fantasma |
| Ultra | 4% | León Cósmico, Serpiente Rayo, Oso Mecánico |
| Dios | 1% | Unicornio Divino, Dragón Celestial, Gato del Vacío |

## Cómo crear los IDs en Roblox

### Gamepasses
1. Ve a [create.roblox.com](https://create.roblox.com)
2. Selecciona tu juego → **Monetization → Passes**
3. Crea cada gamepass con imagen 512×512 px
4. Copia el ID numérico
5. Pégalo en `MonetizationSystem.server.lua` en la tabla `GAMEPASSES`
6. Haz lo mismo en `MonetizationUI.client.lua` tabla `GAMEPASSES`

### Developer Products
1. Ve a [create.roblox.com](https://create.roblox.com)
2. Selecciona tu juego → **Monetization → Developer Products**
3. Crea cada producto
4. Copia el ID numérico
5. Pégalo en `MonetizationSystem.server.lua` tabla `PRODUCTS`
6. Haz lo mismo en `MonetizationUI.client.lua` tabla `PRODUCTS`

## Tamaños de imágenes

| Asset | Tamaño | Formato |
|---|---|---|
| Thumbnail del juego | 1920×1080 px | PNG/JPG |
| Ícono del juego | 512×512 px | PNG |
| Gamepass icon | 512×512 px | PNG |
| Camisa (template) | 585×559 px | PNG con transparencia |
| Pantalón (template) | 585×559 px | PNG con transparencia |
