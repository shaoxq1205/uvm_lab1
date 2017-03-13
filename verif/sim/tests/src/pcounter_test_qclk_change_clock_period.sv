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
 * @brief pcounter_test_qclk_change_clock_period Class File.
 * 
 * Implements the class pcounter_test_qclk_change_clock_period
 * 
 * @file pcounter_test_qclk_change_clock_period.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.3 $
 * $Date: Mon Nov 15 12:05:30 2010 $
 * $Author: mironm $
 */

`ifndef PCOUNTER_TEST_QCLK_CHANGE_CLOCK_PERIOD__SV
`define PCOUNTER_TEST_QCLK_CHANGE_CLOCK_PERIOD__SV

`include "uvm_macros.svh"
import uvm_pkg::*;
import pcounter_pkg::*;

/**
 * @brief pcounter_test_qclk_change_clock_period Class.
 *
 * Implements a test which waits for signal values
 *  * Signals are specified by signal names
 *
 * @class pcounter_test_qclk_change_clock_period
 *
 */ 
class pcounter_test_qclk_change_clock_period extends pcounter_test_base;
  `uvm_component_utils(pcounter_test_qclk_change_clock_period)

  pcounter_test_qclk_change_clock_period_vseq m_test_qclk_change_clock_period_vseq_h;

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
  endfunction: new

  /**
   * @brief build method
   * Method to create the pcounter_test_qclk_change_clock_period_vseq sequence
   * using the UVM factory
   */ 
  extern virtual function void build_phase (uvm_phase phase);

  /**
   * @brief run method
   * Method to execute the test
   */ 
  extern virtual task run_phase (uvm_phase phase);

endclass: pcounter_test_qclk_change_clock_period

function void pcounter_test_qclk_change_clock_period::build_phase (uvm_phase phase);
  super.build_phase (phase);
endfunction : build_phase

task pcounter_test_qclk_change_clock_period::run_phase (uvm_phase phase);

  phase.raise_objection(this);
  m_test_qclk_change_clock_period_vseq_h = pcounter_test_qclk_change_clock_period_vseq::type_id::create(
    "m_test_qclk_change_clock_period_vseq_h", this, m_virtual_sequencer_h.get_full_name());
  
  m_test_qclk_change_clock_period_vseq_h.start(m_virtual_sequencer_h);
  phase.drop_objection(this);

endtask : run_phase

`endif
