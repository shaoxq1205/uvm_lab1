library verilog;
use verilog.vl_types.all;
entity XlEdgeDetector is
    generic(
        EDGE_VECTOR_WIDTH: integer := 1;
        MAX_EDGE_VALUE_WIDTH: integer := 1;
        NUM_EDGE_DETECTS: integer := 1
    );
    port(
        clock           : in     vl_logic;
        edgeVector      : in     vl_logic_vector
    );
end XlEdgeDetector;
