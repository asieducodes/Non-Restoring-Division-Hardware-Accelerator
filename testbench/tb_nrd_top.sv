
module testbench;

    
    // SIGNALS
    logic       clk;
    logic       rst;
    logic [3:0] dividend;
    logic [3:0] divisor;
    logic [3:0] Quotient;
    logic [3:0] Remainder;

    top DUT (
        .clk       (clk),
        .rst       (rst),
        .dividend  (dividend),
        .divisor   (divisor),
        .Quotient  (Quotient),
        .Remainder (Remainder)
    );

    // Clock Generation (20ns Period)
    initial clk = 1'b0;
    always #10 clk = ~clk; 


    initial begin
        // Startup Initialization
        rst      = 1'b1;
        dividend = 4'd0;
        divisor  = 4'd0;
        repeat(2) @(posedge clk);
        #1 rst = 1'b0; 

        // TEST CASE 1: 13 / 3
        dividend = 4'd13;
        divisor  = 4'd3;

        @(posedge DUT.out_en); // Wait for calculation to finish
        #2;                    // Settle data
    
        $display("[CALCULATION COMPLETED]");
        $display("Inputs  => Dividend: %0d | Divisor: %0d", dividend, divisor);
        $display("Outputs => Quotient: %0d | Remainder: %0d", Quotient, Remainder);
        if (Quotient === 4'd4 && Remainder === 4'd1) 
            $display("STATUS  => PASS");
        else 
            $display("STATUS  => FAIL (Expected Q=4, R=1)");

        // VISUAL HOLD WINDOW: View outputs on screen before next inputs arrive
        repeat (3) @(posedge clk); 

        
        // TEST CASE 2: 15 / 3
        
        #1 rst = 1'b1; // Safe to reset now
        @(posedge clk);
        #1 rst = 1'b0;
        
        dividend = 4'd15;
        divisor  = 4'd3;

        @(posedge DUT.out_en); 
        #2;

        
        $display("[CALCULATION COMPLETED]");
        $display("Inputs  => Dividend: %0d | Divisor: %0d", dividend, divisor);
        $display("Outputs => Quotient: %0d | Remainder: %0d", Quotient, Remainder);
        if (Quotient === 4'd5 && Remainder === 4'd0) 
            $display("STATUS  => PASS");
        else 
            $display("STATUS  => FAIL (Expected Q=5, R=0)");
        

        //  VISUAL HOLD WINDOW: View outputs on screen before next inputs arrive
        repeat (3) @(posedge clk); 

        
        // TEST CASE 3: 9 / 4
        
        #1 rst = 1'b1;
        @(posedge clk);
        #1 rst = 1'b0;

        dividend = 4'd9;
        divisor  = 4'd4;

        @(posedge DUT.out_en);
        #2;
        
        $display("[CALCULATION COMPLETED]");
        $display("Inputs  => Dividend: %0d | Divisor: %0d", dividend, divisor);
        $display("Outputs => Quotient: %0d | Remainder: %0d", Quotient, Remainder);
        if (Quotient === 4'd2 && Remainder === 4'd1) 
            $display("STATUS  => PASS");
        else 
            $display("STATUS  => FAIL (Expected Q=2, R=1)");

        //  VISUAL HOLD WINDOW: Final screen stabilization
        repeat (3) @(posedge clk); 

        $finish;
    end

endmodule
