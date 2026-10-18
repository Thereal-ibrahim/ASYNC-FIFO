module FIFO_TOP
#(
parameter DATA_WIDTH = 8,
parameter FIFO_DEPTH = 16,
parameter ADDR_WIDTH = $clog2(FIFO_DEPTH),
parameter POINTER_WIDTH = ADDR_WIDTH + 1

)


(
input logic WR_CLK, RD_CLK, RST,
input logic [DATA_WIDTH-1:0] Wr_Data,
input logic Wr_Req,
input logic Rd_Req,
output logic Rd_En,
output logic [DATA_WIDTH-1:0] Rd_Data
);




logic Empty_Flag;
logic [POINTER_WIDTH-1:0] Gray_Rd_Ptr;
logic [POINTER_WIDTH-1:0] Gray_Wr_Ptr;
logic [POINTER_WIDTH-1:0] Gray_Rd_Ptr_Sync;
logic [POINTER_WIDTH-1:0] Gray_Wr_Ptr_Sync;
logic [POINTER_WIDTH-1:0] Rd_Ptr;
logic [POINTER_WIDTH-1:0] Wr_Ptr;
logic FIFO_FULL;
logic Wr_en;
logic Read_Accept;

assign Wr_en = Wr_Req && !FIFO_FULL;



FIFO_WR #(
.DATA_WIDTH(DATA_WIDTH),
.FIFO_DEPTH(FIFO_DEPTH),
.POINTER_WIDTH(ADDR_WIDTH+1)
) fifo_wr_inst (
.WR_CLK(WR_CLK),
.RST(RST),
.Wr_Req(Wr_Req),
.Gray_Rd_Pointer(Gray_Rd_Ptr_Sync),
.Wr_Pointer(Wr_Ptr),
.Gray_Wr_Pointer(Gray_Wr_Ptr),
.FIFO_FULL(FIFO_FULL)
);  



FIFO_RD #(
.POINTER_WIDTH(ADDR_WIDTH+1)
) fifo_rd_inst (
.CLK(RD_CLK),
.RST(RST),
.Rd_Req(Rd_Req),
.Gray_Wr_Ptr(Gray_Wr_Ptr_Sync),
.Gray_Rd_Ptr(Gray_Rd_Ptr),
.Empty_Flag(Empty_Flag),
.Rd_Ptr(Rd_Ptr),
.Rd_En(Rd_En),
.Read_Accept(Read_Accept)
);



DATA_SYNC #(
.DATA_WIDTH(POINTER_WIDTH)
) data_sync_inst (
.CLK1(RD_CLK),
.RST(RST),
.DATA_IN(Gray_Wr_Ptr),
.DATA_OUT(Gray_Wr_Ptr_Sync)
);


DATA_SYNC #(
.DATA_WIDTH(ADDR_WIDTH+1)
) gray_rd_sync_inst (
.CLK1(WR_CLK),
.RST(RST),
.DATA_IN(Gray_Rd_Ptr),
.DATA_OUT(Gray_Rd_Ptr_Sync)
);



MEMORY #(
.DATA_WIDTH(DATA_WIDTH),
.FIFO_DEPTH(FIFO_DEPTH),
.ADDR_WIDTH(ADDR_WIDTH)
) memory_inst (
.WR_CLK(WR_CLK),
.RD_CLK(RD_CLK),
.RST(RST),
.Rd_Add(Rd_Ptr[ADDR_WIDTH-1:0]),
.Wr_Add(Wr_Ptr[ADDR_WIDTH-1:0]),
.Wr_Data(Wr_Data),
.Wr_en(Wr_en),
.Rd_En(Read_Accept),
.Rd_Data(Rd_Data)
);








endmodule