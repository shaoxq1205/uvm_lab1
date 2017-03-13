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
 * @brief qclk Sequence
 *
 * The qclk sequence list file lists all  sequences for the qclk UVC.
 *
 * @file qclk_seq_list.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.3 $
 * $Date: Wed Sep 21 17:54:01 2011 $
 * $Author: mironm $
 */

`ifndef QCLK_SEQ_LIST__SV
`define QCLK_SEQ_LIST__SV

`include "uvm_macros.svh"

import uvm_pkg::*;

  // Include all available sequences with `include
`include "qclk_period_seq.sv"
`include "qclk_gate_hi_seq.sv"
`include "qclk_gate_lo_seq.sv"
`include "qclk_gate_z_seq.sv"
`include "qclk_disable_gating_seq.sv"
`include "qclk_advance_clk_seq.sv"
`include "qclk_dynamic_reset_seq.sv"

`endif
