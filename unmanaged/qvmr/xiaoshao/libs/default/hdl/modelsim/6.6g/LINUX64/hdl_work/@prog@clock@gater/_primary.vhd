library verilog;
use verilog.vl_types.all;
entity ProgClockGater is
    port(
        hclk            : in     vl_logic;
        oclk            : out    vl_logic
    );
end ProgClockGater;
