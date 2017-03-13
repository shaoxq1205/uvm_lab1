library verilog;
use verilog.vl_types.all;
entity XlAhbMasterTransactor is
    generic(
        DATA_WIDTH      : integer := 32;
        MEMORY_DEPTH    : integer := 1024;
        BIG_ENDIAN      : integer := 0
    );
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        hready          : in     vl_logic;
        hresp           : in     vl_logic_vector(1 downto 0);
        hrdata          : in     vl_logic_vector;
        haddr           : out    vl_logic_vector(63 downto 0);
        htrans          : out    vl_logic_vector(1 downto 0);
        hsize           : out    vl_logic_vector(2 downto 0);
        hburst          : out    vl_logic_vector(2 downto 0);
        hwrite          : out    vl_logic;
        hwdata          : out    vl_logic_vector
    );
end XlAhbMasterTransactor;
