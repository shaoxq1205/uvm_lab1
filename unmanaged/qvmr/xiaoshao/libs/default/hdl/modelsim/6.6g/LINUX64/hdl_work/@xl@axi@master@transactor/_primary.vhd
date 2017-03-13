library verilog;
use verilog.vl_types.all;
entity XlAxiMasterTransactor is
    generic(
        DATA_WIDTH      : integer := 64;
        MEMORY_DEPTH    : integer := 1024;
        ID_WIDTH        : integer := 4
    );
    port(
        aclk            : in     vl_logic;
        aresetn         : in     vl_logic;
        awid            : out    vl_logic_vector;
        awaddr          : out    vl_logic_vector(31 downto 0);
        awlen           : out    vl_logic_vector(3 downto 0);
        awsize          : out    vl_logic_vector(2 downto 0);
        awburst         : out    vl_logic_vector(1 downto 0);
        awlock          : out    vl_logic_vector(1 downto 0);
        awcache         : out    vl_logic_vector(3 downto 0);
        awprot          : out    vl_logic_vector(2 downto 0);
        awvalid         : out    vl_logic;
        awready         : in     vl_logic;
        wid             : out    vl_logic_vector;
        wdata           : out    vl_logic_vector;
        wstrb           : out    vl_logic_vector;
        wlast           : out    vl_logic;
        wvalid          : out    vl_logic;
        wready          : in     vl_logic;
        bid             : in     vl_logic_vector;
        bresp           : in     vl_logic_vector(1 downto 0);
        bvalid          : in     vl_logic;
        bready          : out    vl_logic;
        arid            : out    vl_logic_vector;
        araddr          : out    vl_logic_vector(31 downto 0);
        arlen           : out    vl_logic_vector(3 downto 0);
        arsize          : out    vl_logic_vector(2 downto 0);
        arburst         : out    vl_logic_vector(1 downto 0);
        arlock          : out    vl_logic_vector(1 downto 0);
        arcache         : out    vl_logic_vector(3 downto 0);
        arprot          : out    vl_logic_vector(2 downto 0);
        arvalid         : out    vl_logic;
        arready         : in     vl_logic;
        rid             : in     vl_logic_vector;
        rdata           : in     vl_logic_vector;
        rresp           : in     vl_logic_vector(1 downto 0);
        rlast           : in     vl_logic;
        rvalid          : in     vl_logic;
        rready          : out    vl_logic
    );
end XlAxiMasterTransactor;
