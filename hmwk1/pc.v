// The Program Counter (PC) is a register structure that contains the address pointer value of the current instruction. 
// Each cycle, the value at the pointer is read into the instruction decoder and the program counter is updated to point 
// to the next instruction. For RISC computers updating the PC register is as simple as adding the machine word 
// length (in bytes) to the PC.


//this module is just a +4 iterator?
module ProgramCounter
(input clk,
input clr,
input [31:0] in,
output reg [32:0] out);


always @(posedge clk) begin
	if (clr) out = 0;
	else out <= in + 4; //iterate though instructions in instruction register (ism.v)
end

endmodule