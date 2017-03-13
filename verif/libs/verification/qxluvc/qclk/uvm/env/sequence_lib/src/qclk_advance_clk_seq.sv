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
 * @brief QCLK Advance Clk Sequence
 *
 * The QCLK advance clk file contains a sequence that makes the
 * thread wait for n clock cycles
 *
 * @file qclk_advance_clk_seq.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.1 $
 * $Date: Mon Nov 15 11:27:28 2010 $
 * $Author: mironm $
 */

`ifndef QCLK_ADVANCE_CLK_SEQ__SV
`define QCLK_ADVANCE_CLK_SEQ__SV

`include "uvm_macros.svh"

import uvm_pkg::*;

/**
 * @brief advance clock
 * The qclk advance clk seque class is a sequence that initiates a 
 * advance clock by n cycles.  The thread that initiates this sequence
 * is essentially suspended till the required clock ticks are completed
 *
 * Usage Notes:<br>
 *
 * @class qclk_advance_clk_seq
 *
 */
class qclk_advance_clk_seq extends uvm_sequence #(qclk_item);
  `uvm_object_utils(qclk_advance_clk_seq)  // Register with Factory

  rand longint unsigned m_num_clks;
  /**
   * @brief Constructor
   * Method to construct this class item
   * required syntax for UVM automation and utilities
   *
   * @param name string - name of class object
   */
  function new(string name = "qclk_advance_clk_seq");
    super.new(name);
  endfunction: new

  /**
   * @brief Body
   * Sequence Body Method - main method of sequence
   */
  extern task body();

endclass : qclk_advance_clk_seq


//-----------------------------------------------------------------------------
// body
//-----------------------------------------------------------------------------
task qclk_advance_clk_seq::body();

  longint unsigned num_clks;                ///< number of clock cyces
  REQ   req_sequence_item_h;     ///< The request sequence item
  RSP   rsp_sequence_item_h;     ///< The response sequence item
   
  req_sequence_item_h = qclk_item::type_id::create("req_sequence_item_h");

  //Required because some simulators dont support local::
  num_clks = m_num_clks;

  start_item(req_sequence_item_h);

  // In this sequence the trans type is fixed and the number
  // of clocks will be fixed by higher level constraints
  if(!req_sequence_item_h.randomize() with {
    m_trans_type == QCLK_TYPE_ADVANCE_CLK;
    m_num_clocks == num_clks;                                          
  }) begin
    `uvm_info(get_full_name(), $psprintf("Was trying to randomize with NumCloks::%d", num_clks),
      UVM_LOW);
    `uvm_fatal(get_full_name(), "randomize failed");
  end
   
  `uvm_info(get_full_name(), $psprintf("QCLK advance_clk seq :%s num_clks:%d",
    req_sequence_item_h.m_trans_type.name(), 
    req_sequence_item_h.m_num_clocks),  UVM_LOW) ;

  finish_item(req_sequence_item_h);
  get_response(rsp_sequence_item_h);
  `uvm_info(get_full_name(), $psprintf("QCLK advance_clk seq :%s num_clks:%d",
    rsp_sequence_item_h.m_trans_type.name(), 
    rsp_sequence_item_h.m_num_clocks),  UVM_LOW) ;

endtask : body

`endif
