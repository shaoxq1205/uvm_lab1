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
 * @brief QRST TB Top Demo.
 *
 * The QRST TB Top Demo file (tb_top.sv) has a
 * toplevel module testbench.
 *
 * @file tb_top.sv
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
`include "ovm_macros.svh"

/**
 * @brief Top Module
 * This is module is an example top level testbench
 *
*/
module tb_top;

  timeunit 1ns;
  timeprecision 1ps;

  import ovm_pkg::*;
  import qovm_addons_pkg::*;
  import qovm_extensions_pkg::*;
  import qrst_pkg::*;
  `include "test_lib.sv"

  // just here to create object printing without the annoying default
  // headers and footers that the standard OVM printers give you
  qovm_null_printer qovm_default_null_printer;

  bit clk = 1;
  /// Simple clk generator
  always begin
    #10 clk = ~clk;
  end

  qrst_if    rst_if_i ( .clk(clk)              );

  typedef qovm_vif_container #( virtual qrst_if.bfm_mp  )  rst_bfm_vif_container_t;
  rst_bfm_vif_container_t  rst_bfm_vif_container_h;

  initial begin

    qovm_default_null_printer = new();

    rst_bfm_vif_container_h  = rst_vif_container::type_id::create( "rst_bfm_vif_container_h"  );

    $timeformat(-9, 0, " ns", 5); // show time in ns

    // set the interfaces into virtual interface containers
    // set those containers into the config database
    rst_bfm_vif_container_h.m_vif_h = rst_if_i.bfm_mp;
    set_config_object( "*", "rst_bfm_vif_container_h",  rst_bfm_vif_container_h  );

    // this removes the default headers and footers from the default OVM class print method
    ovm_default_printer = qovm_default_null_printer;

    //Run the test
    run_test();

  end

endmodule: tb_top
