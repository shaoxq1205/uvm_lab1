library verilog;
use verilog.vl_types.all;
entity channel_fifo is
    generic(
        FIFO_DEPTH      : integer := 8;
        FIFO_WIDTH      : integer := 64
    );
    port(
        o_data          : out    vl_logic_vector;
        o_full          : out    vl_logic;
        o_mpty          : out    vl_logic;
        i_data          : in     vl_logic_vector;
        i_wren          : in     vl_logic;
        i_rden          : in     vl_logic;
        reset           : in     vl_logic;
        clk             : in     vl_logic
    );
end channel_fifo;
