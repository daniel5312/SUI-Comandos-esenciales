# ⚡ SUI - Referencia Rápida

## 🚀 Setup Inicial (Copiar y Pegar)

```bash
# Configurar DevNet
sui client new-env --alias devnet --rpc https://fullnode.devnet.sui.io:443
sui client switch --env devnet
sui client faucet
sui client balance
```

## 💰 Comandos Esenciales

| Comando | Descripción |
|---------|-------------|
| `sui client active-address` | Muestra dirección activa |
| `sui client balance` | Muestra saldo de la billetera |
| `sui client gas` | Lista objetos de gas |
| `sui client faucet` | Solicita tokens de prueba |
| `sui client envs` | Lista ambientes |
| `sui client switch --env devnet` | Cambia a DevNet |

## 🏗️ Desarrollo Move

```bash
# Crear proyecto
sui move new mi_proyecto
cd mi_proyecto

# Compilar
sui move build

# Probar
sui move test

# Publicar
sui client publish --gas-budget 20000000
```

## 🌐 URLs Importantes

| Red | RPC URL |
|-----|---------|
| **DevNet** | `https://fullnode.devnet.sui.io:443` |
| **TestNet** | `https://fullnode.testnet.sui.io:443` |
| **MainNet** | `https://fullnode.mainnet.sui.io:443` |

## 🔧 Troubleshooting Rápido

```bash
# Verificar todo
sui client active-env
sui client active-address
sui client balance

# Reset si es necesario
sui client switch --env devnet
sui client faucet
```

## 📚 Enlaces Rápidos

- 📖 [Docs Oficiales](https://docs.sui.io/)
- 💬 [Discord](https://discord.gg/sui)
- 🔍 [Explorer](https://explorer.sui.io/)
- 🎮 [Playground](https://play.sui.io/)

---
**💡 Consejo**: ¡Siempre usa DevNet para desarrollo y pruebas!
