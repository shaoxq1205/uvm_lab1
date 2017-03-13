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



`ifndef QCLK_GATE_Z_SEQ__SV
`define QCLK_GATE_Z_SEQ__SV

`include "ovm_macros.svh"

import ovm_pkg::*;

/**
 * @brief QCLK Gate Z Sequence
 *
 * The QCLK gate z seq file contains a sequence that makes the
 * clock gating to become z in hardware. The clock becomes
 * z after the next posedge and remains z for n clock cyles
 *
 * @file qclk_gate_z_seq.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.1 $
 * $Date: Wed Sep  7 21:56:45 2011 $
 * $Author: mironm $
 */


class qclk_gate_z_seq extends ovm_sequence #(qclk_item);
  `ovm_object_utils(qclk_gate_z_seq)  // Register with Factory

  rand int m_num_clks;
   
  /**
   * @brief Constructor
   * Method to construct this class item
   * required syntax for OVM automation and utilities
   *
   * @param name string - name of class object
   */
  function new(string name = "qclk_gate_z_seq");
    super.new(name);
  endfunction: new

  /**
   * @brief Body
   * Sequence Body Method - main method of sequence
   */
  extern task body();

endclass : qclk_gate_z_seq


//-----------------------------------------------------------------------------
// body
//-----------------------------------------------------------------------------
task qclk_gate_z_seq::body();

  int   num_clks;
   
  REQ   req_sequence_item_h;
  RSP   rsp_sequence_item_h;
   
  req_sequence_item_h = qclk_item::type_id::create("req_sequence_item_h");

  //Required because some simulators dont support local::
  num_clks  = m_num_clks;
   
  start_item(req_sequence_item_h);
  if(!req_sequence_item_h.randomize() with {
    m_trans_type == QCLK_TYPE_GATE_CLK_Z;
    m_num_clocks == num_clks;                                          
  }) begin
    `ovm_info(get_full_name(), $psprintf("Was randomizing with num_clocks:%d ", num_clks), OVM_LOW);
    `ovm_fatal(get_full_name(), "Randomize failed");
  end
   
  `ovm_info(get_full_name(), $psprintf("QCLK clk_gate_z seq :%s Num_clocks:%d ",
    req_sequence_item_h.m_trans_type.name(), 
    req_sequence_item_h.m_num_clocks), 
    OVM_LOW) ;

  finish_item(req_sequence_item_h);
  get_response(rsp_sequence_item_h);
  `ovm_info(get_full_name(), $psprintf("QCLK clk_gate_z seq :%s Num_clocks:%d",
    rsp_sequence_item_h.m_trans_type.name(), 
    rsp_sequence_item_h.m_num_clocks),
    OVM_LOW);
endtask : body

`endif
