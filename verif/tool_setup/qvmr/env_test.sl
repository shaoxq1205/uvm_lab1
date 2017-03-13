`include "transform_common.inc"

REGRESS_OPTIONS {
  +DEFAULT_OPTIONS
# qwebstats/reports regression name
  -regression_name="env_test"
}

# setups
ius_env_test \
  +ius \
  -tl=%verif_sim_dir%/tests/testlists/regress_env_error.tl

mti_env_test \
  +mti \
  -tl=%verif_sim_dir%/tests/testlists/regress_env_error.tl

vcs_env_test \
  +vcs \
  -tl=%verif_sim_dir%/tests/testlists/regress_env_error.tl

