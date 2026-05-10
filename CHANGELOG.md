# Changelog

## v2.0.0 — MEGA UPDATE

### 🆕 Sistemas nuevos
- **GamepassSystem** — Gamepasses + Developer Products con gacha de mascotas por rareza
- **MapSystem** — Selector de mapas con votación de 3 opciones en el lobby
- **AccessorySystem** — Accesorios (head, back, face, shoulder) y estelas equipables
- **LevelSystem** — Niveles 1-100 con XP, curva exponencial, desbloquea mapas
- **LeaderboardSystem** — Tabla de líderes global (ELO, Monedas, Nivel) con OrderedDataStore

### 📦 Datos nuevos
- **PetData v2** — 15 mascotas en 5 rarezas: Común, Legendario, Máximo, Ultra, Dios
- **AccessoryData** — 14 accesorios: gorras, alas, estelas, halo, loro, jetpack
- **ClothingData** — 11 prendas: camisas, pantalones y outfits completos
- **MapData** — 6 mapas: Callejón, Bosque, Escuela, Alcantarillas, Espacio, Dulces
- **GamepassData** — 6 gamepasses + 5 developer products configurados

### 🖥️ UIs nuevas (cliente)
- **MapVoteUI** — Votación animada de mapas con cards y countdown
- **ClosetUI** — Armario: equipa accesorios y ropa (tecla T)
- **LeaderboardUI** — Top 10 global por ELO / Monedas / Nivel (tecla L)
- **LevelUI** — Barra de XP + notificación animada de subida de nivel

### ⌨️ Atajos de teclado
| Tecla | Función |
|---|---|
| `E` | Abrir tienda (ShopUI) |
| `T` | Abrir armario (ClosetUI) |
| `L` | Tabla de líderes |
| `C` | Agacharse (solo escondidos) |

## v1.0.0 — Base
- GameManager, RoundSystem, CoinSystem, RankSystem, DataStore
- GameUI, ShopUI, MouseMovement, HideMovement
- PetData v1 (5 mascotas), ToolData, GameConfig
