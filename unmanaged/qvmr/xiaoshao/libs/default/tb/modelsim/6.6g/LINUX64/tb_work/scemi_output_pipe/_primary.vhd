library verilog;
use verilog.vl_types.all;
entity scemi_output_pipe is
    generic(
        BYTES_PER_ELEMENT: integer := 1;
        PAYLOAD_MAX_ELEMENTS: integer := 1;
        BUFFER_MAX_ELEMENTS: integer := 32;
        TC_RATIO        : integer := 1;
        IS_CLOCKED_INTF : integer := 0;
        VISIBILITY_MODE : integer := 2;
        TBX_SCEMI_PIPE_INTERNAL_USE: integer := 1
    );
    port(
        scemiPipeInterfaceClkInternal: in     vl_logic
    );
end scemi_output_pipe;
