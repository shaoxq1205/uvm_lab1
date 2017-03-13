library verilog;
use verilog.vl_types.all;
entity sram_rstatem is
    generic(
        DATA_WIDTH      : integer := 64
    );
    port(
        o_rvalid        : out    vl_logic;
        o_sram_rd_ack   : out    vl_logic;
        o_sram_rd_vld   : out    vl_logic;
        o_sram_datr     : out    vl_logic_vector;
        o_sram_adrr     : out    vl_logic_vector(31 downto 0);
        o_sram_last     : out    vl_logic;
        o_rd_freeze     : out    vl_logic;
        i_sram_rd_rdy   : in     vl_logic;
        i_sram_rdata    : in     vl_logic_vector;
        i_sram_raddr    : in     vl_logic_vector(31 downto 0);
        i_sram_rsize    : in     vl_logic_vector(2 downto 0);
        i_sram_rblen    : in     vl_logic_vector(3 downto 0);
        i_sram_rbtyp    : in     vl_logic_vector(1 downto 0);
        i_sram_rd_req   : in     vl_logic;
        i_sram_rd_ena   : in     vl_logic;
        i_axi_rbeat     : in     vl_logic;
        i_reset         : in     vl_logic;
        clk             : in     vl_logic
    );
end sram_rstatem;
