`include "controller.v"
module Controller_tb();

reg clk, reset;
reg [5:0] Opcode, Funct;
reg zero;
wire MemToReg, RegDst, IorD, PCSrc, ALUSrcA, ALUSrcB, IRWrite, MemWrite, PCWrite, Branch, RegWrite, ALUControl;

Controller controller (clk, reset, Opcode, Funct, //end of inputs
	MemToReg, RegDst, IorD, PCSrc, PCEn, ALUSrcA, ALUSrcB, 
	IRWrite, MemWrite, PCWrite, Branch, RegWrite, ALUControl
	);
	
initial begin
	clk=0;
	Opcode=6'b100011; //lw
	Funct=0;
	
	@(posedge clk) reset=1;
	@(posedge clk) reset=0;
	@(posedge clk) reset=0;
	@(posedge clk) reset=0;
	@(posedge clk) reset=0; Opcode=0;
	@(posedge clk) reset=0;
	@(posedge clk) reset=0;
	@(posedge clk) reset=0;
	@(posedge clk) reset=0;
	@(posedge clk) reset=0;
	@(posedge clk) reset=0;
	$finish;
	
end

initial begin
    $dumpfile("controller_tb.vcd");
    $dumpvars(0,Controller_tb);
 end

always #10 clk=~clk;


endmodule


//iverilog -o controller_tb controller_tb.v && ./controller_tb