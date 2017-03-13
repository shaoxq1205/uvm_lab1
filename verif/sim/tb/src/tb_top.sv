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

`include "uvm_macros.svh"

`timescale 1ns / 1ps

/**
 * @brief Testbench Top
 * This is module is the top level testbench for the transform DUT.
 * It instantiates all UVC interfaces and the
 * transform DUT.
 *
*/
module tb_top;

  import uvm_pkg::*;
  import quvm_addons_pkg::*;
  import pcounter_test_pkg::*;
  import pcounter_pkg::*;

  pcounter_env env_h;


  initial begin
    $timeformat(-9, 0, " ns", 5); // show time in ns

    // Create the env and Run the test
    env_h = pcounter_env::type_id::create("env_h", null);
    run_test();

  end

endmodule: tb_top






