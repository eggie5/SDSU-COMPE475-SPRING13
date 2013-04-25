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

integer fp;
integer i;

DataPath dp (clk, reset, MemToReg, RegDstE, PCSrc, ALUSrcA, MemWrite, PCWrite, Branch, RegWriteW, ALUSrcE,
	ALUControlE, Opcode, Funct);

initial begin

	clk=0;
	reset=1;
	MemToReg=0; 
	RegDstE=0; 
	PCSrc=0;
	ALUSrcA=1;
	MemWrite=1;
	PCWrite=0; 
	Branch=0;
	RegWriteW=0;
	ALUSrcE=0;
	ALUControlE=3'b010;

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
	
	
	fp = $fopen("tmp/mem_after.dump"); 
	for (i = 0; i <= 63; i = i + 1) 
		$fdisplayb(fp, dp.mem.RAM[i]); 
	$fclose(fp);
	
	fp = $fopen("tmp/reg_after.dump"); 
	for (i = 0; i <= 31; i = i + 1) 
		$fdisplay(fp, dp.reg_file.registers[i]); 
	$fclose(fp);

	$finish;
end


initial begin
    $dumpfile("tmp/datapath_tb.vcd");
    $dumpvars(0,DataPath_tb);
 end

always #10 clk=~clk;

endmodule