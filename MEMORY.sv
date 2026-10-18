module MEMORY 
#(
parameter DATA_WIDTH = 8,
parameter FIFO_DEPTH = 16,
parameter ADDR_WIDTH = $clog2(FIFO_DEPTH)

)

(

input logic WR_CLK, RD_CLK, RST,
input logic [ADDR_WIDTH-1:0] Rd_Add,
input logic [ADDR_WIDTH-1:0] Wr_Add,
input logic [DATA_WIDTH-1:0] Wr_Data,
input logic Wr_en, //no need for a rd_en here
input logic Rd_En,
output logic [DATA_WIDTH-1:0] Rd_Data
);


logic [DATA_WIDTH-1:0] register [0:FIFO_DEPTH-1];

always @(posedge WR_CLK or negedge RST) begin
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

    always @(posedge RD_CLK or negedge RST) begin
        if (!RST) begin
            Rd_Data <= '0;
        end
        else if (Rd_En) begin
            Rd_Data <= register[Rd_Add];
        end
    end





endmodule