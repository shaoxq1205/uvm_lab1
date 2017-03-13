library verilog;
use verilog.vl_types.all;
entity ClkRstDriver is
    generic(
        CLK_INITIAL_VALUE: integer := 0;
        NUM_RESET_CYCLES: integer := 20;
        CLK_INITIAL_HI  : integer := 20;
        CLK_INITIAL_LO  : integer := 30;
        CLK_INITIAL_OFFSET: integer := 30;
        RESET_ACTIVE_LOW: integer := 1
    );
    port(
        clock           : out    vl_logic;
        gclock          : out    vl_logic;
        reset           : out    vl_logic
    );
end ClkRstDriver;
