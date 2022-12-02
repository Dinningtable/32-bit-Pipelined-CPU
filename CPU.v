module CPU
(
    clk_i, 
    rst_i,
	start_i,
   
	mem_data_i, 
	mem_ack_i, 	
	mem_data_o, 
	mem_addr_o, 	
	mem_enable_o, 
	mem_write_o
);

//input
input clk_i;
input rst_i;
input start_i;

//
// to Data Memory interface		
//
input	[256-1:0]	mem_data_i; 
input				mem_ack_i; 	
output reg	[256-1:0]	mem_data_o; 
output reg	[32-1:0]	mem_addr_o; 	
output reg				mem_enable_o; 
output reg				mem_write_o;

wire [255:0] mem_data;
wire [31:0] mem_addr;
wire mem_enable;
wire mem_write;

always @(mem_write or mem_data or mem_addr or mem_enable) begin
	mem_data_o <= mem_data;
	mem_addr_o <= mem_addr;
	mem_enable_o <= mem_enable;
	mem_write_o <= mem_write;
end


wire 	[31:0]	mux2_result;
wire	[31:0]	mux1_result;
wire	[31:0]	Jump_addr;
wire	Jump;
MUX32 mux2(
    .data1_i	(mux1_result),
    .data2_i	(Jump_addr),
    .select_i	(Jump),
    .data_o	(mux2_result)
);

wire	Branch_result;
wire	[31:0]	Add_pc_result;
wire	[31:0]	ADD_result;
MUX32 mux1(
    .data1_i	(Add_pc_result),
    .data2_i	(ADD_result),
    .select_i	(Branch_result),
    .data_o	(mux1_result)
);

wire	Branch;
AND_Gate AND(
    .input1	(Eq_result),
    .input2	(Branch),
    .result	(Branch_result)
);

