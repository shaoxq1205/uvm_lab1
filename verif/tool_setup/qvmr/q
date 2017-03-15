
TBX_HOME := $(shell Tbxcomp -qc_query_env TBX_HOME)

export TBX_HOME

#_________________________________________________________________________

SIM = modelsim
CODE_COVERAGE = 1
SVA_COVERAGE = 1

VCS_OPTS += -debug_all -Marchive=12 -lca

#_________________________________________________________________________

HW_ENABLE = 0

XL_VIP_VERSION = xl_vip2.4.0.2b
XL_VIP_HOME = /prj/qct/evals/veloce/software/iSolveTransactors/${XL_VIP_VERSION}
export XL_VIP_VERSION
export XL_VIP_HOME

MODELSIM_INI_OPTS += [sccom]CppPath=/pkg/modeltech/${MODELTECH_VERSION}/gcc-4.1.2-linux_x86_64/bin/gcc
MODELSIM_INI_OPTS += [vsim]CppPath=/pkg/modeltech/${MODELTECH_VERSION}/gcc-4.1.2-linux_x86_64/bin/gcc
MODELSIM_INI_OPTS += [vsim]DpiCppPath=/pkg/modeltech/${MODELTECH_VERSION}/gcc-4.1.2-linux_x86_64/bin/gcc
MODELSIM_INI_OPTS += [vsim]SolveArrayResizeMax=20000
MODELSIM_INI_OPTS += [Library]work=${QVMR_SIM_TOP_DIR}/sim_top_work
VSIM_OPTS+=-cpppath /pkg/modeltech/${MODELTECH_VERSION}/gcc-4.1.2-linux_x86_64/bin/gcc
TBXSVLINK_OPTS += -verbose




#
#-----------------------------------------------------------------------------
#       Programmable Counter  Example with simulation acceleration -- Logie
#------------------------------------------------------------------------------
	HDL_TOP_SPEC = pcounter


# Setup TBX  Version
	export MTI_HOME := $(shell Vsim ${QC_OPTS} -qc_query_env MTI_HOME)


# Setup QBAR variables for sim accel
#	SIM           = modelsim
	VERBOSITY     = VERBOSE
	TESTCASE_TYPE = uvm	
        ENABLE_TMP_WORK = 0

# Setup QBAR DPI variables 
	DPI_MODULE_NAMES += tb_top

# Setup QBAR Tool Options


# QBAR HDL paths
	DUT_MODULE_NAME = test_bench
	HDL_TOP_SPEC    = pcounter_veloce
	HDL_SPEC_PATHS += ${WORKSPACE}/pcounter


# QBAR HVL paths
	HVL_TOP_SPEC    = uvc_pcounter_tb
#	HVL_SPEC_PATHS += ${WORKSPACE}/verif/sim/env/agents/qclk
	HVL_SPEC_PATHS += ${WORKSPACE}/libs/verification/quvm
	HVL_SPEC_PATHS += ${WORKSPACE}/verif


# QBAR Sim Variables
	SIM_TOP_MODULE_NAME = tb_top

# Test Name
	TEST_NAME    = pcounter_test_qclk_change_clock_period

	SIM_OPTS += +UVM_USE_OVM_RUN_SEMANTIC

# Linter Tool Opts
        TB_LINT = 
	DVT_WAIVER_FILE    = ${WORKSPACE}/verif/tool_setup/dvt/waivers.xml
	DVT_SOURCEMAP_FILE = ${WORKSPACE}/verif/tool_setup/dvt/sourcemap.txt
	DVT_OVC_ROOTS_FILE =
	DVT_RUN_BATCH_MODE_OPTS += -dump_debug_info


# Debug Opts
	DEBUG_TARGETS += dut
	VERDI_VTOPS += ${DUT_MODULE_NAME}=${SIM_TOP_MODULE_NAME}.dut


# MTI Tool Opts
	VLOG_OPTS += -mfcu
	VLOG_OPTS += -timescale 1ns/1ps
	VSIM_OPTS += -t ns

# Setup XL-VIP
	include /prj/qct/evals/veloce/software/mgc_vip/1.0/include/xl_vip.mk


ifeq (${SIM},ius)
	export PD_VIP_HOME   = ${WORKSPACE}/libs/pd_vip_home
	export AXIS_HOME     = /prj/qct/evals_cadence_projects/UXE/uxe-10.2.p10/tools.lnx86
	FLOW          = sim
	HW   	      = palladium
	HW_ENABLE     = 0
	HW_EMULATOR   = PALLADIUM_XP
	NCVLOG_OPTS	+= -define PALLADIUM -define PALLADIUM_XP
	NCVLOG_OPTS	+= -svea -define USE_PARAMETERIZED_WRAPPER -linedebug
	NCELAB_OPTS	+= -timescale 1ns/1ns -access +rwc 

	HDL_SPEC_PATHS  += ${PD_VIP_HOME}/hdl
	HDL_SPEC_PATHS  += ${WORKSPACE}/pcounter/temp_sv_builder_output_for_palladium/hdl

	HVL_SPEC_PATHS  += ${PD_VIP_HOME}/hvl

	DUT_TOP_SPEC    = pcounter_palladium
	override HDL_TOP_SPEC    = pcounter_palladium_hw_top
	HVL_TOP_SPEC    = uvc_pcounter_tb_palladium

	# trying to get 2 tops
	SIM_TOP_MODULE_NAME += test_bench

	#The following line can be removed after new SV builder support for Palladium
	SIM_DEPS += link_data_file  

	DPI_CFLAGS = -DPALLADIUM

link_data_file:
	cd ${QVMR_SIM_DIR} && ln -sf ${WORKSPACE}/pcounter/temp_sv_builder_output_for_palladium/hvl/edgeDetector.dat
	cd ${QVMR_SIM_DIR} && ln -sf ${WORKSPACE}/pcounter/temp_sv_builder_output_for_palladium/hvl/gpioTransactor.dat



else  
	SIM	      = modelsim
	FLOW          = tbx
	HW   	      = veloce
	HW_ENABLE     = 0
	HW_EMULATOR   = QEMU_QUATTRO1

	HDL_SPEC_PATHS += ${XL_VIP_HOME}/qcom_spec/hdl
	DUT_TOP_SPEC    = pcounter_veloce
        HDL_TOP_SPEC    = pcounter_veloce
	override HDL_TOP_SPEC    = pcounter_veloce
	HVL_TOP_SPEC    = uvc_pcounter_tb

endif ## ifeq (${SIM},ius)

GEN: 
	@../gen/lab_gen.pl uvm1

POST_SIM += GEN

#_________________________________________________________________________
# include qbar makefile
include /pkg/qvmr/include/qbar.mk


