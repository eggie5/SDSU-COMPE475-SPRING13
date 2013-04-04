module DFF #(parameter W = 32)
(input clk,
 input en,
 input [W-1:0] d,
 output reg [W-1:0] q
);

always @(posedge clk) begin
	if(en) q <= d;
end

endmodule