// The Program Counter (PC) is a register structure that contains the address pointer value of the current instruction. 
// Each cycle, the value at the pointer is read into the instruction decoder and the program counter is updated to point 
// to the next instruction. For RISC computers updating the PC register is as simple as adding the machine word 
// length (in bytes) to the PC.

module pc
(input clk,
input [31:0] in,
output reg [32:0] out,
output reg [32:0] pc_plus_4);

always @(posedge clk) begin
	out <= in;
end

always @(posedge clk) begin
	//this might have synch issues w/ out. does it need out this cycle or next?
	//increment out by 4 to be at the index of next instruction address?
	//addresses are 4 bits?
	pc_plus_4 <= out + 4;

end

endmodule