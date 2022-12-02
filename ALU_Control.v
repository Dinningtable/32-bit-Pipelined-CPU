module ALU_Control(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);

input	[5:0]	funct_i;
input	[1:0]	ALUOp_i;
output	[2:0]	ALUCtrl_o;

reg 	[2:0]	temp;
assign	ALUCtrl_o = temp;


always@(funct_i or ALUOp_i or ALUCtrl_o)
  begin
    if(ALUOp_i == 2'b11)
	begin
	  case(funct_i)
	    6'b100000 : temp <= 3'b000;
	    6'b100010 : temp <= 3'b001;
	    6'b100100 : temp <= 3'b010;
	    6'b100101 : temp <= 3'b011;
	    6'b011000 : temp <= 3'b100;
	  endcase
	end
    else if(ALUOp_i == 2'b00)
	begin
	  temp <= 3'b000;
	end
  end
endmodule
