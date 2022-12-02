module ID_EX(
    clk_i,
    WB_i,
    WB_o,
    M_i,
    M_o,
    EX_i,
    ALUSrc_o,
    ALUOp_o,
    RegDst_o,
    RSdata_i,
    RSdata_o,
    RTdata_i,
    RTdata_o,
    Sig_imm_i,
    Sig_imm_o,
    RSaddr_i,
    RSaddr_o,
    RTaddr1_i,
    RTaddr1_o,
    RTaddr2_i,
    RTaddr2_o,
    RDaddr_i,
    RDaddr_o,
    hold_i
);

input	clk_i, hold_i;
input	[1:0]	WB_i, M_i;
input	[3:0]	EX_i;
input	[4:0]	RSaddr_i, RTaddr1_i, RTaddr2_i, RDaddr_i;
input	[31:0]	RSdata_i, RTdata_i, Sig_imm_i;
output	reg	ALUSrc_o, RegDst_o;
output	reg	[1:0]	WB_o, M_o, ALUOp_o;
output	reg	[4:0]	RSaddr_o, RTaddr1_o, RTaddr2_o, RDaddr_o;
output	reg	[31:0]	RSdata_o, RTdata_o, Sig_imm_o;

initial begin
	WB_o = 2'b0;
    M_o = 2'b0;
    ALUSrc_o = 1'b0;
    ALUOp_o = 2'b0;
    RegDst_o = 1'b0;
    RSdata_o = 32'b0;
    RTdata_o = 32'b0;
    Sig_imm_o = 32'b0;
    RSaddr_o = 5'b0;
    RTaddr1_o = 5'b0;
    RTaddr2_o = 5'b0;
    RDaddr_o = 5'b0;
end

always@(posedge clk_i) begin
	if(hold_i) begin
		WB_o <= WB_o;
    	M_o <= M_o;
    	ALUSrc_o <= ALUSrc_o;
    	ALUOp_o <= ALUOp_o;
    	RegDst_o <= RegDst_o;
    	RSdata_o <= RSdata_o;
    	RTdata_o <= RTdata_o;
    	Sig_imm_o <= Sig_imm_o;
    	RSaddr_o <= RSaddr_o;
    	RTaddr1_o <= RTaddr1_o;
    	RTaddr2_o <= RTaddr2_o;
    	RDaddr_o <= RDaddr_o;
	end
	else begin
		WB_o <= WB_i;
    	M_o <= M_i;
    	ALUSrc_o <= EX_i[3];
    	ALUOp_o <= EX_i[2:1];
    	RegDst_o <= EX_i[0];
    	RSdata_o <= RSdata_i;
    	RTdata_o <= RTdata_i;
    	Sig_imm_o <= Sig_imm_i;
    	RSaddr_o <= RSaddr_i;
    	RTaddr1_o <= RTaddr1_i;
    	RTaddr2_o <= RTaddr2_i;
    	RDaddr_o <= RDaddr_i;
	end
    
end
endmodule
