// Trigger is true more often when more switches (0 - 5) are switched on.
// This effectively creates more cars when more switches are active. 
module trigger_proc (SW, adder_out, OF, trigger, clk, enable);
    input logic clk, enable;
    input logic OF;
    input logic [5:0] SW;
    input logic [9:0] adder_out;
    output logic trigger;
    
    int switch_decimal;
    int adder_decimal;
    
    always_ff @(posedge clk) begin
        if (enable) begin
            switch_decimal = int'(SW);
            adder_decimal = int'(adder_out);
            
            if(OF)                                            
                trigger <= 1;
            else if(switch_decimal == 0)                        
                trigger <= 0;
            else if(switch_decimal >= 1 && switch_decimal < 3 && adder_decimal > 400)
                trigger <= 1; 
            else if(switch_decimal >= 3 && switch_decimal < 7 && adder_decimal > 400)    
                trigger <= 1;
            else if(switch_decimal >= 7 && switch_decimal < 15 && adder_decimal > 300)    
                trigger <= 1;
            else if(switch_decimal >= 15 && switch_decimal < 31 && adder_decimal > 300)
                trigger <= 1;
            else if(switch_decimal >= 31 && switch_decimal < 63 && adder_decimal > 150)
                trigger <= 1;
            else if(switch_decimal >= 63 && switch_decimal < 127 && adder_decimal > 150)
                trigger <= 1;
            else                                            
                trigger <= 0;
        end
    end
endmodule 

module trigger_proc_testbench();
	logic [5:0] SW;
	logic [9:0] adder_out;
	logic OF, clk;
	logic trigger;
	
	trigger_proc dut (.SW, .adder_out, .OF, .trigger, .clk);
	
	parameter CLOCK_PERIOD=100;
	initial begin
    	clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	 
	initial begin
		OF <= 0; trigger <= 0; SW <= '0;		@(posedge clk);
		adder_out <= 410;							@(posedge clk);
														@(posedge clk);
		OF <= 1; 									@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
		OF <= 0;									   @(posedge clk);
														@(posedge clk);
		SW <= 6'b000001; 							@(posedge clk);
														@(posedge clk);
		SW <= 6'b000000; 							@(posedge clk);
														@(posedge clk);
		SW <= 6'b000011; 							@(posedge clk);
														@(posedge clk);
		SW <= 6'b000000; 							@(posedge clk);
														@(posedge clk);
		SW <= 6'b000111; 							@(posedge clk);
														@(posedge clk);
		SW <= 6'b000000; 							@(posedge clk);
														@(posedge clk);
		SW <= 6'b001111; 							@(posedge clk);
														@(posedge clk);
		SW <= 6'b000000; 							@(posedge clk);
														@(posedge clk);
		SW <= 6'b011111; 							@(posedge clk);
														@(posedge clk);
		SW <= 6'b000000; 							@(posedge clk);
														@(posedge clk);
		SW <= 6'b111111; 							@(posedge clk);
														@(posedge clk);
		SW <= 6'b000000; 							@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
				
	$stop;
	end
	
endmodule

