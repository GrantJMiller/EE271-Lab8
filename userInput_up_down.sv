module userInput_up_down (clk, playfieldReset, hardReset, KEY1, KEY2, U, D);
	output logic U, D;
	input logic clk, playfieldReset, hardReset;
	input logic KEY1, KEY2;
	
	logic [1:0] ps; 
	logic [1:0] ns;

	parameter up = 1'b0, down = 1'b1;

	// NS logic
	always_comb begin
		case (ps)
			up: if ((~KEY1 && ~KEY2) || (KEY1 && KEY2))		
						ns = 2'b11;
				else if (~KEY2 && KEY1)		
							ns = up;
				else										
				ns = down;
			down: if ((~KEY1 && ~KEY2) || (KEY1 && KEY2))	
						  ns = 2'b11;
					else if (~KEY1 && KEY2)			
							   ns = down;
				else								
				ns = up;
			default: if ((~KEY1 && ~KEY2) || (KEY1 && KEY2))
							  ns = 2'b11;	
				else if (~KEY2)									
							ns = up; 
				else												
				ns = down;
		endcase
	end
	
	// Output logic
	always_ff @(posedge clk) begin
		if(playfieldReset || hardReset) begin
			U <= 0;
			D <= 0;
			ps <= 2'b11;
		end
		else begin
			U <= ~KEY2;
			D <= ~KEY1;
			
			case (ns)
				up: if (ps == up) begin
						U <= 0; 
						D <= 0;
					end
					else begin
						U <= 1; 
						D <= 0;
					end
				down: if (ps == down) begin
						U <= 0; 
						D <= 0;
					end
					else begin
						U <= 0; 
						D <= 1;
					end
				default: begin
					U <= 0; 
					D <= 0;
				end
			endcase

			ps <= ns;
		end
	end
	
endmodule

module userInput_up_down_testbench();
	logic clk, playfieldReset, hardReset, KEY1, KEY2;
	logic U, D;

	userInput_up_down dut (.clk, .playfieldReset, .hardReset, .KEY1, .KEY2, .U, .D);
    
	parameter CLOCK_PERIOD=100;
	initial begin
    	clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
 
	initial begin
		KEY1 <= 1; 	KEY2 <= 1; 	playfieldReset <= 1;			@(posedge clk);	
										playfieldReset <= 0;			@(posedge clk);
		KEY1 <= 0;														@(posedge clk);
																			@(posedge clk);
																			@(posedge clk);
		KEY1 <= 1;														@(posedge clk);
		KEY1 <= 0;					playfieldReset <= 1;			@(posedge clk);
																			@(posedge clk);
																			@(posedge clk);
		KEY1 <= 1;             										@(posedge clk);
																			@(posedge clk);
		KEY1 <= 0;														@(posedge clk);
										playfieldReset <= 0;			@(posedge clk);
		KEY1 <= 1; 	KEY2 <= 0;										@(posedge clk);
						KEY2 <= 1;										@(posedge clk);
																			@(posedge clk);
																			@(posedge clk);
						KEY2 <= 0;										@(posedge clk);
		KEY1 <= 0;					playfieldReset <= 0;			@(posedge clk);
																			@(posedge clk);
																			@(posedge clk);
																			@(posedge clk);
		$stop;
	end
endmodule
