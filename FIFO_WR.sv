module FIFO_WR
#(

parameter FIFO_DEPTH = 8,
parameter DATA_WIDTH = 8,
parameter POINTER_WIDTH = $clog2(FIFO_DEPTH)+1
)


(
input logic WR_CLK, RST,
input logic Wr_Req,

input logic [POINTER_WIDTH-1 : 0] Gray_Rd_Pointer, 


output logic [POINTER_WIDTH-1 : 0] Wr_Pointer,
output logic [POINTER_WIDTH-1 : 0] Gray_Wr_Pointer,

output logic FIFO_FULL

);


logic [POINTER_WIDTH-1 : 0] wr_pointer;
logic [POINTER_WIDTH-1 : 0] gray_wr_pointer;
logic fifo_full;
logic [POINTER_WIDTH-1:0] next_wr_pointer;
logic [POINTER_WIDTH-1:0] next_gray_wr_pointer;

assign next_wr_pointer =
    wr_pointer + (Wr_Req && !fifo_full);

assign next_gray_wr_pointer =
    (next_wr_pointer >> 1) ^ next_wr_pointer;



assign gray_wr_pointer = wr_pointer ^ (wr_pointer >> 1);


always @(posedge WR_CLK or negedge RST) begin
    if (!RST) begin
        wr_pointer <= 0;
    end


    else begin
        
        if (!fifo_full && Wr_Req) begin
            wr_pointer <= wr_pointer +1;
        end
    end

end





always @(posedge WR_CLK or negedge RST) begin
    if (!RST) begin
        FIFO_FULL <=0;
    end

    else 
    FIFO_FULL <= fifo_full;


end



assign fifo_full =
    (next_gray_wr_pointer == {
        ~Gray_Rd_Pointer[POINTER_WIDTH-1:POINTER_WIDTH-2],
         Gray_Rd_Pointer[POINTER_WIDTH-3:0]
    });


assign Wr_Pointer = wr_pointer;
assign Gray_Wr_Pointer = gray_wr_pointer;








endmodule