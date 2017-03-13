library verilog;
use verilog.vl_types.all;
entity XlRngTransactor is
    generic(
        DEFAULT_SEED    : integer := -87114067
    );
    port(
        clockIn         : in     vl_logic;
        resetIn         : in     vl_logic;
        toggleIn        : in     vl_logic;
        minValueIn      : in     vl_logic_vector(31 downto 0);
        maxValueIn      : in     vl_logic_vector(31 downto 0);
        randomValueOut  : out    vl_logic_vector(31 downto 0)
    );
end XlRngTransactor;
