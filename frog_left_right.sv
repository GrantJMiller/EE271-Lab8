module frog_left_right(clk, hardReset, playfieldReset, L, R, row_in, row_out);

	input logic L, R, playfieldReset, hardReset, clk;
	input logic [3:0] row_in;
	output logic [3:0] row_out;

	logic [1:0] ps; 
	logic [1:0] ns; 

	// State logic
	parameter [1:0] left = 2'b00, right = 2'b01, noInput = 2'b10;
	
	logic [3:0] val;
	
	assign val = row_in;

	// NS logic
	always_comb begin
		case (ps)
			noInput: if (L && ~(row_in == 4'b1111))	// if in no input state and either signal is recieved, move to that state	
							 ns = left;
				else if (L && (row_in == 4'b1111))							
							 ns = noInput;
				else if (R && ~(row_in == 4'b0000))								
							 ns = right;
				else if (R && (row_in == 4'b0000))								
							 ns = noInput;
				else																			
							 ns = noInput;
			left: if (L && ~(row_in == 4'b1111))									
						 ns = left;
				else if ((L && (row_in == 4'b1111)) || (~L && ~R))				
							 ns = noInput;
				else																			
							 ns = right; // if the frog recieves a right signal in left state, go right
			right: if (R && ~(row_in == 4'b0000))									
						  ns = right;
				else if ((R && (row_in == 4'b0000)) || (~L && ~R))				
							 ns = noInput;
				else																			
							 ns = left;  // If frog recieves left signal in right state, go left
			default:	if (val == 4'b0111)												
							 ns = noInput;
				else																			
				ns = 2'b11;
		endcase
	end
	
	// assigning output logic
	always_ff @(posedge clk) begin
		if(playfieldReset || hardReset) begin
			row_out <= 4'b0111;
			ps <= noInput;
		end
		else begin
			case (ns)
				left: row_out <= val + 1;
				right: row_out <= val - 1;
				noInput:; // do nothing
				default:	row_out <= 4'b0111;
			endcase
			ps <= ns;
		end
	end
	
endmodule


module frog_left_right_testbench();
	logic L, R, playfieldReset, hardReset, clk;
	logic [3:0] row_in, row_out;
	
	frog_left_right dut (.L, .R, .row_in, .row_out, .playfieldReset, .hardReset, .clk);
	
	parameter CLOCK_PERIOD=100;
	initial begin
    	clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

	initial begin
		playfieldReset <= 0; L <= 0; R <= 0;
		
				
					 row_in <= row_out;		@(posedge clk);
		 			 row_in <= row_out;		@(posedge clk);
		L <= 1;   row_in <= row_out;		@(posedge clk);
		 		    row_in <= row_out;		@(posedge clk);
					 row_in <= row_out;		@(posedge clk);
		L <= 0;	 row_in <= row_out;		@(posedge clk);
	   L <= 1;   row_in <= row_out;		@(posedge clk);
		L <= 0;   row_in <= row_out;		@(posedge clk);
		L <= 1;   row_in <= row_out;		@(posedge clk);
		L <= 0;   row_in <= row_out;		@(posedge clk);
		L <= 1;   row_in <= row_out;		@(posedge clk);
		L <= 0;   row_in <= row_out;		@(posedge clk);
		L <= 1;   row_in <= row_out;		@(posedge clk);
		L <= 0;   row_in <= row_out;		@(posedge clk);
		L <= 1;   row_in <= row_out;		@(posedge clk);
		L <= 0;   row_in <= row_out;		@(posedge clk);
		R <= 1;   row_in <= row_out;		@(posedge clk);
		R <= 0;   row_in <= row_out;		@(posedge clk);
		R <= 1;   row_in <= row_out;		@(posedge clk);
		R <= 0;   row_in <= row_out;		@(posedge clk);
	   R <= 1;   row_in <= row_out;		@(posedge clk);
		R <= 1;   row_in <= row_out;		@(posedge clk);
		L <= 1;   row_in <= row_out;		@(posedge clk);
		L <= 0;   row_in <= row_out;		@(posedge clk);
	   L <= 1;   row_in <= row_out;		@(posedge clk);
		L <= 0;   row_in <= row_out;		@(posedge clk);
		L <= 1;   row_in <= row_out;		@(posedge clk);
		L <= 0;   row_in <= row_out;		@(posedge clk);
		L <= 1;   row_in <= row_out;		@(posedge clk);
		L <= 0;   row_in <= row_out;		@(posedge clk);
													@(posedge clk);
													@(posedge clk);
		R <= 1;   row_in <= row_out;		@(posedge clk);
		R <= 0;   row_in <= row_out;		@(posedge clk);
		R <= 1;   row_in <= row_out;		@(posedge clk);
		R <= 0;   row_in <= row_out;		@(posedge clk);
		playfieldReset <= 1;					@(posedge clk);
	   playfieldReset <= 0;					@(posedge clk);
		R <= 1;   row_in <= row_out;		@(posedge clk);
		R <= 0;   row_in <= row_out;		@(posedge clk);
		R <= 1;   row_in <= row_out;		@(posedge clk);
		R <= 0;   row_in <= row_out;		@(posedge clk);	
		R <= 1;   row_in <= row_out;		@(posedge clk);
		R <= 0;   row_in <= row_out;		@(posedge clk);
		L <= 1;   row_in <= row_out;		@(posedge clk);
		L <= 0;   row_in <= row_out;		@(posedge clk);
	   R <= 1;   row_in <= row_out;		@(posedge clk);
		R <= 1;   row_in <= row_out;		@(posedge clk);
		R <= 0;   row_in <= row_out;		@(posedge clk);
													@(posedge clk);
													@(posedge clk);
	   L <= 1;   row_in <= row_out;		@(posedge clk);
		L <= 0;   row_in <= row_out;		@(posedge clk);
		L <= 1;   row_in <= row_out;		@(posedge clk);
		L <= 0;   row_in <= row_out;		@(posedge clk);
	
		
	$stop;
	end
endmodule

