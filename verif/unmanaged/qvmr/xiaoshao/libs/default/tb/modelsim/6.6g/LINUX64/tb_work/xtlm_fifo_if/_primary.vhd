library verilog;
use verilog.vl_types.all;
entity xtlm_fifo_if is
    generic(
        BYTES_PER_ELEMENT: integer := 1;
        BUFFER_DEPTH    : integer := 32;
        MODE            : integer := 0;
        PAYLOAD_MAX_ELEMENTS: integer := 1;
        TC_RATIO        : integer := 1;
        IS_CLOCKED_INTF : integer := 1;
        TBX_SCEMI_PIPE_INTERNAL_USE: integer := 1
    );
    port(
        scemiPipeInterfaceClkInternal: in     vl_logic
    );
end xtlm_fifo_if;
