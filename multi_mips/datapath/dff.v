module DFF #(parameter W = 32)
(input clk,
 input en,
 input [W-1] d,
 output reg [W-1] q
);

always@(posedge clk)
	q <= d;
end

endmodule