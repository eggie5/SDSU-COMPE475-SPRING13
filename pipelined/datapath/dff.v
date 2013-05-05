module DFF #(parameter W = 32)
(input clk,
 input reset,
 input en,
 input [W-1:0] d,
 output reg [W-1:0] q
);

always @(posedge clk) begin
	if (reset===1'b1) q <= 32'bx;
	else if(~en || en=== 1'bx) q <= d;
end

endmodule