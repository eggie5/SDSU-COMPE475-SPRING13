// The Program Counter (PC) is a register structure that contains the address pointer value of the current instruction. 
// Each cycle, the value at the pointer is read into the instruction decoder and the program counter is updated to point 
// to the next instruction. For RISC computers updating the PC register is as simple as adding the machine word 
// length (in bytes) to the PC.


//this module is just a +4 iterator?
module ProgramCounter #(parameter W = 32)
(input clk,
input clr,
input [W-1:0] in,
output reg [W-1:0] out,
output reg [W-1:0] next); // the content of this register is an address


	always @(posedge clk) begin
		if (clr) out = 0;
		else out <= in; //iterate though instructions in instruction register (ism.v)
	end
	
	always @(posedge clk) begin
		next <= out + 1; 
	end

endmodule