wire	[31:0] inst_addr;
Adder Add_PC(
    .data1_i    (inst_addr),
    .data2_i    (32'b00000000000000000000000000000100),
    .data_o     (Add_pc_result)
);

wire	[31:0] inst;
wire  PC_stall, p1_stall;
PC PC(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.start_i(start_i),
	.stall_i(PC_stall),
	.pcEnable_i(p1_stall),
	.pc_i(mux2_result),
	.pc_o(inst_addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    (inst)
);

wire	Flush;
OR_Gate OR(
    .input1	(Jump),
    .input2	(Branch_result),
    .result	(Flush)
);

wire	[31:0]	IF_ID_inst, IF_ID_pc;
IF_ID IF_ID(
    .clk_i	(clk_i),
    .Add_pc_i	(Add_pc_result),
    .Hazzard_i	(IF_ID_stall),
    .inst_data_i	(inst),
    .Flush_i	(Flush),
    .Add_pc_o	(IF_ID_pc),
    .inst_o	(IF_ID_inst),
    .hold_i	(p1_stall)
);

wire	[27:0]	Sf_inst;

Shift_Left26 Shift_Left2(
    .data_i	(IF_ID_inst[25:0]),
    .data_o	(Sf_inst)
);
assign	Jump_addr = {mux1_result[31:28], Sf_inst};
wire	[1:0]	ID_EX_M;
wire	[4:0]	ID_EX_RTaddr2;
Hazzard_detection Hazzard_detection_unit(
    .clk_i	(clk_i),
    .IF_ID_RSaddr_i	(IF_ID_inst[25:21]),
    .IF_ID_RTaddr_i	(IF_ID_inst[20:16]),
    .ID_EX_RTaddr_i	(ID_EX_RTaddr2),
    .ID_EX_M_i	(ID_EX_M),
    .PC_stall_o	(PC_stall),
    .IF_ID_stall_o	(IF_ID_stall),
    .ID_EX_stall_o	(ID_EX_stall)
);

wire	[7:0]	following_signals;
Control Control(
    .Op_i       (IF_ID_inst[31:26]),
    .Branch_o   (Branch),
    .Jump_o    (Jump),
    .EX_MEM_WB_signals_o   (following_signals)
);

wire	[7:0]	mux3_result;
MUX8 mux3(
    .data1_i	(following_signals),
    .data2_i	(8'b0),
    .select_i	(ID_EX_stall),
    .data_o	(mux3_result)
);

wire	[31:0]	SigEx_imm;
Sign_Extend Sign_Extend(
    .data_i     (IF_ID_inst[15:0]),
    .data_o     (SigEx_imm)
);

wire	[31:0]	Sig_Sf_imm;
Shift_Left32 Shift_Left1(
    .data_i	(SigEx_imm),
    .data_o	(Sig_Sf_imm)
);

Adder ADD(
    .data1_i	(Sig_Sf_imm),
    .data2_i	(IF_ID_pc),
    .data_o	(ADD_result)
);

wire	RegWrite;
wire	[4:0]	MEM_WB_mux8_result;
wire	[31:0]	mux5_result, RSdata, RTdata;
Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (IF_ID_inst[25:21]),
    .RTaddr_i   (IF_ID_inst[20:16]),
    .RDaddr_i   (MEM_WB_mux8_result), 
    .RDdata_i   (mux5_result),
    .RegWrite_i (RegWrite), 
    .RSdata_o   (RSdata), 
    .RTdata_o   (RTdata) 
);

Eq Eq(
    .data1_i	(RSdata),
    .data2_i	(RTdata),
    .data_o	(Eq_result)
);

wire	[1:0]	ID_EX_WB, ALUOp;
wire	[31:0]	ID_EX_SigEx_imm;
wire	[31:0]	ID_EX_RSdata, ID_EX_RTdata;
wire	[4:0]	ID_EX_RSaddr, ID_EX_RTaddr1, ID_EX_RDaddr;
wire    ALUSrc, RegDst;
ID_EX ID_EX(
    .clk_i	(clk_i),
    .WB_i	(mux3_result[7:6]),
    .WB_o	(ID_EX_WB),
    .M_i	(mux3_result[5:4]),
    .M_o	(ID_EX_M),
    .EX_i	(mux3_result[3:0]),
    .ALUSrc_o	(ALUSrc),
    .ALUOp_o	(ALUOp),
    .RegDst_o	(RegDst),
    .RSdata_i	(RSdata),
    .RSdata_o	(ID_EX_RSdata),
    .RTdata_i	(RTdata),
    .RTdata_o	(ID_EX_RTdata),
    .Sig_imm_i	(SigEx_imm),
    .Sig_imm_o	(ID_EX_SigEx_imm),
    .RSaddr_i	(IF_ID_inst[25:21]),
    .RSaddr_o	(ID_EX_RSaddr),
    .RTaddr1_i	(IF_ID_inst[20:16]),
    .RTaddr1_o	(ID_EX_RTaddr1),
    .RTaddr2_i	(IF_ID_inst[20:16]),
    .RTaddr2_o	(ID_EX_RTaddr2),
    .RDaddr_i	(IF_ID_inst[15:11]),
    .RDaddr_o	(ID_EX_RDaddr),
    .hold_i	(p1_stall)
);

wire	[31:0]	mux6_result;
wire	[1:0]	ForwardA, ForwardB;
wire	[31:0]	EX_MEM_ALUresult;
MultiMUX32 mux6(
    .data1_i	(ID_EX_RSdata),
    .data2_i	(mux5_result),
    .data3_i	(EX_MEM_ALUresult),
    .select_i	(ForwardA),
    .data_o	(mux6_result)
);

wire 	[31:0]	mux7_result;
MultiMUX32 mux7(
    .data1_i	(ID_EX_RTdata),
    .data2_i	(mux5_result),
    .data3_i	(EX_MEM_ALUresult),
    .select_i	(ForwardB),
    .data_o	(mux7_result)
);

wire	[31:0]	mux4_result;
//MUX_ALUSrc
MUX32 mux4(
    .data1_i    (mux7_result),
    .data2_i    (ID_EX_SigEx_imm),
    .select_i   (ALUSrc),
    .data_o     (mux4_result)
);

wire	[2:0]	ALUCtrl;
ALU_Control ALU_Control(
    .funct_i    (ID_EX_SigEx_imm[5:0]),
    .ALUOp_i    (ALUOp),
    .ALUCtrl_o  (ALUCtrl)
);

wire 	[31:0]	ALUresult;
ALU ALU(
    .data1_i    (mux6_result),
    .data2_i    (mux4_result),
    .ALUCtrl_i  (ALUCtrl),
    .data_o     (ALUresult),
    .Zero_o     ()
);


//MUX_RegDst
wire	[4:0]	mux8_result;
MUX5 mux8(
    .data1_i    (ID_EX_RTaddr2),
    .data2_i    (ID_EX_RDaddr),
    .select_i   (RegDst),
    .data_o     (mux8_result)
);

wire	[1:0]	EX_MEM_WB;
wire	[4:0]	EX_MEM_mux8_result;
Forwarding Forwarding_unit(
    .clk_i	(clk_i),
    .ID_EX_RSaddr_i	(ID_EX_RSaddr),
    .ID_EX_RTaddr_i	(ID_EX_RTaddr1),
    .EX_MEM_mux8_i	(EX_MEM_mux8_result),
    .EX_MEM_WBs_i	(EX_MEM_WB),
    .MEM_WB_mux8_i	(MEM_WB_mux8_result),
    .MEM_WB_RegWrite_i	(RegWrite),
    .for_mux6	(ForwardA),
    .for_mux7	(ForwardB)
);

wire	MemRead, MemWrite;
wire    [31:0]  EX_MEM_mux7_result;
EX_MEM EX_MEM(
    .clk_i	(clk_i),
    .WB_i	(ID_EX_WB),
    .WB_o	(EX_MEM_WB),
    .M_i	(ID_EX_M),
    .MemRead_o	(MemRead),
    .MemWrite_o	(MemWrite),
    .ALU_i	(ALUresult),
    .ALU_o	(EX_MEM_ALUresult),
    .mux7_i	(mux7_result),
    .mux7_o	(EX_MEM_mux7_result),
    .mux8_i	(mux8_result),
    .mux8_o	(EX_MEM_mux8_result),
    .hold_i	(p1_stall)
);

wire	[31:0]	Read_data;
dcache_top dcache(
    // System clock, reset and stall
	.clk_i(clk_i), 
	.rst_i(rst_i),
	
	// to Data Memory interface		
	.mem_data_i(mem_data_i), 
	.mem_ack_i(mem_ack_i), 	
	.mem_data_o(mem_data), 
	.mem_addr_o(mem_addr), 	
	.mem_enable_o(mem_enable), 
	.mem_write_o(mem_write), 
	
	// to CPU interface	
	.p1_data_i(EX_MEM_mux7_result), 
	.p1_addr_i(EX_MEM_ALUresult), 	
	.p1_MemRead_i(MemRead), 
	.p1_MemWrite_i(MemWrite), 
	.p1_data_o(Read_data), 
	.p1_stall_o(p1_stall)
);

wire	MemtoReg;
wire	[31:0]	MEM_WB_read_data, MEM_WB_ALUresult;
MEM_WB MEM_WB(
    .clk_i	(clk_i),
    .WB_i	(EX_MEM_WB),
    .RegWrite_o	(RegWrite),
    .MemtoReg_o	(MemtoReg),
    .Read_data_i	(Read_data),
    .Read_data_o	(MEM_WB_read_data),
    .ALUresult_i	(EX_MEM_ALUresult),
    .ALUresult_o	(MEM_WB_ALUresult),
    .mux8_result_i	(EX_MEM_mux8_result),
    .mux8_result_o	(MEM_WB_mux8_result),
    .hold_i	(p1_stall)
);

MUX32 mux5(
    .data1_i	(MEM_WB_ALUresult),
    .data2_i	(MEM_WB_read_data),
    .select_i	(MemtoReg),
    .data_o	(mux5_result)
);
endmodule

