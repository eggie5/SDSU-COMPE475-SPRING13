module PCDFF #(parameter W = 32)
(input clk,
 input reset,
 input jumps, 
 input stall,
 input [W-1:0] d,
 output reg [W-1:0] q
);




always @(posedge clk) begin
	if(reset) q <= 0;
	else if(~stall|| stall===1'bx) q <= d;
	

end

endmodule