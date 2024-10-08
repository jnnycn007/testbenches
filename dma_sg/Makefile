####################################################################################
## Copyright (C) 2024 Analog Devices, Inc.
####################################################################################

# All test-bench dependencies except test programs
SV_DEPS += ../common/sv/utils.svh
SV_DEPS += ../common/sv/logger_pkg.sv
SV_DEPS += ../common/sv/reg_accessor.sv
SV_DEPS += ../common/sv/m_axis_sequencer.sv
SV_DEPS += ../common/sv/s_axis_sequencer.sv
SV_DEPS += ../common/sv/m_axi_sequencer.sv
SV_DEPS += ../common/sv/s_axi_sequencer.sv
SV_DEPS += ../common/sv/dmac_api.sv
SV_DEPS += ../common/sv/adi_regmap_pkg.sv
SV_DEPS += ../common/sv/adi_regmap_dmac_pkg.sv
SV_DEPS += ../common/sv/dma_trans.sv
SV_DEPS += ../common/sv/test_harness_env.sv
SV_DEPS += system_tb.sv

ENV_DEPS += system_project.tcl
ENV_DEPS += system_bd.tcl
ENV_DEPS +=../scripts/adi_sim.tcl
ENV_DEPS +=../scripts/run_sim.tcl

LIB_DEPS += axi_dmac

# default test program
TP := test_program_1d

# config files should have the following format
#  cfg_<param1>_<param2>.tcl
CFG_FILES := $(notdir $(wildcard cfgs/cfg*.tcl))
#$(warning $(CFG_FILES))

# List of tests and configuration combinations that has to be run
# Format is:  <configuration>:<test name>
#TESTS := $(foreach cfg, $(basename $(CFG_FILES)), $(cfg):$(TP))
TESTS += cfg1:test_program_1d
TESTS += cfg2:test_program_2d
TESTS += cfg1:test_program_tr_queue

include ../scripts/project-sim.mk

# usage :
#
# run specific test on a specific configuration in gui mode
# 	make CFG=cfg2 TST=test_program_2d MODE=gui
#
# run all test from a configuration
# 	make cfg2

####################################################################################
####################################################################################
