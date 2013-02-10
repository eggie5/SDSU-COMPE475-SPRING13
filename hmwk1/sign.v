module SignExtender
(input [15:0] in,
output reg [31:0] extended);

always @(*) begin
	extended = $signed(in);
end

endmodule