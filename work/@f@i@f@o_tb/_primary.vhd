library verilog;
use verilog.vl_types.all;
entity FIFO_tb is
    generic(
        DATA_WIDTH      : integer := 8;
        FIFO_DEPTH      : integer := 16;
        ADDR_WIDTH      : vl_notype;
        POINTER_WIDTH   : vl_notype;
        WR_CLK_PERIOD   : integer := 10;
        RD_CLK_PERIOD   : integer := 15
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of FIFO_DEPTH : constant is 1;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 3;
    attribute mti_svvh_generic_type of POINTER_WIDTH : constant is 3;
    attribute mti_svvh_generic_type of WR_CLK_PERIOD : constant is 1;
    attribute mti_svvh_generic_type of RD_CLK_PERIOD : constant is 1;
end FIFO_tb;
