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
 * @brief QGPIO Package
 *
 * The QGPIO package file (qgpio_pkg.sv) contains the toplevel package
 * for the QGPIO UVC.
 *
 * @file qgpio_pkg.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.1 $
 * $Date: Mon Nov 15 11:29:46 2010 $
 * $Author: mironm $
 */
`ifndef QGPIO_PKG__SV
`define QGPIO_PKG__SV

`include "uvm_macros.svh"

/**
 * @brief QGPIO Package
 *
 * The QGPIO package (qgpio_pkg) is the toplevel package
 * for the QGPIO UVC.
 *
 */
package qgpio_pkg;

  import uvm_pkg::*;
  import quvm_addons_pkg::*;

  parameter MAX_NUM_SIGNALS   = 200;
  parameter MAX_GET_VALUE_WIDTH = 32;
  parameter MAX_SET_VALUE_WIDTH = 32;
   
`include "uvm_macros.svh"
   
`include "qgpio_item.sv"
`include "qgpio_sequencer.sv"   
`include "qgpio_driver.sv"
`include "qgpio_agent.sv"
`include "qgpio_seq_list.sv"
`include "qgpio_proxy.sv"

   
endpackage: qgpio_pkg

`endif

