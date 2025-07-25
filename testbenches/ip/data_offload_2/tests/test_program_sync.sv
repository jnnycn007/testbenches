// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2021-2025 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`include "utils.svh"

import axi_vip_pkg::*;
import axi4stream_vip_pkg::*;
import m_axis_sequencer_pkg::*;
import logger_pkg::*;

import environment_pkg::*;
import data_offload_pkg::*;

//=============================================================================
// Register Maps
//=============================================================================

module test_program_sync (
  output  reg       init_req = 1'b0,
  output  reg       sync_ext = 1'b0,
  output  reg       mem_rst_n = 1'b0
);

  //declaring environment instance
  environment                       env;
  xil_axi4stream_ready_gen_policy_t dac_mode;

  data_offload                      dut;

  initial begin
    //creating environment
    env = new(`TH.`MNG_AXI.inst.IF,
              `TH.`SRC_AXIS.inst.IF,
              `TH.`DST_AXIS.inst.IF
             );

    dut = new(env.mng, `DOFF_BA);

    //=========================================================================
    // Setup generator/monitor stubs
    //=========================================================================

    env.src_axis_seq.set_data_gen_mode(DATA_GEN_MODE_AUTO_INCR);
    env.src_axis_seq.add_xfer_descriptor_byte_count(`SRC_TRANSFERS_LENGTH, 1, 0);

    env.dst_axis_seq.set_mode(`DST_READY_MODE);
    env.dst_axis_seq.set_high_time(`DST_READY_HIGH);
    env.dst_axis_seq.set_low_time(`DST_READY_LOW);

    //=========================================================================

    setLoggerVerbosity(ADI_VERBOSITY_NONE);

    env.scoreboard.set_oneshot(1);

    start_clocks();
    sys_reset();

    env.start();

    `INFO(("Bring up IP from reset."), ADI_VERBOSITY_LOW);
    systemBringUp();

    env.src_axis_seq.start();

    // Start the ADC/DAC stubs
    `INFO(("Call the run() ..."), ADI_VERBOSITY_LOW);
    env.run();

    init_req <= 1'b1;

    // @env.src_axis_seq.queue_empty;
    // init_req <= 1'b0;
    #100ns;


    sync_ext <= 1'b1;
    @(posedge `TH.`DST_CLK.clk_out);
    @(posedge `TH.`DST_CLK.clk_out);
    sync_ext <= 1'b0;
    #1000ns;

    sync_ext <= 1'b1;
    @(posedge `TH.`DST_CLK.clk_out);
    @(posedge `TH.`DST_CLK.clk_out);
    sync_ext <= 1'b0;
    #1000ns;

    sync_ext <= 1'b1;
    @(posedge `TH.`DST_CLK.clk_out);
    @(posedge `TH.`DST_CLK.clk_out);
    sync_ext <= 1'b0;
    #1000ns;

    // init_req <= 1'b1;

    sync_ext <= 1'b1;
    @(posedge `TH.`DST_CLK.clk_out);
    @(posedge `TH.`DST_CLK.clk_out);

    sync_ext <= 1'b0;
    #1000ns;

    #((`SRC_TRANSFERS_DELAY)*1ns);


    //init_req <= 1'b1;
    #100ns;
    // env.src_axis_seq.add_xfer_descriptor_byte_count(`SRC_TRANSFERS_LENGTH, 1, 0);

    // @env.src_axis_seq.queue_empty;
    // init_req <= 1'b0;

    #300ns;
    sync_ext <= 1'b1;
    @(posedge `TH.`DST_CLK.clk_out);
    sync_ext <= 1'b0;

    #((`TIME_TO_WAIT)*1ns);

    env.stop();

    stop_clocks();

    `INFO(("Test bench done!"), ADI_VERBOSITY_NONE);
    $finish();

  end

  task start_clocks();
    `TH.`SRC_CLK.inst.IF.start_clock();
    `TH.`DST_CLK.inst.IF.start_clock();
    `TH.`SYS_CLK.inst.IF.start_clock();
  endtask

  task stop_clocks();
    `TH.`SRC_CLK.inst.IF.stop_clock();
    `TH.`DST_CLK.inst.IF.stop_clock();
    `TH.`SYS_CLK.inst.IF.stop_clock();
  endtask

  task sys_reset();
    `TH.`SRC_RST.inst.IF.assert_reset();
    `TH.`DST_RST.inst.IF.assert_reset();
    `TH.`SYS_RST.inst.IF.assert_reset();

    #500ns;
    `TH.`SRC_RST.inst.IF.deassert_reset();
    `TH.`DST_RST.inst.IF.deassert_reset();
    `TH.`SYS_RST.inst.IF.deassert_reset();
  endtask

  task systemBringUp();
    // bring up the Data Offload instances from reset
    `INFO(("Bring up TX Data Offload"), ADI_VERBOSITY_LOW);

    dut.set_oneshot(0);
    dut.set_sync_config(1); // Hardware Sync

    // dut.set_transfer_length(`TRANSFER_LENGTH);

    dut.set_resetn(1'b1);
  endtask

endmodule
