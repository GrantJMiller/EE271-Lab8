// Module to keep track of the state of the game
module gameState_decoding (row_out, col_out, col, row);
	output int col;
	output logic [15:0] row;
	input logic [3:0] row_out, col_out; // 4 bit signals representing column and row number
	
	parameter [3:0] s0 = 4'b0000, s1 = 4'b0001, s2 = 4'b0010, s3 = 4'b0011, s4 = 4'b0100,
		s5 = 4'b0101, s6 = 4'b0110, s7 = 4'b0111, s8 = 4'b1000, s9 = 4'b1001, s10 = 4'b1010,
		s11 = 4'b1011, s12 = 4'b1100, s13 = 4'b1101, s14 = 4'b1110, s15 = 4'b1111;
	
	always_comb begin
		if 	  (row_out == s0)		row = 16'b0000000000000001;
		else if (row_out == s1)		row = 16'b0000000000000010;
		else if (row_out == s2)		row = 16'b0000000000000100;
		else if (row_out == s3)		row = 16'b0000000000001000;
		else if (row_out == s4)		row = 16'b0000000000010000;
		else if (row_out == s5)		row = 16'b0000000000100000;
		else if (row_out == s6)		row = 16'b0000000001000000;
		else if (row_out == s7)		row = 16'b0000000010000000;
		else if (row_out == s8)		row = 16'b0000000100000000;
		else if (row_out == s9)		row = 16'b0000001000000000;
		else if (row_out == s10)	row = 16'b0000010000000000;
		else if (row_out == s11)	row = 16'b0000100000000000;
		else if (row_out == s12)	row = 16'b0001000000000000;
		else if (row_out == s13)	row = 16'b0010000000000000;
		else if (row_out == s14)	row = 16'b0100000000000000;
		else								row = 16'b1000000000000000;	
			
		col = int'(col_out);
	end
endmodule

module gameState_decoding_testbench();

	logic [3:0] row_out, col_out;
	logic [15:0] row;
	logic clk;
	int col;
	
	gameState_decoding dut (.row_out, .col_out, .col, .row);

	parameter CLOCK_PERIOD=100;
	initial begin
    	clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		row_out <= 4'b0000; col_out <= 4'b0000;		@(posedge clk);
																	@(posedge clk);
		row_out <= 4'b0001; col_out <= 4'b0001;		@(posedge clk);
																	@(posedge clk);
		row_out <= 4'b0010; col_out <= 4'b0010;		@(posedge clk);
																	@(posedge clk);
		row_out <= 4'b0011; col_out <= 4'b0011;		@(posedge clk);
																	@(posedge clk);
		row_out <= 4'b0100; col_out <= 4'b0100;		@(posedge clk);
																	@(posedge clk);
		row_out <= 4'b0101; col_out <= 4'b0101;		@(posedge clk);
																	@(posedge clk);
		row_out <= 4'b0110; col_out <= 4'b0110;		@(posedge clk);
																	@(posedge clk);
		row_out <= 4'b0111; col_out <= 4'b0111;		@(posedge clk);
																	@(posedge clk);
		row_out <= 4'b1000; col_out <= 4'b1000;		@(posedge clk);
																	@(posedge clk);
		row_out <= 4'b1001; col_out <= 4'b1001;		@(posedge clk);
																	@(posedge clk);
		row_out <= 4'b1010; col_out <= 4'b1010;		@(posedge clk);
																	@(posedge clk);
		row_out <= 4'b1011; col_out <= 4'b1011;		@(posedge clk);
																	@(posedge clk);
		row_out <= 4'b1100; col_out <= 4'b1100;		@(posedge clk);
																	@(posedge clk);
		row_out <= 4'b1101; col_out <= 4'b1101;		@(posedge clk);
																	@(posedge clk);	
		row_out <= 4'b1110; col_out <= 4'b1110;		@(posedge clk);
																	@(posedge clk);
		row_out <= 4'b1111; col_out <= 4'b1111;		@(posedge clk);
																	@(posedge clk);
																	@(posedge clk);
	$stop;
	end
endmodule
