module FIFO_RD

#(
parameter POINTER_WIDTH = 4

)
(

input logic CLK, RST,
input logic Rd_Req,
input logic [POINTER_WIDTH-1:0] Gray_Wr_Ptr ,
output logic [POINTER_WIDTH-1:0] Gray_Rd_Ptr,
output logic Empty_Flag,
output logic [POINTER_WIDTH-1:0] Rd_Ptr,
output logic Rd_En,
output logic Read_Accept

);



logic [POINTER_WIDTH-1:0] rd_ptr;
logic [POINTER_WIDTH-1:0] gray_rd_ptr;
logic empty_flag;
logic [POINTER_WIDTH-1:0] next_rd_ptr;
logic [POINTER_WIDTH-1:0] next_gray_rd_ptr;

assign Read_Accept = Rd_Req && !Empty_Flag;


always_ff @(posedge CLK or negedge RST) begin
    if(!RST) begin
        rd_ptr <= '0;
    end
    else if(Read_Accept) begin
        rd_ptr <= rd_ptr + 1;
    end
end

always_ff @(posedge CLK or negedge RST) begin
    if(!RST) begin
        empty_flag <= 1'b1;
        Rd_En <= 1'b0;
    end
    else begin
        empty_flag <= (next_gray_rd_ptr == Gray_Wr_Ptr);
        Rd_En <= Read_Accept;
    end
end



assign gray_rd_ptr = (rd_ptr >> 1) ^ rd_ptr;
assign Gray_Rd_Ptr = gray_rd_ptr;
assign Rd_Ptr = rd_ptr;
assign Empty_Flag = empty_flag;
assign next_rd_ptr = rd_ptr + Read_Accept;
assign next_gray_rd_ptr = (next_rd_ptr >> 1) ^ next_rd_ptr;



endmodule
