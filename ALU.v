module ALU(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
    Zero_o
);

input	[31:0]	data1_i, data2_i;
input	[2:0]	ALUCtrl_i;
output	[31:0]	data_o;
output 	Zero_o;

reg [31:0] temp;
assign data_o = temp;

always@(data1_i or data2_i or ALUCtrl_i)
  begin
    case(ALUCtrl_i)
      3'b000 : temp <= data1_i+data2_i;
      3'b001 : temp <= data1_i-data2_i;
      3'b010 : temp <= data1_i&data2_i;
      3'b011 : temp <= data1_i|data2_i;
      3'b100 : temp <= data1_i*data2_i;
    endcase
  end

endmodule
