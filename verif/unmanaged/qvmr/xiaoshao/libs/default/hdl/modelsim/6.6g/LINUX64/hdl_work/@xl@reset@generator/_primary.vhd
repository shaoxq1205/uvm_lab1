library verilog;
use verilog.vl_types.all;
entity XlResetGenerator is
    generic(
        NUM_RESET_CYCLES: integer := 8;
        NUM_POST_RESET_CYCLES: integer := 0
    );
    port(
        clock           : in     vl_logic;
        reset           : out    vl_logic
    );
end XlResetGenerator;
