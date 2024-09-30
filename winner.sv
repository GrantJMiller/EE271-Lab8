// module to check for win or loss based on position of frog

module winner (col, row, GrnPixels, RedPixels, lost, won, clk);
    input int col;  // Player's column position
    input logic clk; 
    input logic [15:0] row;  // Player's row position
    input logic [15:0][15:0] RedPixels, GrnPixels;  // 16x16 arrays of red and green pixels
    output logic lost, won; 
    
    logic [1:0] ps; // PS
    logic [1:0] ns; // NS

    parameter loss = 2'b10, win = 2'b11, noInput = 2'b00;
    int row_int; 
    
    always_comb begin // decoding the row to be just an integer
        if (row == 16'b0000000000000001) row_int = 0;
        else if (row == 16'b0000000000000010) row_int = 1;
        else if (row == 16'b0000000000000100) row_int = 2;
        else if (row == 16'b0000000000001000) row_int = 3;
        else if (row == 16'b0000000000010000) row_int = 4;
        else if (row == 16'b0000000000100000) row_int = 5;
        else if (row == 16'b0000000001000000) row_int = 6;
        else if (row == 16'b0000000010000000) row_int = 7;
        else if (row == 16'b0000000100000000) row_int = 8;
        else if (row == 16'b0000001000000000) row_int = 9;
        else if (row == 16'b0000010000000000) row_int = 10;
        else if (row == 16'b0000100000000000) row_int = 11;
        else if (row == 16'b0001000000000000) row_int = 12;
        else if (row == 16'b0010000000000000) row_int = 13;
        else if (row == 16'b0100000000000000) row_int = 14;
        else if (row == 16'b1000000000000000) row_int = 15;
        else row_int = 0;

        case(ps)
            win: if (RedPixels[col][row_int]) ns = loss;
                 else if (col == 0) ns = win;
                 else ns = noInput;
					  
            loss: if (col == 0) ns = win;
                  else if (RedPixels[col][row_int]) ns = loss;
                  else ns = noInput;
						
            noInput: if (RedPixels[col][row_int]) ns = loss;
                     else if (col == 0) ns = win;
                     else ns = noInput;
            default: ns = noInput;
        endcase
    end

    always_ff @(posedge clk) begin
        case (ns)
           loss: if (ps == loss) begin
                lost <= 0;
               won <= 0;
            end else begin
              lost <= 1;
                won <= 0;
            end
            win: if (ps == win) begin
               lost <= 0;
               won <= 0;
            end else begin
               lost <= 0;
               won <= 1;
            end
            noInput: begin
               lost <= 0;
               won <= 0;
            end
            default: begin // this particular case should never happen
               lost <= 1;
               won <= 1;
            end
        endcase
        ps <= ns;
    end
endmodule 

module winner_testbench();
	int col;
	logic clk, lost, won;
	logic [15:0] row;
	logic [15:0][15:0] RedPixels, GrnPixels;
	
	winner dut (.lost, .won, .clk, .col, .row, .GrnPixels, .RedPixels);
	

	parameter CLOCK_PERIOD=100;
	initial begin
    	clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		col <= 15; 										@(posedge clk);		
		row <= 16'b0000001000000000;           @(posedge clk);	
		GrnPixels <= '0; 								@(posedge clk);	
		RedPixels <= '0;								@(posedge clk);	
		col <= 0;										@(posedge clk);	
															@(posedge clk);	 
															@(posedge clk);
															@(posedge clk);
															@(posedge clk);	
		col <= 14; 										@(posedge clk);         	 
		RedPixels[col][7] <= 1; 					@(posedge clk);
															@(posedge clk);
		col <= 0;										@(posedge clk);	
															@(posedge clk);
															@(posedge clk);     
															@(posedge clk);
															@(posedge clk);		
		
		$stop;
	end
endmodule
