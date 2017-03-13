library verilog;
use verilog.vl_types.all;
entity xtlm_peek_port_if is
    generic(
        NUM_BYTES       : integer := 4
    );
end xtlm_peek_port_if;
