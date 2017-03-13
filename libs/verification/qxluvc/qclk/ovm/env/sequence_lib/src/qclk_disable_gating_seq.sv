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



`ifndef QCLK_DISABLE_GATING_SEQ__SV
`define QCLK_DISABLE_GATING_SEQ__SV

`include "ovm_macros.svh"

import ovm_pkg::*;

/**
 * @brief QCLK Disable Clock Gating Sequence
 *
 * The QCLK disable gating seq file contains a sequence that disables
 * any clock gating.  The clock resumes toggling when this sequence
 * is used.
 *
 * @file qclk_disable_gating_seq.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.1 $
 * $Date: Wed Sep 21 17:54:44 2011 $
 * $Author: mironm $
 */


class qclk_disable_gating_seq extends ovm_sequence #(qclk_item);
  `ovm_object_utils(qclk_disable_gating_seq)  // Register with Factory

  /**
   * @brief Constructor
   * Method to construct this class item
   * required syntax for OVM automation and utilities
   *
   * @param name string - name of class object
   */
  function new(string name = "qclk_disable_gating_seq");
    super.new(name);
  endfunction: new

  /**
   * @brief Body
   * Sequence Body Method - main method of sequence
   */
  extern task body();

endclass : qclk_disable_gating_seq


//-----------------------------------------------------------------------------
// body
//-----------------------------------------------------------------------------
task qclk_disable_gating_seq::body();

  int   num_clks;
   
  REQ   req_sequence_item_h;
  RSP   rsp_sequence_item_h;
   
  req_sequence_item_h = qclk_item::type_id::create("req_sequence_item_h");

  start_item(req_sequence_item_h);
  if(!req_sequence_item_h.randomize() with {
    m_trans_type == QCLK_TYPE_DISABLE_GATING;
  }) begin
    `ovm_fatal(get_full_name(), "Randomize failed");
  end
   
  `ovm_info(get_full_name(), $psprintf(
    "QCLK clk_disable_gating seq started:%s",
    req_sequence_item_h.m_trans_type.name()), 
    OVM_LOW) ;

  finish_item(req_sequence_item_h);
  get_response(rsp_sequence_item_h);
  `ovm_info(get_full_name(), $psprintf(
    "QCLK clk_disable_gating seq finished:%s",
    rsp_sequence_item_h.m_trans_type.name()),
    OVM_LOW);
endtask : body

`endif
