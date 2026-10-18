library verilog;
use verilog.vl_types.all;
entity FIFO_RD is
    generic(
        POINTER_WIDTH   : integer := 4
    );
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        Rd_Req          : in     vl_logic;
        Gray_Wr_Ptr     : in     vl_logic_vector;
        Gray_Rd_Ptr     : out    vl_logic_vector;
        Empty_Flag      : out    vl_logic;
        Rd_Ptr          : out    vl_logic_vector;
        Rd_En           : out    vl_logic;
        Read_Accept     : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of POINTER_WIDTH : constant is 1;
end FIFO_RD;
