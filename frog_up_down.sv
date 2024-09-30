module frog_up_down (U, D, col_in, col_out, playfieldReset, hardReset, clk);
	 output logic [3:0] col_out;
    input logic U, D, playfieldReset, hardReset, clk;
    input logic [3:0] col_in;
    
    logic [1:0] ps; 
    logic [1:0] ns; 

    parameter [1:0] up = 2'b00, down = 2'b01, noInput = 2'b10;

    logic [3:0] temp;
    assign temp = col_in;

    // NS logic
    always_comb begin
        case (ps)
            noInput: 
                if (D && ~(col_in == 4'b1111))
                    ns = down;
                else if (D && (col_in == 4'b1111))
                    ns = noInput;
                else if (U && ~(col_in == 4'b0000))
                    ns = up;
                else if (U && (col_in == 4'b0000))
                    ns = noInput;
                else
                    ns = noInput;
            down: 
                if (D && ~(col_in == 4'b1111))
                    ns = down;
                else if ((D && (col_in == 4'b1111)) || (~D && ~U))
                    ns = noInput;
                else
                    ns = up;
            up: 
                if (U && ~(col_in == 4'b0000))
                    ns = up;
                else if ((U && (col_in == 4'b0000)) || (~U && ~D))
                    ns = noInput;
                else
                    ns = down; 
            default:
                if (temp == 4'b1111)
                    ns = noInput;
                else
                    ns = 2'b11;
        endcase
    end

    // Output logic
    always_ff @(posedge clk) begin
        if (playfieldReset || hardReset) begin
            col_out <= 4'b1111;
            ps <= noInput;
        end
        else begin
            case (ns)
                down: col_out <= temp + 1;
                up: col_out <= temp - 1;
                noInput:;
                default: col_out <= 4'b1111;
            endcase
            ps <= ns;
        end
    end
endmodule


module frog_up_down_testbench();
	logic U, D, playfieldReset, hardReset, clk;
	logic [3:0] col_in, col_out;
	
	frog_up_down dut (.U, .D, .col_in, .col_out, .playfieldReset, .hardReset, .clk);
	
	parameter CLOCK_PERIOD=100;
	initial begin
    	clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

	initial begin
    playfieldReset <= 0; D <= 0; U <= 0; 	@(posedge clk);
    col_in <= col_out; 							@(posedge clk);
    col_in <= col_out; 							@(posedge clk);
    U <= 1; col_in <= col_out; 				@(posedge clk);
    U <= 0; col_in <= col_out; 				@(posedge clk);
    U <= 1; col_in <= col_out; 				@(posedge clk);
    U <= 0; col_in <= col_out; 				@(posedge clk);
    U <= 1; col_in <= col_out; 				@(posedge clk);
    U <= 0; col_in <= col_out;			   @(posedge clk);
    U <= 1; col_in <= col_out; 				@(posedge clk);
    U <= 0; col_in <= col_out; 				@(posedge clk);
    U <= 1; col_in <= col_out; 				@(posedge clk);
    U <= 0; col_in <= col_out; 				@(posedge clk);
    U <= 1; col_in <= col_out; 				@(posedge clk);
    U <= 0; col_in <= col_out; 				@(posedge clk);
    U <= 1; col_in <= col_out; 				@(posedge clk);
    U <= 0; col_in <= col_out; 				@(posedge clk);
    U <= 1; col_in <= col_out; 				@(posedge clk);
    U <= 0; col_in <= col_out; 				@(posedge clk);
    U <= 1; col_in <= col_out; 				@(posedge clk);
    U <= 0; col_in <= col_out; 				@(posedge clk);
    U <= 1; col_in <= col_out; 				@(posedge clk);
    U <= 0; col_in <= col_out; 				@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
    D <= 1; col_in <= col_out;				@(posedge clk);
    D <= 0; col_in <= col_out; 				@(posedge clk);
    D <= 1; col_in <= col_out; 				@(posedge clk);
    D <= 0; col_in <= col_out; 				@(posedge clk);
    D <= 1; col_in <= col_out; 				@(posedge clk);
    D <= 0; col_in <= col_out; 				@(posedge clk);
    D <= 1; col_in <= col_out; 				@(posedge clk);
    D <= 0; col_in <= col_out; 				@(posedge clk);
    D <= 1; col_in <= col_out; 				@(posedge clk);
    D <= 0; col_in <= col_out; 				@(posedge clk);
    D <= 1; col_in <= col_out; 				@(posedge clk);
    D <= 0; col_in <= col_out; 				@(posedge clk);
    D <= 1; col_in <= col_out; 				@(posedge clk);
    D <= 0; col_in <= col_out; 				@(posedge clk);
    D <= 1; col_in <= col_out; 				@(posedge clk);
    D <= 0; col_in <= col_out; 				@(posedge clk);
    D <= 1; col_in <= col_out; 				@(posedge clk);
    D <= 0; col_in <= col_out; 				@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
    U <= 1; col_in <= col_out; 				@(posedge clk);
    U <= 0; col_in <= col_out; 				@(posedge clk);
    U <= 1; col_in <= col_out; 				@(posedge clk);
    U <= 0; col_in <= col_out; 				@(posedge clk);
    playfieldReset <= 1; 						@(posedge clk);
    playfieldReset <= 0; 						@(posedge clk);
														@(posedge clk);
														@(posedge clk);
    $stop;
	end
endmodule
