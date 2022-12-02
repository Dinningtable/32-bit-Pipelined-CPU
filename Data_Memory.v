module Data_Memory
(
	clk_i,
	rst_i,
	addr_i,
	data_i,
	enable_i,
	write_i,
	ack_o,
	data_o
);

// Interface
input				    clk_i;
input				    rst_i;
input	[31:0]		addr_i;
input	[255:0]		data_i;
input				    enable_i;
input				    write_i;
output	reg			  ack_o;
output	[255:0] data_o;


// Memory
reg		[255:0]		memory 			[0:511];	//16KB
reg		[3:0]		  count;
//wire				    ack;
reg					write_reg;
reg		[255:0]		data;
wire	[26:0]		addr;

parameter STATE_IDLE			= 2'h0,
			STATE_WAIT			= 2'h1,
			STATE_FINISH		= 2'h2;			

reg		[1:0]		state;

//assign	ack_o = ack;
assign	addr = addr_i>>5;
assign	data_o = data;

initial begin
	ack_o = 1'b0;
	data = 256'b0;
	state = 2'b0;
	count = 4'b0;
	write_reg = 1'b0;
end

//Controller 
always@(posedge clk_i) begin
	if(~rst_i) begin
		state <= STATE_IDLE;
		count <= 4'd0;
	end
	else begin
		case(state)
			STATE_IDLE: begin
				if(enable_i || write_i) begin
					state <= STATE_WAIT;
				end
				else begin
					state <= state;
				end
			end
			STATE_WAIT: begin
				if(count == 4'd9) begin
					ack_o <= 1'b1;
					state <= STATE_FINISH;
				end
				else begin
					count <= count + 1;
					state <= state;
				end
			end
			STATE_FINISH: begin
				ack_o <= 1'b0;
				count <= 4'd0;
				state <= STATE_IDLE;
			end
		endcase	
	end
end
/*
always@(posedge clk_i) begin
	if(~rst_i) begin
		count <= 4'd0;
	end
	else begin
		case(state) 
			STATE_IDLE: begin
				count <= 4'd0;
			end
			STATE_WAIT: begin
				count <= count + 1;
			end
			default: begin
				count <= 4'd0;
			end
		endcase	
	end
end

//assign ack = (state == STATE_WAIT) && (count == 4'd9);

always@(posedge clk_i) begin
	if(~rst_i) begin
		write_reg <= 0;
	end
	else begin
		case(state) 
			STATE_IDLE: begin
				write_reg <= write_i;
			end
			STATE_WAIT: begin
				write_reg <= write_reg;
			end
			default: begin
				write_reg <= 0;
			end
		endcase	
	end
end
*/
// Read Data       
always@(posedge clk_i) begin
    if(ack_o && !write_i) begin
		data = memory[addr];
	end
end

// Write Data      
always@(posedge clk_i) begin
    if(ack_o && write_i) begin
		memory[addr] <= data_i;
	end
end


endmodule
