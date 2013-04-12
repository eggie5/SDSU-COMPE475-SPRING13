module ALU
(input [2:0] sel, 
input signed [31:0] a, 
input signed [31:0] b, 
output reg signed [31:0] out,
output reg out_zero); 
	
	always @(*) begin
		case(sel)
			0:  out = a&b;
			1:  out = a|b;
			2:  out = a+b;
			//3 not used
			4:  out = a&~b;
			5:  out = a|~b;
			6:  out = a-b;
			7:  out = (a<b)?1:0;
			default begin 
/*				$display("sel ERROR in ALU for: '%b'", sel);*/
				out = 3'bxxx;
			end
		endcase
		
		out_zero = (out==0) ? 1'b1 : 1'b0;
		
	end
	
endmodule