module ALU
(input [2:0] sel, 
input [31:0] a, 
input [31:0] b, 
output reg [31:0] out); //should it be signed???
	
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
			default: $display("sel ERROR in ALU");
		endcase
	end
	
endmodule