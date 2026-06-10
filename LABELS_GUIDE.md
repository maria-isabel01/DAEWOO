# 🏷️ Sistema de Gestión de Labels Automático

Este proyecto incluye un sistema completamente automatizado para crear y mantener labels en tu repositorio GitHub de acuerdo con la metodología ágil.

## 📋 Contenido

- **`.github/labels.yml`** - Configuración de todos los labels con colores y descripciones
- **`scripts/create-labels.py`** - Script Python para crear labels
- **`scripts/create-labels.sh`** - Script Bash para crear labels (usando curl)

## 🎨 Labels Disponibles (48 Total)

### 🎯 Gestión Ágil (8 labels)
- `sprint` - Sprint actual o planificado
- `backlog` - Item en el backlog
- `ready` - Listo para comenzar
- `in-progress` - Trabajo en progreso
- `blocked` - Bloqueado por dependencia
- `review` - En revisión de código
- `testing` - En fase de testing
- `done` - Completado

### 📖 Historias de Usuario (5 labels)
- `user-story`, `epic`, `task`, `subtask`, `acceptance-criteria`

### 📚 Documentación (5 labels)
- `documentation`, `api-documentation`, `technical-documentation`, `user-manual`, `architecture`

### 🔗 Integraciones (5 labels)
- `integration`, `external-api`, `third-party`, `webhook`, `authentication`

### 💻 Desarrollo (7 labels)
- `frontend`, `backend`, `database`, `api`, `microservice`, `refactor`, `technical-debt`

### ✅ Calidad (5 labels)
- `testing`, `unit-test`, `integration-test`, `e2e-test`, `qa`

### 🚀 DevOps (6 labels)
- `devops`, `ci-cd`, `deployment`, `docker`, `cloud`, `monitoring`

### 🔒 Seguridad (4 labels)
- `security`, `vulnerability`, `permissions`, `authorization`

### ⚠️ Prioridad (4 labels)
- `priority:high`, `priority:medium`, `priority:low`, `critical`

### 🐛 Tipo de Incidencia (5 labels)
- `bug`, `hotfix`, `incident`, `performance`, `maintenance`

---

## 🚀 Cómo Usar

### Opción 1: Script Python (Recomendado)

```bash
# Instalar dependencias
pip install pyyaml requests

# Ejecutar el script
export GITHUB_TOKEN=tu_token_personal
export GITHUB_OWNER=maria-isabel01
export GITHUB_REPO=DAEWOO
python scripts/create-labels.py
```

**Ventajas:**
- ✅ Más robusto y mantenible
- ✅ Mejor manejo de errores
- ✅ Output más legible

### Opción 2: Script Bash

```bash
# Dar permisos de ejecución
chmod +x scripts/create-labels.sh

# Ejecutar el script
export GITHUB_TOKEN=tu_token_personal
bash scripts/create-labels.sh
```

**Ventajas:**
- ✅ No requiere dependencias (solo curl)
- ✅ Más portátil entre sistemas

### Opción 3: Workflow GitHub Actions (Próximo)

Una vez que tengas permisos suficientes en el repositorio, crearé un workflow automático que:
- Ejecuta automáticamente al hacer push a `.github/labels.yml`
- Se puede ejecutar manualmente desde la pestaña "Actions"
- Crea/actualiza todos los labels automáticamente

---

## 🔑 Requisitos

### Token Personal de GitHub

1. Ve a **Settings → Developer settings → Personal access tokens**
2. Clic en "Generate new token"
3. Selecciona los scopes:
   - ✅ `repo` (full control of private repositories)
   - ✅ `admin:repo_hook` (full control of repository hooks)

4. Copia el token y usa:
   ```bash
   export GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxx
   ```

---

## 📊 Ejemplo de Output

```
🚀 Iniciando creación de 48 labels en maria-isabel01/DAEWOO...
==================================================
📊 Total de labels a procesar: 48

✅ Creado: sprint (🔵 #0052CC)
✅ Creado: backlog (🔵 #0066FF)
✅ Creado: ready (🔵 #1F77B4)
🔄 Actualizado: bug (🔴 #FF6B6B)
...
==================================================
📊 Resumen:
   ✅ Creados: 42
   🔄 Actualizados: 5
   ❌ Fallidos: 0
   📈 Total procesados: 47/48

✅ ¡Todos los labels fueron procesados exitosamente!
```

---

## 🔄 Mantener Labels Actualizados

### Modificar un Label Existente

1. Edita `.github/labels.yml`
2. Cambia el nombre, color o descripción
3. Ejecuta el script nuevamente
4. El script automáticamente actualizará los labels existentes

### Agregar Nuevos Labels

1. Agrega entradas nuevas a `.github/labels.yml`:
   ```yaml
   - name: "nuevo-label"
     color: "1F6FEB"
     description: "Descripción del nuevo label"
   ```
2. Ejecuta el script
3. ¡Listo! El nuevo label se creará automáticamente

### Eliminar Labels

Para eliminar un label:
1. Elimina la entrada de `.github/labels.yml`
2. Elimina manualmente desde GitHub (Settings → Labels) si es necesario

---

## 🛠️ Troubleshooting

### Error: "GITHUB_TOKEN no está configurado"
```bash
export GITHUB_TOKEN=tu_token_aqui
```

### Error: "Unauthorized" (401)
- Verifica que tu token sea válido
- Revisa que no haya expirado
- Verifica que tenga los permisos correctos

### Error: "Repository not found" (404)
- Verifica `GITHUB_OWNER` y `GITHUB_REPO`
- Asegúrate de tener acceso al repositorio

### Error: "Permission denied" (403)
- Verifica los permisos de tu token personal
- Asegúrate de tener acceso de escritura al repositorio

---

## 📚 Referencias

- [GitHub API Labels](https://docs.github.com/en/rest/reference/issues#labels)
- [Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [GitHub Actions](https://docs.github.com/en/actions)

---

## ✨ Próximos Pasos

1. **Ejecuta uno de los scripts** para crear todos los labels
2. **Verifica en GitHub** que todos los labels aparezcan correctamente
3. **Configura el workflow de GitHub Actions** para automatización futura
4. **Comienza a usar los labels** en tus issues y pull requests

---

¡Hecho con ❤️ para una gestión ágil efectiva!
