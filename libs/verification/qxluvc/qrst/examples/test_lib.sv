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
 * @brief Demo Testbench Libarary
 *
 * The QRST TB Top Libary file (test_lib.sv) has the classes required
 * to confirm proper operation of the QRST OVC.
 *
 * @file test_lib.sv
 *
 * @author Sean O'Boyle
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.1 $
 * $Date: Fri Nov  6 09:28:07 2009 $
 * $Author: joboyle $
 */

`ifndef TEST_LIB__SV
`define TEST_LIB__SV

`include "demo_tb.sv"

//----------------------------------------------------------------
//
// TEST: demo_base_test - Base test
//
//----------------------------------------------------------------
class demo_base_test extends ovm_test;

  `ovm_component_utils(demo_base_test)

  demo_tb demo_tb0;
  ovm_table_printer printer;

  function new(string name = "demo_base_test",
    ovm_component parent=null);
    super.new(name,parent);
    printer = new();
  endfunction : new

  virtual function void build();
    super.build();
    // Enable transaction recording for everything
    set_config_int("*", "recording_detail", OVM_FULL);
    // Create the testbench
    demo_tb0 = demo_tb::type_id::create("demo_tb0", this);
  endfunction : build

  task run();
    printer.knobs.depth = 5;
    this.print(printer);
    #3000;
    ovm_report_info(get_type_name(), "User activated end of simulation", OVM_LOW);
    global_stop_request();
  endtask : run

endclass : demo_base_test

//----------------------------------------------------------------
//
// TEST: default_reset_test - sets the default sequences
//
//----------------------------------------------------------------
class default_reset_test extends demo_base_test;

  `ovm_component_utils(default_reset_test)

  function new(string name = "default_reset_test", ovm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build();
    // Change the default default sequence
    set_config_string("demo_tb0.qrst.m_agent.qrst_sequencer","default_sequence","qrst_basic_seq");
    // Create the testbench
    super.build();
  endfunction : build

endclass : default_reset_test

//----------------------------------------------------------------
//
// TEST: default_reset_test - sets the default sequences
//
//----------------------------------------------------------------
class async_rst_test extends demo_base_test;

  `ovm_component_utils(async_rst_test)

  function new(string name = "async_rst_test", ovm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build();
    // Change the default default sequence
    set_config_string("demo_tb0.qrst.m_agent.qrst_sequencer","default_sequence","qrst_act_low_async_seq");
    // Create the testbench
    super.build();
  endfunction : build

endclass : async_rst_test

`endif
