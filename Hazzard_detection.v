module Hazzard_detection(
    clk_i,
    IF_ID_RSaddr_i,
    IF_ID_RTaddr_i,
    ID_EX_RTaddr_i,
    ID_EX_M_i,
    PC_stall_o,
    IF_ID_stall_o,
    ID_EX_stall_o
);

input	clk_i;
input	[1:0]	ID_EX_M_i;
input	[4:0]	IF_ID_RSaddr_i, IF_ID_RTaddr_i, ID_EX_RTaddr_i;
output	reg	PC_stall_o, IF_ID_stall_o, ID_EX_stall_o;

always@(posedge clk_i) begin
    if(ID_EX_M_i[1] && ((ID_EX_RTaddr_i == IF_ID_RSaddr_i) || (ID_EX_RTaddr_i == IF_ID_RTaddr_i)))
	begin
	  PC_stall_o <= 1;
	  IF_ID_stall_o <= 1;
	  ID_EX_stall_o <= 1;
	end
	else
	begin
	  PC_stall_o <= 0;
	  IF_ID_stall_o <= 0;
	  ID_EX_stall_o <= 0;
	end
end
endmodule
