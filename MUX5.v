module MUX5(
    data1_i,
    data2_i,
    select_i,
    data_o
);

input	select_i;
input	[4:0]	data1_i, data2_i;
output  reg	[4:0]	data_o;

always@(data1_i or data2_i or select_i) begin
	data_o = 5'b0;
    if(select_i)
	begin
        data_o <= data2_i;
	end
    else
	begin
	    data_o <= data1_i;
	end
end
endmodule
