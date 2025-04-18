// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2025 Analog Devices, Inc. All rights reserved.
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
`include "axi_definitions.svh"

package m_axi_sequencer_pkg;

  import axi_vip_pkg::*;
  import logger_pkg::*;
  import adi_vip_pkg::*;


  class m_axi_sequencer_base extends adi_sequencer;

    function new(
      input string name,
      input adi_agent parent = null);

      super.new(name, parent);
    endfunction: new

    virtual task automatic RegWrite32(
      input xil_axi_ulong addr =0,
      input bit [31:0]    data);

      this.fatal($sformatf("Base class was instantiated instead of the parameterized class!"));
    endtask: RegWrite32

    virtual task automatic RegRead32(
      input xil_axi_ulong  addr =0,
      output bit [31:0]    data);

      this.fatal($sformatf("Base class was instantiated instead of the parameterized class!"));
    endtask: RegRead32

    virtual task automatic RegReadVerify32(
      input xil_axi_ulong  addr =0,
      input bit [31:0]     data);

      this.fatal($sformatf("Base class was instantiated instead of the parameterized class!"));
    endtask: RegReadVerify32

  endclass: m_axi_sequencer_base


  class m_axi_sequencer #(`AXI_VIP_PARAM_DECL(AXI)) extends m_axi_sequencer_base;

    axi_mst_wr_driver #(`AXI_VIP_PARAM_ORDER(AXI)) wr_driver;
    axi_mst_rd_driver #(`AXI_VIP_PARAM_ORDER(AXI)) rd_driver;

    semaphore reader_s;
    semaphore writer_s;

    function new(
      input string name,
      input axi_mst_wr_driver #(`AXI_VIP_PARAM_ORDER(AXI)) wr_driver,
      input axi_mst_rd_driver #(`AXI_VIP_PARAM_ORDER(AXI)) rd_driver,
      input adi_agent parent = null);

      super.new(name, parent);

      this.wr_driver = wr_driver;
      this.rd_driver = rd_driver;

      reader_s = new(1);
      writer_s = new(1);
    endfunction: new

    // ---------------------------------------------------------------------------
    // Generic tasks
    // ---------------------------------------------------------------------------
    virtual task automatic RegWrite32(
      input xil_axi_ulong addr =0,
      input bit [31:0]    data);

      static xil_axi_uint       id =0;

      writer_s.get(1);
      this.info($sformatf("writing to address %h value %h", addr , data), ADI_VERBOSITY_HIGH);

      single_write_transaction_readback_api(.id(id),
                                            .addr(addr),
                                            .len(0),
                                            .size(XIL_AXI_SIZE_4BYTE),
                                            .burst(XIL_AXI_BURST_TYPE_INCR),
                                            .data(data));
      id++;
      writer_s.put(1);
    endtask : RegWrite32

    virtual task automatic RegRead32(
      input xil_axi_ulong  addr =0,
      output bit [31:0]    data);

      xil_axi_data_beat DataBeat_for_read[];
      static xil_axi_uint       id =0;

      reader_s.get(1);

      single_read_transaction_readback_api (.id(id),
                                            .addr(addr),
                                            .len(0),
                                            .size(XIL_AXI_SIZE_4BYTE),
                                            .burst(XIL_AXI_BURST_TYPE_INCR),
                                            .Rdatabeat(DataBeat_for_read));
      id++;
      data = DataBeat_for_read[0][0+:32];
      this.info($sformatf(" Reading data : %h @ 0x%h", data, addr), ADI_VERBOSITY_HIGH);

      reader_s.put(1);
    endtask : RegRead32

    virtual task automatic RegReadVerify32(
      input xil_axi_ulong  addr =0,
      input bit [31:0]     data);

      bit [31:0]    data_out;
      RegRead32(.addr(addr),
                .data(data_out));
      if (data !== data_out) begin
        this.error($sformatf(" Address : %h; Data mismatch. Read data is : %h; expected is %h", addr, data_out, data));
      end
    endtask : RegReadVerify32


    // ---------------------------------------------------------------------------
    // BFM specific tasks
    // ---------------------------------------------------------------------------
    protected task automatic single_write_transaction_api (
      input string            name ="single_write",
      input xil_axi_uint      id =0,
      input xil_axi_ulong     addr =0,
      input xil_axi_len_t     len =0,
      input xil_axi_size_t    size =xil_axi_size_t'(xil_clog2((32)/8)),
      input xil_axi_burst_t   burst =XIL_AXI_BURST_TYPE_INCR,
      input xil_axi_lock_t    lock = XIL_AXI_ALOCK_NOLOCK,
      input xil_axi_cache_t   cache =3,
      input xil_axi_prot_t    prot =0,
      input xil_axi_region_t  region =0,
      input xil_axi_qos_t     qos =0,
      input bit [63:0]        data =0);

      axi_transaction  wr_trans;
      wr_trans = wr_driver.create_transaction(name);
      wr_trans.set_write_cmd(addr, burst, id, len, size);
      wr_trans.set_prot(prot);
      wr_trans.set_lock(lock);
      wr_trans.set_cache(cache);
      wr_trans.set_region(region);
      wr_trans.set_qos(qos);
      wr_trans.set_data_block(data);
      wr_driver.send(wr_trans);
    endtask : single_write_transaction_api

    protected task automatic single_write_transaction_readback_api (
      input string            name ="single_write",
      input xil_axi_uint      id =0,
      input xil_axi_ulong     addr =0,
      input xil_axi_len_t     len =0,
      input xil_axi_size_t    size =xil_axi_size_t'(xil_clog2((32)/8)),
      input xil_axi_burst_t   burst =XIL_AXI_BURST_TYPE_INCR,
      input xil_axi_lock_t    lock = XIL_AXI_ALOCK_NOLOCK,
      input xil_axi_cache_t   cache =3,
      input xil_axi_prot_t    prot =0,
      input xil_axi_region_t  region =0,
      input xil_axi_qos_t     qos =0,
      input bit [63:0]        data =0);

      axi_transaction  wr_trans;
      wr_trans = wr_driver.create_transaction(name);
      wr_trans.set_write_cmd(addr, burst, id, len, size);
      wr_trans.set_prot(prot);
      wr_trans.set_lock(lock);
      wr_trans.set_cache(cache);
      wr_trans.set_region(region);
      wr_trans.set_qos(qos);
      wr_trans.set_data_block(data);
      wr_trans.set_driver_return_item_policy(XIL_AXI_PAYLOAD_RETURN);
      wr_driver.send(wr_trans);
      wr_driver.wait_rsp(wr_trans);
    endtask : single_write_transaction_readback_api

    protected task automatic single_read_transaction_api (
      input string             name ="single_read",
      input xil_axi_uint       id =0,
      input xil_axi_ulong      addr =0,
      input xil_axi_len_t      len =0,
      input xil_axi_size_t     size =xil_axi_size_t'(xil_clog2((32)/8)),
      input xil_axi_burst_t    burst =XIL_AXI_BURST_TYPE_INCR,
      input xil_axi_lock_t     lock =XIL_AXI_ALOCK_NOLOCK ,
      input xil_axi_cache_t    cache =3,
      input xil_axi_prot_t     prot =0,
      input xil_axi_region_t   region =0,
      input xil_axi_qos_t      qos =0,
      input xil_axi_data_beat  aruser =0);

      axi_transaction   rd_trans;
      rd_trans = rd_driver.create_transaction(name);
      rd_trans.set_read_cmd(addr, burst, id, len, size);
      rd_trans.set_prot(prot);
      rd_trans.set_lock(lock);
      rd_trans.set_cache(cache);
      rd_trans.set_region(region);
      rd_trans.set_qos(qos);
      rd_driver.send(rd_trans);
    endtask : single_read_transaction_api

    protected task automatic single_read_transaction_readback_api (
      input string             name ="single_read",
      input xil_axi_uint       id =0,
      input xil_axi_ulong      addr =0,
      input xil_axi_len_t      len =0,
      input xil_axi_size_t     size =xil_axi_size_t'(xil_clog2((32)/8)),
      input xil_axi_burst_t    burst =XIL_AXI_BURST_TYPE_INCR,
      input xil_axi_lock_t     lock =XIL_AXI_ALOCK_NOLOCK ,
      input xil_axi_cache_t    cache =3,
      input xil_axi_prot_t     prot =0,
      input xil_axi_region_t   region =0,
      input xil_axi_qos_t      qos =0,
      input xil_axi_data_beat  aruser =0,
      output xil_axi_data_beat Rdatabeat[]);

      axi_transaction   rd_trans;
      rd_trans = rd_driver.create_transaction(name);
      rd_trans.set_driver_return_item_policy(XIL_AXI_PAYLOAD_RETURN);
      rd_trans.set_read_cmd(addr, burst, id, len, size);
      rd_trans.set_prot(prot);
      rd_trans.set_lock(lock);
      rd_trans.set_cache(cache);
      rd_trans.set_region(region);
      rd_trans.set_qos(qos);
      rd_driver.send(rd_trans);
      rd_driver.wait_rsp(rd_trans);
      Rdatabeat = new[rd_trans.get_len()+1];
      for( xil_axi_uint beat=0; beat<rd_trans.get_len()+1; beat++) begin
        Rdatabeat[beat] = rd_trans.get_data_beat(beat);
        //$display("Read data from Driver: beat index %d, Data beat %h ", beat, Rdatabeat[beat]);
      end
    endtask : single_read_transaction_readback_api

  endclass: m_axi_sequencer

endpackage: m_axi_sequencer_pkg
