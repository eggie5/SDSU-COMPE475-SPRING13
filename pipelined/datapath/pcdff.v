module PCDFF #(parameter W = 32)
(input clk,
 input reset,
 input jump, 
 input en,
 input [W-1:0] d,
 output reg [W-1:0] q
);

always @(jump) begin
	if(jump) q = 32'bx;
end

always @(posedge clk, posedge reset) begin
	if (reset) q <= 0;
	else if(en) q <= d;
end

endmodule