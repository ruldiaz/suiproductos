module marketplace::products {
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::event;
    use std::string::{Self, String};

    // ========== STRUCTS ========== //
    struct Product has key, store {
        id: UID,
        sku: String,
        description: String,
        price: u64
    }

    // ========== EVENTOS ========== //
    struct ProductCreated has copy, drop {
        product_id: ID,
        sku: String
    }

    struct ProductUpdated has copy, drop {
        product_id: ID,
        field: String
    }

    struct ProductDeleted has copy, drop {
        product_id: ID
    }

    // ========== CONSTANTES ========== //
    const EPriceZero: u64 = 1;

    // ========== FUNCIONES PÚBLICAS ========== //
    public entry fun create_product(
        sku: String,
        description: String,
        price: u64,
        ctx: &mut TxContext
    ) {
        assert!(price > 0, EPriceZero);

        let product = Product {
            id: object::new(ctx),
            sku,
            description,
            price
        };

        event::emit(ProductCreated {
            product_id: object::uid_to_inner(&product.id),
            sku: product.sku
        });

        transfer::public_transfer(product, tx_context::sender(ctx));
    }

    public entry fun update_description(
        product: &mut Product,
        new_description: String
    ) {
        product.description = new_description;
        
        event::emit(ProductUpdated {
            product_id: object::uid_to_inner(&product.id),
            field: string::utf8(b"description")
        });
    }

    public entry fun update_price(
        product: &mut Product,
        new_price: u64
    ) {
        assert!(new_price > 0, EPriceZero);
        product.price = new_price;
        
        event::emit(ProductUpdated {
            product_id: object::uid_to_inner(&product.id),
            field: string::utf8(b"price")
        });
    }

    public entry fun delete_product(
        product: Product
    ) {
        let Product { id, sku: _, description: _, price: _ } = product;
        
        event::emit(ProductDeleted {
            product_id: object::uid_to_inner(&id)
        });

        object::delete(id);
    }

    public fun get_sku(product: &Product): &String {
        &product.sku
    }

    public fun get_description(product: &Product): &String {
        &product.description
    }

    public fun get_price(product: &Product): u64 {
        product.price
    }
}

#[test_only]
module marketplace::products_tests {
    use sui::test_scenario;
    use sui::object;
    use std::string;
    use marketplace::products::{Self, Product};

    #[test]
    fun test_product_lifecycle() {
        // 1. Setup inicial - use a proper address (not 0x0)
        let admin = @0xABCD;
        let scenario = test_scenario::begin(admin);
        
        // Create a test user
        let user = @0x1234;
        test_scenario::next_tx(&mut scenario, user);
        let ctx = test_scenario::ctx(&mut scenario);

        // 2. Creación del producto
        let sku = string::utf8(b"TEST-001");
        let description = string::utf8(b"Test Product");
        products::create_product(sku, description, 100, ctx);
        
        // 3. Advance to next transaction to ensure object is available
        test_scenario::next_tx(&mut scenario, user);
        
        // 4. Obtención del producto creado - use the correct address (user)
        let product = test_scenario::take_from_sender<Product>(&scenario);
        let _product_id = object::id(&product);

        // 5. Verificación inicial
        assert!(products::get_price(&product) == 100, 0);
        
        // 6. Comparación de strings
        let expected_sku = string::utf8(b"TEST-001");
        let actual_sku = products::get_sku(&product);
        assert!(string::as_bytes(actual_sku) == string::as_bytes(&expected_sku), 1);
        
        // 7. Actualización del precio
        products::update_price(&mut product, 150);
        assert!(products::get_price(&product) == 150, 2);

        // 8. Limpieza final
        products::delete_product(product);
        test_scenario::end(scenario);
    }
}