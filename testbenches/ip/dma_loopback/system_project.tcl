source ../../../scripts/adi_sim.tcl

if {$argc < 1} {
  puts "Expecting at least one argument that specifies the test configuration"
  exit 1
} else {
  set cfg_file [lindex $argv 0]
}

# Read config file
source "cfgs/${cfg_file}"

# Set the project name
set project_name [file rootname $cfg_file]

# Create the project
adi_sim_project_xilinx $project_name "xcvu9p-flga2104-2L-e"

source $ad_tb_dir/library/includes/sp_include_dmac.tcl

# Add test files to the project
adi_sim_project_files [list \
  "tests/test_program.sv" \
]

#set a default test program
adi_sim_add_define "TEST_PROGRAM=test_program"

adi_sim_generate $project_name
