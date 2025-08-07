module my_add::IdentityRegistry {
    use aptos_framework::signer;
    use std::string::String;

    /// Error codes
    const E_IDENTITY_ALREADY_EXISTS: u64 = 1;
    const E_IDENTITY_NOT_FOUND: u64 = 2;
    const E_NOT_VERIFIED: u64 = 3;

    /// Struct representing a user's identity
    struct Identity has store, key {
        name: String,           // User's name
        email: String,          // User's email
        is_verified: bool,      // Verification status
        verification_level: u8, // Level of verification (1-5)
        timestamp: u64,         // Registration timestamp
    }

    /// Function to register a new identity
    public fun register_identity(
        user: &signer, 
        name: String, 
        email: String
    ) {
        // Check if identity already exists
        let user_addr = signer::address_of(user);
        assert!(!exists<Identity>(user_addr), E_IDENTITY_ALREADY_EXISTS);

        // Create new identity
        let identity = Identity {
            name,
            email,
            is_verified: false,
            verification_level: 0,
            timestamp: 0, // In real implementation, use timestamp::now_microseconds()
        };

        // Move identity to user's account
        move_to(user, identity);
    }

    /// Function to verify an identity (simplified verification)
    public fun verify_identity(
        verifier: &signer,
        user_address: address,
        verification_level: u8
    ) acquires Identity {
        // Check if identity exists
        assert!(exists<Identity>(user_address), E_IDENTITY_NOT_FOUND);
        
        // Get mutable reference to identity
        let identity = borrow_global_mut<Identity>(user_address);
        
        // Update verification status
        identity.is_verified = true;
        identity.verification_level = verification_level;
    }

    /// Function to check if an identity is verified
    public fun is_identity_verified(user_address: address): bool acquires Identity {
        if (!exists<Identity>(user_address)) {
            return false
        };
        
        let identity = borrow_global<Identity>(user_address);
        identity.is_verified
    }
}