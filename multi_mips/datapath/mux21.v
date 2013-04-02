module MUX21
#(parameter W=32)
(
 input [W-1:0] A,
 input [W-1:0] B,
input sel,
 output [W-1:0] out);

	assign out = sel ? A : B;

endmodule