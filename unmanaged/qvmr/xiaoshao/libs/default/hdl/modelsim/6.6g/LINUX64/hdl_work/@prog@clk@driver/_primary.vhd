library verilog;
use verilog.vl_types.all;
entity ProgClkDriver is
    generic(
        CLK_INITIAL_VALUE: integer := 0;
        CLK_INITIAL_OFFSET: integer := 1;
        CLK_INITIAL_LO  : integer := 20;
        CLK_INITIAL_HI  : integer := 20
    );
    port(
        hclk            : out    vl_logic
    );
end ProgClkDriver;
