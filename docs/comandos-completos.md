# 📘 Guía Completa de Comandos SUI

## 🔧 Comandos de Configuración

Después de verificar tu versión, cualquier comando que utilices básicamente pedirá que configures el cliente.

![alt text](image-1.png)

En esa secuencia mostrada en la imagen, SUI hará:
1. **Generar una nueva billetera** automáticamente
2. **Crear las keypairs** necesarias
3. **Utilizar la keypair 0** (que es la más indicada y predeterminada)
4. **Configurar el ambiente** de red

Sería básicamente

### `sui client new-env`
Crea un nuevo ambiente de red.

```bash
sui client new-env --alias <nombre> --rpc <url-rpc>
```

**Ejemplos:**
```bash
# DevNet
sui client new-env --alias devnet --rpc https://fullnode.devnet.sui.io:443

# TestNet
sui client new-env --alias testnet --rpc https://fullnode.testnet.sui.io:443

# MainNet
sui client new-env --alias mainnet --rpc https://fullnode.mainnet.sui.io:443
```

### `sui client envs`
Lista todos los ambientes configurados.

```bash
sui client envs
```

**Salida esperada:**
```
╭─────────┬─────────────────────────────────────┬────────╮
│ alias   │ url                                 │ active │
├─────────┼─────────────────────────────────────┼────────┤
│ devnet  │ https://fullnode.devnet.sui.io:443  │ *      │
│ testnet │ https://fullnode.testnet.sui.io:443 │        │
╰─────────┴─────────────────────────────────────┴────────╯
```

### `sui client switch`
Alterna entre ambientes.

```bash
sui client switch --env <nombre-ambiente>
```

**Ejemplo:**
```bash
sui client switch --env devnet
```

## 💰 Comandos de Billetera

### `sui client active-address`
Muestra la dirección activa actual.

```bash
sui client active-address
```

**Salida esperada:**
```
0x1234567890abcdef1234567890abcdef12345678
```

### `sui client balance`
Muestra el saldo de la billetera activa.

```bash
sui client balance
```

**Salida esperada:**
```
╭────────────────────────────────────────╮
│ Balance of coins owned by this address │
├────────────────────────────────────────┤
│ ╭──────────────────────────────────────────────────────────────────────╮ │
│ │ coin  balance (raw)  balance (display)  coin type                     │ │
│ ├──────────────────────────────────────────────────────────────────────┤ │
│ │ SUI   1000000000    1.00 SUI           0x2::sui::SUI                  │ │
│ ╰──────────────────────────────────────────────────────────────────────╯ │
╰────────────────────────────────────────╯
```

### `sui client gas`
Lista objetos de gas disponibles.

```bash
sui client gas
```

**Salida esperada:**
```
╭────────────────────────────────────────────────────────────────────╮
│ gasCoinId                          │ gasBalance │ suiBalance       │
├────────────────────────────────────────────────────────────────────┤
│ 0x123...abc                        │ 1000000000 │ 1000000000       │
╰────────────────────────────────────────────────────────────────────╯
```

### `sui client faucet`
Solicita tokens de prueba (solo redes de prueba).

```bash
sui client faucet
```

**⚠️ Importante**:
- Funciona solo en DevNet y TestNet
- Limitado a una solicitud por tiempo
- Proporciona tokens SUI para pruebas

## 🏗️ Comandos Move

### `sui move new`
Crea un nuevo proyecto Move.

```bash
sui move new <nombre-del-proyecto>
```

**Ejemplo:**
```bash
sui move new mi_primer_contrato
```

**Estructura creada:**
```
mi_primer_contrato/
├── Move.toml
├── sources/
│   └── (tus archivos .move aquí)
└── tests/
    └── (tus tests aquí)
```

### `sui move build`
Compila el proyecto Move.

```bash
cd <nombre-del-proyecto>
sui move build
```

### `sui move test`
Ejecuta las pruebas del proyecto.

```bash
sui move test
```

## 🔍 Comandos de Consulta

### `sui client object`
Consulta información sobre un objeto específico.

```bash
sui client object <object-id>
```

### `sui client ptb`
Ejecuta un bloque de transacción programable.

```bash
sui client ptb --help
```

## 📊 Comandos de Monitoreo

### `sui client active-env`
Muestra el ambiente activo actual.

```bash
sui client active-env
```

### `sui client addresses`
Lista todas las direcciones de la billetera.

```bash
sui client addresses
```

## 🔐 Comandos de Seguridad

### `sui keytool`
Gestiona claves criptográficas.

```bash
sui keytool --help
```

### `sui client new-address`
Genera una nueva dirección.

