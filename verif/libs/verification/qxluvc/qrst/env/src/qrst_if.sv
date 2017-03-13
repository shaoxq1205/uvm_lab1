//-----------------------------------------------------------------------------
// Qualcomm Proprietary
// Copyright (c) Qualcomm Inc.
// All rights reserved.
//
//
// All data and information contained in or disclosed by this document
// are confidential and proprietary information of QUALCOMM Incorporated,
// and all rights therein are expressly reserved. By accepting this
// material, the recipient agrees that this material and the information
// contained therein are held in confidence and in trust and will not be
// used, copied, reproduced in whole or in part, nor its contents
// revealed in any manner to others without the express written
// permission of QUALCOMM Incorporated.
//
// This technology was exported from the United States in accordance with
// the Export Administration Regulations. Diversion contrary to U.S. law
// prohibited.
//-----------------------------------------------------------------------------

/**
 * @brief QRST Interface
 *
 * The QRST Interface file (qrst_if.sv) contains the
 * signal interface for the reset interface.
 *
 * @file qrst_if.sv
 *
 * @author Sean O'Boyle
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.2 $
 * $Date: Mon May  3 10:29:35 2010 $
 * $Author: c_jcravy $
 */

`ifndef QRST_IF__SV
`define QRST_IF__SV

`include "ovm_macros.svh"

`timescale 1ns / 1ps

/**
 * @brief Reset Interface.
 * This interface is use to control reset on a device. <br>
 * It receives a clock as an input and the rst_pin is
 * controlled by the QRST OVC.<br>
 * <br>
 * Modports:
 * <ul>
 *  <li> bfm - bus functional model - has bfm_cb clking block </li>
 *  <li> mon - passive monitor - has mon_cb clking block</li>
 * </ul>
 *
 * @param clk bit - input clock
 */
interface qrst_if (input logic clk);

  import ovm_pkg::*;

  logic        rst_pin; // Reset Pin

  clocking bfm_cb @ (posedge clk);
    default input #1step output #1ns;
    output rst_pin;
  endclocking: bfm_cb

  modport bfm_mp (
    clocking bfm_cb,
    output rst_pin  // for async access of the pin
  );

  clocking mon_cb @ (posedge clk);
    default input #1step;
    input  rst_pin;
  endclocking: mon_cb

  modport mon_mp (clocking mon_cb);

endinterface: qrst_if

`endif

