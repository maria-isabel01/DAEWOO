#!/usr/bin/env python3
"""
Script para crear labels automáticamente desde labels.yml
"""

import os
import yaml
import requests
from typing import List, Dict

def load_labels(file_path: str) -> List[Dict]:
    """Cargar labels desde archivo YAML"""
    with open(file_path, 'r', encoding='utf-8') as f:
        return yaml.safe_load(f)

def create_labels(owner: str, repo: str, token: str, labels: List[Dict]) -> None:
    """Crear labels en el repositorio usando GitHub API"""
    
    api_url = f"https://api.github.com/repos/{owner}/{repo}/labels"
    headers = {
        "Authorization": f"token {token}",
        "Accept": "application/vnd.github.v3+json"
    }
    
    print(f"🚀 Iniciando creación de {len(labels)} labels en {owner}/{repo}...")
    print("=" * 60)
    
    created = 0
    updated = 0
    failed = 0
    
    for label in labels:
        payload = {
            "name": label["name"],
            "color": label["color"],
            "description": label["description"]
        }
        
        try:
            # Intentar crear el label
            response = requests.post(api_url, json=payload, headers=headers)
            
            if response.status_code == 201:
                print(f"✅ Creado: {label['name']} (#{label['color']})")
                created += 1
            elif response.status_code == 422:
                # El label ya existe, intentar actualizar
                update_url = f"{api_url}/{label['name']}"
                update_response = requests.patch(update_url, json=payload, headers=headers)
                if update_response.status_code == 200:
                    print(f"🔄 Actualizado: {label['name']} (#{label['color']})")
                    updated += 1
                else:
                    print(f"❌ Error al actualizar {label['name']}: {update_response.status_code}")
                    failed += 1
            else:
                print(f"❌ Error creando {label['name']}: {response.status_code}")
                print(f"   Respuesta: {response.text}")
                failed += 1
                
        except Exception as e:
            print(f"❌ Exception al procesar {label['name']}: {str(e)}")
            failed += 1
    
    print("=" * 60)
    print(f"\n📊 Resumen:")
    print(f"   ✅ Creados: {created}")
    print(f"   🔄 Actualizados: {updated}")
    print(f"   ❌ Fallidos: {failed}")
    print(f"   📈 Total: {created + updated + failed}/{len(labels)}")

if __name__ == "__main__":
    # Configuración
    OWNER = os.getenv("GITHUB_OWNER", "maria-isabel01")
    REPO = os.getenv("GITHUB_REPO", "DAEWOO")
    TOKEN = os.getenv("GITHUB_TOKEN")
    LABELS_FILE = ".github/labels.yml"
    
    if not TOKEN:
        print("❌ Error: GITHUB_TOKEN no está configurado")
        exit(1)
    
    if not os.path.exists(LABELS_FILE):
        print(f"❌ Error: {LABELS_FILE} no encontrado")
        exit(1)
    
    # Cargar y crear labels
    labels = load_labels(LABELS_FILE)
    create_labels(OWNER, REPO, TOKEN, labels)
    print("\n✅ ¡Proceso completado!")
