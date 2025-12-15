module artesania_sui::craft_shop;

use std::string::{Self, String};
use sui::coin::{Self, Coin};
use sui::object::{Self, UID};
use sui::sui::{Self, SUI};
use sui::transfer;
use sui::tx_context::{Self, TxContext};

const ENotEnoughSui: u64 = 0;
const EInvalidProduct: u64 = 1;

// --- Structs ---
public struct Manilla has key, store {
    id: UID,
    material: String,
    design: String,
}

public struct CraftShop has key, store {
    id: UID,
    price: u64,
    owner: address,
}

// --- Init ---
fun init(ctx: &mut TxContext) {
    let shop = CraftShop {
        id: object::new(ctx),
        price: 1_000_000_000, // 1 SUI precio base
        owner: tx_context::sender(ctx),
    };
    //transfer::transfer(shop, tx_context::sender(ctx));
    transfer::share_object(shop); // ¡Ahora es compartida y pública!
}

// --- Compra ---
public entry fun buy_manilla(
    shop: &mut CraftShop,
    //payment: Coin<sui::sui::SUI>,//asi seria si no la importo arriba al principio
    payment: Coin<SUI>,
    design_name: String,
    ctx: &mut TxContext,
) {
    // Validación de precio
    let value = coin::value(&payment);
    assert!(value >= shop.price, ENotEnoughSui);

    // Lógica simple de productos para evitar errores de String complejos
    // Simplemente creamos la manilla con el nombre que el usuario pida
    let new_manilla = Manilla {
        id: object::new(ctx),
        material: string::utf8(b"Plata y Cuero"),
        design: design_name,
    };

    // Transferencias
    transfer::public_transfer(new_manilla, tx_context::sender(ctx));
    transfer::public_transfer(payment, shop.owner);
}
