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
  * @brief QCLK Package
 *
 * The QCLK package file (qclk_pkg.sv) contains the 
 * toplevel package
 * for the QCLK UVC.
 *
 * @file qclk_pkg.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.1 $
 * $Date: Mon Nov 15 11:27:29 2010 $
 * $Author: mironm $
 */
`ifndef QCLK_PKG__SV
`define QCLK_PKG__SV

`include "uvm_macros.svh"

/**
 * @brief QCLK Package
 *
 * The QCLK package (qclk_pkg) is the toplevel package
 * for the QCLK UVC.
 *
 */


package qclk_pkg;

import uvm_pkg::*;
import quvm_addons_pkg::*;

`include "uvm_macros.svh"
   
`include "qclk_item.sv"
`include "qclk_sequencer.sv"   
`include "qclk_driver.sv"
`include "qclk_agent.sv"
`include "qclk_seq_list.sv"
`include "qclk_proxy.sv"
   
endpackage: qclk_pkg

`endif

