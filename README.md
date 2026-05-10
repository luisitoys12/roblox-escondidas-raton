# 🐭 Las Escondidas + Huye del Ratón — Roblox Game

> Un juego de escondidas donde 1 jugador es el **Ratón** y los demás se **esconden**. El Ratón debe atrapar a todos antes de que acabe el tiempo. ¡Con monedas, mascotas, herramientas y partidas clasificadas!

---

## 🎮 Mecánicas Principales

| Rol | Descripción |
|-----|-------------|
| 🐭 **Ratón** | Corre por el mapa buscando a los escondidos. Puede usar herramientas. |
| 🙈 **Escondido** | Se esconde antes de que acabe el countdown. Puede usar habilidades. |

### Sistemas incluidos
- 🪙 **Monedas** — se ganan al sobrevivir / atrapar jugadores
- 🐾 **Mascotas** — compradas con monedas, dan bonuses pasivos
- 🛠️ **Herramientas** — para el Ratón (linterna, trampa) y Escondidos (señuelo, humo)
- 📊 **Partidas Clasificadas** — ELO simple: ganar sube, perder baja
- ⏱️ **Lobby / Countdown / Juego / Resultados** — ciclo completo de rondas

---

## 📁 Estructura del Proyecto

```
roblox-escondidas-raton/
├── src/
│   ├── ServerScriptService/
│   │   ├── GameManager.server.lua       -- Ciclo de la partida
│   │   ├── RoundSystem.server.lua       -- Roles, tiempo, capturas
│   │   ├── CoinSystem.server.lua        -- Economía de monedas
│   │   ├── RankSystem.server.lua        -- ELO / Rango
│   │   └── DataStore.server.lua        -- Guardado de datos (DataStore2)
│   ├── ReplicatedStorage/
│   │   ├── GameConfig.lua              -- Configuración central
│   │   ├── PetData.lua                 -- Tabla de mascotas
│   │   └── ToolData.lua               -- Tabla de herramientas
│   ├── StarterPlayerScripts/
│   │   ├── GameUI.client.lua           -- HUD: monedas, rol, timer
│   │   ├── PetUI.client.lua            -- UI de mascotas equipadas
│   │   └── ShopUI.client.lua          -- Tienda de mascotas/herramientas
│   └── StarterCharacterScripts/
│       ├── MouseMovement.client.lua    -- Velocidad extra del Ratón
│       └── HideMovement.client.lua    -- Mecánica de agacharse al escondido
├── SETUP.md                           -- Instrucciones de instalación
└── README.md
```

---

## 🚀 Instalación en Roblox Studio

Ver [SETUP.md](./SETUP.md) para instrucciones paso a paso.

---

## ⚙️ Configuración Rápida

Edita `src/ReplicatedStorage/GameConfig.lua`:

```lua
Config.RoundTime       = 120   -- segundos de partida
Config.LobbyTime       = 30    -- segundos en lobby
Config.HideTime        = 15    -- segundos para esconderse
Config.MinPlayers      = 2     -- mínimo para iniciar
Config.MaxPlayers      = 12    -- máximo por servidor
Config.CoinsPerCapture = 10    -- monedas por atrapar
Config.CoinsPerSurvive = 20    -- monedas por sobrevivir
```

---

## 📦 Dependencias

- [DataStore2](https://devforum.roblox.com/t/datastore2-data-store-caching-and-data-loss-prevention/136317) — instalar en ServerScriptService
- Roblox Studio (versión actual)

---

## 🗺️ Roadmap

- [ ] Mapa principal (lobby + arena)
- [ ] Animaciones de mascotas
- [ ] Efectos de partículas para herramientas
- [ ] Tabla de líderes global
- [ ] Pases de juego (GamePass)
- [ ] Evento de temporada / skins

---

## 📝 Licencia

MIT — úsalo libremente para tu juego de Roblox.
