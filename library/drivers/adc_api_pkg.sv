// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2025 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsabilities that he or she has by using this source/core.
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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`include "utils.svh"

package adc_api_pkg;

  import logger_pkg::*;
  import adi_api_pkg::*;
  import adi_regmap_adc_pkg::*;
  import adi_regmap_pkg::*;
  import m_axi_sequencer_pkg::*;

  class adc_api extends adi_api;

    protected logic [31:0] val;

    function new(
      input string name,
      input m_axi_sequencer_base bus,
      input bit [31:0] base_address,
      input adi_component parent = null);

      super.new(name, bus, base_address, parent);
    endfunction

    task reset(
      input bit ce_n,
      input bit mmcm_rstn,
      input bit rstn);

      this.axi_write(GetAddrs(ADC_COMMON_REG_RSTN),
        `SET_ADC_COMMON_REG_RSTN_CE_N(ce_n) |
        `SET_ADC_COMMON_REG_RSTN_MMCM_RSTN(mmcm_rstn) |
        `SET_ADC_COMMON_REG_RSTN_RSTN(rstn));
    endtask

    task set_common_control(
      input bit pin_mode,
      input bit ddr_edgesel,
      input bit r1_mode,
      input bit sync,
      input bit [4:0] num_lanes,
      input bit symb_8_16b,
      input bit symb_op,
      input bit sdr_ddr_n);

      this.axi_write(GetAddrs(ADC_COMMON_REG_CNTRL),
        `SET_ADC_COMMON_REG_CNTRL_DDR_EDGESEL(ddr_edgesel) |
        `SET_ADC_COMMON_REG_CNTRL_NUM_LANES(num_lanes) |
        `SET_ADC_COMMON_REG_CNTRL_PIN_MODE(pin_mode) |
        `SET_ADC_COMMON_REG_CNTRL_R1_MODE(r1_mode) |
        `SET_ADC_COMMON_REG_CNTRL_SDR_DDR_N(sdr_ddr_n) |
        `SET_ADC_COMMON_REG_CNTRL_SYMB_8_16B(symb_8_16b) |
        `SET_ADC_COMMON_REG_CNTRL_SYMB_OP(symb_op) |
        `SET_ADC_COMMON_REG_CNTRL_SYNC(sync));
    endtask

    task set_common_control_2(
      input bit ext_sync_arm,
      input bit ext_sync_disarm,
      input bit manual_sync_request);

      this.axi_write(GetAddrs(ADC_COMMON_REG_CNTRL_2),
        `SET_ADC_COMMON_REG_CNTRL_2_EXT_SYNC_ARM(ext_sync_arm) |
        `SET_ADC_COMMON_REG_CNTRL_2_EXT_SYNC_DISARM(ext_sync_disarm) |
        `SET_ADC_COMMON_REG_CNTRL_2_MANUAL_SYNC_REQUEST(manual_sync_request));
    endtask

    task get_sync_status(output logic status);
      this.axi_read(GetAddrs(ADC_COMMON_REG_SYNC_STATUS), val);
      status = `GET_ADC_COMMON_REG_SYNC_STATUS_ADC_SYNC(val);
    endtask

    task set_adc_config_wr(input bit [31:0] cfg);
      this.axi_write(GetAddrs(ADC_COMMON_REG_ADC_CONFIG_WR), `SET_ADC_COMMON_REG_ADC_CONFIG_WR_ADC_CONFIG_WR(cfg));
    endtask

    task get_adc_config_wr(output logic [31:0] cfg);
      this.axi_read(GetAddrs(ADC_COMMON_REG_ADC_CONFIG_WR), val);
      cfg = `GET_ADC_COMMON_REG_ADC_CONFIG_WR_ADC_CONFIG_WR(val);
    endtask

    task get_adc_config_rd(output logic [31:0] cfg);
      this.axi_read(GetAddrs(ADC_COMMON_REG_ADC_CONFIG_RD), val);
      cfg = `GET_ADC_COMMON_REG_ADC_CONFIG_RD_ADC_CONFIG_RD(val);
    endtask

    task set_adc_config_control(input bit [31:0] cfg);
      this.axi_write(GetAddrs(ADC_COMMON_REG_ADC_CONFIG_CTRL), `SET_ADC_COMMON_REG_ADC_CONFIG_CTRL_ADC_CONFIG_CTRL(cfg));
    endtask

    task get_adc_config_control(output logic [31:0] cfg);
      this.axi_read(GetAddrs(ADC_COMMON_REG_ADC_CONFIG_CTRL), val);
      cfg = `GET_ADC_COMMON_REG_ADC_CONFIG_CTRL_ADC_CONFIG_CTRL(val);
    endtask

    task set_common_control_3(
      input bit crc_en,
      input bit [7:0] custom_control);

      this.axi_write(GetAddrs(ADC_COMMON_REG_CNTRL_3),
        `SET_ADC_COMMON_REG_CNTRL_3_CRC_EN(crc_en) |
        `SET_ADC_COMMON_REG_CNTRL_3_CUSTOM_CONTROL(custom_control));
    endtask

    task set_channel_control(
      input bit [7:0] channel,
      input bit adc_lb_owr,
      input bit adc_pn_sel_owr,
      input bit iqcor_enb,
      input bit dcfilt_enb,
      input bit format_signext,
      input bit format_type,
      input bit format_enable,
      input bit adc_pn_type_owr,
      input bit enable);

      this.axi_write(channel * 'h40 + GetAddrs(ADC_CHANNEL_REG_CHAN_CNTRL),
        `SET_ADC_CHANNEL_REG_CHAN_CNTRL_ADC_LB_OWR(adc_lb_owr) |
        `SET_ADC_CHANNEL_REG_CHAN_CNTRL_ADC_PN_SEL_OWR(adc_pn_sel_owr) |
        `SET_ADC_CHANNEL_REG_CHAN_CNTRL_IQCOR_ENB(iqcor_enb) |
        `SET_ADC_CHANNEL_REG_CHAN_CNTRL_DCFILT_ENB(dcfilt_enb) |
        `SET_ADC_CHANNEL_REG_CHAN_CNTRL_FORMAT_SIGNEXT(format_signext) |
        `SET_ADC_CHANNEL_REG_CHAN_CNTRL_FORMAT_TYPE(format_type) |
        `SET_ADC_CHANNEL_REG_CHAN_CNTRL_FORMAT_ENABLE(format_enable) |
        `SET_ADC_CHANNEL_REG_CHAN_CNTRL_ADC_PN_TYPE_OWR(adc_pn_type_owr) |
        `SET_ADC_CHANNEL_REG_CHAN_CNTRL_ENABLE(enable));
    endtask

    task set_channel_control_3(
      input bit [7:0] channel,
      input bit [3:0] pn_sel,
      input bit [3:0] data_sel);

      this.axi_write(channel * 'h40 + GetAddrs(ADC_CHANNEL_REG_CHAN_CNTRL_3),
        `SET_ADC_CHANNEL_REG_CHAN_CNTRL_3_ADC_PN_SEL(pn_sel) |
        `SET_ADC_CHANNEL_REG_CHAN_CNTRL_3_ADC_DATA_SEL(data_sel));
    endtask

    task clear_channel_status(input bit [7:0] channel);
      this.axi_write(channel * 'h40 + GetAddrs(ADC_CHANNEL_REG_CHAN_STATUS),
        `SET_ADC_CHANNEL_REG_CHAN_STATUS_CRC_ERR(1'b1) |
        `SET_ADC_CHANNEL_REG_CHAN_STATUS_PN_ERR(1'b1) |
        `SET_ADC_CHANNEL_REG_CHAN_STATUS_PN_OOS(1'b1) |
        `SET_ADC_CHANNEL_REG_CHAN_STATUS_OVER_RANGE(1'b1));
    endtask

    task enable_channel(input bit [7:0] channel);
      this.axi_write(channel * 'h40 + GetAddrs(ADC_CHANNEL_REG_CHAN_CNTRL), `SET_ADC_CHANNEL_REG_CHAN_CNTRL_ENABLE(1));
    endtask

    task disable_channel(input bit [7:0] channel);
      this.axi_write(channel * 'h40 + GetAddrs(ADC_CHANNEL_REG_CHAN_CNTRL), `SET_ADC_CHANNEL_REG_CHAN_CNTRL_ENABLE(0));
    endtask

    task get_status(output logic status);
      this.axi_read(GetAddrs(ADC_COMMON_REG_STATUS), val);
      status = `GET_ADC_COMMON_REG_STATUS_STATUS(val);
    endtask

    task get_adc_ctrl_status(output logic adc_ctrl_status);
      this.axi_read(GetAddrs(ADC_COMMON_REG_STATUS), val);
      adc_ctrl_status = `GET_ADC_COMMON_REG_STATUS_ADC_CTRL_STATUS(val);
    endtask

    task get_over_range_status(output logic over_range);
      this.axi_read(GetAddrs(ADC_COMMON_REG_STATUS), val);
      over_range = `GET_ADC_COMMON_REG_STATUS_OVER_RANGE(val);
    endtask

    task get_pn_oos_status(output logic pn_oos);
      this.axi_read(GetAddrs(ADC_COMMON_REG_STATUS), val);
      pn_oos = `GET_ADC_COMMON_REG_STATUS_PN_OOS(val);
    endtask

    task get_pn_err_status(output logic pn_err);
      pn_err = `GET_ADC_COMMON_REG_STATUS_PN_ERR(val);
    endtask

  endclass

endpackage
