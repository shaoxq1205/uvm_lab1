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

`ifndef PCOUNTER_TEST_PKG__SV
`define PCOUNTER_TEST_PKG__SV

`include "uvm_macros.svh"

`timescale 1ns/1ps

package pcounter_test_pkg;

  import uvm_pkg::*;
  // Base Test
  `include "pcounter_test_base.sv"
  

  `include "pcounter_test_qclk_change_clock_period.sv"



  
endpackage: pcounter_test_pkg

`endif
