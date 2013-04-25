`include "datapath/datapath.v"

module DataPath_tb();
reg clk, reset;
reg MemToReg, RegDstE;
reg PCSrc;
reg ALUSrcA, MemWrite, PCWrite, Branch, RegWriteW;
reg  ALUSrcE;
reg [2:0] ALUControlE;
wire [5:0] Opcode, Funct;

parameter addWidth = 6, dataWidth=32;

DataPath dp (clk, reset, MemToReg, RegDstE, PCSrc, ALUSrcA, MemWrite, PCWrite, Branch, RegWriteW, ALUSrcE,
	ALUControlE, Opcode, Funct);

initial begin

	clk=0;
	reset=1;
	MemToReg=0; 
	RegDstE=0; 
	PCSrc=0;
	ALUSrcA=0;
	MemWrite=0;
	PCWrite=0; 
	Branch=0;
	RegWriteW=0;
	ALUSrcE=0;

	@(posedge clk); reset=0;
	@(posedge clk); 
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);

	$finish;
end


initial begin
    $dumpfile("tmp/datapath_tb.vcd");
    $dumpvars(0,DataPath_tb);
 end

always #10 clk=~clk;

endmodule