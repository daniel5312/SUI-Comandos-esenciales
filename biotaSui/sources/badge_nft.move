module biota_sui::badge_nft;

use std::string::{Self, String};
use sui::display;
use sui::object::{Self, UID};
use sui::package;
use sui::transfer;
use sui::tx_context::{Self, TxContext};

// ===== 2. Structs (Definiciones) =====

/// El Ticket Dorado (One Time Witness).
/// Sirve para demostrar que este módulo es auténtico al publicarse.
public struct BADGE_NFT has drop {}

/// El NFT (La Medalla).
/// Tiene key (existe en la red) y store (se puede guardar/transferir).
public struct BadgeNFT has key, store {
    id: UID,
    name: String,
    description: String,
    image_url: String,
}

// ===== 3. Funciones =====

/// FUNCIÓN INIT (Constructor)
/// Se ejecuta AUTOMÁTICAMENTE una sola vez al publicar.
/// Nos da el objeto "Publisher" para controlar cómo se ve el NFT.
fun init(otw: BADGE_NFT, ctx: &mut TxContext) {
    let publisher = package::claim(otw, ctx);
    transfer::public_transfer(publisher, tx_context::sender(ctx));
}

/// FUNCIÓN MINT (Crear NFT)
/// Cualquiera puede llamar a esta función para acuñar (crear) una medalla.
public entry fun mint(
    name: vector<u8>,
    description: vector<u8>,
    url: vector<u8>,
    ctx: &mut TxContext,
) {
    let badge = BadgeNFT {
        id: object::new(ctx),
        name: string::utf8(name),
        description: string::utf8(description),
        image_url: string::utf8(url),
    };

    // Enviamos el NFT recién creado a quien llamó la función.
    transfer::public_transfer(badge, tx_context::sender(ctx));
}

/// FUNCIÓN CREATE_DISPLAY (Vitrina)
/// Define qué datos ve la billetera o el explorador cuando miran tu NFT.
/// Requiere el objeto 'Publisher' que obtuvimos en el init.
public entry fun create_display(publisher: &package::Publisher, ctx: &mut TxContext) {
    let keys = vector[
        string::utf8(b"name"),
        string::utf8(b"description"),
        string::utf8(b"image_url"),
    ];

    let values = vector[
        string::utf8(b"{name}"),
        string::utf8(b"{description}"),
        string::utf8(b"{image_url}"),
    ];

    // Crea la configuración de visualización
    let mut display = display::new_with_fields<BadgeNFT>(
        publisher,
        keys,
        values,
        ctx,
    );

    // Guarda y activa la configuración
    display::update_version(&mut display);

    // Te envía el objeto Display a ti (para que puedas editarlo en el futuro si quieres)
    transfer::public_transfer(display, tx_context::sender(ctx));
}
