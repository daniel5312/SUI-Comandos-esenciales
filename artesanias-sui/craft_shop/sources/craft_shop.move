module craft_shop::craft_shop;

use std::string::String;
use sui::coin::{Self, Coin};
use sui::object::{Self, ID};
use sui::transfer;
use sui::tx_context::TxContext;

/// Error codes
const ENotEnoughSui: u64 = 0;

// --- Objetos de la Tienda (Declarados como public) ---
public struct Manilla has key, store {
    id: ID,
    design: String,
    material: String,
}

public struct CraftShop has key {
    id: ID,
    price_in_mist: u64, // Precio en el token más pequeño de Sui
    owner: address,
}

// --- Funciones de Inicialización ---
fun init(ctx: &mut TxContext) {
    let initial_price = 1_000_000_000; // 1 SUI
    let shop = CraftShop {
        id: object::new(ctx),
        price_in_mist: initial_price,
        owner: tx_context::sender(ctx),
    };
    transfer::transfer(shop, tx_context::sender(ctx));
}

// --- Función de Compra ---
public entry fun buy_manilla(
    shop: &mut CraftShop,
    payment: Coin<sui::SUI>,
    design_name: String,
    material_type: String,
    ctx: &mut TxContext,
) {
    let amount = coin::value(&payment);
    assert!(amount >= shop.price_in_mist, ENotEnoughSui);

    let new_manilla = Manilla {
        id: object::new(ctx),
        design: design_name,
        material: material_type,
    };

    transfer::public_transfer(new_manilla, tx_context::sender(ctx));
    transfer::transfer(payment, shop.owner);
}
