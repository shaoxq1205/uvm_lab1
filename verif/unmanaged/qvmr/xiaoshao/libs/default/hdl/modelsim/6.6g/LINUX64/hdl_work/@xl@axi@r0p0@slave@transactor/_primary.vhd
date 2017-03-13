library verilog;
use verilog.vl_types.all;
entity XlAxiR0p0SlaveTransactor is
    generic(
        DATA_WIDTH      : integer := 64;
        MEMORY_DEPTH    : integer := 1024;
        BASE_ADDRESS    : integer := 0;
        ID_WIDTH        : integer := 4
    );
    port(
        aclk            : in     vl_logic;
        aresetn         : in     vl_logic;
        csel            : in     vl_logic;
        aid             : in     vl_logic_vector;
        addr            : in     vl_logic_vector(31 downto 0);
        alen            : in     vl_logic_vector(3 downto 0);
        asize           : in     vl_logic_vector(2 downto 0);
        aburst          : in     vl_logic_vector(1 downto 0);
        alock           : in     vl_logic_vector(1 downto 0);
        acache          : in     vl_logic_vector(3 downto 0);
        aprot           : in     vl_logic_vector(2 downto 0);
        avalid          : in     vl_logic;
        awrite          : in     vl_logic;
        aready          : out    vl_logic;
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
        rid             : out    vl_logic_vector;
        rdata           : out    vl_logic_vector;
        rresp           : out    vl_logic_vector(1 downto 0);
        rlast           : out    vl_logic;
        rvalid          : out    vl_logic;
        rready          : in     vl_logic
    );
end XlAxiR0p0SlaveTransactor;
