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
 * @brief Pcounter Base Test.
 *
 * Implements the basic environment construction, setup, and default
 *   test features. Real tests are expected to extend this class.
 *
 * @file pcounter_test_base.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.3 $
 * $Date: Mon Nov 15 12:05:28 2010 $
 * $Author: mironm $
 */

`ifndef PCOUNTER_TEST_BASE__SV
`define PCOUNTER_TEST_BASE__SV

`include "uvm_macros.svh"
import uvm_pkg::*;
import pcounter_pkg::*;

/**
 * @brief Pcounter Base Test.
 *
 * The pcounter_test_base is a class that
 * serves as the basis for many tests. It has the
 * following sub-components:
 * <ul>
  * <li> m_env_h - pcounter environment </li>
  * <li> m_virtual_sequencer_h - pcounter virtual sequencer </li>
 * </ul>
 * and following config objects:
 * <ul>
  * <li> m_qrst_cfg_h - reset config </li>
 * </ul>
 * <br>
 * Usage Notes:<br>
 *
 * @class pcounter_test_base
 *
 */
class pcounter_test_base extends uvm_test;
  `uvm_component_utils(pcounter_test_base)

  pcounter_env                 m_env_h; ///< Pcounter env with all the UVCs.
  pcounter_virtual_sequencer   m_virtual_sequencer_h; ///< Pcounter Virtual Sequencer Handle

  /**
   * @brief new method
   * Method to construct this class
   * required syntax for UVM automation and utilities
   *
   * @param name string - name of class object
   * @param parent uvm_component - parent of this class
   */
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  /**
   * @brief UVM build method
   * Method to create the environment and configure the UVC sequencers
   * using the UVM factory
   */
  extern virtual function void build_phase (uvm_phase phase);

  /**
   * @brief connect method
   * Method to connect the virtual sequencer
   */
  extern virtual function void connect_phase (uvm_phase phase);

  /**
   * @brief UVM run method
   * Run testcase
   */
  extern virtual task run_phase (uvm_phase phase);

  /**
   * @brief sequence part of run
   * Testcases can optionally implement this to create and start test sequence.
   * OR testcases can just implement the run() method.
   */
  virtual protected task run_test_seq();
  endtask: run_test_seq

endclass: pcounter_test_base

//-----------------------------------------------------------------------------
// build
//-----------------------------------------------------------------------------
function void pcounter_test_base::build_phase (uvm_phase phase);
  super.build_phase(phase);


  // Get the environment
  `uvm_info(get_type_name(), "creating the environment", UVM_LOW);
  m_env_h            = pcounter_env::type_id::create("m_env_h", this);
  // For demonstration only (Remove for real testbenches)
  `uvm_info(get_type_name(), "test message NONE (critical summary info only)", UVM_NONE);
  `uvm_info(get_type_name(), "test message LOW (one time important messages)", UVM_LOW);
  `uvm_info(get_type_name(), "test message MEDIUM (basic test progression)", UVM_MEDIUM);
  `uvm_info(get_type_name(), "test message HIGH (detailed data flow debugging)", UVM_HIGH);
  `uvm_info(get_type_name(), "test message FULL (detailed testbench debugging)", UVM_FULL);
endfunction : build_phase

//-----------------------------------------------------------------------------
// connect
//-----------------------------------------------------------------------------
function void pcounter_test_base::connect_phase (uvm_phase phase);
  `uvm_info(get_type_name(), "assigning the sequencer list from the environment", UVM_HIGH);
  m_virtual_sequencer_h = m_env_h.m_pcounter_virtual_sequencer_h;
endfunction : connect_phase

//-----------------------------------------------------------------------------
// run
//-----------------------------------------------------------------------------
task pcounter_test_base::run_phase (uvm_phase phase);
  `uvm_info(get_type_name(), "Starting test...", UVM_HIGH);
  run_test_seq();
  global_stop_request();
  `uvm_info(get_type_name(), "Done test.", UVM_HIGH);
endtask: run_phase

`endif
