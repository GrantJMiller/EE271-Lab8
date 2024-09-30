module upCounter (out, trigger, reset, clk);
	output logic [15:0] out;
	input logic reset, clk;
	input logic trigger;
	
	logic [15:0] out_holder = 16'b0000000000000000;
	logic [15:0] holder_hold;
	always_comb begin
		if (reset)																							
			out_holder = '0;
		else if(out != 16'b0000000000000000)														
			out_holder = out;
		else if((out_holder == 16'b1000000000000000) && trigger)								
			out_holder = '0;
		else																									
			out_holder = holder_hold;
	end
	
	always_ff @(posedge clk) begin
		if (reset) begin
			out <= '0;
		end
		else if (trigger && (out_holder == 16'b0000000000000000)) begin
			out <= out_holder + 1;
		end
		else if (trigger && (out_holder != 16'b0000000000000000)) begin
			out <= out_holder << 1;
		end
		else begin
			out <= 16'b0000000000000000;
		end
		
		holder_hold <= out_holder;
	end
endmodule

module upCounter_testbench();
	logic [15:0] out;
	logic reset, clk;
	logic trigger;
	
	upCounter dut (.out, .trigger, .reset, .clk);
	
	parameter CLOCK_PERIOD=100;
	initial begin
    	clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		trigger <= 0;	reset <= 1;
		@(posedge clk);	reset <= 0;	trigger <= 1;
		@(posedge clk);	trigger <= 0;					
		@(posedge clk);	trigger <= 1;
		@(posedge clk);	trigger <= 0;
		@(posedge clk);	trigger <= 1;	
		@(posedge clk);	trigger <= 0;				
		@(posedge clk); 	trigger <= 1;     
		@(posedge clk);	trigger <= 0;
		@(posedge clk); 	trigger <= 1;             	 
		@(posedge clk);	trigger <= 1;
		@(posedge clk);	trigger <= 0;
		@(posedge clk);	trigger <= 1;	
		@(posedge clk);	trigger <= 0;				
		@(posedge clk); 	trigger <= 1;     
		@(posedge clk);	trigger <= 0;
		@(posedge clk); 	trigger <= 1;             	 
		@(posedge clk);	trigger <= 0;
		@(posedge clk); 	trigger <= 1;             	 
		@(posedge clk);	trigger <= 0;
		@(posedge clk);	trigger <= 1;
		@(posedge clk);	trigger <= 0;
		@(posedge clk);	trigger <= 1;	
		@(posedge clk);	trigger <= 0;				
		@(posedge clk); 	trigger <= 1;     
		@(posedge clk);	trigger <= 0;
		@(posedge clk); 	trigger <= 1;             	 
		@(posedge clk);	trigger <= 0;
		@(posedge clk); 	trigger <= 1;             	 
		@(posedge clk);	trigger <= 0;
		@(posedge clk);	trigger <= 1;
		@(posedge clk);	trigger <= 0;
		@(posedge clk);	trigger <= 1;	
		@(posedge clk);	trigger <= 0;				
		@(posedge clk); 	trigger <= 1;     
		@(posedge clk);	trigger <= 0;
		@(posedge clk); 	trigger <= 1;             	 
		@(posedge clk);	trigger <= 0;
		@(posedge clk); 	trigger <= 1;             	 
		@(posedge clk);	trigger <= 0;
		@(posedge clk);	trigger <= 1;
		@(posedge clk);	trigger <= 0;
		@(posedge clk);	trigger <= 1;	
		@(posedge clk);	trigger <= 0;				
		@(posedge clk); 	trigger <= 1;     
		@(posedge clk);	trigger <= 0;
		@(posedge clk); 	trigger <= 1;             	 
		@(posedge clk);	trigger <= 0;
		@(posedge clk); 	trigger <= 1;             	 
		@(posedge clk);	trigger <= 0;
		@(posedge clk);	trigger <= 1;
		@(posedge clk);	trigger <= 0;
		@(posedge clk);	trigger <= 1;	
		@(posedge clk);	trigger <= 0;			
		@(posedge clk);	
		@(posedge clk);			
		@(posedge clk);             	 
		@(posedge clk);
		@(posedge clk); 	trigger <= 1;             	 
		@(posedge clk);	trigger <= 0; 
		@(posedge clk);	reset <= 1;
		@(posedge clk);
		@(posedge clk); 	reset <= 0;
		@(posedge clk);
		@(posedge clk);

		$stop; // End the simulation
	end
endmodule
