library verilog;
use verilog.vl_types.all;
entity XlAhbMonitor is
    generic(
        DATA_WIDTH      : integer := 32
    );
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        haddr           : in     vl_logic_vector(63 downto 0);
        htrans          : in     vl_logic_vector(1 downto 0);
        hsize           : in     vl_logic_vector(2 downto 0);
        hburst          : in     vl_logic_vector(2 downto 0);
        hwrite          : in     vl_logic;
        hwdata          : in     vl_logic_vector;
        hready          : in     vl_logic;
        hresp           : in     vl_logic_vector(1 downto 0);
        hrdata          : in     vl_logic_vector
    );
end XlAhbMonitor;
