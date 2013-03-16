// The Program Counter (PC) is a register structure that contains the address pointer value of the current instruction. 
// Each cycle, the value at the pointer is read into the instruction decoder and the program counter is updated to point 
// to the next instruction. For RISC computers updating the PC register is as simple as adding the machine word 
// length (in bytes) to the PC.


module ProgramCounter #(parameter W = 6)
(input clk,
input clr,
input PCSrc, //from controller
input [W-1:0] branch,
output reg [W-1:0] out); // the content of this register is an address


	always @(posedge clk) begin
		if (clr) out = 0;
		else out <= (PCSrc) ? branch+(out+1) : out+1; //iterate though instructions in instruction register (ism.v)
	end

endmodule