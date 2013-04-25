`include "datapath/imem.v"
module IMemory_tb();
parameter addWidth=6, dataWidth=32;
reg [addWidth-1:0] addr_in;
wire [dataWidth-1:0] out_instruction;

IMemory imem(addr_in, out_instruction);

initial begin 

addr_in=0;

$display("out=%b", out_instruction);

end

endmodule
