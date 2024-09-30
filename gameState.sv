module gameState (clk, hardReset, playfieldReset, L, R, U, D, GrnPixels, col, row);
    input logic L, R, U, D, playfieldReset, hardReset, clk;
    output logic [15:0][15:0] GrnPixels; // Output for a 16x16 array of green LEDs
    output int col; // Output for the column position
    output logic [15:0] row; // Output for the row position
    
    // Internal signals for row and column
    logic [3:0] row_in, row_out;
    logic [3:0] col_in, col_out;
    
    // Instantiation of modules for left-right and up-down movement
    frog_left_right LR1 (.L, .R, .row_in, .row_out, .playfieldReset, .hardReset, .clk); // Instantiating left-right module
    frog_up_down UD1 (.U, .D, .col_in, .col_out, .playfieldReset, .hardReset, .clk); // Instantiating up-down module
    
    gameState_decoding dec1 (.row_out, .col_out, .col, .row); // Decoding module to obtain row and column
    
    // Updates green board LEDs based on inputs
    always_ff @(posedge clk) begin
        if(playfieldReset || hardReset) begin // Reset condition
            GrnPixels [15:0] <= 16'b0000000000000000; // Reset GrnPixels
        end
        else begin
            col_in <= col_out; 
            row_in <= row_out; 
            GrnPixels [15:0] <= 16'b0000000000000000; // Reset GrnPixels
            GrnPixels [col] <= row; // Set the specified LED in GrnPixels based on row and column
        end
    end
endmodule

module gameState_testbench();
	logic L, R, U, D, playfieldReset, hardReset, clk;
   logic [15:0][15:0] GrnPixels;
	
	gameState dut (.L, .R, .U, .D, .GrnPixels, .playfieldReset, .hardReset, .clk);
	
	parameter CLOCK_PERIOD=100;
	initial begin
    	clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

	initial begin
		// Initial setup
		playfieldReset <= 1; @(posedge clk); 
		D <= 0; 					@(posedge clk); 
		U <= 0; 					@(posedge clk); 
		L <= 0; 					@(posedge clk); 
		R <= 0; 					@(posedge clk); 
		playfieldReset <= 0; @(posedge clk);

		// Move Up sequence
		U <= 1; 					@(posedge clk);
		U <= 0; 					@(posedge clk);
		U <= 1; 					@(posedge clk);
		U <= 0; 					@(posedge clk);
		U <= 1; 					@(posedge clk);
		U <= 0; 					@(posedge clk);
		U <= 1; 					@(posedge clk);
		U <= 0; 					@(posedge clk);
		U <= 1; 					@(posedge clk);
		U <= 0; 					@(posedge clk);
		U <= 1; 					@(posedge clk);
		U <= 0; 					@(posedge clk);
		U <= 1; 					@(posedge clk);
		U <= 0; 					@(posedge clk);
		U <= 1; 					@(posedge clk);
		U <= 0; 					@(posedge clk);
		U <= 1; 					@(posedge clk);
		U <= 0; 					@(posedge clk);
		U <= 1; 					@(posedge clk);
		U <= 0; 					@(posedge clk);
		U <= 1; 					@(posedge clk);
		U <= 0; 					@(posedge clk);
		U <= 1; 					@(posedge clk);
		U <= 0; 					@(posedge clk);
		U <= 1; 					@(posedge clk);
		U <= 0; 					@(posedge clk);
		U <= 1; 					@(posedge clk);
		U <= 0; 					@(posedge clk);
		U <= 1; 					@(posedge clk);
		U <= 0; 					@(posedge clk);
		U <= 1; 					@(posedge clk);
		U <= 0; 					@(posedge clk);
		U <= 1; 					@(posedge clk);
		U <= 0; 					@(posedge clk);

		// Move Down sequence
		D <= 1; 					@(posedge clk);
		D <= 0; 					@(posedge clk);
		D <= 1; 					@(posedge clk);
		D <= 0; 					@(posedge clk);
		D <= 1; 					@(posedge clk);
		D <= 0; 					@(posedge clk);
		D <= 1; 					@(posedge clk);
		D <= 0; 					@(posedge clk);
		D <= 1; 					@(posedge clk);
		D <= 0; 					@(posedge clk);
		D <= 1; 					@(posedge clk);
		D <= 0; 					@(posedge clk);
		D <= 1; 					@(posedge clk);
		D <= 0; 					@(posedge clk);
		D <= 1; 					@(posedge clk);
		D <= 0; 					@(posedge clk);
		D <= 1; 					@(posedge clk);
		D <= 0; 					@(posedge clk);
		D <= 1; 					@(posedge clk);
		D <= 0; 					@(posedge clk);
		D <= 1; 					@(posedge clk);
		D <= 0; 					@(posedge clk);
		D <= 1; 					@(posedge clk);
		D <= 0; 					@(posedge clk);
		D <= 1; 					@(posedge clk);
		D <= 0; 					@(posedge clk);
		D <= 1; 					@(posedge clk);
		D <= 0; 					@(posedge clk);
		D <= 1; 					@(posedge clk);
		D <= 0; 					@(posedge clk);
	

		// Move Left sequence
		L <= 1; 					@(posedge clk);
		L <= 0; 					@(posedge clk);
		L <= 1; 					@(posedge clk);
		L <= 0; 					@(posedge clk);
		L <= 1; 					@(posedge clk);
		L <= 0; 					@(posedge clk);
		L <= 1; 					@(posedge clk);
		L <= 0; 					@(posedge clk);
		L <= 1; 					@(posedge clk);
		L <= 0; 					@(posedge clk);
		L <= 1;					@(posedge clk);
		L <= 0; 					@(posedge clk);
		L <= 1; 					@(posedge clk);
		L <= 0; 					@(posedge clk);

		// Move Right sequence
		R <= 1; 					@(posedge clk);
		R <= 0; 					@(posedge clk);
		R <= 1; 					@(posedge clk);
		R <= 0; 					@(posedge clk);
		R <= 1; 					@(posedge clk);
		R <= 0;					@(posedge clk);
		R <= 1; 					@(posedge clk);
		R <= 0; 					@(posedge clk);
		R <= 1; 					@(posedge clk);
		R <= 0; 					@(posedge clk);
		R <= 1; 					@(posedge clk);
		R <= 0; 					@(posedge clk);
		R <= 1; 					@(posedge clk);
		R <= 0; 					@(posedge clk);

		playfieldReset <= 1; @(posedge clk);
		playfieldReset <= 0; @(posedge clk);
	$stop;
	end
endmodule
