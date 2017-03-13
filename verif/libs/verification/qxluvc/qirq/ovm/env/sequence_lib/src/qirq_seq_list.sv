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
 * @brief qirq Sequence
 *
 * The qirq sequence list file contains the available sequences for the CFG OVC.
 *
 * @file qirq_seq_list.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.1 $
 * $Date: Mon Nov 15 11:31:25 2010 $
 * $Author: mironm $
 */

`ifndef QIRQ_SEQ_LIST__SV
`define QIRQ_SEQ_LIST__SV

`include "ovm_macros.svh"

import ovm_pkg::*;

  // Include all available sequences with `include
`include "qirq_wait_edge_seq.sv"
`include "qirq_wait_value_seq.sv"
`include "qirq_wait_next_transition_by_signame_seq.sv"
`include "qirq_wait_next_transition_by_sigloc_seq.sv"
`include "qirq_wait_next_value_by_signame_seq.sv"
`include "qirq_wait_next_value_by_sigloc_seq.sv"

`endif
