module biota_sui::hello;

use std::string::String;
use sui::object::{Self, UID};
use sui::transfer;
use sui::tx_context::{Self, TxContext};

// ===== Structs (La Caja LEGO) =====
public struct HelloMessage has key, store {
    id: UID,
    text: String,
}

// ===== Entry Functions (La Puerta Principal) =====

/// 1. CREACIÓN: Fabrica un nuevo objeto y lo transfiere.
public entry fun create_message(text: String, ctx: &mut TxContext) {
    let message = HelloMessage {
        id: object::new(ctx),
        text: text,
    };
    transfer::transfer(message, tx_context::sender(ctx));
}

/// 2. MUTACIÓN/ACTUALIZACIÓN: Cambia el contenido de un objeto existente.
public entry fun update_message(
    message: &mut HelloMessage, // Objeto a modificar (Referencia Mutable)
    new_text: String, // El nuevo valor
) {
    // Asigna el nuevo texto al campo 'text' del objeto
    message.text = new_text;
}
