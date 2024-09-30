// module to generate and move cars from right to left

module cars_RTL (clk, trigger, col_in, col_out, hardReset);
	input logic clk, trigger, hardReset;
	input logic [15:0] col_in;
	output logic [15:0] col_out;
	
	logic ps;
	logic ns;
	parameter generate_car = 1'b1, shift = 1'b0;
	
		// Next State logic
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
	
	// Output logic - could also be another always, or part of above block
	always_ff @(posedge clk) begin
		if (hardReset) begin
			col_out <= 16'b0000000000000000;
			ps <= shift;
		end
		
		else begin
			case (ns)
				generate_car:		col_out <= (col_in >> 1) + 32768;  	// generate a new car in right most column
				shift: 		col_out <= col_in >> 1; 	// shift cars 1 to the left
				default:		col_out <= 16'b0000000000000000;
			endcase
			ps <= ns;
		end
	end
endmodule

module cars_RTL_testbench();
	logic trigger, hardReset, clk;
	logic [15:0] col_in, col_out;
	
	cars_RTL dut (.clk, .hardReset, .trigger, .col_in(col_out), .col_out);
	
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
