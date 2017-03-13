library verilog;
use verilog.vl_types.all;
entity XlAxiR0p0MasterTransactor is
    generic(
        DATA_WIDTH      : integer := 64;
        MEMORY_DEPTH    : integer := 1024;
        ID_WIDTH        : integer := 4
    );
    port(
        aclk            : in     vl_logic;
        aresetn         : in     vl_logic;
        aid             : out    vl_logic_vector;
        addr            : out    vl_logic_vector(31 downto 0);
        alen            : out    vl_logic_vector(3 downto 0);
        asize           : out    vl_logic_vector(2 downto 0);
        aburst          : out    vl_logic_vector(1 downto 0);
        alock           : out    vl_logic_vector(1 downto 0);
        acache          : out    vl_logic_vector(3 downto 0);
        aprot           : out    vl_logic_vector(2 downto 0);
        avalid          : out    vl_logic;
        awrite          : out    vl_logic;
        aready          : in     vl_logic;
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
        rid             : in     vl_logic_vector;
        rdata           : in     vl_logic_vector;
        rresp           : in     vl_logic_vector(1 downto 0);
        rlast           : in     vl_logic;
        rvalid          : in     vl_logic;
        rready          : out    vl_logic
    );
end XlAxiR0p0MasterTransactor;
