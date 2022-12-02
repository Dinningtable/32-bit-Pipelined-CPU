module IF_ID(
    clk_i,
    Add_pc_i,
    Hazzard_i,
    inst_data_i,
    Flush_i,
    Add_pc_o,
    inst_o,
    hold_i
);

input	clk_i, Hazzard_i, Flush_i, hold_i;
input	[31:0]	Add_pc_i, inst_data_i;
output 	reg	[31:0]	Add_pc_o, inst_o;

initial begin
	Add_pc_o = 0;
	inst_o = 0;
end

always@(posedge clk_i) begin
	if(hold_i) begin
		Add_pc_o <= Add_pc_o;
		inst_o <= inst_o;
	end
	else begin
		Add_pc_o <= Flush_i ? 0 : Hazzard_i ? Add_pc_o : Add_pc_i;
    	inst_o <= Flush_i ? 0 : Hazzard_i ? inst_o : inst_data_i;
	end
end
    
endmodule
