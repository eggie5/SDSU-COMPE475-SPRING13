`include "controller/controller.v"
module Controller_tb();

reg clk, reset;
reg [5:0] Opcode, Funct;
wire MemToReg, RegDst, IorD, PCSrc, ALUSrcA, IRWrite, MemWrite, PCWrite, Branch, RegWrite;
wire [1:0] ALUSrcB;
wire [2:0] ALUControl;

Controller controller (clk, reset, Opcode, Funct, zero,//end of inputs
	MemToReg, RegDst, IorD, PCSrc, ALUSrcA, ALUSrcB, 
	IRWrite, MemWrite, PCWrite, Branch, RegWrite, ALUControl
	);//PCEn
	
initial begin
	clk=0;
	Opcode=0;//6'b100011; //lw
	Funct=0;
	
	@(posedge clk) reset=1;
	@(posedge clk) reset=0;
	$display("IorD=%b", IorD);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	$display("IorD=%b", IorD);
	$finish;
	
end

initial begin
    $dumpfile("tmp/controller_tb.vcd");
    $dumpvars(0,Controller_tb);
 end

always #10 clk=~clk;


endmodule

//run from project root
//iverilog -o tmp/controller_tb controller/controller_tb.v && ./tmp/controller_tb