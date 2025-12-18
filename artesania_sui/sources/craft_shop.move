module artesania_sui::craft_shop;

use std::string::{Self, String};
use sui::coin::{Self, Coin};
use sui::display;
use sui::object::{Self, UID};
use sui::package;
use sui::sui::SUI;
use sui::transfer;
use sui::tx_context::{Self, TxContext};

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

public struct CRAFT_SHOP has drop {}

fun init(otw: CRAFT_SHOP, ctx: &mut TxContext) {
    let keys = vector[
        string::utf8(b"name"),
        string::utf8(b"description"),
        string::utf8(b"image_url"),
    ];
    let values = vector[
        string::utf8(b"{design}"),
        string::utf8(b"Artesanía única de {material}"),
        string::utf8(
            b"https://ipfs.io/ipfs/bafkreifvni56llsf4yvqrckbezpm27ni7ggcezwc4ey42f7r4qri2vj7a4",
        ), // URL de ejemplo
    ];

    let publisher = package::claim(otw, ctx);
    let mut display = display::new_with_fields<Manilla>(&publisher, keys, values, ctx);
    display::update_version(&mut display);

    transfer::public_transfer(publisher, tx_context::sender(ctx));
    transfer::public_transfer(display, tx_context::sender(ctx));

    transfer::share_object(CraftShop {
        id: object::new(ctx),
        price: 1_000_000_000,
        owner: tx_context::sender(ctx),
    });
}

public entry fun buy_manilla(
    shop: &mut CraftShop,
    payment: Coin<SUI>,
    design_name: String,
    ctx: &mut TxContext,
) {
    assert!(coin::value(&payment) >= shop.price, 0);
    let new_manilla = Manilla {
        id: object::new(ctx),
        material: string::utf8(b"Plata y Cuero"),
        design: design_name,
    };
    transfer::public_transfer(new_manilla, tx_context::sender(ctx));
    transfer::public_transfer(payment, shop.owner);
}
