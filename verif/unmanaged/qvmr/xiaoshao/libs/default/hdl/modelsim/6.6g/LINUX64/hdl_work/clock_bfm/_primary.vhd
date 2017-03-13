library verilog;
use verilog.vl_types.all;
entity clock_bfm is
    port(
        clk             : out    vl_logic;
        rst             : out    vl_logic
    );
end clock_bfm;
