module PCMUX
#(parameter W=32)
(
 input [W-1:0] A,
 input [W-1:0] B,
 input sel,
 output reg [W-1:0] out);

	always @ * begin
		if(sel == 1)
			out = B;
		else
			out = A;
	end

endmodule