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
 * @brief QRST Sequence List File.
 *
 * The QRST Sequence List File (qrst_seq_list.sv) includes all of the available
 * sequences for the QRST OVC.
 *
 * @file qrst_seq_list.sv
 *
 * @author Sean O'Boyle
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.3 $
 * $Date: Thu Mar  4 16:34:17 2010 $
 * $Author: joboyle $
 */

`ifndef QRST_SEQ_LIST__SV
`define QRST_SEQ_LIST__SV

`include "ovm_macros.svh"
import ovm_pkg::*;

// Include all available sequences with `include
`include "qrst_typical_seq.sv"
`include "qrst_basic_seq.sv"
`include "qrst_act_low_async_seq.sv"

`endif
