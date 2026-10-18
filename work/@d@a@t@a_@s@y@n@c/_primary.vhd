library verilog;
use verilog.vl_types.all;
entity DATA_SYNC is
    generic(
        DATA_WIDTH      : integer := 8
    );
    port(
        CLK1            : in     vl_logic;
        RST             : in     vl_logic;
        DATA_IN         : in     vl_logic_vector;
        DATA_OUT        : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
end DATA_SYNC;
