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
 * @brief QIRQ Package
 *
 * The QIRQ package file (qirq_pkg.sv) contains the toplevel package
 * for the QIRQ OVC.
 *
 * @file qirq_pkg.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.1 $
 * $Date: Mon Nov 15 11:31:23 2010 $
 * $Author: mironm $
 */
`ifndef QIRQ_PKG__SV
`define QIRQ_PKG__SV

`include "ovm_macros.svh"

/**
 * @brief QIRQ Package
 *
 * The QIRQ package (qirq_pkg) is the toplevel package
 * for the QIRQ OVC.
 *
 */
package qirq_pkg;

  import ovm_pkg::*;
  import qovm_addons_pkg::*;

  parameter MAX_EDGE_VALUE_WIDTH = 32;
  parameter MAX_NUM_SIGNALS   = 200;
   
   
`include "ovm_macros.svh"
   
`include "qirq_item.sv"
`include "qirq_sequencer.sv"   
`include "qirq_driver.sv"
`include "qirq_agent.sv"
`include "qirq_seq_list.sv"
`include "qirq_proxy.sv"
   
endpackage: qirq_pkg

`endif

