module HazardUnit
#(parameter W=32)
(
	input [4:0] RS_EX,
	input [4:0] RT_EX,
	input [4:0] RS_D,
	input [4:0] RT_D,
	input [4:0] WriteReg_M,
	input [4:0] WriteReg_W,
	input  RegWrite_M,
	input  RegWrite_W,
	input MemToReg_E,
	input BranchD,
	output reg [1:0] ForwardAE,
	output reg [1:0] ForwardBE,
	output reg ForwardAD, ForwardBD,
	output reg StallF, 
	output reg StallD, 
	output reg FlushE
);

/*	if((RS !=0 ) AND (RS == WriteRegM) AND RegWriteM) then ForwardAE =10;
	else if ((RS !=0) AND (RS == WriteRegW) AND RegWriteW) then ForwardAE=01;
	else ForwardAE=00;*/
	
	//rd = rs
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
		ForwardAD = (RS_D != 0) & (RS_D == WriteReg_M) & RegWrite_M;
		ForwardBD = (RT_D != 0) & (RT_D == WriteReg_M) & RegWrite_M;
	end
	
	//lw stall
	reg lwstall;
	always @(*) begin
		// I changed these from OR and AND to | and & ... not sure of reprocuvions
		lwstall = (RS_EX == RT_EX) | (RT_D == RT_EX) & MemToReg_E;
		StallF = 1;//lwstall;
		StallD = 1;//lwstall;
		FlushE = 0;//~lwstall;
	end

endmodule