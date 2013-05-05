module HazardUnit
#(parameter W=32)
(
	input [4:0] RS_EX,
	input [4:0] RT_EX,
	input [4:0] RS_D,
	input [4:0] RT_D,
	input [4:0] WriteReg_E,
	input [4:0] WriteReg_M,
	input [4:0] WriteReg_W,
	input RegWrite_E,
	input  RegWrite_M,
	input  RegWrite_W,
	input MemToReg_E,
	input MemToReg_M,
	input BranchD,
	output reg [1:0] ForwardAE,
	output reg [1:0] ForwardBE,
	output reg ForwardAD, ForwardBD,
	output reg StallF, 
	output reg StallD, 
	output reg FlushE
);



	always @(*)  begin
        // Set ForwardA
        // Forward around EX hazards
        if (RegWrite_M
            && (RS_EX != 0)
            && (RS_EX == WriteReg_M))
            ForwardAE = 2'b10;
        // Forward around MEM hazards
        else if (RegWrite_W
            && (RS_EX != 0)
            && (RS_EX == WriteReg_W))
            ForwardAE = 2'b01;
        // No hazards, use the value from ID/EX
        else
            ForwardAE = 2'b00;

        // Set ForwardB
        // Forward around EX hazards
        if (RegWrite_M
            && (RT_EX != 0)
            && (RT_EX == WriteReg_M))
            ForwardBE = 2'b10;
        // Forward around MEM hazards
        else if (RegWrite_W
            && (RT_EX != 0)
            && (RT_EX == WriteReg_W))
            ForwardBE = 2'b01;
        // No hazards, use the value from ID/EX
        else
            ForwardBE = 2'b00;
    end

	// Forwarding AD, BD
	always @(*) begin
		ForwardAD = (RS_D != 0) && (RS_D == WriteReg_M) & RegWrite_M;
		ForwardBD = (RT_D != 0) && (RT_D == WriteReg_M) & RegWrite_M;
	end
	
	//lw stall
	reg lwstall;
	reg branchstall;
	always @(*) begin
	
		//stalling for branches
		branchstall = BranchD && RegWrite_E && (WriteReg_E == RS_D || WriteReg_E == RT_D) || BranchD && MemToReg_M
			&& (WriteReg_M == RS_D || WriteReg_M == RT_D);
		
		//MemToReg_E implies an LW command
		lwstall = ((RS_D == RT_EX) || (RT_D == RT_EX)) && MemToReg_E;
		StallF = lwstall || branchstall;
		StallD = lwstall || branchstall;
		FlushE = lwstall || branchstall;
	end

endmodule