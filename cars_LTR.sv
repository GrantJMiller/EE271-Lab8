// module to generate and move cars from left to right

module cars_LTR (clk, trigger, col_in, col_out, hardReset);
	input logic clk, trigger, hardReset;
	input logic [15:0] col_in;
	output logic [15:0] col_out;
	
	logic ps; 
	logic ns;
	parameter generate_car = 1'b1, shift = 1'b0;
	
		// NS logic
	always_comb begin
		case (ps)
			generate_car: if (trigger)	
									ns = generate_car;
							  else	
							      ns = shift;
			shift: if (trigger)		
						  ns = generate_car;	
					 else 							
						  ns = shift; 
			default: if (~trigger)		
							 ns = shift;
				      else 					
							 ns = generate_car;
		endcase
	end
	
	// Output logic
	always_ff @(posedge clk) begin
		if (hardReset) begin
			col_out <= 16'b0000000000000000;
			ps <= shift;
		end
		
		else begin
			case (ns)
				generate_car:		col_out <= (col_in << 1) + 1;	// generates a new car in the leftmost column
				shift: 		col_out <= col_in << 1;		// shifts car one to the right 
				default:		col_out <= 16'b0000000000000000;
			endcase
		ps <= ns;
		
		end
	end
endmodule

module cars_LTR_testbench();
	logic trigger, hardReset, clk;
	logic [15:0] col_in, col_out;
	
	cars_LTR dut (.clk, .trigger, .col_in(col_out), .col_out, .hardReset);
	
	parameter CLOCK_PERIOD=100;
	initial begin
    	clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

	initial begin
		col_in <= 16'b0000000000000000;
		col_out <= 16'b0000000000000000;
		hardReset <= 0; trigger <= 0;
		
											       @(posedge clk);
						trigger <= 1;			 @(posedge clk);
													 @(posedge clk); 			 
						trigger <= 0;			 @(posedge clk); 			 
													 @(posedge clk);
													 @(posedge clk);
													 @(posedge clk); 
													 @(posedge clk);
													 @(posedge clk);
						trigger <= 1;			 @(posedge clk); 
						trigger <= 0;			 @(posedge clk); 
						trigger <= 1;		    @(posedge clk); 
													 @(posedge clk);
						trigger <= 0;		    @(posedge clk); 
						trigger <= 1;			 @(posedge clk); 
						trigger <= 0;		    @(posedge clk);
													 @(posedge clk);
		
	$stop; 
	end
endmodule
