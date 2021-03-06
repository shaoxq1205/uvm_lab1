library verilog;
use verilog.vl_types.all;
entity rd_arbmux is
    port(
        o_rch_act       : out    vl_logic_vector(7 downto 0);
        o_sram_raddr    : out    vl_logic_vector(31 downto 0);
        o_sram_rsize    : out    vl_logic_vector(2 downto 0);
        o_sram_rblen    : out    vl_logic_vector(3 downto 0);
        o_sram_rbtyp    : out    vl_logic_vector(1 downto 0);
        o_sram_rd_req   : out    vl_logic;
        o_sram_rd_ena   : out    vl_logic;
        i_ch1_raddr     : in     vl_logic_vector(31 downto 0);
        i_ch1_rsize     : in     vl_logic_vector(2 downto 0);
        i_ch1_rblen     : in     vl_logic_vector(3 downto 0);
        i_ch1_rbtyp     : in     vl_logic_vector(1 downto 0);
        i_ch1_rd_req    : in     vl_logic;
        i_ch1_rd_ena    : in     vl_logic;
        i_ch1_fin       : in     vl_logic;
        i_ch2_raddr     : in     vl_logic_vector(31 downto 0);
        i_ch2_rsize     : in     vl_logic_vector(2 downto 0);
        i_ch2_rblen     : in     vl_logic_vector(3 downto 0);
        i_ch2_rbtyp     : in     vl_logic_vector(1 downto 0);
        i_ch2_rd_req    : in     vl_logic;
        i_ch2_rd_ena    : in     vl_logic;
        i_ch2_fin       : in     vl_logic;
        i_ch3_raddr     : in     vl_logic_vector(31 downto 0);
        i_ch3_rsize     : in     vl_logic_vector(2 downto 0);
        i_ch3_rblen     : in     vl_logic_vector(3 downto 0);
        i_ch3_rbtyp     : in     vl_logic_vector(1 downto 0);
        i_ch3_rd_req    : in     vl_logic;
        i_ch3_rd_ena    : in     vl_logic;
        i_ch3_fin       : in     vl_logic;
        i_ch4_raddr     : in     vl_logic_vector(31 downto 0);
        i_ch4_rsize     : in     vl_logic_vector(2 downto 0);
        i_ch4_rblen     : in     vl_logic_vector(3 downto 0);
        i_ch4_rbtyp     : in     vl_logic_vector(1 downto 0);
        i_ch4_rd_req    : in     vl_logic;
        i_ch4_rd_ena    : in     vl_logic;
        i_ch4_fin       : in     vl_logic;
        i_arb_freeze    : in     vl_logic;
        i_reset         : in     vl_logic;
        clk             : in     vl_logic
    );
end rd_arbmux;
