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
 * @brief QCLK Dynamic Reset Sequence
 *
 * The QCLK dynamic reset file contains a sequence that issues reset in the
 * middle of simulation
 *
 * @file qclk_dynamic_reset_seq.sv
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

`ifndef QCLK_DYNAMIC_RESET_SEQ__SV
`define QCLK_DYNAMIC_RESET_SEQ__SV

`include "uvm_macros.svh"

import uvm_pkg::*;

/**
 * @brief dynamic reset
 * The qclk dynamic reset sequence class is a sequence that initiates a
 * reset/restart in the middle of simulation. 
 *
 * Usage Notes:<br>
 *
 * @class qclk_dynamic_reset_seq
 *
 */
class qclk_dynamic_reset_seq extends uvm_sequence #(qclk_item);
  `uvm_object_utils(qclk_dynamic_reset_seq)  // Register with Factory

  rand longint unsigned m_num_clks;
  /**
   * @brief Constructor
   * Method to construct this class item
   * required syntax for UVM automation and utilities
   *
   * @param name string - name of class object
   */
  function new(string name = "qclk_dynamic_reset_seq");
    super.new(name);
  endfunction: new

  /**
   * @brief Body
   * Sequence Body Method - main method of sequence
   */
  extern task body();

endclass : qclk_dynamic_reset_seq


//-----------------------------------------------------------------------------
// body
//-----------------------------------------------------------------------------
task qclk_dynamic_reset_seq::body();

  REQ   req_sequence_item_h;     ///< The request sequence item
  RSP   rsp_sequence_item_h;     ///< The response sequence item
   
  req_sequence_item_h = qclk_item::type_id::create("req_sequence_item_h");

  start_item(req_sequence_item_h);

  // In this sequence the trans type is fixed and the number
  // of clocks will be fixed by higher level constraints
  if(!req_sequence_item_h.randomize() with {
    m_trans_type == QCLK_TYPE_DYNAMIC_RESET;
  }) begin
    `uvm_info(get_full_name(), $psprintf("Was trying to randomize", ),
      UVM_LOW);
    `uvm_fatal(get_full_name(), "randomize failed");
  end
   
  `uvm_info(get_full_name(), $psprintf("QCLK dynamic_reset seq :%s",
    req_sequence_item_h.m_trans_type.name()),  UVM_LOW) ;

  finish_item(req_sequence_item_h);
  get_response(rsp_sequence_item_h);
  `uvm_info(get_full_name(), $psprintf("QCLK dynamic_reset seq :%s",
    rsp_sequence_item_h.m_trans_type.name()),  UVM_LOW) ;

endtask : body

`endif
