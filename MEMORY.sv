module MEMORY 
#(
parameter DATA_WIDTH = 8,
parameter FIFO_DEPTH = 8,
parameter ADDR_WIDTH = $clog2(FIFO_DEPTH)

)

(

input logic WR_CLK, RST,
input logic [ADDR_WIDTH-1:0] Rd_Add,
input logic [ADDR_WIDTH-1:0] Wr_Add,
input logic [DATA_WIDTH-1:0] Wr_Data,
input logic Wr_en, //no need for a rd_en here
output logic [DATA_WIDTH-1:0] Rd_Data
);


logic [DATA_WIDTH-1:0] register [0:FIFO_DEPTH-1];

always @(posedge WR_CLK or posedge RST) begin
    if(!RST) begin
        for (int i = 0; i < FIFO_DEPTH; i++) begin
            register[i] <= '0;
        end
    end
    else 

        if (Wr_en) begin
            register [Wr_Add] <= Wr_Data;
        end

    end



assign Rd_Data = register[Rd_Add]; //keeping the value at all times but only read when rd_en is high.





endmodule