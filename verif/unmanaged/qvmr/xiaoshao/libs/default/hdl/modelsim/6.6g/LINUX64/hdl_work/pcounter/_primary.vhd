library verilog;
use verilog.vl_types.all;
entity pcounter is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        cfg_enable      : in     vl_logic;
        cfg_rd_wr       : in     vl_logic;
        cfg_addr        : in     vl_logic_vector(2 downto 0);
        cfg_wdata       : in     vl_logic_vector(9 downto 0);
        cfg_rdata       : out    vl_logic_vector(9 downto 0);
        counter_o       : out    vl_logic_vector(9 downto 0);
        curr_state_o    : out    vl_logic_vector(1 downto 0)
    );
end pcounter;
