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
 * @brief QRST Package
 *
 * The QRST package file (qrst_pkg.sv) contains the toplevel package
 * for the QRST OVC.
 *
 * @file qrst_pkg.sv
 *
 * @author Sean O'Boyle
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.1 $
 * $Date: Fri Nov  6 09:28:06 2009 $
 * $Author: joboyle $
 */
`ifndef QRST_PKG__SV
`define QRST_PKG__SV

`include "ovm_macros.svh"

/**
 * @brief QRST Package
 *
 * The QRST package (qrst_pkg) is the toplevel package
 * for the QRST OVC.
 *
 */
package qrst_pkg;

  import ovm_pkg::*;
  import qovm_addons_pkg::*;

  `include "qrst_item.sv"
  `include "qrst_cfg.sv"
  `include "qrst_driver.sv"
  `include "qrst_sequencer.sv"
  `include "qrst_agent.sv"
  `include "qrst_env.sv"
  `include "qrst_seq_list.sv"

endpackage: qrst_pkg

`endif
