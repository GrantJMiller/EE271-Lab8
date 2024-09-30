
module LFSR (ps, clk, initialize, enable);
    output logic [8:0] ps;    
    input logic clk, initialize, enable;
    
    always_ff @(posedge clk) begin
        if (initialize) begin
            ps <= 9'b000000000;
        end else if (enable) begin
            ps <= {ps[7:0], ~(ps[8] ^ ps[4])};
        end
    end
endmodule

module LFSR_testbench();
	logic [8:0] ps;
	logic clk, initialize;
	
	LFSR dut (.ps, .clk, .initialize);
	
	parameter CLOCK_PERIOD=100;
	initial begin
    	clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		initialize <= 1;
									@(posedge clk);	
									@(posedge clk);	
		initialize <= 0;		@(posedge clk);	
									@(posedge clk);		
									@(posedge clk);					
									@(posedge clk); 	     
									@(posedge clk);	
									@(posedge clk); 	            	 
									@(posedge clk);	
									@(posedge clk); 	             	 
									@(posedge clk);	
									@(posedge clk);	

		$stop; 
	end
endmodule

