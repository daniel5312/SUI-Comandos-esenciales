# 🚀 SUI - Comandos Esenciales

Documentación completa de los comandos esenciales para desarrollo en la blockchain SUI.

## 📋 Índice

- [🔧 Configuración Inicial](#-configuración-inicial)
- [💰 Gestión de Billetera](#-gestión-de-billetera)
- [🌐 Ambientes de Red](#-ambientes-de-red)
- [🏗️ Desarrollo Move](#️-desarrollo-move)
- [📖 Guías Detalladas](#-guías-detalladas)

## 🔧 Configuración Inicial

### Verificar Instalación
```bash
sui --version
```

### Configurar Ambiente de Desarrollo
```bash
# Crear nuevo ambiente DevNet
sui client new-env --alias devnet --rpc https://fullnode.devnet.sui.io:443

# Verificar ambientes disponibles
sui client envs

# Cambiar a DevNet
sui client switch --env devnet
```

## 💰 Gestión de Billetera

### Comandos Básicos de Billetera
```bash
# Verificar dirección activa
sui client active-address

# Verificar saldo
sui client balance

# Verificar gas disponible
sui client gas

# Solicitar tokens de prueba (solo DevNet/TestNet)
sui client faucet
```

## 🌐 Ambientes de Red

### Configuración de Ambientes
```bash
# Listar todos los ambientes
sui client envs

# Crear ambiente personalizado
sui client new-env --alias <nombre> --rpc <url-rpc>

# Cambiar entre ambientes
sui client switch --env <nombre-ambiente>
```

## 🏗️ Desarrollo Move

### Crear Proyecto Move
```bash
# Crear nuevo proyecto
sui move new <nombre-del-proyecto>

# Estructura básica creada:
# ├── Move.toml
# ├── sources/
# └── tests/
```

## 📖 Guías Detalladas

- [📘 Guía Completa de Comandos](./docs/comandos-completos.md)
- [🔨 Tutorial de Desarrollo](./docs/tutorial-desenvolvimento.md)
- [❗ Solución de Problemas](./docs/troubleshooting.md)
- [📚 Recursos Adicionales](./docs/recursos.md)

---

## 🎯 Para Principiantes

Si eres nuevo en SUI, recomendamos seguir este orden:

1. ✅ **Configuración**: Configura tu ambiente DevNet
2. 💰 **Billetera**: Obtén tokens de prueba con el faucet
3. 🏗️ **Primer Proyecto**: Crea tu primer proyecto Move
4. 📖 **Estudio**: Explora las guías detalladas

---

**💡 Consejo**: ¡Siempre usa el ambiente DevNet para pruebas y desarrollo!

**Soporte**: En caso de dudas, consulta la [documentación oficial de SUI](https://docs.sui.io/)
