module SignExtender
(input [15:0] in,
output reg [31:0] extended);

	always @(*) begin
		extended = $signed(in);
	end
	// or this?
	// assign out[15:0] = in[15:0];
	// assign out[31:16] = in[15];
endmodule