```bash
sui client new-address ed25519
```

---

## 🔑 Recursos Avanzados

⚠️ **ATENCIÓN**: Los comandos de esta sección manipulan datos sensibles. ¡**NUNCA** compartas tus claves privadas o mnemónicos!

### Exportar Clave Privada
```bash
sui keytool export --key-identity <dirección>
```

**Ejemplo:**
```bash
sui keytool export --key-identity <TU-BILLETERA>
```

**⚠️ CUIDADOS EXTREMOS:**
- Ejecuta solo en ambiente seguro
- **NUNCA** compartas la salida de este comando
- **NUNCA** publiques en foros, Discord o redes sociales
- Considera usar solo para respaldo seguro

### Exportar Mnemónico (Seed Phrase)
```bash
sui keytool export --key-identity <dirección> mnemonic
```

**Ejemplo:**
```bash
sui keytool export --key-identity 0xa74fc5f23330ccf02f63d161c86201f9bf75d69b04eee6792fa9efae9212292b mnemonic
```

**🚨 SEGURIDAD CRÍTICA:**
- Almacena en lugar físico seguro
- **JAMÁS** escribas en sitios web o aplicaciones sospechosas
- **NUNCA** tomes captura de pantalla o foto
- Considera usar papel y bolígrafo para respaldo

### Verificar Seed Phrase
Para verificar si tu seed phrase está correcta, puedes:

1. **Exportar la seed phrase actual:**
```bash
sui keytool export --key-identity <tu-dirección> mnemonic
```

2. **Verificar la dirección generada por la seed phrase:**
```bash
# Importa temporalmente en un alias de prueba
sui keytool import "<tu-seed-phrase>" ed25519 --alias test-verificacion

# Ve la dirección generada
sui keytool list

# Elimina el alias de prueba si deseas
```

3. **Listar todas las billeteras para comparar:**
```bash
sui keytool list
```

**Salida esperada del `sui keytool list`:**
```
╭──────────────────────────────────────────────────────────────────────────────────────╮
│ alias    │ address                                                │ key scheme │ flag │
├──────────────────────────────────────────────────────────────────────────────────────┤
│ active   │ 0xa74fc5f23330ccf02f63d161c86201f9bf75d69b04eee6792fa9efae9212292b │ ed25519    │ 0    │
╰──────────────────────────────────────────────────────────────────────────────────────╯
```

### Importar Billetera Existente

**Por mnemónico (seed phrase):**
```bash
sui keytool import "<tu-seed-phrase>" ed25519
```

**Por clave privada Bech32 (suiprivkey):**
```bash
sui keytool import "<suiprivkey...>" ed25519
```

**Con alias personalizado:**
```bash
sui keytool import "<tu-seed-phrase>" ed25519 --alias mi-billetera
```

**Ejemplos:**
```bash
# Importar con mnemónico de 12 palabras
sui keytool import "word1 word2 word3 word4 word5 word6 word7 word8 word9 word10 word11 word12" ed25519

# Importar con clave privada Bech32
sui keytool import "suiprivkey1q..." ed25519

# Importar con alias
sui keytool import "word1 word2..." ed25519 --alias billetera-principal
```

**⚠️ Importante:**
- Soporta mnemónicos de 12, 15, 18, 21 o 24 palabras
- Para claves privadas, usa formato Bech32 iniciando con "suiprivkey"
- Usa comillas dobles para proteger la entrada
- El alias es opcional - si no se proporciona, se generará automáticamente

### Ver Información de la Clave
```bash
sui keytool list
```

### Generar Nueva Keypair
```bash
sui keytool generate ed25519
```

### Respaldo Seguro de la Configuración
```bash
# Hacer backup del directorio de configuración
# Windows PowerShell:
Copy-Item -Recurse ~/.sui ~/.sui_backup_$(Get-Date -Format "yyyy-MM-dd")
```

**📋 Checklist de Seguridad:**
- [ ] Nunca compartir claves privadas
- [ ] Hacer backup en lugar seguro offline
- [ ] Verificar siempre el ambiente activo antes de transacciones
- [ ] Usar cantidades pequeñas para pruebas
- [ ] Mantener software actualizado

---

## 💡 Consejos Importantes

1. **Siempre verifica el ambiente activo** antes de ejecutar comandos
2. **Usa DevNet para desarrollo** y pruebas
3. **Mantén tus claves privadas seguras**
4. **Haz backup de tus configuraciones**

## 🚨 Comandos de Emergencia

```bash
# Resetear configuración (¡cuidado!)
rm -rf ~/.sui

# Verificar estado de la red
sui client call --help
```
