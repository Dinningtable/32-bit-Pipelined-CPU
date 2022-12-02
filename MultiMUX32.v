module MultiMUX32(
    data1_i,
    data2_i,
    data3_i,
    select_i,
    data_o
);

input	[1:0]	select_i;
input	[31:0]	data1_i, data2_i, data3_i;
output	reg	[31:0]	data_o;

always@(data1_i or data2_i or data3_i or select_i) begin
	data_o = 32'b0;
    case(select_i)
      2'b00 : data_o <= data1_i;
      2'b10 : data_o <= data3_i;
      2'b01 : data_o <= data2_i;
    endcase
end

endmodule
