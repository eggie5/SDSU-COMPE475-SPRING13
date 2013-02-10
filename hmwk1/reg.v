// A register file is a whole collection of registers, typically all of which are the same length. 
// A register file takes three inputs, an index address value, a data value, and an enable signal. 
// A signal decoder is used to pass the data value from the register file input to the particular 
// register with the specified address.

//The MIPS processor has one standard register file containing 32 32-bit registers for use by integer and logic instructions. These registers are called $0 through $31


module RegisterFile //this is a ramRF memory module
#(parameter addWidth=32, dataWidth=32)
(input clk, input we3,
input [4:0] A1,
input [4:0] A2,
input [4:0] A3,
input [31:0] WD3,
input [4:0] fromALU,
output reg [31:0] RD1,
output reg [31:0] RD2);

reg [dataWidth-1:0] registers [addWidth-1:0];


	always @(posedge clk) begin
		//these the 2 instructions operands, i.e. A & B in C=A+B
		RD1 <= registers[A1]; //A
		RD2 <= registers[A2]; //B
	end

	always @(posedge clk) begin
		if(we3)
			registers[A3] <= WD3;
	end

endmodule