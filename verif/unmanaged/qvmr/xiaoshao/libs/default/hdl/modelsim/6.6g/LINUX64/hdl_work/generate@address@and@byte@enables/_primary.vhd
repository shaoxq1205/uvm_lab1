library verilog;
use verilog.vl_types.all;
entity generateAddressAndByteEnables is
    generic(
        DATA_WIDTH      : integer := 64
    );
    port(
        o_bena          : out    vl_logic_vector(15 downto 0);
        o_waddr         : out    vl_logic_vector(31 downto 0);
        o_raddr         : out    vl_logic_vector(31 downto 0);
        i_addr          : in     vl_logic_vector(31 downto 0);
        i_bena          : in     vl_logic_vector(15 downto 0);
        i_blen          : in     vl_logic_vector(7 downto 0);
        i_type          : in     vl_logic_vector(1 downto 0);
        i_brst_siz      : in     vl_logic_vector(2 downto 0);
        i_brst_lod      : in     vl_logic;
        i_brst_ena      : in     vl_logic;
        i_reset         : in     vl_logic;
        clk             : in     vl_logic
    );
end generateAddressAndByteEnables;
