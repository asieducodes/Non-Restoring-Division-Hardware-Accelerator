module controller import pack_states::*; (
    input  logic clk,
    input  logic rst,

    // Status signals from datapath
    input  logic Amsb,
    input  logic count_gt_0,

    // Control signals to datapath
    output logic A_Rst,
    output logic A_load,
    output logic A_sel,

    output logic Q_load,
    output logic Q_sel,

    output logic M_load,

    output logic n_load,
    output logic cnt_sel,

    output logic alu_op,

    output logic out_en
);

    state_t ps, ns;


   =======
    // PRESENT STATE REGISTER
   =======

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            ps <= S0;
        else
            ps <= ns;
    end


   =======
    // NEXT STATE LOGIC
   =======

    always_comb begin

        ns = S0;

        case (ps)

            
            // Initialization
            
            S0: begin
                ns = S1;
            end


            
            // Check sign of A
            //
            // Amsb = 0 → A >= 0 → subtract M
            // Amsb = 1 → A < 0  → add M
            
            S1: begin
                if (Amsb)
                    ns = S2;
                else
                    ns = S3;
            end


            
            // Add operation
            
            S2: begin
                ns = S6;
            end


            
            // Subtract operation
            
            S3: begin
                ns = S6;
            end


            
            // Check counter
            
            S6: begin

                if (count_gt_0) begin
                    // More iterations required
                    ns = S1;
                end
                else begin

                    // Finished all iterations
                    if (Amsb)
                        ns = S4;
                    else
                        ns = S5;

                end

            end


            
            // Final restoration
            // A = A + M
            
            S4: begin
                ns = S5;
            end


            
            // Output
            
            S5: begin
                ns = S5;
            end


            default: begin
                ns = S0;
            end

        endcase

    end


   =======
    // OUTPUT / CONTROL SIGNAL DECODER
   =======

    always_comb begin

        // Default: hold everything
        A_Rst  = 1'b0;
        A_load = 1'b0;
        A_sel  = 1'b0;

        Q_load = 1'b0;
        Q_sel  = 1'b0;

        M_load = 1'b0;

        n_load = 1'b0;
        cnt_sel = 1'b0;

        alu_op = 1'b0;

        out_en = 1'b0;


        case (ps)

           
            // S0: INITIALIZATION
            //
            // A     = 0
            // Q     = Dividend
            // M     = Divisor
            // count = 4
           

            S0: begin

                A_Rst   = 1'b1;

                Q_load  = 1'b1;
                Q_sel   = 1'b0;       // Select dividend

                M_load  = 1'b1;

                n_load  = 1'b1;
                cnt_sel = 1'b0;       // Select 4

            end


           
            // S1: CHECK SIGN OF A
           

            S1: begin

                // Nothing changes in the datapath.
                // Controller only examines Amsb.

            end


           
            // S2: SHIFT + ADD
            //
            // Previous A < 0
            //
            // A = shifted_A + M
            // Q = shifted_Q with new Q0
            // count = count - 1
           

            S2: begin

                A_load  = 1'b1;
                A_sel   = 1'b0;       // Select shifted A

                Q_load  = 1'b1;
                Q_sel   = 1'b1;       // Select shifted Q

                n_load  = 1'b1;
                cnt_sel = 1'b1;       // Select count - 1

                alu_op  = 1'b0;       // ADD

            end


           
            // S3: SHIFT + SUBTRACT
            //
            // Previous A >= 0
            //
            // A = shifted_A - M
            // Q = shifted_Q with new Q0
            // count = count - 1
           

            S3: begin

                A_load  = 1'b1;
                A_sel   = 1'b0;       // Select shifted A

                Q_load  = 1'b1;
                Q_sel   = 1'b1;       // Select shifted Q

                n_load  = 1'b1;
                cnt_sel = 1'b1;       // Select count - 1

                alu_op  = 1'b1;       // SUBTRACT

            end


           
            // S6: CHECK COUNTER
           

            S6: begin

                // Hold all registers.
                // count_gt_0 determines the next state.

            end


           
            // S4: FINAL RESTORATION
            //
            // If final A < 0:
            //
            // A = A + M
            //
            // IMPORTANT:
            // A_sel = 1 selects the unshifted A.
           

            S4: begin

                A_load = 1'b1;

                A_sel  = 1'b1;        // Select current A

                alu_op = 1'b0;        // ADD M

            end


           
            // S5: OUTPUT
           

            S5: begin

                out_en = 1'b1;

            end


            default: begin

            end

        endcase

    end

endmodule