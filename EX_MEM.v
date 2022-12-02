module EX_MEM(
    clk_i,
    WB_i,
    WB_o,
    M_i,
    MemRead_o,
    MemWrite_o,
    ALU_i,
    ALU_o,
    mux7_i,
    mux7_o,
    mux8_i,
    mux8_o,
    hold_i
);

input	clk_i, hold_i;
input	[1:0]	WB_i,M_i;
input	[4:0]	mux8_i;
input	[31:0]	ALU_i, mux7_i;
output	reg	MemRead_o, MemWrite_o;
output	reg	[1:0]	WB_o;
output	reg	[4:0]	mux8_o;
output	reg	[31:0]	ALU_o, mux7_o;

initial begin
	WB_o = 2'b0;
    MemRead_o = 1'b0;
    MemWrite_o = 1'b0;
    ALU_o = 32'b0;
    mux7_o = 32'b0;
    mux8_o = 5'b0;
end

always@(posedge clk_i) begin
	if (hold_i) begin
		WB_o <= WB_o;
    	MemRead_o <= MemRead_o;
    	MemWrite_o <= MemWrite_o;
    	ALU_o <= ALU_o;
    	mux7_o <= mux7_o;
    	mux8_o <= mux8_o;
	end
	else begin
    	WB_o <= WB_i;
    	MemRead_o <= M_i[1];
    	MemWrite_o <= M_i[0];
    	ALU_o <= ALU_i;
    	mux7_o <= mux7_i;
    	mux8_o <= mux8_i;
    end
end

endmodule
