library verilog;
use verilog.vl_types.all;
entity xtlm_blocking_slave_port_if is
    generic(
        NUM_BYTES       : integer := 4;
        NUM_RSP_BYTES   : integer := 4
    );
end xtlm_blocking_slave_port_if;