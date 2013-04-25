`include "datapath/datapath.v"

module DataPath_tb();
reg clk, reset;
reg MemToReg, RegDstE;
reg PCSrc;
reg ALUSrcA, MemWrite, PCWrite, Branch, RegWrite;
reg  ALUSrcE;
reg [2:0] ALUControlE;
wire [5:0] Opcode, Funct;

parameter addWidth = 6, dataWidth=32;

integer fp;
integer i;

DataPath dp (clk, reset, MemToReg, RegDstE, PCSrc, ALUSrcA, MemWrite, PCWrite, RegWrite,
	ALUControlE, Opcode, Funct);

initial begin

	clk=0;
	reset=1;
	MemToReg=0; 
	RegDstE=1; 
	PCSrc=1;
	ALUSrcA=0;
	MemWrite=0;
	PCWrite=0; 
	RegWrite=1;
	ALUSrcE=0;
	ALUControlE=3'b110;

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

//iverilog -o tmp/datapath_tb -Ddp_test_program datapath/datapath_tb.v && ./tmp/datapath_tb