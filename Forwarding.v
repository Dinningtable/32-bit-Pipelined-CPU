module Forwarding(
    clk_i,
    ID_EX_RSaddr_i,
    ID_EX_RTaddr_i,
    EX_MEM_mux8_i,
    EX_MEM_WBs_i,
    MEM_WB_mux8_i,
    MEM_WB_RegWrite_i,
    for_mux6,
    for_mux7
);

input	clk_i, MEM_WB_RegWrite_i;
input	[1:0]	EX_MEM_WBs_i;
input	[4:0]	ID_EX_RSaddr_i, ID_EX_RTaddr_i, EX_MEM_mux8_i, MEM_WB_mux8_i;
output	reg	[1:0]	for_mux6, for_mux7;
reg aaa;
reg [4:0] bbb ,ccc,ddd,eee;
always@(MEM_WB_RegWrite_i or EX_MEM_WBs_i[1] or ID_EX_RSaddr_i or ID_EX_RTaddr_i or EX_MEM_mux8_i or MEM_WB_mux8_i) begin
    aaa=MEM_WB_RegWrite_i;
    bbb=MEM_WB_mux8_i;
    ccc=EX_MEM_mux8_i;
    ddd=ID_EX_RSaddr_i;
    eee=ID_EX_RTaddr_i;
    //EX hazard
    if(EX_MEM_WBs_i[1] && (EX_MEM_mux8_i != 0) && (EX_MEM_mux8_i == ID_EX_RSaddr_i))
	begin
	    for_mux6 <= 2'b10;
	end
	//MEM hazard
	else if(MEM_WB_RegWrite_i && (MEM_WB_mux8_i != 0) && (EX_MEM_mux8_i != ID_EX_RSaddr_i) && (MEM_WB_mux8_i == ID_EX_RSaddr_i))
	begin
	    for_mux6 <= 2'b01;
	end
	else
		for_mux6 <= 2'b00;
    //EX hazard
    if(EX_MEM_WBs_i[1] && (EX_MEM_mux8_i != 0) && (EX_MEM_mux8_i == ID_EX_RTaddr_i))
	begin
	    for_mux7 <= 2'b10;
	end
	//MEM hazard
    else if(MEM_WB_RegWrite_i && (MEM_WB_mux8_i != 0) && (EX_MEM_mux8_i != ID_EX_RTaddr_i) && (MEM_WB_mux8_i == ID_EX_RTaddr_i))
	begin
	    for_mux7 <= 2'b01;
	end
	else
		for_mux7 <= 2'b00;
end

endmodule
