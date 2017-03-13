library verilog;
use verilog.vl_types.all;
entity axi_rd_bfr is
    generic(
        ID_WIDTH        : integer := 4;
        FIFO_DEPTH      : integer := 8;
        DATA_WIDTH      : integer := 64
    );
    port(
        i_aid           : in     vl_logic_vector;
        i_addr          : in     vl_logic_vector(31 downto 0);
        i_alen          : in     vl_logic_vector(3 downto 0);
        i_asize         : in     vl_logic_vector(2 downto 0);
        i_aburst        : in     vl_logic_vector(1 downto 0);
        i_alock         : in     vl_logic_vector(1 downto 0);
        i_acache        : in     vl_logic_vector(3 downto 0);
        i_aprot         : in     vl_logic_vector(2 downto 0);
        i_avalid        : in     vl_logic;
        o_aready        : out    vl_logic;
        o_did           : out    vl_logic_vector;
        o_data          : out    vl_logic_vector;
        o_dstrb         : out    vl_logic_vector(1 downto 0);
        o_dlast         : out    vl_logic;
        o_dvalid        : out    vl_logic;
        i_dready        : in     vl_logic;
        i_stm_rd_data   : in     vl_logic_vector;
        o_stm_rd_addr   : out    vl_logic_vector(31 downto 0);
        i_stm_rd_last   : out    vl_logic;
        o_stm_rd_size   : out    vl_logic_vector(2 downto 0);
        o_stm_rd_blen   : out    vl_logic_vector(3 downto 0);
        o_stm_rd_btyp   : out    vl_logic_vector(1 downto 0);
        o_stm_rd_tags   : out    vl_logic_vector(3 downto 0);
        o_stm_rd_req    : out    vl_logic;
        o_stm_rd_ena    : out    vl_logic;
        o_axi_rbeat     : out    vl_logic;
        i_stm_rd_ack    : in     vl_logic;
        i_stm_rd_vld    : in     vl_logic;
        i_ch_id         : in     vl_logic_vector(7 downto 0);
        i_ch_mask       : in     vl_logic_vector(7 downto 0);
        i_ch_grnt       : in     vl_logic_vector(7 downto 0);
        arreadyNumWaits_fire: in     vl_logic;
        reset           : in     vl_logic;
        aclk            : in     vl_logic
    );
end axi_rd_bfr;
