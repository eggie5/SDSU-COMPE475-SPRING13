//Synchronous RAM, always read, read-first mode

module DataMemory
#(parameter addWidth=6, dataWidth=16)
(input clk, we, en,
input [addWidth-1:0] addr,
input [dataWidth-1:0] di,
output reg [dataWidth-1:0] _do);


//this should be a 16 (column) x 64 (row) memory array 1024 B = 1 KB
//0000000000000001
//0000000000000001
//64
//0000000000000001

reg [dataWidth-1:0] RAM [2**addWidth-1:0];

always@(posedge clk) begin
	if(en) begin
		if(we) RAM[addr] <= di; //this should select a row and write di to it
		
		_do <= RAM[addr]; // do doesn't get new din in this clock cycle
	end
end

endmodule
