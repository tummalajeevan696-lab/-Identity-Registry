module my_add::IdentityRegistry {
    use aptos_framework::signer;
    use std::string::String;

    
    const E_IDENTITY_ALREADY_EXISTS: u64 = 1;
    const E_IDENTITY_NOT_FOUND: u64 = 2;
    const E_NOT_VERIFIED: u64 = 3;

    
    struct Identity has store, key {
        name: String,           
        email: String,          
        is_verified: bool,     
        verification_level: u8, 
        timestamp: u64,         
    }

    
    public fun register_identity(
        user: &signer, 
        name: String, 
        email: String
    ) {
        
        let user_addr = signer::address_of(user);
        assert!(!exists<Identity>(user_addr), E_IDENTITY_ALREADY_EXISTS);

        
        let identity = Identity {
            name,
            email,
            is_verified: false,
            verification_level: 0,
            timestamp: 0, 
        };

        
        move_to(user, identity);
    }

    
    public fun verify_identity(
        verifier: &signer,
        user_address: address,
        verification_level: u8
    ) acquires Identity {
        
        assert!(exists<Identity>(user_address), E_IDENTITY_NOT_FOUND);
        
        
        let identity = borrow_global_mut<Identity>(user_address);
        
        
        identity.is_verified = true;
        identity.verification_level = verification_level;
    }

    
    public fun is_identity_verified(user_address: address): bool acquires Identity {
        if (!exists<Identity>(user_address)) {
            return false
        };
        
        let identity = borrow_global<Identity>(user_address);
        identity.is_verified
    }
}
