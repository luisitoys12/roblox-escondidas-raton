# 🎨 ComfyUI Cloud — Guía del Equipo
> Generación de assets para **Escondidas + Huye del Ratón**  
> Dos opciones disponibles: **RunPod** (control total) o **ComfyDeploy** (sin setup).

---

## ¿Cuál elegir?

| | RunPod | ComfyDeploy |
|---|---|---|
| Setup técnico | Medio (terminal, Docker) | Cero (solo browser) |
| Control sobre GPU | Total | Automático |
| Costo | ~$0.22–0.44/hr encendido | Pay-per-generación |
| Modelos pesados (Flux) | ✅ Ideal | ✅ Compatible |
| Compartir con el equipo | URL mientras pod activo | Link permanente |
| Ideal para | Devs con experiencia | **Todo el equipo** ✅ |

---

# 🟣 OPCIÓN A — RunPod

## 1. Crear cuenta y cargar créditos
1. Entra a [runpod.io](https://runpod.io) y regístrate
2. Ve a **Billing → Add Credits** — carga mínimo **$10 USD**
3. Guarda tu **API Key** en `Settings → API Keys`

---

## 2. Crear Network Volume (almacenamiento persistente)
> Los modelos y workflows se guardan aquí — no se pierden al apagar el pod.

1. Ve a **Storage → New Network Volume**
2. Configuración:
   - **Name:** `comfyui-escondidas`
   - **Size:** `50 GB` (~$3.50/mes)
   - **Datacenter:** US-TX o US-CA (más cercano a México)
3. Click **Create**

---

## 3. Deploy del Pod

1. Ve a **Pods → Deploy Pod**
2. Busca el template: **`ComfyUI Manager – Permanent Disk`**
3. Selecciona GPU:

| GPU | Precio/hr | Uso recomendado |
|---|---|---|
| RTX 3090 | ~$0.22/hr | Íconos y mascotas |
| A5000 | ~$0.30/hr | Balance precio/calidad ✅ |
| RTX 4090 | ~$0.44/hr | Thumbnails + Flux |

4. **Adjunta el Network Volume** creado en el paso anterior
5. **Container Disk:** mínimo 30 GB
6. Click **Deploy On-Demand**

> ⏳ El primer arranque tarda 10–15 min mientras descarga modelos.

---

## 4. Acceder a ComfyUI

1. Espera que el pod diga **Running**
2. Click en **Connect → HTTP Service [Port 8188]**
3. Se abre ComfyUI en el browser ✅
4. Comparte esa URL con el equipo mientras el pod esté activo

---

## 5. Instalar modelos

Abre el **Terminal** del pod y ejecuta:

```bash
cd /workspace

# Modelo rápido para íconos (mascotas, gamepasses)
wget -O models/checkpoints/dreamshaper.safetensors \
  https://huggingface.co/Lykon/DreamShaper/resolve/main/DreamShaper_8_pruned.safetensors

# Flux.1-dev ya viene preinstalado en el template (thumbnails épicos)
```

---

## 6. Guardar workflows del proyecto

```bash
mkdir -p /workspace/workflows/escondidas

# Copia aquí los .json exportados desde ComfyUI:
# mascotas.json, thumbnail.json, camisas.json, banner.json
```

Exporta cualquier workflow desde ComfyUI: **Save → Export (API Format)** → sube el `.json` a este repo en `/workflows/`.

---

## 7. ⚠️ Importante — Apagar el pod cuando no se use

```
Pods → tu pod → Stop Pod
```
> Solo pagas GPU cuando el pod está **Running**. El Network Volume persiste aunque el pod esté apagado.

---

## 💰 Costo estimado RunPod

| Concepto | Costo |
|---|---|
| Network Volume 50 GB | ~$3.50/mes |
| GPU A5000 × 5 hrs/semana | ~$6.00/semana |
| **Total estimado** | **~$28/mes** uso moderado |

---

---

# 🔵 OPCIÓN B — ComfyDeploy

> Sin terminal, sin Docker. El equipo genera assets desde el browser con un link.

## 1. Crear cuenta

1. Entra a [comfydeploy.com](https://www.comfydeploy.com) → **Sign Up** (gratis)
2. Verifica tu correo y entra al dashboard

---

## 2. Crear una Machine (GPU)

1. Dashboard → **Machines → New Machine**
2. Configuración recomendada:
   - **GPU:** RTX 4090
   - **Disk:** 50 GB
3. En **Custom Nodes** instala:
   - `ComfyUI-Manager`
   - `WAS Node Suite`
   - `ComfyUI Impact Pack`
4. Click **Build Machine** — tarda ~5 min la primera vez

---

## 3. Importar workflow

1. Dashboard → **Workflows → New Workflow**
2. Opciones:
   - **Import JSON** → sube el archivo desde `/workflows/` de este repo
   - **Use Template** → busca `Image Generation` en la galería
3. Asigna la Machine que creaste al workflow

---

## 4. Descargar modelos

Dentro del workflow editor:
1. Click en **Models → Add Model**
2. Pega la URL de HuggingFace o CivitAI:
   ```
   # Mascotas / íconos
   https://huggingface.co/Lykon/DreamShaper/resolve/main/DreamShaper_8_pruned.safetensors

   # Thumbnails (ya disponible en ComfyDeploy por defecto)
   flux1-dev.safetensors
   ```
3. Los modelos quedan en **storage compartido** — todos los devs los usan sin re-descargar ✅

---

## 5. Compartir con el equipo

**Opción 1 — Link de uso simple (recomendado para el equipo):**
1. Workflow → **Share → Generate Link**
2. Los devs ven solo los inputs (prompt, seed, estilo) sin ver los nodos
3. Generan y descargan la imagen directamente

**Opción 2 — Acceso al workspace completo:**
1. Dashboard → **Settings → Team → Invite Members**
2. Manda invitación por email

---

## 6. API automática (opcional — para automatización futura)

1. Workflow → **Deploy → Production**
2. ComfyDeploy genera el endpoint automáticamente:
   ```
   POST https://api.comfydeploy.com/run
   Authorization: Bearer TU_API_KEY
   ```
3. Útil para integrar con **n8n** o scripts de generación masiva de assets

---

## 💰 Costo estimado ComfyDeploy

| Uso | Costo aprox |
|---|---|
| ~50 imágenes/semana (íconos mascotas) | ~$2–5 |
| ~10 thumbnails grandes (Flux) | ~$3–6 |
| **Total estimado demo** | **~$10–15/mes** |

> Sin costo cuando no se genera — el plan Pay-as-You-Go no cobra por tener la cuenta.

---

---

# 📁 Workflows del proyecto

Guarda los workflows exportados en la carpeta `/workflows/` de este repo:

```
workflows/
├── mascotas-comun.json       ← íconos 256x256 rareza común
├── mascotas-legendario.json  ← íconos con glow dorado
├── mascotas-dios.json        ← íconos rainbow glow
├── gamepass-icono.json       ← íconos 512x512 gamepasses
├── thumbnail-principal.json  ← portada 1920x1080
├── camisa-grupo.json         ← plantilla camisas 585x559
└── banner-grupo.json         ← banner redes 1920x384
```

Los prompts para cada workflow están en [`PROMPTS_IMAGENES.md`](./PROMPTS_IMAGENES.md).

---

# ✅ Checklist antes de generar assets

- [ ] Cuenta RunPod o ComfyDeploy creada
- [ ] Modelos descargados (DreamShaper + Flux)
- [ ] Workflow importado desde `/workflows/`
- [ ] Prompts copiados desde `PROMPTS_IMAGENES.md`
- [ ] Output guardado en carpeta local `/assets/[tipo]/`
- [ ] Apagar pod RunPod al terminar (si usas RunPod)

---

*Para dudas sobre los prompts ver [`PROMPTS_IMAGENES.md`](./PROMPTS_IMAGENES.md)*  
*Para bugs del juego abrir un [Issue](../../issues/new)*
