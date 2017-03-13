library verilog;
use verilog.vl_types.all;
entity XlGpioTransactor is
    generic(
        SET_VALUE_VECTOR_WIDTH: integer := 1;
        GET_VALUE_VECTOR_WIDTH: integer := 1;
        MAX_SET_VALUE_WIDTH: integer := 1;
        MAX_GET_VALUE_WIDTH: integer := 1
    );
    port(
        setValueVector  : out    vl_logic_vector;
        getValueVector  : in     vl_logic_vector
    );
end XlGpioTransactor;
