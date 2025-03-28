// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
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
/* Auto generated Register Map */
/* Thu Mar 28 13:22:23 2024 */

package adi_regmap_gpreg_pkg;
  import adi_regmap_pkg::*;


/* General Purpose Registers (axi_gpreg) */

  const reg_t AXI_GPREG_REG_IO_ENB = '{ 'h0400, "REG_IO_ENB" , '{
    "IO_ENB": '{ 31, 0, RW, 'h00000000 }}};
  `define SET_AXI_GPREG_REG_IO_ENB_IO_ENB(x) SetField(AXI_GPREG_REG_IO_ENB,"IO_ENB",x)
  `define GET_AXI_GPREG_REG_IO_ENB_IO_ENB(x) GetField(AXI_GPREG_REG_IO_ENB,"IO_ENB",x)
  `define DEFAULT_AXI_GPREG_REG_IO_ENB_IO_ENB GetResetValue(AXI_GPREG_REG_IO_ENB,"IO_ENB")
  `define UPDATE_AXI_GPREG_REG_IO_ENB_IO_ENB(x,y) UpdateField(AXI_GPREG_REG_IO_ENB,"IO_ENB",x,y)

  const reg_t AXI_GPREG_REG_IO_OUT = '{ 'h0404, "REG_IO_OUT" , '{
    "IO_ENB": '{ 31, 0, RW, 'h00000000 }}};
  `define SET_AXI_GPREG_REG_IO_OUT_IO_ENB(x) SetField(AXI_GPREG_REG_IO_OUT,"IO_ENB",x)
  `define GET_AXI_GPREG_REG_IO_OUT_IO_ENB(x) GetField(AXI_GPREG_REG_IO_OUT,"IO_ENB",x)
  `define DEFAULT_AXI_GPREG_REG_IO_OUT_IO_ENB GetResetValue(AXI_GPREG_REG_IO_OUT,"IO_ENB")
  `define UPDATE_AXI_GPREG_REG_IO_OUT_IO_ENB(x,y) UpdateField(AXI_GPREG_REG_IO_OUT,"IO_ENB",x,y)

  const reg_t AXI_GPREG_REG_IO_IN = '{ 'h0408, "REG_IO_IN" , '{
    "IO_IN": '{ 31, 0, RO, 'h00000000 }}};
  `define SET_AXI_GPREG_REG_IO_IN_IO_IN(x) SetField(AXI_GPREG_REG_IO_IN,"IO_IN",x)
  `define GET_AXI_GPREG_REG_IO_IN_IO_IN(x) GetField(AXI_GPREG_REG_IO_IN,"IO_IN",x)
  `define DEFAULT_AXI_GPREG_REG_IO_IN_IO_IN GetResetValue(AXI_GPREG_REG_IO_IN,"IO_IN")
  `define UPDATE_AXI_GPREG_REG_IO_IN_IO_IN(x,y) UpdateField(AXI_GPREG_REG_IO_IN,"IO_IN",x,y)

  const reg_t AXI_GPREG_REG_CM_RESET = '{ 'h0800, "REG_CM_RESET" , '{
    "CM_RESET_N": '{ 0, 0, RW, 'h0 }}};
  `define SET_AXI_GPREG_REG_CM_RESET_CM_RESET_N(x) SetField(AXI_GPREG_REG_CM_RESET,"CM_RESET_N",x)
  `define GET_AXI_GPREG_REG_CM_RESET_CM_RESET_N(x) GetField(AXI_GPREG_REG_CM_RESET,"CM_RESET_N",x)
  `define DEFAULT_AXI_GPREG_REG_CM_RESET_CM_RESET_N GetResetValue(AXI_GPREG_REG_CM_RESET,"CM_RESET_N")
  `define UPDATE_AXI_GPREG_REG_CM_RESET_CM_RESET_N(x,y) UpdateField(AXI_GPREG_REG_CM_RESET,"CM_RESET_N",x,y)

  const reg_t AXI_GPREG_REG_CM_COUNT = '{ 'h0808, "REG_CM_COUNT" , '{
    "CM_CLK_COUNT": '{ 31, 0, RO, 'h00000000 }}};
  `define SET_AXI_GPREG_REG_CM_COUNT_CM_CLK_COUNT(x) SetField(AXI_GPREG_REG_CM_COUNT,"CM_CLK_COUNT",x)
  `define GET_AXI_GPREG_REG_CM_COUNT_CM_CLK_COUNT(x) GetField(AXI_GPREG_REG_CM_COUNT,"CM_CLK_COUNT",x)
  `define DEFAULT_AXI_GPREG_REG_CM_COUNT_CM_CLK_COUNT GetResetValue(AXI_GPREG_REG_CM_COUNT,"CM_CLK_COUNT")
  `define UPDATE_AXI_GPREG_REG_CM_COUNT_CM_CLK_COUNT(x,y) UpdateField(AXI_GPREG_REG_CM_COUNT,"CM_CLK_COUNT",x,y)


endpackage
