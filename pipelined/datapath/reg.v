module Register
#(parameter addWidth=5, dataWidth=32)
(
input clk, 
input we3, //from controller
input [addWidth-1:0] A1,
input [addWidth-1:0] A2,
input [addWidth-1:0] A3,
input [dataWidth-1:0] WD3,
output  [dataWidth-1:0] RD1,
output  [dataWidth-1:0] RD2
);

reg [dataWidth-1:0] registers [2**addWidth-1:0];

initial $readmemb("datapath/reg.mem", registers);


		//these the 2 instructions operands, i.e. A & B in C=A+B
		assign RD1 = registers[A1]; //A
		assign RD2 = registers[A2]; //B

	// synchronous writes; handles $zero register
	always @(posedge clk) begin
		if(we3)
			registers[A3] <= WD3;
	end



endmodule