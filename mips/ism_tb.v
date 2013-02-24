`include "ism.v"

module InstructionSet_tb();

parameter addWidth=6, dataWidth=32;

reg [addWidth-1:0] addr_in; //from pc
wire [dataWidth-1:0] out_instruction;
 



//this should be a 32 (column) x 64 (row) memory array 1024 B = 1 KB
//0000000000000000000000000000001
//0000000000000000000000000000001
//64
//0000000000000000000000000000001

InstructionSet #(addWidth, dataWidth) ism (addr_in, out_instruction);

initial begin
	addr_in=0;
	
	$display("time\taddr_in\tout_instruction");
	$monitor("%g\t%b\t%b", $time, addr_in, out_instruction);
	
	$finish;
end


endmodule
