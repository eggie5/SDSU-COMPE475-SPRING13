module ProgramCounter #(parameter W = 6)
(input clk,
input clr,
input PCSrc, //from controller
input [W-1:0] branch, //TODO: what should the width of this reg be? I think 32...
output reg [W-1:0] out); // the content of this register is an address


	always @(posedge clk) begin
		if (clr) out = 0;
		else out <= (PCSrc) ? branch+(out+1) : out+1; 
		//this is not correct -- need to pipeline branch signal twice
	end

endmodule