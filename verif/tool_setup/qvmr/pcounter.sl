`include "pcounter_common.inc"

REGRESS_OPTIONS {
  +DEFAULT_OPTIONS
# qwebstats/reports regression name
  -regression_name="pcounter"
  -runcmd_args="TB_LINT= "
#  -exec=after,dut,"/bin/cp $PWD/QEMU_QUATTRO1_velsyn2bsub.out %sharedir%/options/QEMU_QUATTRO1_velsyn2bsub.out"
#  -exec=after,dut,"/bin/cp $PWD/TRIO1_velsyn2bsub.out %sharedir%/options/TRIO1_velsyn2bsub.out"
}

# setups
pcounter_passing \
  -tl=%verif_sim_dir%/tests/testlists/passing.tl


