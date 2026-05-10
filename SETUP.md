# ⚙️ Guía de Instalación en Roblox Studio

## 1. Clonar / Descargar el repositorio

```bash
git clone https://github.com/luisitoys12/roblox-escondidas-raton.git
```

## 2. Abrir Roblox Studio

1. Crea un nuevo lugar o abre el tuyo.
2. En el **Explorer**, crea las carpetas correspondientes a la estructura del proyecto.

## 3. Copiar los scripts

| Archivo fuente | Destino en Studio |
|---|---|
| `src/ServerScriptService/*.server.lua` | **ServerScriptService** |
| `src/ReplicatedStorage/*.lua` | **ReplicatedStorage** |
| `src/StarterPlayerScripts/*.client.lua` | **StarterPlayer > StarterPlayerScripts** |
| `src/StarterCharacterScripts/*.client.lua` | **StarterPlayer > StarterCharacterScripts** |

## 4. Instalar DataStore2

1. Ve a [DataStore2 en Roblox](https://www.roblox.com/library/1936396537/DataStore2)
2. Tómalo en tu inventario.
3. En Studio: **Toolbox > My Models > DataStore2** → arrástralo a **ServerScriptService**.

## 5. Configurar el mapa

1. Crea un `Model` en Workspace llamado **Map**.
2. Añade partes/modelos para esconderse (arbustos, cajas, paredes).
3. Agrega un `SpawnLocation` para el Lobby y otro para el mapa de juego.
4. Crea una carpeta `CoinSpawns` en Workspace con partes invisibles donde aparecerán monedas.

## 6. Probar

- Presiona **Play** con al menos 2 jugadores (usa **Test > Start Server** para simular).
- Verifica en Output que aparezca `[GameManager] Servidor iniciado correctamente`.

## 7. Publicar

- **File > Publish to Roblox** cuando estés listo.
