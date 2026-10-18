library verilog;
use verilog.vl_types.all;
entity FIFO_WR is
    generic(
        FIFO_DEPTH      : integer := 16;
        DATA_WIDTH      : integer := 8;
        POINTER_WIDTH   : vl_notype
    );
    port(
        WR_CLK          : in     vl_logic;
        RST             : in     vl_logic;
        Wr_Req          : in     vl_logic;
        Gray_Rd_Pointer : in     vl_logic_vector;
        Wr_Pointer      : out    vl_logic_vector;
        Gray_Wr_Pointer : out    vl_logic_vector;
        FIFO_FULL       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FIFO_DEPTH : constant is 1;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of POINTER_WIDTH : constant is 3;
end FIFO_WR;
