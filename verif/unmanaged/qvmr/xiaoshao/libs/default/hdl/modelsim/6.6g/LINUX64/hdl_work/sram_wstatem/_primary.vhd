library verilog;
use verilog.vl_types.all;
entity sram_wstatem is
    generic(
        DATA_WIDTH      : integer := 64
    );
    port(
        o_bvalid        : out    vl_logic;
        o_sram_wr_ack   : out    vl_logic;
        o_sram_wr_vld   : out    vl_logic;
        o_sram_we       : out    vl_logic;
        o_sram_datw     : out    vl_logic_vector;
        o_sram_adrw     : out    vl_logic_vector(31 downto 0);
        o_sram_benw     : out    vl_logic_vector(15 downto 0);
        o_wr_freeze     : out    vl_logic;
        i_bready        : in     vl_logic;
        i_sram_wdata    : in     vl_logic_vector;
        i_sram_waddr    : in     vl_logic_vector(31 downto 0);
        i_sram_wbena    : in     vl_logic_vector(15 downto 0);
        i_sram_wsize    : in     vl_logic_vector(2 downto 0);
        i_sram_wblen    : in     vl_logic_vector(3 downto 0);
        i_sram_wbtyp    : in     vl_logic_vector(1 downto 0);
        i_sram_wr_rdy   : in     vl_logic;
        i_sram_wr_req   : in     vl_logic;
        i_reset         : in     vl_logic;
        clk             : in     vl_logic
    );
end sram_wstatem;
