# ❗ Solución de Problemas SUI

## 🔧 Problemas Comunes y Soluciones

### 1. 🌐 Problemas de Conexión

#### Error: "Failed to connect to RPC"
**Síntomas:**
```
Error: Failed to connect to RPC server
```

**Soluciones:**
```bash
# 1. Verificar ambiente activo
sui client active-env

# 2. Verificar configuración de ambientes
sui client envs

# 3. Recrear ambiente DevNet
sui client new-env --alias devnet --rpc https://fullnode.devnet.sui.io:443

# 4. Cambiar al ambiente correcto
sui client switch --env devnet
```

#### Error: "Network timeout"
**Soluciones:**
```bash
# 1. Verificar conexión a internet
ping google.com

# 2. Probar ambiente alternativo
sui client new-env --alias devnet2 --rpc https://sui-devnet.public.blastapi.io

# 3. Verificar firewall/proxy
```

### 2. 💰 Problemas con Faucet

#### Error: "Faucet request failed"
**Síntomas:**
```
Error: Faucet request failed: Too many requests
```

**Soluciones:**
```bash
# 1. Esperar cooldown (generalmente 24h)
# 2. Usar faucet web alternativo:
# https://discord.gg/sui (canal #devnet-faucet)

# 3. Verificar si está en el ambiente correcto
sui client active-env

# 4. Verificar dirección
sui client active-address
```

#### Saldo Cero Después del Faucet
**Verificaciones:**
```bash
# 1. Confirmar recepción
sui client balance

# 2. Verificar historial de transacciones
sui client objects

# 3. Verificar ambiente
sui client active-env
```

### 3. 🏗️ Problemas de Compilación Move

#### Error: "Package not found"
**Síntomas:**
```
Error: Unable to resolve package dependency
```

**Soluciones:**
```bash
# 1. Verificar Move.toml
cat Move.toml

# 2. Actualizar dependencias
sui move build --fetch-deps-only

# 3. Verificar versión del framework
# En Move.toml, usar:
[dependencies]
Sui = { git = "https://github.com/MystenLabs/sui.git", subdir = "crates/sui-framework/packages/sui-framework", rev = "framework/devnet" }
```

#### Error: "Compilation failed"
**Verificaciones:**
```move
// 1. Verificar sintaxis Move
// 2. Verificar imports
use sui::object::{Self, UID};
use sui::transfer;
use sui::tx_context::{Self, TxContext};

// 3. Verificar estructuras
public struct MiStruct has key {
    id: UID,
    // otros campos...
}
```

### 4. 🚀 Problemas de Deploy

#### Error: "Insufficient gas"
**Síntomas:**
```
Error: Insufficient gas
```

**Soluciones:**
```bash
# 1. Verificar gas disponible
sui client gas

# 2. Solicitar más tokens
sui client faucet

# 3. Aumentar presupuesto de gas
sui client publish --gas-budget 30000000

# 4. Usar objeto de gas específico
sui client publish --gas <OBJECT_ID> --gas-budget 20000000
```

#### Error: "Package already exists"
**Soluciones:**
```bash
# 1. Incrementar versión en Move.toml
version = "0.0.2"

# 2. O hacer upgrade del package
sui client upgrade --package-id <PACKAGE_ID>
```

### 5. 🔑 Problemas de Claves/Direcciones

#### Error: "Private key not found"
**Soluciones:**
```bash
# 1. Verificar direcciones disponibles
sui client addresses

# 2. Generar nueva dirección
sui client new-address ed25519

# 3. Cambiar dirección activa
sui client switch --address <DIRECCIÓN>

# 4. En último caso, resetear configuración
rm -rf ~/.sui/sui_config
sui client
```

#### Problema: "Dirección cambió"
**Verificaciones:**
```bash
# 1. Listar todas las direcciones
sui client addresses

# 2. Verificar dirección activa
sui client active-address

# 3. Verificar ambiente activo
sui client active-env
```

### 6. 🔄 Problemas de Ambiente

#### Ambientes Mezclados
**Síntomas:** Transacciones no encontradas, objetos desapareciendo

**Soluciones:**
```bash
# 1. Verificar ambiente actual
sui client active-env

# 2. Listar todos los ambientes
sui client envs

# 3. Limpiar y reconfigurar
sui client new-env --alias devnet --rpc https://fullnode.devnet.sui.io:443
sui client switch --env devnet

# 4. Verificar configuración
cat ~/.sui/sui_config/client.yaml
```

### 7. 📦 Problemas de Objetos

#### Objeto No Encontrado
**Síntomas:**
```
Error: Object not found
```

**Verificaciones:**
```bash
# 1. Listar objetos propios
sui client objects

# 2. Verificar ambiente correcto
sui client active-env

# 3. Verificar si objeto existe
sui client object <OBJECT_ID>
```

## 🆘 Comandos de Emergencia

### Reset Completo
```bash
# ⚠️ CUIDADO: Esto borra TODA la configuración
rm -rf ~/.sui
sui client
```

### Backup de la Configuración
```bash
# Hacer backup
cp -r ~/.sui ~/.sui_backup

# Restaurar backup
cp -r ~/.sui_backup ~/.sui
```

### Verificación de Salud
```bash
# Script de verificación completa
echo "=== Verificación SUI ==="
echo "Versión SUI:"
sui --version

echo -e "\nAmbiente Activo:"
sui client active-env

echo -e "\nDirección Activa:"
sui client active-address

echo -e "\nSaldo:"
sui client balance

echo -e "\nGas Disponible:"
sui client gas

echo -e "\nAmbientes Configurados:"
sui client envs
```

## 📞 Dónde Buscar Ayuda

1. **Documentación Oficial**: https://docs.sui.io/
2. **Discord SUI**: https://discord.gg/sui
3. **GitHub Issues**: https://github.com/MystenLabs/sui/issues
4. **Stack Overflow**: Tag `sui-blockchain`
5. **Reddit**: r/sui

## 💡 Consejos de Prevención

1. **Siempre verifica el ambiente** antes de ejecutar comandos
2. **Haz backup de las configuraciones** regularmente
3. **Usa DevNet para pruebas** siempre
4. **Mantén la SUI CLI actualizada**
5. **Documenta cambios** en tu proyecto

## 🔍 Logs y Debug

### Habilitar Logs Detallados
```bash
export RUST_LOG=debug
sui client <comando>
```

### Verificar Logs del Sistema
```bash
# Linux/Mac
tail -f ~/.sui/sui_config/sui.log

# Verificar configuración
cat ~/.sui/sui_config/client.yaml
```
