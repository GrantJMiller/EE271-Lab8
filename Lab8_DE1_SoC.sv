module Lab8_DE1_SoC (CLOCK_50, GPIO_1, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR);
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    output logic [9:0] LEDR;
    input  logic [3:0] KEY;
    input  logic [9:0] SW;
    output logic [35:0] GPIO_1;
    input logic CLOCK_50;

    // Set up system base clock to 1526 Hz (50 MHz / 2**(14+1))
    logic [31:0] clk;
    logic SYSTEM_CLOCK;
    
    clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk));
    assign SYSTEM_CLOCK = clk[14];

    // Counters to generate enable signals
    logic [9:0] car_counter;
    logic [7:0] trigger_counter;
    logic car_enable, trigger_enable;

    // Clock division logic
    always_ff @(posedge SYSTEM_CLOCK or posedge SW[9]) begin
        if (SW[9]) begin
            car_counter <= 0;
            trigger_counter <= 0;
            car_enable <= 0;
            trigger_enable <= 0;
        end else begin
            // Car clock enable generation (50 MHz / 2**(24-14) = 48.828125 Hz)
            if (car_counter == 1023) begin // 2**10 = 1024
                car_counter <= 0;
                car_enable <= 1;
            end else begin
                car_counter <= car_counter + 1;
                car_enable <= 0;
            end

            // Trigger clock enable generation (50 MHz / 2**(22-14) = 195.3125 Hz)
            if (trigger_counter == 255) begin // 2**8 = 256
                trigger_counter <= 0;
                trigger_enable <= 1;
            end else begin
                trigger_counter <= 0;
                trigger_enable <= 0;
            end
        end
    end

    // Set up LED board driver
    logic [15:0][15:0] RedPixels; // 16 x 16 array representing red LEDs
    logic [15:0][15:0] GrnPixels; // 16 x 16 array representing green LEDs
    
    assign hardReset = SW[9];

    // Standard LED Driver instantiation
    LEDDriver driver (.CLK(SYSTEM_CLOCK), .RST(playfieldReset), .EnableCount(1'b1), .RedPixels, .GrnPixels, .GPIO_1);

    logic L, R, U, D, lost, won;
    int col;
    logic [15:0] row;

    // User input modules
    userInput_left_right lr1 (.clk(SYSTEM_CLOCK), .playfieldReset(playfieldReset), .hardReset(hardReset), .KEY0(KEY[0]), .KEY3(KEY[3]), .L(L), .R(R));
    userInput_up_down ud1 (.clk(SYSTEM_CLOCK), .playfieldReset(playfieldReset), .hardReset(hardReset), .KEY1(KEY[1]), .KEY2(KEY[2]), .U(U), .D(D));

    // Game state module
    gameState state1 (.L(L), .R(R), .U(U), .D(D), .GrnPixels(GrnPixels), .col(col), .row(row), .playfieldReset(playfieldReset), .hardReset(hardReset), .clk(SYSTEM_CLOCK));

    // Car output module with enable signal
    car_output co1 (.clk(SYSTEM_CLOCK), .trigger_enable(car_enable), .hardReset(hardReset), .SW(SW[5:0]), .RedPixels(RedPixels));

    // Winner module with enable signal
    winner w1 (.col(col), .row(row), .GrnPixels(GrnPixels), .RedPixels(RedPixels), .lost(lost), .won(won), .clk(SYSTEM_CLOCK));

    // Win count logic
    logic [3:0] win_count;
    always_ff @(posedge SYSTEM_CLOCK or posedge hardReset) begin
        if (hardReset) begin
            win_count <= 4'b0000;
        end else if (won) begin
            win_count <= win_count + 4'b1;
        end else if (lost) begin
            win_count <= 4'b0000;
        end
    end

    // HEX display
    hex_display hex0 (.num(win_count), .segments(HEX0));
    
    // Turn off other HEX displays 1-5
    assign HEX1 = 7'b1111111;
    assign HEX2 = 7'b1111111;
    assign HEX3 = 7'b1111111;
    assign HEX4 = 7'b1111111;
    assign HEX5 = 7'b1111111;
    
    // Playfield reset logic
    assign playfieldReset = won || lost;
endmodule

module Lab8_DE1_SoC_testbench();
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [9:0] LEDR;
    logic [3:0] KEY;
    logic [9:0] SW;
	 logic [15:0][15:0] RedPixels;
    logic [15:0][15:0] GrnPixels;
    logic [35:0] GPIO_1;
    logic CLOCK_50;
    
	 initial begin
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            RedPixels[i][j] = 0;
            GrnPixels[i][j] = 0;
        end
    end
	 end

    Lab8_DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .SW, .LEDR, .GPIO_1, .CLOCK_50);
    
    parameter CLOCK_PERIOD = 100;
    initial begin
        CLOCK_50 <= 0;
        forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~ CLOCK_50;
    end
    
    initial begin
        SW[9] <= 1; SW[8:6] <= 0;  
		  KEY[3:0] <= 0; SW[5:0] <= 1;
						
								   @(posedge CLOCK_50);
        SW[9] <= 0;			@(posedge CLOCK_50);
        KEY[0] <= 1;			@(posedge CLOCK_50);
        KEY[0] <= 0;			@(posedge CLOCK_50);
        KEY[0] <= 1;			@(posedge CLOCK_50);
        KEY[0] <= 0;			@(posedge CLOCK_50);
        KEY[0] <= 1;			@(posedge CLOCK_50);
        KEY[0] <= 0;			@(posedge CLOCK_50);
        KEY[3] <= 1;			@(posedge CLOCK_50);
        KEY[3] <= 0;			@(posedge CLOCK_50);
        KEY[0] <= 1;			@(posedge CLOCK_50);
        KEY[0] <= 0;			@(posedge CLOCK_50);
        KEY[0] <= 1;			@(posedge CLOCK_50);
        KEY[0] <= 0;			@(posedge CLOCK_50);
        KEY[0] <= 1;			@(posedge CLOCK_50);
        KEY[0] <= 0;			@(posedge CLOCK_50);
        KEY[1] <= 1;			@(posedge CLOCK_50);
        KEY[1] <= 0;			@(posedge CLOCK_50);
        KEY[1] <= 1;			@(posedge CLOCK_50);
        KEY[1] <= 0;			@(posedge CLOCK_50);
        KEY[2] <= 1;			@(posedge CLOCK_50);
        KEY[2] <= 0;			@(posedge CLOCK_50);
        KEY[2] <= 1;			@(posedge CLOCK_50);
        KEY[2] <= 0;			@(posedge CLOCK_50);
        KEY[1] <= 1;			@(posedge CLOCK_50);
        KEY[1] <= 0;			@(posedge CLOCK_50);
        KEY[1] <= 1;			@(posedge CLOCK_50);
        KEY[1] <= 0;			@(posedge CLOCK_50);
        KEY[1] <= 1;			@(posedge CLOCK_50);
        KEY[1] <= 0;			@(posedge CLOCK_50);
        KEY[3] <= 1;			@(posedge CLOCK_50);
        KEY[3] <= 0;			@(posedge CLOCK_50);
        KEY[3] <= 1;			@(posedge CLOCK_50);
        KEY[3] <= 0;			@(posedge CLOCK_50);
        KEY[3] <= 1;			@(posedge CLOCK_50);
        KEY[3] <= 0;			@(posedge CLOCK_50);
        KEY[3] <= 1;			@(posedge CLOCK_50);
        KEY[3] <= 0;			@(posedge CLOCK_50);
        KEY[1] <= 1;			@(posedge CLOCK_50);
        KEY[1] <= 0;			@(posedge CLOCK_50);
        KEY[1] <= 1;			@(posedge CLOCK_50);
        KEY[1] <= 0;			@(posedge CLOCK_50);
        KEY[1] <= 1;			@(posedge CLOCK_50);
        KEY[1] <= 0;			@(posedge CLOCK_50);
        KEY[1] <= 1;			@(posedge CLOCK_50);
									@(posedge CLOCK_50);
									@(posedge CLOCK_50);
		  KEY[1] <= 1;			@(posedge CLOCK_50);
        KEY[1] <= 1;			@(posedge CLOCK_50);
        KEY[1] <= 1;			@(posedge CLOCK_50);
        KEY[1] <= 1;			@(posedge CLOCK_50);
        KEY[1] <= 1;			@(posedge CLOCK_50);
		  KEY[1] <= 0;			@(posedge CLOCK_50);
									@(posedge CLOCK_50);
		  KEY[1] <= 1;			@(posedge CLOCK_50);
		  KEY[1] <= 0;			@(posedge CLOCK_50);							
		  KEY[1] <= 1;			@(posedge CLOCK_50);
		  KEY[1] <= 0;			@(posedge CLOCK_50);	
		  KEY[1] <= 1;			@(posedge CLOCK_50);
		  KEY[1] <= 0;			@(posedge CLOCK_50);
		  KEY[1] <= 1;			@(posedge CLOCK_50);
		  KEY[1] <= 0;			@(posedge CLOCK_50);
		  KEY[1] <= 1;			@(posedge CLOCK_50);
		  KEY[1] <= 0;			@(posedge CLOCK_50);
		  KEY[1] <= 1;			@(posedge CLOCK_50);
		  KEY[1] <= 0;			@(posedge CLOCK_50);
		  KEY[1] <= 1;			@(posedge CLOCK_50);
		  KEY[1] <= 0;			@(posedge CLOCK_50);
		  KEY[1] <= 1;			@(posedge CLOCK_50);
		  KEY[1] <= 0;			@(posedge CLOCK_50);
		  KEY[1] <= 1;			@(posedge CLOCK_50);
		  KEY[1] <= 0;			@(posedge CLOCK_50);
		  KEY[1] <= 1;			@(posedge CLOCK_50);
		  KEY[1] <= 0;			@(posedge CLOCK_50);
		  
        $stop;
    end
endmodule
