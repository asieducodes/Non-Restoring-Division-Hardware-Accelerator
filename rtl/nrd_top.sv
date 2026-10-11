module top (

    input logic clk,
    input logic rst,

    input logic [3:0] dividend,
    input logic [3:0] divisor,

    output logic [3:0] Quotient,
    output logic [3:0] Remainder

);


    
    // STATUS SIGNALS
    

    logic Amsb;
    logic count_gt_0;


    
    // CONTROL SIGNALS
    

    logic A_Rst;
    logic A_load;
    logic A_sel;

    logic Q_load;
    logic Q_sel;

    logic M_load;

    logic n_load;
    logic cnt_sel;

    logic alu_op;

    logic out_en;


    
    // CONTROLLER
    

    controller control_unit (

        .clk        (clk),
        .rst        (rst),

        .Amsb       (Amsb),
        .count_gt_0 (count_gt_0),

        .A_Rst      (A_Rst),
        .A_load     (A_load),
        .A_sel      (A_sel),

        .Q_load     (Q_load),
        .Q_sel      (Q_sel),

        .M_load     (M_load),

        .n_load     (n_load),
        .cnt_sel    (cnt_sel),

        .alu_op     (alu_op),

        .out_en     (out_en)

    );


    
    // DATAPATH
    

    datapath datapath_unit (

        .clk (clk),

        .A_Rst  (A_Rst),
        .A_load (A_load),
        .A_sel  (A_sel),

        .Q_load (Q_load),
        .Q_sel  (Q_sel),

        .M_load (M_load),

        .n_load (n_load),
        .cnt_sel(cnt_sel),

        .alu_op (alu_op),

        .out_en (out_en),

        .dividend (dividend),
        .divisor  (divisor),

        .Amsb       (Amsb),
        .count_gt_0 (count_gt_0),

        .Quotient  (Quotient),
        .Remainder (Remainder)

    );


endmodule