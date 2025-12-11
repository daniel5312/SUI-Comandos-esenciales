# 🎯 Ejemplos Prácticos SUI

## 📋 Lista de Ejemplos

### Básicos
- [Hello World](#hello-world)
- [TodoList - Lista de Tareas](#todolist---lista-de-tareas)
- [Contador Simple](#contador-simple)

### Intermedios
- [NFT con Display - Ejemplo Real](#nft-con-display---ejemplo-real)
- [Token Personalizado](#token-personalizado)
- [Marketplace Simple](#marketplace-simple)

---

## Hello World

### Move.toml
```toml
[package]
name = "introducao"
version = "0.0.1"
edition = "2024.beta"

[dependencies]
Sui = { git = "https://github.com/MystenLabs/sui.git", subdir = "crates/sui-framework/packages/sui-framework", rev = "framework/devnet" }

[addresses]
introducao = "0x0"
```

### sources/pratica_sui.move
```move
module introducao::pratica_sui {
    use std::debug::print;
    use std::string::utf8;

    fun pratica() {
        print(&utf8(b"Hello, World!"));
    }

    #[test]
    fun teste() {
        pratica();
    }
}
```

### Cómo Usar
```bash
# 1. Crear proyecto
sui move new introducao
cd introducao

# 2. Copiar código arriba en los archivos

# 3. Ejecutar el test para ver la salida
sui move test

# Salida esperada:
# [debug] "Hello, World!"
```

### 🎯 Desafío para Practicar

**Modifica el código para:**

1. **Crear una nueva función de saludo**:
```move
fun saludo_personalizado() {
    print(&utf8(b"¡Hola, SUI Blockchain!"));
}
```

2. **Agregar función con parámetro**:
```move
fun saludar(nombre: vector<u8>) {
    let mensaje = utf8(b"Hola, ");
    // Desafío: ¿Cómo concatenar el nombre en el mensaje?
}
```

3. **Crear múltiples saludos**:
```move
fun multiples_saludos() {
    print(&utf8(b"¡Primer saludo!"));
    print(&utf8(b"¡Segundo saludo!"));
    print(&utf8(b"¡Tercer saludo!"));
}
```

### Conceptos Aprendidos
- 📝 **Debug print** - Cómo imprimir valores para debug
- 🔤 **Strings** - Usando `utf8()` para crear strings
- 🧪 **Tests** - Cómo crear y ejecutar tests
- 📦 **Módulos** - Estructura básica de un módulo Move

### 💡 Consejos
- Usa `sui move test` para ejecutar y ver las salidas
- Experimenta diferentes mensajes
- Intenta crear tus propias funciones de saludo

---

## Contador Simple

### sources/counter.move
```move
module counter::counter {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    public struct Counter has key {
        id: UID,
        value: u64,
    }

    public fun create_counter(ctx: &mut TxContext) {
        let counter = Counter {
            id: object::new(ctx),
            value: 0,
        };
        transfer::share_object(counter);
    }

    public fun increment(counter: &mut Counter) {
        counter.value = counter.value + 1;
    }

    public fun decrement(counter: &mut Counter) {
        if (counter.value > 0) {
            counter.value = counter.value - 1;
        };
    }

    public fun get_value(counter: &Counter): u64 {
        counter.value
    }

    public fun reset(counter: &mut Counter) {
        counter.value = 0;
    }
}
```

### Cómo Usar
```bash
# 1. Publicar
sui client publish --gas-budget 20000000

# 2. Crear contador (usar PACKAGE_ID del deploy)
sui client call --function create_counter --module counter --package <PACKAGE_ID> --gas-budget 10000000

# 3. Incrementar (usar OBJECT_ID del contador creado)
sui client call --function increment --module counter --package <PACKAGE_ID> --args <OBJECT_ID> --gas-budget 10000000
```

---

## NFT con Display - Ejemplo Real

> 🎨 **Ejemplo práctico basado en el proyecto real**: [sui-nft-create](https://github.com/gustavo-f0ntz/sui-nft-create/tree/master)

### Move.toml
```toml
[package]
name = "meu_nft_exemplo"
version = "0.0.1"
edition = "2024.beta"

[dependencies]
Sui = { git = "https://github.com/MystenLabs/sui.git", subdir = "crates/sui-framework/packages/sui-framework", rev = "framework/devnet" }

[addresses]
meu_nft_exemplo = "0x0"
```

### sources/meu_nft.move
```move
/// Módulo para crear un NFT de ejemplo con Display Estándar.
module meu_nft_exemplo::meu_nft {
    // --- Dependencias ---
    // Importaciones necesarias del framework de Sui.

    // Para crear el Display que muestra nuestro NFT en UIs.
    use sui::display;
    // Para usar el tipo String.
    use std::string::{Self, String};
    // Para poder obtener el Publisher en la inicialización.
    use sui::package::{Self, Publisher};

    // --- Definición del Objeto NFT ---

    /// One-Time Witness para el Publisher
    public struct MEU_NFT has drop {}

    /// La estructura principal de nuestro NFT.
    /// 'has key' permite que sea un objeto que puede ser poseído.
    /// 'has store' permite que sea colocado dentro de otras estructuras.
    public struct MeuNFT has key, store {
        id: UID,
        name: String,
        description: String,
        /// URL para la imagen del NFT (idealmente, un link de gateway IPFS https://).
        url: String
    }

    // --- Funciones de Inicialización ---

    /// Esta función es llamada solo UNA VEZ, cuando el módulo es publicado en la red.
    /// Crea el "Publisher", que es un objeto que nos da permiso para crear
    /// y actualizar el Display de nuestro tipo `MeuNFT`.
    fun init(otw: MEU_NFT, ctx: &mut TxContext) {
        // Crea un nuevo objeto Publisher para nuestro tipo `MeuNFT`.
        let publisher = package::claim(otw, ctx);
        // Transfiere el Publisher a la persona que está publicando el contrato.
        // Esto garantiza que solo el creador del contrato pueda cambiar cómo se muestran los NFTs.
        transfer::public_transfer(publisher, tx_context::sender(ctx));
    }

    // --- Funciones Públicas (Entry Functions) ---

    /// Crea ("mintea") una nueva instancia de nuestro NFT y la envía al llamador.
    entry fun mint(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ) {
        // Crea el objeto NFT con los datos proporcionados.
        let nft = MeuNFT {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            url: string::utf8(url),
        };
        // Transfiere el NFT recién creado a la billetera que llamó esta función.
        transfer::public_transfer(nft, tx_context::sender(ctx));
    }

    /// Crea y publica el objeto `Display` para el tipo `MeuNFT`.
    /// Esta función debe ser llamada SOLO UNA VEZ después de la publicación del contrato.
    /// Requiere el objeto `Publisher` (que fue obtenido en el `init`) como prueba de autoridad.
    entry fun create_display(
        publisher: &Publisher,
        ctx: &mut TxContext
    ) {
        // Crea un nuevo objeto Display.
        let mut display = display::new_with_fields<MeuNFT>(
            publisher,
            // Nombres de los campos que aparecerán en el Display.
            // Estos son los nombres que las billeteras y exploradores leerán.
            vector[
                string::utf8(b"name"),
                string::utf8(b"description"),
                string::utf8(b"image_url") // ¡Nombre estándar para la imagen!
            ],
            // Valores para los campos del Display.
            // Usamos "placeholders" (variables) que apuntan a los campos de nuestro struct `MeuNFT`.
            // "{name}" en el display mostrará el valor del campo "name" del NFT.
            // "{url}" en el display mostrará el valor del campo "url" del NFT.
            vector[
                string::utf8(b"{name}"),
                string::utf8(b"{description}"),
                string::utf8(b"{url}") // ¡Mapeamos nuestro campo 'url' al 'image_url' del display!
            ],
            ctx
        );

        // Actualiza la versión del display para hacerlo activo.
        display::update_version(&mut display);
        // Transfiere el objeto Display al sender.
        transfer::public_transfer(display, tx_context::sender(ctx));
    }
}
```

### Cómo Usar el NFT
```bash
# 1. Crear proyecto
sui move new meu_nft_exemplo
cd meu_nft_exemplo

# 2. Copiar código arriba en los archivos

# 3. Compilar y publicar
sui move build
sui client publish --gas-budget 20000000

# 4. Paso 1: Crear el Display (usar PACKAGE_ID y PUBLISHER_ID del deploy)
sui client call --function create_display --module meu_nft --package <PACKAGE_ID> --args <PUBLISHER_ID> --gas-budget 10000000

# 5. Paso 2: Mintear un NFT
sui client call --function mint --module meu_nft --package <PACKAGE_ID> --args "Mi Primer NFT" "¡Un NFT increíble creado en SUI!" "https://example.com/image.png" --gas-budget 10000000

# 6. Verificar NFT creado
sui client object <NFT_OBJECT_ID>
```

### Funcionalidades del NFT
- 🎨 **Crear NFT** - `mint()` con nombre, descripción e imagen
- 📱 **Display estándar** - Aparece correctamente en billeteras y exploradores
- 🔐 **Publisher control** - Solo el creador puede modificar el display
- 🖼️ **Soporte de imágenes** - URLs para imágenes (IPFS recomendado)

### Conceptos Avanzados Aprendidos
- 🏗️ **One-Time Witness (OTW)** - Patrón para inicialización única
- 📺 **Display Object** - Cómo los NFTs aparecen en UIs
- 🔑 **Publisher** - Control de autoridad sobre tipos
- 📋 **Entry functions** - Funciones llamables directamente
- 🔄 **Init function** - Función ejecutada en el deploy

### 💡 Consejos Importantes
- **Publisher**: ¡Guarda bien el objeto Publisher, es tu autoridad!
- **Display**: Crea solo una vez después del deploy
- **URLs**: Usa IPFS para imágenes descentralizadas
- **Metadatos**: El Display mapea campos a estándares de billetera

---

## Token Personalizado

### sources/my_coin.move
```move
module my_coin::my_coin {
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::url::{Self, Url};

    public struct MY_COIN has drop {}

    fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<MY_COIN>(
            witness,
            6,                // decimals
            b"MYCOIN",        // symbol
            b"My Coin",       // name
            b"A simple educational coin", // description
            option::some<Url>(url::new_unsafe_from_bytes(b"https://example.com/icon.png")), // icon
            ctx
        );

        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
    }

    public fun mint(
        treasury_cap: &mut TreasuryCap<MY_COIN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx)
    }

    public fun burn(treasury_cap: &mut TreasuryCap<MY_COIN>, coin: Coin<MY_COIN>) {
        coin::burn(treasury_cap, coin);
    }
}
```

---

## Marketplace Simple

### sources/marketplace.move
```move
module marketplace::marketplace {
    use sui::object::{Self, UID, ID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::dynamic_object_field as dof;

    public struct Marketplace has key {
        id: UID,
    }

    public struct Listing has key, store {
        id: UID,
        item_id: ID,
        ask: u64,
        owner: address,
    }

    fun init(ctx: &mut TxContext) {
        let marketplace = Marketplace {
            id: object::new(ctx),
        };
        transfer::share_object(marketplace);
    }

    public fun list_item<T: key + store>(
        marketplace: &mut Marketplace,
        item: T,
        ask: u64,
        ctx: &mut TxContext
    ) {
        let item_id = object::id(&item);
        let listing = Listing {
            id: object::new(ctx),
            item_id,
            ask,
            owner: tx_context::sender(ctx),
        };

        dof::add(&mut marketplace.id, item_id, item);
        transfer::public_transfer(listing, tx_context::sender(ctx));
    }

    public fun purchase<T: key + store>(
        marketplace: &mut Marketplace,
        listing: Listing,
        payment: Coin<SUI>,
        ctx: &mut TxContext
    ): T {
        let Listing { id, item_id, ask, owner } = listing;

        assert!(coin::value(&payment) >= ask, 0);

        let item: T = dof::remove(&mut marketplace.id, item_id);

        transfer::public_transfer(payment, owner);
        object::delete(id);

        item
    }
}
```

---

## 🚀 Cómo Usar los Ejemplos

### 1. Preparación
```bash
# Configurar ambiente
sui client switch --env devnet
sui client faucet
```

### 2. Para cada ejemplo
```bash
# Crear proyecto
sui move new <nombre_ejemplo>
cd <nombre_ejemplo>

# Copiar código
# Editar Move.toml y archivos .move

# Compilar y probar
sui move build
sui move test

# Publicar
sui client publish --gas-budget 20000000
```

### 3. Interactuar
```bash
# Usar PACKAGE_ID retornado en el deploy
sui client call --function <función> --module <módulo> --package <PACKAGE_ID> --args <argumentos> --gas-budget 10000000
```

---

## 📚 Próximos Pasos

1. **Comienza con Hello World** - Entiende la estructura básica
2. **Practica con TodoList** - Aprende manipulación de datos
3. **Explora el Contador** - Ve objetos compartidos
4. **Crea tus variaciones** - Modifica los ejemplos
5. **Combina conceptos** - Mezcla diferentes funcionalidades

### 💡 Proyectos Sugeridos
- **TodoList con categorías** - Agrega tipos de tarea
- **Contador con múltiples usuarios** - Sistema de puntuación
- **Hello World personalizado** - Mensajes personalizables

## 🔗 Enlaces Útiles

### 🎯 Repositorios de los Ejemplos
- [📝 TodoList Original](https://github.com/gustavo-f0ntz/move-smart-todolist)
- [🎨 NFT con Display](https://github.com/gustavo-f0ntz/sui-nft-create/tree/master)

### 📚 Recursos Oficiales
- [📚 Más ejemplos oficiales](https://github.com/MystenLabs/sui/tree/main/examples/move)
- [🎓 Move Book](https://move-language.github.io/move/)
- [🌟 SUI by Example](https://examples.sui.io/)
