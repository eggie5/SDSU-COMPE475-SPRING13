module DFF #(parameter W = 32)
(input clk,
 input reset,
 input en,
 input [W-1:0] d,
 output reg [W-1:0] q
);

always @(posedge clk, posedge reset) begin
	if (reset) q <= 0;
	else if(en) q <= d;
end

endmodule