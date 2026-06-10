#!/bin/bash

# Script para crear labels automáticamente desde labels.yml
# Uso: GITHUB_TOKEN=tu_token bash scripts/create-labels.sh

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuración
OWNER="${GITHUB_OWNER:-maria-isabel01}"
REPO="${GITHUB_REPO:-DAEWOO}"
TOKEN="${GITHUB_TOKEN}"
LABELS_FILE=".github/labels.yml"

# Validaciones
if [ -z "$TOKEN" ]; then
    echo -e "${RED}❌ Error: GITHUB_TOKEN no está configurado${NC}"
    echo "Usa: export GITHUB_TOKEN=tu_token_aqui"
    exit 1
fi

if [ ! -f "$LABELS_FILE" ]; then
    echo -e "${RED}❌ Error: $LABELS_FILE no encontrado${NC}"
    exit 1
fi

echo -e "${BLUE}🚀 Iniciando creación de labels en ${OWNER}/${REPO}...${NC}"
echo "=================================================="

# Contar labels en el archivo
TOTAL_LABELS=$(grep -c "^- name:" "$LABELS_FILE" || echo 0)
echo -e "${BLUE}📊 Total de labels a procesar: $TOTAL_LABELS${NC}"
echo ""

CREATED=0
UPDATED=0
FAILED=0

# Procesar cada label
while IFS= read -r line; do
    if [[ $line =~ ^-\ name:\ \"(.+)\" ]]; then
        NAME="${BASH_REMATCH[1]}"
        
        # Leer las siguientes líneas para obtener color y descripción
        read COLOR_LINE
        COLOR=$(echo "$COLOR_LINE" | sed 's/.*color: "\(.*\)".*/\1/')
        
        read DESC_LINE
        DESC=$(echo "$DESC_LINE" | sed 's/.*description: "\(.*\)".*/\1/')
        
        # Intentar crear el label
        RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
            -H "Authorization: token $TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            "https://api.github.com/repos/${OWNER}/${REPO}/labels" \
            -d "{
                \"name\": \"$NAME\",
                \"color\": \"$COLOR\",
                \"description\": \"$DESC\"
            }")
        
        HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
        BODY=$(echo "$RESPONSE" | head -n-1)
        
        if [ "$HTTP_CODE" = "201" ]; then
            echo -e "${GREEN}✅ Creado: $NAME${NC} (${BLUE}#${COLOR}${NC})"
            ((CREATED++))
        elif [ "$HTTP_CODE" = "422" ]; then
            # Label ya existe, intentar actualizar
            UPDATE_RESPONSE=$(curl -s -w "\n%{http_code}" -X PATCH \
                -H "Authorization: token $TOKEN" \
                -H "Accept: application/vnd.github.v3+json" \
                "https://api.github.com/repos/${OWNER}/${REPO}/labels/$NAME" \
                -d "{
                    \"color\": \"$COLOR\",
                    \"description\": \"$DESC\"
                }")
            
            UPDATE_CODE=$(echo "$UPDATE_RESPONSE" | tail -n1)
            
            if [ "$UPDATE_CODE" = "200" ]; then
                echo -e "${YELLOW}🔄 Actualizado: $NAME${NC} (${BLUE}#${COLOR}${NC})"
                ((UPDATED++))
            else
                echo -e "${RED}❌ Error al actualizar $NAME (HTTP $UPDATE_CODE)${NC}"
                ((FAILED++))
            fi
        else
            echo -e "${RED}❌ Error creando $NAME (HTTP $HTTP_CODE)${NC}"
            ((FAILED++))
        fi
    fi
done < "$LABELS_FILE"

echo ""
echo "=================================================="
echo -e "${BLUE}📊 Resumen:${NC}"
echo -e "   ${GREEN}✅ Creados: $CREATED${NC}"
echo -e "   ${YELLOW}🔄 Actualizados: $UPDATED${NC}"
echo -e "   ${RED}❌ Fallidos: $FAILED${NC}"
TOTAL=$((CREATED + UPDATED + FAILED))
echo -e "   ${BLUE}📈 Total procesados: $TOTAL/$TOTAL_LABELS${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ ¡Todos los labels fueron procesados exitosamente!${NC}"
else
    echo -e "${YELLOW}⚠️  Se completó con algunos errores${NC}"
fi
