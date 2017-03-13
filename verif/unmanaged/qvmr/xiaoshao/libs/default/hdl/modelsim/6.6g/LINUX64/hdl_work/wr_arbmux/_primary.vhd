library verilog;
use verilog.vl_types.all;
entity wr_arbmux is
    generic(
        DATA_WIDTH      : integer := 64
    );
    port(
        o_wch_act       : out    vl_logic_vector(7 downto 0);
        o_sram_wdata    : out    vl_logic_vector;
        o_sram_waddr    : out    vl_logic_vector(31 downto 0);
        o_sram_wbena    : out    vl_logic_vector(15 downto 0);
        o_sram_wsize    : out    vl_logic_vector(2 downto 0);
        o_sram_wblen    : out    vl_logic_vector(3 downto 0);
        o_sram_wbtyp    : out    vl_logic_vector(1 downto 0);
        o_sram_wr_rdy   : out    vl_logic;
        o_sram_wr_req   : out    vl_logic;
        i_ch1_wdata     : in     vl_logic_vector;
        i_ch1_waddr     : in     vl_logic_vector(31 downto 0);
        i_ch1_wbena     : in     vl_logic_vector(15 downto 0);
        i_ch1_wsize     : in     vl_logic_vector(2 downto 0);
        i_ch1_wblen     : in     vl_logic_vector(3 downto 0);
        i_ch1_wbtyp     : in     vl_logic_vector(1 downto 0);
        i_ch1_wr_rdy    : in     vl_logic;
        i_ch1_wr_req    : in     vl_logic;
        i_ch1_fin       : in     vl_logic;
        i_ch2_wdata     : in     vl_logic_vector;
        i_ch2_waddr     : in     vl_logic_vector(31 downto 0);
        i_ch2_wbena     : in     vl_logic_vector(15 downto 0);
        i_ch2_wsize     : in     vl_logic_vector(2 downto 0);
        i_ch2_wblen     : in     vl_logic_vector(3 downto 0);
        i_ch2_wbtyp     : in     vl_logic_vector(1 downto 0);
        i_ch2_wr_rdy    : in     vl_logic;
        i_ch2_wr_req    : in     vl_logic;
        i_ch2_fin       : in     vl_logic;
        i_ch3_wdata     : in     vl_logic_vector;
        i_ch3_waddr     : in     vl_logic_vector(31 downto 0);
        i_ch3_wbena     : in     vl_logic_vector(15 downto 0);
        i_ch3_wsize     : in     vl_logic_vector(2 downto 0);
        i_ch3_wblen     : in     vl_logic_vector(3 downto 0);
        i_ch3_wbtyp     : in     vl_logic_vector(1 downto 0);
        i_ch3_wr_rdy    : in     vl_logic;
        i_ch3_wr_req    : in     vl_logic;
        i_ch3_fin       : in     vl_logic;
        i_ch4_wdata     : in     vl_logic_vector;
        i_ch4_waddr     : in     vl_logic_vector(31 downto 0);
        i_ch4_wbena     : in     vl_logic_vector(15 downto 0);
        i_ch4_wsize     : in     vl_logic_vector(2 downto 0);
        i_ch4_wblen     : in     vl_logic_vector(3 downto 0);
        i_ch4_wbtyp     : in     vl_logic_vector(1 downto 0);
        i_ch4_wr_rdy    : in     vl_logic;
        i_ch4_wr_req    : in     vl_logic;
        i_ch4_fin       : in     vl_logic;
        i_arb_freeze    : in     vl_logic;
        i_reset         : in     vl_logic;
        clk             : in     vl_logic
    );
end wr_arbmux;
