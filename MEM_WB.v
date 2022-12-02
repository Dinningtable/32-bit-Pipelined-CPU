module MEM_WB(
    clk_i,
    WB_i,
    RegWrite_o,
    MemtoReg_o,
    Read_data_i,
    Read_data_o,
    ALUresult_i,
    ALUresult_o,
    mux8_result_i,
    mux8_result_o,
    hold_i
);

input	clk_i, hold_i;
input	[1:0]	WB_i;
input	[4:0]	mux8_result_i;
input	[31:0]	Read_data_i, ALUresult_i;
output	reg	RegWrite_o, MemtoReg_o;
output	reg	[4:0]	mux8_result_o;
output	reg	[31:0]	Read_data_o, ALUresult_o;

initial begin
	RegWrite_o = 1'b0;
    MemtoReg_o = 1'b0;
    Read_data_o = 32'b0;
    ALUresult_o = 32'b0;
    mux8_result_o = 5'b0;
end

always@(posedge clk_i) begin
	if(hold_i) begin
		RegWrite_o <= RegWrite_o;
    	MemtoReg_o <= MemtoReg_o;
    	Read_data_o <= Read_data_o;
    	ALUresult_o <= ALUresult_o;
    	mux8_result_o <= mux8_result_o;
	end
	else begin
		RegWrite_o <= WB_i[1];
    	MemtoReg_o <= WB_i[0];
    	Read_data_o <= Read_data_i;
    	ALUresult_o <= ALUresult_i;
    	mux8_result_o <= mux8_result_i;
	end
end
endmodule
