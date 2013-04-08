`include "controller/alu_dec.v"
module Controller
(
input clk, reset,
input [5:0] Opcode, Funct,
input zero,
output reg MemToReg,
output reg RegDst,
output reg IorD,
output reg [1:0] PCSrc,
output reg ALUSrcA,
output reg [1:0] ALUSrcB,
output reg IRWrite, 
output reg MemWrite, 
output reg PCWrite, 
output reg Branch, 
output reg RegWrite,
output [2:0] ALUControl
);

//??? in pdf
reg [1:0] ALUOp;

//CONSTANTS
parameter LW=6'b100011;
parameter SW=6'b101011;
parameter R=0;
parameter BEQ =6'b000100;
parameter ADDI=6'b001000;
parameter J=6'b000010;

//state declartion
reg [3:0] state_reg, next_state; //2 bits for 3 states  - not one-hot encoding

parameter S0=0; //fetch/reset
parameter S1=1; //decode
parameter S2=2; //MemAdr
parameter S3=3; //MemRead
parameter S4=4; //MemWriteBack
parameter S5=5; //MemWrite
parameter S6=6; //Execute
parameter S7=7; //WriteBack
parameter S8=8; //Branch
parameter S9=9; //ADDI Execute
parameter S10=10; //ADDI WriteBack
parameter S11=11; //Jump

ALUDec aludec(Funct, ALUOp, ALUControl);

always @(posedge clk or posedge reset) begin
	if(reset) state_reg <= S0;
	else state_reg <= next_state;
end

always @(state_reg) begin
	case(state_reg)
		S0:
			next_state = S1;
		S1: begin
			if (Opcode == LW) next_state = S2; //next
			else if(Opcode == SW) next_state = S2; //next
			else if(Opcode == R) next_state = S6;
			else if(Opcode ==BEQ) next_state = S8;
			else if(Opcode == ADDI) next_state=S9;
			else if(Opcode == J) next_state=S11;
			else next_state=S1; //loopback...?
			end
		S2: begin
			if(Opcode == LW) next_state = S3; //next
			else if(Opcode == SW) next_state = S5; //next
			else next_state = S2; //loopback
			end
		S3: next_state = S4;
		S4: next_state = S0; //reset
		S5: next_state = S0; //reset
		S6: next_state=S7;
		S7: next_state=S0; //reset
		S8: next_state=S0; //reset
		S9: next_state=S10;
		S10: next_state=S0; //reset
		S11: next_state=S0; //reset
	endcase
end

always @(state_reg) begin
	case(state_reg)
		S0: begin//fetch
			IorD = 0;
			ALUSrcA=0;
			ALUSrcB=2'b01;
			ALUOp=2'b00;
			PCSrc=2'b00;
			IRWrite=1;
			PCWrite=1;
			RegWrite=0;
			MemWrite=0;
			end
		S1: begin //decode
			ALUSrcA=0;
			ALUSrcB=2'b11;
			ALUOp=2'b00;
			IorD = 1'bx;
			PCSrc=2'bxx;
			IRWrite=0;
			end
		S2: begin //MemAdr
			ALUSrcA=1;
			ALUSrcB=2'b10;
			ALUOp=2'b00;
			RegWrite=0;
			MemWrite=0;
			end
		S3: begin //MemRead
			IorD=1;
			end
		S4: begin //Mem WriteBack
			RegDst=0;
			MemToReg=1;
			RegWrite=1;
			end
		S5: begin //MemWrite
			IorD=1;
			MemWrite=1;
		end
		S6: begin //execute
			ALUSrcA=1;
			ALUSrcB=0;
			ALUOp=2'b10;
			
		end
		S7: begin //Writeback
			RegDst=1;
			MemToReg=0;
			RegWrite=1;
		end
		S8: begin //Branch
			ALUSrcA=1;
			ALUSrcB=2'b00;
			ALUOp=2'b01;
			PCSrc=2'b01;
			Branch=1;
			PCWrite=0;
		end
		S9: begin //ADDI Exectute
			ALUSrcA=1;
			ALUSrcB=2'b10;
			ALUOp=2'b00;
		end
		S10: begin //ADDi writeback
			RegDst=0;
			MemToReg=0;
			RegWrite=1;
		end
		S11: begin //jump
			PCSrc=2'b10;
			PCWrite=1;
		end
		default: 
			$display("controller does not know state: %b", state_reg);
	endcase
end

endmodule