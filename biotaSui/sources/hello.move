/// Módulo: Hello Sui - Primer Smart Contract
/// Objetivo: Crear un objeto simple que almacena un mensaje

// ADAPTACIÓN: Usamos el nombre de tu paquete 'Biota_sui'
module biota_sui::hello;

use std::string::String;
use sui::object::{Self, UID};
use sui::transfer;
use sui::tx_context::{Self, TxContext};

// ===== Structs =====

/// Representa un mensaje "Hello" en la blockchain
public struct HelloMessage has key, store {
    id: UID,
    text: String,
}

// ===== Entry Functions =====

/// Crea un nuevo mensaje y transfiere para quien llamó la función
public entry fun create_message(text: String, ctx: &mut TxContext) {
    let message = HelloMessage {
        id: object::new(ctx),
        text: text,
    };
    transfer::transfer(message, tx_context::sender(ctx));
}

/// Función de entrada para actualizar el mensaje de un objeto existente.
/// La clave es usar '&mut' (referencia mutable) para poder modificar el objeto.
public entry fun update_message(
    message: &mut HelloMessage, // Objeto a modificar
    new_text: String, // El nuevo valor
) {
    // La mutación (cambio de estado) ocurre aquí:
    message.text = new_text;
} // <--- Cierre del módulo
