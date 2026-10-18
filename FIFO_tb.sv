`timescale 1ns/1ps 

module FIFO_tb;

logic WR_CLK, RD_CLK, RST;
logic [7:0] Wr_Data;
logic Wr_Req;
logic Rd_Req;
logic Rd_En;
logic [7:0] Rd_Data;
integer wr_file;
integer rd_file;



parameter DATA_WIDTH = 8;
parameter FIFO_DEPTH = 16;
parameter ADDR_WIDTH = $clog2(FIFO_DEPTH);
parameter POINTER_WIDTH = ADDR_WIDTH + 1;


parameter WR_CLK_PERIOD = 10; //frequency = 100MHz
parameter RD_CLK_PERIOD = 15; //frequency = 66.67MHz

//with depth 8, the FIFO should handle a burst of 24 data words



initial begin
    WR_CLK = 0;
    forever #(WR_CLK_PERIOD/2) WR_CLK = ~WR_CLK; // the forever loop stops me from adding another line of code after it, so I will add the RD_CLK generation in a separate initial block
end

initial begin
    RD_CLK = 0;
    forever #(RD_CLK_PERIOD/2) RD_CLK = ~RD_CLK;
end

FIFO_TOP #(
    .DATA_WIDTH(DATA_WIDTH),
    .FIFO_DEPTH(FIFO_DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .POINTER_WIDTH(POINTER_WIDTH)
) dut (
    .WR_CLK(WR_CLK),
    .RD_CLK(RD_CLK),
    .RST(RST),
    .Wr_Data(Wr_Data),
    .Wr_Req(Wr_Req),
    .Rd_Req(Rd_Req),
    .Rd_En(Rd_En),
    .Rd_Data(Rd_Data)
);

initial begin
    wr_file = $fopen("Wr_Data.txt", "w");
    rd_file = $fopen("Rd_Data.txt", "w");

    if (wr_file == 0 || rd_file == 0) begin
        $fatal(1, "Could not open Wr_Data.txt or Rd_Data.txt");
    end
end

always @(posedge WR_CLK) begin
    if (RST && dut.Wr_en) begin
        $fdisplay(wr_file, "%0h", Wr_Data);
    end
end

always @(posedge RD_CLK) begin
    if (RST && dut.Read_Accept) begin
        $fstrobe(rd_file, "%0h", Rd_Data);
    end
end



task automatic reset;
    begin
        RST = 1;
        #(WR_CLK_PERIOD*2);
        RST = 0;
        #(WR_CLK_PERIOD*2);
        RST = 1;
    end
endtask

task automatic burst_write(input int num_words);
    int i;
    begin
        for (i = 0; i < num_words; i++) begin
            @(negedge WR_CLK);
            Wr_Data = $urandom_range(0, 255);
            Wr_Req = 1;
            @(posedge WR_CLK);
        end
        @(negedge WR_CLK);
        Wr_Req = 0;
    end
endtask

initial begin
    Wr_Data = '0;
    Wr_Req = 0;
    Rd_Req = 0;
    reset();
    #(WR_CLK_PERIOD*2);
    Rd_Req = 1;
    
    for (int i = 0; i < 27; i++) begin
        #(WR_CLK_PERIOD);
        burst_write(24);
    end
    
    

    #(RD_CLK_PERIOD*100);
    $fclose(wr_file);
    $fclose(rd_file);
    $finish;
end




endmodule