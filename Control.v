module Control(
    Op_i,
    Branch_o,
    Jump_o,
    EX_MEM_WB_signals_o
);

input	[5:0]	Op_i;
output	Branch_o, Jump_o;
output	[7:0]	EX_MEM_WB_signals_o;
reg	[1:0] ALUOp_o;
reg	Branch_o, Jump_o, RegWrite_o, MemtoReg, MemWrite, MemRead, ALUSrc_o, RegDst_o;
assign EX_MEM_WB_signals_o = {RegWrite_o, MemtoReg, MemRead, MemWrite, ALUSrc_o, ALUOp_o[1:0], RegDst_o};

initial begin
	 ALUOp_o = 2'b00;
	RegDst_o = 1'b0;
	ALUSrc_o = 1'b0;
	RegWrite_o = 1'b0;
	MemtoReg = 1'b0;
    MemWrite = 1'b0;
	MemRead = 1'b0;
  	Branch_o = 1'b0;
    Jump_o = 1'b0;
end

always@(Op_i)
 begin
   case(Op_i)
     //R-type
    6'b000000 : begin
	ALUOp_o <= 2'b11;
	RegDst_o <= 1'b1;
	ALUSrc_o <= 1'b0;
	RegWrite_o <= 1'b1;
	MemtoReg <= 1'b0;
    MemWrite <= 1'b0;
	MemRead <= 1'b0;
  	Branch_o <= 1'b0;
    Jump_o <= 1'b0;
	//ExtOp <=
    end
     //addi
    6'b001000 : begin
	ALUOp_o <= 2'b00;
	RegDst_o <= 1'b0;
	ALUSrc_o <= 1'b1;
	RegWrite_o <= 1'b1;
	MemtoReg <= 1'b0;
    MemWrite <= 1'b0;
	MemRead <= 1'b0;
  	Branch_o <= 1'b0;
    Jump_o <= 1'b0;
	//ExtOp <= 1'b0;
       end
     //lw
    6'b100011 : begin
	ALUOp_o <= 2'b00;
	RegDst_o <= 1'b0;
	ALUSrc_o <= 1'b1;
	RegWrite_o <= 1'b1;
	MemtoReg <= 1'b1;
    MemWrite <= 1'b0;
	MemRead <= 1'b1;
  	Branch_o <= 1'b0;
    Jump_o <= 1'b0;
	//ExtOp <= 1'b1;
    end
     //sw
    6'b101011 : begin
	ALUOp_o <= 2'b00;
	RegDst_o <= 1'b0;
	ALUSrc_o <= 1'b1;
	RegWrite_o <= 1'b0;
	MemtoReg <= 1'b0;
    MemWrite <= 1'b1;
	MemRead <= 1'b0;
  	Branch_o <= 1'b0;
    Jump_o <= 1'b0;
	//ExtOp <= 1'b1;
    end
     //beq
    6'b000100 : begin
	ALUOp_o <= 2'b01;
	RegDst_o <= 1'b0;
	ALUSrc_o <= 1'b0;
	RegWrite_o <= 1'b0;
	MemtoReg <= 1'b0;
    MemWrite <= 1'b0;
	MemRead <= 1'b0;
  	Branch_o <= 1'b1;
    Jump_o <= 1'b0;
	//ExtOp <= 1'b1;
    end
     //jump
    6'b000010 : begin
	ALUOp_o <= 2'bxx;
	RegDst_o <= 1'bx;
	ALUSrc_o <= 1'bx;
	RegWrite_o <= 1'b0;
	MemtoReg <= 1'bx;
    MemWrite <= 1'b0;
	MemRead <= 1'b0;
  	Branch_o <= 1'b0;
    Jump_o <= 1'b1;
	//ExtOp <= 1'b1;
    end
   endcase
 end

endmodule
