library verilog;
use verilog.vl_types.all;
entity FIFO_TOP is
    generic(
        DATA_WIDTH      : integer := 8;
        FIFO_DEPTH      : integer := 16;
        ADDR_WIDTH      : vl_notype;
        POINTER_WIDTH   : vl_notype
    );
    port(
        WR_CLK          : in     vl_logic;
        RD_CLK          : in     vl_logic;
        RST             : in     vl_logic;
        Wr_Data         : in     vl_logic_vector;
        Wr_Req          : in     vl_logic;
        Rd_Req          : in     vl_logic;
        Rd_En           : out    vl_logic;
        Rd_Data         : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of FIFO_DEPTH : constant is 1;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 3;
    attribute mti_svvh_generic_type of POINTER_WIDTH : constant is 3;
end FIFO_TOP;
