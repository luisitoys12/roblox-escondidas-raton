# 🐭 Escondidas + Huye del Ratón
> **Demo Privada — Acceso restringido al grupo**

Juego de Roblox que combina las escondidas clásicas con mecánica de persecución.  
Un jugador es el **Ratón** y todos los demás deben **esconderse y sobrevivir**.

---

## 🎮 ¿Cómo se juega?

| Rol | Objetivo | Habilidades |
|---|---|---|
| 🐭 **Ratón** | Atrapar a todos los escondidos antes de que acabe el tiempo | Mayor velocidad, Radar, Trampa |
| 🙈 **Escondido** | Sobrevivir hasta que termine el tiempo | Señuelo, Humo, Dash |

### Fases de cada partida
1. **Lobby** (30 seg) — Los jugadores eligen mascotas/herramientas
2. **Escóndete** (20 seg) — Los escondidos buscan lugar, el Ratón espera con los ojos cerrados
3. **¡A jugar!** — El Ratón caza, los escondidos evaden
4. **Resultados** — Estadísticas, monedas ganadas y cambios de ELO
5. **Reinicio automático** → regresa al Lobby

---

## 🏗️ Estructura del proyecto

```
roblox-escondidas-raton/
├── ServerScriptService/
│   ├── GameManager.lua        ← Ciclo completo del juego
│   ├── RoundSystem.lua        ← Detección de capturas
│   ├── CoinSystem.lua         ← Economía y tienda
│   ├── RankSystem.lua         ← Sistema ELO (6 rangos)
│   └── DataStore.lua          ← Guardado persistente
├── ReplicatedStorage/
│   ├── GameConfig.lua         ← Todos los parámetros ajustables
│   ├── PetData.lua            ← 5 mascotas con stats
│   └── ToolData.lua           ← 6 herramientas
├── StarterPlayer/
│   ├── GameUI.lua             ← HUD, timer, monedas
│   ├── ShopUI.lua             ← Tienda (tecla E)
│   ├── MouseMovement.lua      ← FOV dinámico del Ratón
│   └── HideMovement.lua       ← Agacharse (tecla C)
├── SETUP.md                   ← Instrucciones de instalación
├── PROMPTS_IMAGENES.md        ← Prompts para thumbnails, camisas, mascotas
└── README.md
```

---

## ⚙️ Instalación rápida

> Ver instrucciones detalladas en [SETUP.md](./SETUP.md)

1. Clona este repositorio
2. Abre **Roblox Studio** y crea un nuevo lugar
3. Copia cada script a su carpeta correspondiente
4. Instala **DataStore2** desde la Toolbox de Roblox
5. En Workspace crea los objetos:
   - `LobbySpawn` — SpawnLocation del lobby
   - `MouseSpawn` — SpawnLocation del Ratón
   - `HiderSpawns` — Folder con múltiples SpawnLocations
6. Ajusta parámetros en `ReplicatedStorage/GameConfig.lua`
7. Prueba con **Test → Start Server**

---

## 💰 Economía de monedas

| Acción | Monedas |
|---|---|
| Sobrevivir la ronda completa | +50 |
| Capturar a un escondido (Ratón) | +30 por captura |
| Ser el último en sobrevivir | +100 bonus |
| Victoria como Ratón (todos capturados) | +80 |
| Derrota | +10 (consuelo) |

> Los multiplicadores de mascota se aplican encima de las cantidades base.

---

## 🐾 Mascotas disponibles

| Mascota | Rareza | Bonus |
|---|---|---|
| Mini Ratón | Común | +5% monedas |
| Gato Fantasma | Legendario | +15% monedas, visión nocturna |
| Zorro Sombra | Máximo | +25% monedas, dash más corto |
| Búho Dorado | Ultra | +40% monedas, radar pasivo |
| Dragón Bebé | Dios | +60% monedas, todos los bonuses |

---

## 🛠️ Herramientas

| Herramienta | Rol | Función |
|---|---|---|
| 🔦 Linterna | Ratón | Revela escondidos en el cono de luz |
| 🪤 Trampa | Ratón | Coloca trampa invisible en el suelo |
| 📡 Radar | Ratón | Muestra posición de escondidos 5 seg |
| 🎭 Señuelo | Escondido | Crea una copia falsa del personaje |
| 💨 Humo | Escondido | Nube que bloquea visión del Ratón |
| ⚡ Dash | Escondido | Salto rápido de emergencia |

---

## 🏆 Sistema de Rangos (ELO)

| Rango | Puntos ELO | Ícono |
|---|---|---|
| Ratoncillo | 0 – 299 | 🐭 |
| Rata Ágil | 300 – 599 | 🐀 |
| Cazador | 600 – 999 | 🔍 |
| Depredador | 1000 – 1499 | ⚡ |
| Leyenda | 1500 – 1999 | 🏆 |
| Dios del Escondite | 2000+ | 👑 |

---

## 👥 Testers — Demo Privada

> Agrega aquí los usuarios de Roblox invitados a la demo

- [ ] `Usuario1`
- [ ] `Usuario2`
- [ ] `Usuario3`
- *(añade más según necesites)*

### 📋 Reglas de la demo
1. **No compartas el link del juego** fuera del grupo
2. Reporta bugs en los [Issues](../../issues) de este repo
3. Feedback de gameplay en el canal del grupo
4. Capturas de pantalla bienvenidas para documentar bugs

---

## 🐛 Reportar bugs

Abre un [Issue](../../issues/new) con:
- Descripción del bug
- Pasos para reproducirlo
- Captura de pantalla (si aplica)
- Tu usuario de Roblox

---

## 🎨 Assets visuales

Todos los prompts para generar imágenes están en [`PROMPTS_IMAGENES.md`](./PROMPTS_IMAGENES.md):
- Thumbnail principal (1920×1080)
- Íconos de gamepasses (512×512)
- Mascotas por rareza (256×256)
- Camisas del grupo (585×559)
- Arte del mapa y loading screen
- Banner e ícono del grupo

---

## 📅 Roadmap

- [x] Sistema de rondas y roles
- [x] Economía de monedas
- [x] Mascotas con bonuses
- [x] Herramientas por rol
- [x] Sistema de rangos ELO
- [x] Guardado de datos (DataStore)
- [x] Prompts de assets visuales
- [ ] Mapa base terminado
- [ ] Animaciones de mascotas
- [ ] Sistema de trampas con físicas
- [ ] Tienda de camisas integrada
- [ ] Leaderboard global
- [ ] Torneos

---

*Demo privada — Grupo Roblox © 2026*
