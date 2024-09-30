module adder (OF, CF, S, sub, A, B);
	output logic OF, CF;
	output logic [9:0] S;
	input logic sub;
	input logic [9:0] A, B;
	logic [9:0] D;	
	logic C2;		// Second-to-last carry-out
	
	always_comb begin
		D = B ^ {10{sub}};	
		{C2, S[8:0]} = A[8:0] + D[8:0] + sub; // adding sub represents the plus one needed when bits are flipped
									
		{CF, S[9]} = A[9] + D[9] + C2; 
		OF = CF ^ C2;
	end
endmodule

module adder_testbench();

	logic sub;
	logic [9:0] A, B;
	logic [9:0] S;
	logic OF, CF;
		
	adder dut (.OF, .CF, .S, .sub, .A, .B);
	
	initial begin
		#100;		sub = 0;		A = 10'b0000000001;		B = 10'b0000000000; 
		#100;		sub = 0;		A = 10'b0111111110;		B = 10'b0000000001; 
		#100;		sub = 0;		A = 10'b0000000000;		B = 10'b0000000000; 
		#100;		sub = 0;		A = 10'b0111111111;		B = 10'b0000000001; 
		#100;		sub = 0;		A = 10'b0100000000;		B = 10'b0100000000; 
		#100;		sub = 0;		A = 10'b1000000001;		B = 10'b1000000001; 
	end
endmodule

