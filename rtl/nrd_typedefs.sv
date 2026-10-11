package pack_states;

    typedef enum logic [2:0] {
        S0 = 3'b000,   // Initialization
        S1 = 3'b001,   // Check sign of A
        S2 = 3'b010,   // Shift + Add M
        S3 = 3'b011,   // Shift + Subtract M
        S4 = 3'b100,   // Final restoration
        S5 = 3'b101,   // Output result
        S6 = 3'b110    // Check counter
    } state_t;

endpackage