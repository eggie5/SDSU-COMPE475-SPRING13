module pc
(input clk,
input [31:0] in,
output reg [32:0] out);

always @(posedge clk) begin
	out <= in;
end

endmodule