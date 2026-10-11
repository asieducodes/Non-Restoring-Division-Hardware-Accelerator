// 1. 4-BIT REGISTER


module reg4 (
    input  logic       clk,
    input  logic       rst,
    input  logic       load,
    input  logic [3:0] D,
    output logic [3:0] Q
);

    always_ff @(posedge clk) begin
        if (rst)
            Q <= 4'b0000;
        else if (load)
            Q <= D;
    end

endmodule



// 2. 4-BIT 2-to-1 MULTIPLEXER
//
// sel = 0 → B
// sel = 1 → A


module mux2x1 (
    input  logic [3:0] A,
    input  logic [3:0] B,
    input  logic       sel,
    output logic [3:0] Y
);

    assign Y = sel ? A : B;

endmodule



// 3. COMBINED A-Q LEFT SHIFTER
//
// A = 5 bits
// Q = 4 bits
//
// Combined:
//
//     {A,Q} = 9 bits
//
// Operation:
//
//     {A,Q} << 1
//
// After shifting:
//
//     shifted_A = {A[3:0], Q[3]}
//     shifted_Q = {Q[2:0], 1'b0}
//
// The Q[0] position will later be replaced by the new
// quotient bit generated from the sign of the new A.


module shifter (
    input  logic [4:0] A,
    input  logic [3:0] Q,
    output logic [4:0] shifted_A,
    output logic [2:0] shifted_Q
);

    assign shifted_A = {A[3:0], Q[3]};
    assign shifted_Q = Q[2:0];

endmodule



// 4. TRI-STATE BUFFER
//
// en = 1 → output A
// en = 0 → high impedance


module tristate_buff (
    input  logic [3:0] A,
    input  logic       en,
    output logic [3:0] Y
);

    assign Y = en ? A : 4'bzzzz;

endmodule



// 5. COMPARATOR
//
// Determines whether a value is greater than zero.
//
// count_gt_0 = 1 → count is not zero
// count_gt_0 = 0 → count is zero


module comp (
    input  logic [3:0] A,
    output logic       Y
);

    assign Y = (A != 4'd0);

endmodule



// 6. DECREMENTER
//
// Y = A - 1


module dec (
    input  logic [3:0] A,
    output logic [3:0] Y
);

    assign Y = A - 4'd1;

endmodule



// 7. ZERO EXTENSION
//
// Converts the 4-bit divisor M into a 5-bit value.
//
// Example:
//
//     M     = 4'b0011
//     M_ext = 5'b00011
//
// The module is called sign_extension to remain compatible
// with the current datapath.


module sign_extension (
    input  logic [3:0] A,
    output logic [4:0] Y
);

    assign Y = {1'b0, A};

endmodule



// 8. 5-BIT ACCUMULATOR REGISTER
//
// A is n+1 bits.
//
// For n = 4:
//
//     A = 5 bits


module reg5 (
    input  logic       clk,
    input  logic       rst,
    input  logic       load,
    input  logic [4:0] D,
    output logic [4:0] Q
);

    always_ff @(posedge clk) begin
        if (rst)
            Q <= 5'b00000;
        else if (load)
            Q <= D;
    end

endmodule



// 9. 5-BIT 2-to-1 MULTIPLEXER
//
// sel = 0 → B
// sel = 1 → A
//
// In our datapath:
//
//     A → current/unshifted A
//     B → shifted A


module mux2x1_5bit (
    input  logic [4:0] A,
    input  logic [4:0] B,
    input  logic       sel,
    output logic [4:0] Y
);

    assign Y = sel ? A : B;

endmodule



// 10. 5-BIT ADDER / SUBTRACTOR
//
// sub = 0 → A + B
// sub = 1 → A - B
//
// Used by the non-restoring algorithm:
//
//     A = A + M
//     A = A - M


module adder_sub5 (
    input  logic [4:0] A,
    input  logic [4:0] B,
    input  logic       sub,
    output logic [4:0] Y
);

    assign Y = sub ? (A - B) : (A + B);

endmodule