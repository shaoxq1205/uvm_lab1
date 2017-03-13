library verilog;
use verilog.vl_types.all;
entity XlMemoryTransactor is
    generic(
        MEMORY_DEPTH    : integer := 1024;
        DATA_WIDTH      : integer := 32;
        BACK_DOOR_PAYLOAD_WIDTH: integer := 512;
        BASE_ADDRESS    : integer := 0
    );
    port(
        clockIn         : in     vl_logic;
        writeEnableIn   : in     vl_logic;
        writeByteEnablesIn: in     vl_logic_vector;
        writeAddressIn  : in     vl_logic_vector(63 downto 0);
        writeDataIn     : in     vl_logic_vector;
        readEnableIn    : in     vl_logic;
        readAddressIn   : in     vl_logic_vector(63 downto 0);
        readDataOut     : out    vl_logic_vector
    );
end XlMemoryTransactor;
