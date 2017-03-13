#!/pkg/qct/software/perl/q4_06/bin/perl -w

### This is the replay script for running simulator command directly

use strict;
use warnings;
use IPC::Run qw(run);
use YAML;
use Getopt::Long;
use FindBin qw($Bin);

my %g_opt;
$g_opt{'-sim_opts'} = '';
$g_opt{'-help'}     = 0;

my $cmd_result = GetOptions(
    "-sim_opts:s" => \$g_opt{'-sim_opts'},
    "-help"       => \$g_opt{'-help'},
);

if ( $g_opt{'-help'} == 1 ) {
    &usage();
}

my $qbar_env =
  YAML::LoadFile( File::Spec->catfile( $Bin, 'qbar_pre_sim.yaml' ) );
%ENV = %{$qbar_env};

###
#my $sim_dir = ".";

my $run_cmd = q{/pkg/qvmr/bin/Vsim -qc_standalone    -permit_unmatched_virtual_intf -cpppath /pkg/modeltech/6.6g/gcc-4.1.2-linux_x86_64/bin/gcc -t ns   -sclib tb_work -lib tb_work -L hdl_work -L tb_work -c -do sim.do -coverage -assertdebug -sv_seed 1   -sv_root /usr2/xiaoshao/uvm_training_labs/lab_backup/lab1/unmanaged/qvmr/xiaoshao/simland/standalone/default/misc/LINUX64/6.6g -sv_lib dpi_lib  +UVM_TESTNAME=pcounter_test_qclk_change_clock_period +UVM_USE_OVM_RUN_SEMANTIC  hdl_work.test_bench tb_work.tb_top tb_work.TbxSvManager};
$run_cmd .=
  join( ' ', $g_opt{-sim_opts}, '2>&1 | tee replay_vanilla.session.log' );

eval { run " $run_cmd " or die "Failed to execute $run_cmd $? "; };

if ($@) {
    print "Error: Replay script failed\n";
    exit(1);
}
else {
    print "Info: Replay script finished\n";
}

sub usage {
    print "#######################################################\n";
    print "############ Standalone Replay Script #################\n";
    print "#######################################################\n\n";
    print "\t-sim_opts: Option to add Simulator Command line options\n";
    print "\t-help: Print this message\n\n\n";
    exit(0);
}

