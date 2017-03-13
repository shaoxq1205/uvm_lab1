library verilog;
use verilog.vl_types.all;
entity pcounter_wrapper is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic
    );
end pcounter_wrapper;
