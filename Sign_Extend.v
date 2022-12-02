module Sign_Extend(
    data_i,
    data_o
);

input	[15:0]	data_i;
output	[31:0]	data_o;

reg	[31:0] temp;
assign data_o = temp;

always@(data_i) begin
    if(data_i[15])
	begin
         temp <= {16'b1, data_i[15:0]};
	end
    else
	begin
	 temp <= {16'b0, data_i[15:0]};
	end
end

endmodule
