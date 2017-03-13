library verilog;
use verilog.vl_types.all;
entity XlAxiSlaveTransactor is
    generic(
        DATA_WIDTH      : integer := 64;
        MEMORY_DEPTH    : integer := 1024;
        BASE_ADDRESS    : integer := 0;
        FIFO_DEPTH      : integer := 8;
        ID_WIDTH        : integer := 4
    );
    port(
        aclk            : in     vl_logic;
        aresetn         : in     vl_logic;
        csel            : in     vl_logic;
        awid            : in     vl_logic_vector;
        awaddr          : in     vl_logic_vector(31 downto 0);
        awlen           : in     vl_logic_vector(3 downto 0);
        awsize          : in     vl_logic_vector(2 downto 0);
        awburst         : in     vl_logic_vector(1 downto 0);
        awlock          : in     vl_logic_vector(1 downto 0);
        awcache         : in     vl_logic_vector(3 downto 0);
        awprot          : in     vl_logic_vector(2 downto 0);
        awvalid         : in     vl_logic;
        awready         : out    vl_logic;
        wid             : in     vl_logic_vector;
        wdata           : in     vl_logic_vector;
        wstrb           : in     vl_logic_vector;
        wlast           : in     vl_logic;
        wvalid          : in     vl_logic;
        wready          : out    vl_logic;
        bid             : out    vl_logic_vector;
        bresp           : out    vl_logic_vector(1 downto 0);
        bvalid          : out    vl_logic;
        bready          : in     vl_logic;
        arid            : in     vl_logic_vector;
        araddr          : in     vl_logic_vector(31 downto 0);
        arlen           : in     vl_logic_vector(3 downto 0);
        arsize          : in     vl_logic_vector(2 downto 0);
        arburst         : in     vl_logic_vector(1 downto 0);
        arlock          : in     vl_logic_vector(1 downto 0);
        arcache         : in     vl_logic_vector(3 downto 0);
        arprot          : in     vl_logic_vector(2 downto 0);
        arvalid         : in     vl_logic;
        arready         : out    vl_logic;
        rid             : out    vl_logic_vector;
        rdata           : out    vl_logic_vector;
        rresp           : out    vl_logic_vector(1 downto 0);
        rlast           : out    vl_logic;
        rvalid          : out    vl_logic;
        rready          : in     vl_logic
    );
end XlAxiSlaveTransactor;
