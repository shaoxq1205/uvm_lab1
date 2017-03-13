library verilog;
use verilog.vl_types.all;
entity XlAhbSlaveTransactor is
    generic(
        DATA_WIDTH      : integer := 32;
        MEMORY_DEPTH    : integer := 1024;
        BASE_ADDRESS    : integer := 0;
        BIG_ENDIAN      : integer := 0
    );
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        hreadyIn        : in     vl_logic;
        hsel            : in     vl_logic;
        haddr           : in     vl_logic_vector(63 downto 0);
        htrans          : in     vl_logic_vector(1 downto 0);
        hsize           : in     vl_logic_vector(2 downto 0);
        hburst          : in     vl_logic_vector(2 downto 0);
        hwrite          : in     vl_logic;
        hwdata          : in     vl_logic_vector;
        hreadyOut       : out    vl_logic;
        hresp           : out    vl_logic_vector(1 downto 0);
        hrdata          : out    vl_logic_vector
    );
end XlAhbSlaveTransactor;
