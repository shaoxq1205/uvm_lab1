`define verif_dir ${WORKSPACE}/verif/sim/pcounter
`define verif_sim_dir %verif_dir%/sim

DEFAULT_OPTIONS {
# queues for simulations
# use -job_type=short in testlist for this (default)
   -short_queue=regression_queue
# use -job_type=long in testlist for this
   -long_queue=regression_long_queue
# automatically selected when number of tests is small
   -interactive_queue=iverify
# do not automatically retry "incomplete" tests
   -max_retries=0
# LSF options for non-simulation tools
   -bsub_args="-R 'select[type==LINUX64]'"
# use pattern files to detect errors
   -test_pattern_file=%verif_dir%/tool_setup/qvmr/pcounter.qre
# qwebstats 'design tag'
   -project_tag="project_tag"
}

# simulator +OPTION groups
mti {
   -simulator=mti
   -run_bsub_args="-R 'select[type==LINUX64]rusage[vsim=1]'"
}

vcs {
   -simulator=vcs_mx
   -run_bsub_args="-R 'select[type==LINUX64]rusage[VCSRuntime_Net=1]'"
}

ius {
   -simulator=ius
   -run_bsub_args="-R 'select[type==LINUX64]'"
# IUS 9.20 issue
   -runcmd_args+="NCVLOG_OPTS='-svea -define USE_PARAMETERIZED_WRAPPER'"
}

