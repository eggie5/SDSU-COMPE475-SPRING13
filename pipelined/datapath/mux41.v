module MUX41
#(parameter W=32)
(
 input [W-1:0] A,
 input [W-1:0] B,
 input [W-1:0] C,
 input [W-1:0] D,
 input [1:0]sel,
 output reg [W-1:0] out);

always @ (A or B or C or D or sel) 
	case (sel) 
	0 : out = A; 
	1 : out = B; 
	2 : out = C; 
	3 : out = D; 
	default : $display("(MUX41) Error in SEL: %b", sel); 
endcase

endmodule