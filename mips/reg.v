// A register file is a whole collection of registers, typically all of which are the same length. 
// A register file takes three inputs, an index address value, a data value, and an enable signal. 
// A signal decoder is used to pass the data value from the register file input to the particular 
// register with the specified address.

//The MIPS processor has one standard register file containing 32 32-bit registers for use by integer and logic instructions. These registers are called $0 through $31

//each mips regiser is 32 bits wide, called a 'word'
//each reg can be addressed w/ 5 bits
//each of the 32 registers has a naem and a number, number: #($0-$31) or symb ($s1 -- $t0, ...)
//$s0-$s7 are used to hold variables

//lw, reads data from memorya nd puts in register
//lw syntax: opcode destination offset(reg) -- the offset is in bytes: 0($0) = 1st word, 4($0) = 2nd word, 8($0) = 3rd word
//destination is the reg you want to put reg in and offset is the numberical offset in bytes (not sure what htis is for)
//ex: lw $t0, 12($s0)



module RegisterFile //this is a ramRF memory module
#(parameter addWidth=32, dataWidth=5)
(input clk, 
input we3, //from controller
input [4:0] A1,
input [4:0] A2,
input [4:0] A3,
input [31:0] WD3,
output reg [31:0] RD1,
output reg [31:0] RD2);

reg [dataWidth-1:0] registers [addWidth-1:0];


initial $readmemb("reg.mem", registers);

	// asynchronous reads???
	always @(posedge clk) begin
		//these the 2 instructions operands, i.e. A & B in C=A+B
		RD1 <= registers[A1]; //A
		RD2 <= registers[A2]; //B
	end

	// synchronous writes; handles $zero register
	always @(posedge clk) begin
		if(we3)
			registers[A3] <= WD3;
	end



endmodule