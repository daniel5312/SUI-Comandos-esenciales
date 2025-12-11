# 🔨 Tutorial de Desarrollo SUI

## 🎯 Objetivo
Este tutorial te guiará desde la configuración inicial hasta la creación de tu primer smart contract en SUI.

## 📋 Prerrequisitos
- SUI CLI instalado
- Conocimiento básico de línea de comandos
- Editor de código (VS Code recomendado)

## 🚀 Paso a Paso

### 1. Configuración Inicial

#### 1.1 Verificar Instalación
```bash
sui --version
```

#### 1.2 Configurar DevNet
```bash
# Crear ambiente DevNet
sui client new-env --alias devnet --rpc https://fullnode.devnet.sui.io:443

# Verificar si fue creado
sui client envs

# Activar DevNet
sui client switch --env devnet
```

### 2. Configuración de la Billetera

#### 2.1 Verificar Dirección
```bash
sui client active-address
```

#### 2.2 Obtener Tokens de Prueba
```bash
sui client faucet
```

#### 2.3 Verificar Saldo
```bash
sui client balance
```

**Resultado esperado:**
```
Balance of coins owned by this address
╭──────────────────────────────────────────────────────────────────────╮
│ coin  balance (raw)  balance (display)  coin type                     │
├──────────────────────────────────────────────────────────────────────┤
│ SUI   1000000000    1.00 SUI           0x2::sui::SUI                  │
╰──────────────────────────────────────────────────────────────────────╯
```

### 3. Primer Proyecto Move

#### 3.1 Crear Proyecto
```bash
sui move new hello_world
cd hello_world
```

#### 3.2 Estructura del Proyecto
```
hello_world/
├── Move.toml
├── sources/
└── tests/
```

#### 3.3 Configurar Move.toml
```toml
[package]
name = "hello_world"
version = "0.0.1"
edition = "2024.beta"

[dependencies]
Sui = { git = "https://github.com/MystenLabs/sui.git", subdir = "crates/sui-framework/packages/sui-framework", rev = "framework/devnet" }

[addresses]
hello_world = "0x0"
```

#### 3.4 Crear Primer Módulo
Crea el archivo `sources/hello_world.move`:

```move
module hello_world::hello_world {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use std::string;

    /// Una estructura simple que contiene un mensaje
    public struct HelloWorldObject has key, store {
        id: UID,
        text: string::String
    }

    /// Función pública para crear un nuevo HelloWorldObject
    public fun mint(ctx: &mut TxContext) {
        let object = HelloWorldObject {
            id: object::new(ctx),
            text: string::utf8(b"Hello World!")
        };
        transfer::public_transfer(object, tx_context::sender(ctx));
    }
}
```

### 4. Compilación y Pruebas

#### 4.1 Compilar el Proyecto
```bash
sui move build
```

**Salida esperada:**
```
BUILDING hello_world
Build Successful
```

#### 4.2 Crear Prueba
Crea el archivo `tests/hello_world_tests.move`:

```move
#[test_only]
module hello_world::hello_world_tests {
    use hello_world::hello_world::{Self, HelloWorldObject};
    use sui::test_scenario;

    #[test]
    public fun test_mint() {
        let addr1 = @0xA;

        let mut scenario = test_scenario::begin(addr1);
        {
            hello_world::mint(test_scenario::ctx(&mut scenario));
        };

        test_scenario::next_tx(&mut scenario, addr1);
        {
            assert!(test_scenario::has_most_recent_for_sender<HelloWorldObject>(&scenario), 0);
        };

        test_scenario::end(scenario);
    }
}
```

#### 4.3 Ejecutar Pruebas
```bash
sui move test
```

### 5. Deploy del Contrato

#### 5.1 Publicar el Módulo
```bash
sui client publish --gas-budget 20000000
```

#### 5.2 Llamar la Función
Después del deploy, usa el Package ID retornado:

```bash
sui client call --function mint --module hello_world --package < PACKAGE_ID > --gas-budget 10000000
```

### 6. Verificación

#### 6.1 Verificar Objetos
```bash
sui client objects
```

#### 6.2 Inspeccionar Objeto
```bash
sui client object < OBJECT_ID >
```

## 🎉 ¡Felicitaciones!

¡Has creado y desplegado tu primer smart contract en SUI!

## 🔄 Próximos Pasos

1. **Explora más funcionalidades Move**
2. **Crea contratos más complejos**
3. **Aprende sobre capabilities**
4. **Estudia el sistema de objetos de SUI**

## 📚 Recursos para Continuar

- [Documentación oficial Move](https://move-language.github.io/move/)
- [SUI Developer Portal](https://docs.sui.io/)
- [Ejemplos de código](https://github.com/MystenLabs/sui/tree/main/examples)

## 🐛 Problemas Comunes

### Error de Gas Insuficiente
```bash
# Verificar gas disponible
sui client gas

# Solicitar más tokens
sui client faucet
```

### Error de Compilación
```bash
# Verificar sintaxis del Move.toml
# Verificar importaciones
# Consultar logs de error detallados
```

### Ambiente Incorrecto
```bash
# Verificar ambiente activo
sui client active-env

# Cambiar si es necesario
sui client switch --env devnet
```
