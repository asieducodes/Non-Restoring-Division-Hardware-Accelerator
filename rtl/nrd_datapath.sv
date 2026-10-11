module datapath (

    input logic clk,

    
    // Control signals
    

    input logic A_Rst,
    input logic A_load,
    input logic A_sel,

    input logic Q_load,
    input logic Q_sel,

    input logic M_load,

    input logic n_load,
    input logic cnt_sel,

    input logic alu_op,

    input logic out_en,


    
    // Inputs
    

    input logic [3:0] dividend,
    input logic [3:0] divisor,


    
    // Status outputs
    

    output logic Amsb,
    output logic count_gt_0,


    
    // Result outputs
    

    output logic [3:0] Quotient,
    output logic [3:0] Remainder

);


    
    // INTERNAL SIGNALS
    

    // A register
    logic [4:0] A_out;
    logic [4:0] A_in;

    // Q register
    logic [3:0] Q_out;
    logic [3:0] Q_in;

    // M register
    logic [3:0] M_out;

    // Counter
    logic [3:0] count_out;
    logic [3:0] count_in;
    logic [3:0] count_dec;

    // Extended M
    logic [4:0] M_ext;

    // Shifted A and Q
    logic [4:0] shifted_A;
    logic [2:0] shifted_Q;

    // Q shift result
    logic [3:0] Q_shift_path;

    // A multiplexer output
    logic [4:0] A_mux_out;


    
    // 1. A REGISTER
    

    reg5 register_A (

        .clk  (clk),
        .rst  (A_Rst),
        .load (A_load),

        .D    (A_in),
        .Q    (A_out)

    );


    
    // 2. A SIGN CHECK
    //
    // A[4] is the sign bit.
    //
    // 0 → A >= 0
    // 1 → A < 0
    

    assign Amsb = A_out[4];


    
    // 3. A-Q COMBINED SHIFT
    

    shifter aq_shifter (

        .A          (A_out),
        .Q          (Q_out),

        .shifted_A (shifted_A),
        .shifted_Q (shifted_Q)

    );


    
    // 4. A MULTIPLEXER
    //
    // A_sel = 0 → shifted A
    // A_sel = 1 → current A
    //
    // During normal iterations:
    //     select shifted A
    //
    // During final restoration:
    //     select current A
    

    mux2x1_5bit A_mux (

        .A   (A_out),
        .B   (shifted_A),
        .sel (A_sel),
        .Y   (A_mux_out)

    );


    
    // 5. M REGISTER / EXTENSION
    

    reg4 register_M (

        .clk  (clk),
        .rst  (1'b0),
        .load (M_load),

        .D    (divisor),
        .Q    (M_out)

    );


    sign_extension M_extender (

        .A (M_out),
        .Y (M_ext)

    );


    
    // 6. ADDER / SUBTRACTOR
    //
    // alu_op = 0 → ADD
    // alu_op = 1 → SUBTRACT
    

    adder_sub5 ALU (

        .A   (A_mux_out),
        .B   (M_ext),
        .sub (alu_op),
        .Y   (A_in)

    );


    
    // 7. Q REGISTER
    //
    // During initialization:
    //     Q = dividend
    //
    // During iterations:
    //     Q = {Q[2:0], new_Q0}
    //
    // new_Q0 = 1 when new A >= 0
    // new_Q0 = 0 when new A < 0
    

    assign Q_shift_path = {
        shifted_Q,
        ~A_in[4]
    };


    mux2x1 Q_mux (

        .A   (Q_shift_path),
        .B   (dividend),
        .sel (Q_sel),
        .Y   (Q_in)

    );


    reg4 register_Q (

        .clk  (clk),
        .rst  (1'b0),
        .load (Q_load),

        .D    (Q_in),
        .Q    (Q_out)

    );


    
    // 8. COUNTER
    

    dec counter_decrement (

        .A (count_out),
        .Y (count_dec)

    );


    // cnt_sel = 0 → load 4
    // cnt_sel = 1 → load count - 1

    mux2x1 counter_mux (

        .A   (count_dec),
        .B   (4'd4),
        .sel (cnt_sel),
        .Y   (count_in)

    );


    reg4 register_count (

        .clk  (clk),
        .rst  (1'b0),
        .load (n_load),

        .D    (count_in),
        .Q    (count_out)

    );


    
    // 9. COUNTER STATUS
    //
    // 1 → more iterations remain
    // 0 → division is complete
    

    comp counter_compare (

        .A (count_out),
        .Y (count_gt_0)

    );


    
    // 10. OUTPUTS
    

    tristate_buff quotient_buffer (

        .A  (Q_out),
        .en (out_en),
        .Y  (Quotient)

    );


    tristate_buff remainder_buffer (

        .A  (A_out[3:0]),
        .en (out_en),
        .Y  (Remainder)

    );


endmodule