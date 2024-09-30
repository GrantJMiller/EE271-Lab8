// The car_output module controls a 16x16 LED matrix to simulate cars moving left-to-right and right-to-left. 
// It uses the LSFR and switches to control the trigger signals which can change how many cars are being generated
// at a given time.

module car_output (clk, trigger_enable, hardReset, SW, RedPixels);
    input logic clk, trigger_enable, hardReset;
    input logic [5:0] SW;
    output logic [15:0][15:0] RedPixels; // 16x16 array of red LEDs
    
    logic [8:0] ps;
    logic OF, CF, trigger;
    logic [9:0] adder_out;
    logic [15:0] triggers, triggers2;
    
    trigger_proc tp1 (.SW(SW), .adder_out(adder_out), .OF(OF), .trigger(trigger), .clk(clk), .enable(trigger_enable));
    LFSR lfsr1 (.ps(ps), .clk(clk), .initialize(hardReset), .enable(trigger_enable));
    
    adder a1 (.OF(OF), .CF(CF), .S(adder_out), .sub(1'b0), .A({4'b0000,SW[5:0]}), .B({1'b0,ps[8:0]}));
    
    upCounter counter1 (.out(triggers), .trigger(trigger), .reset(hardReset), .clk(clk), .enable(trigger_enable));
    upCounter counter2 (.out(triggers2), .trigger(trigger), .reset(hardReset), .clk(clk), .enable(trigger_enable));
    
    logic [15:0][15:0] out;
    
    // Generate block for handling odd columns (left-to-right car movement)
    genvar i;
    generate
        for(i = 1; i < 15; i = i + 2) begin : ColumnRTL
            cars_LTR carsLTR1 (.clk(clk), .trigger((triggers[i] || triggers2[14-i])), .col_in(out[i]), .col_out(out[i]), .hardReset(hardReset), .enable(trigger_enable));
        end
    endgenerate
    
    // Generate block for handling even columns (right-to-left car movement)
    genvar j;
    generate
        for(j = 2; j < 15; j = j + 2) begin : ColumnLTR
            cars_RTL carsRTL1 (.clk(clk), .trigger((triggers[j] || triggers2[16-j])), .col_in(out[(16-j)]), .col_out(out[(16-j)]), .hardReset(hardReset), .enable(trigger_enable));
        end
    endgenerate
    
    // Always block to update RedPixels on the rising edge of clk
    always_ff @(posedge clk) begin
        if (hardReset) begin
            RedPixels <= '0;
        end
        else if (trigger_enable) begin
            int k;
            for(k = 0; k < 16; k++) begin
                RedPixels[k] <= out[k];
            end
        end
    end
endmodule

module car_output_testbench();
	
	logic [5:0] SW;
	logic hardReset, clk;
	logic [15:0][15:0] RedPixels;
	
	car_output dut (.clk, .hardReset, .SW, .RedPixels);
	
	parameter CLOCK_PERIOD=100;
	initial begin
    	clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
 
	initial begin
		SW[0] <= 1;
		SW[1] <= 1;
		SW[2] <= 1;
		SW[3] <= 1;
		SW[4] <= 1;
		SW[5] <= 1;
		SW[8:6] <= 0;
						hardReset <= 1; 	@(posedge clk);
						hardReset <= 0;	@(posedge clk);
												@(posedge clk);
												@(posedge clk);			 
												@(posedge clk);		 
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
		SW[5] <= 0; SW[4] <= 0;			@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);			 
												@(posedge clk);		 
												@(posedge clk);
												@(posedge clk);
		SW[3] <= 0; SW [2] <= 0;		@(posedge clk);
												@(posedge clk);
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

