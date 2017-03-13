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
 * @brief QCLK period sequence
 *
 * The QCLK period sequence  a sequence that can be used
 * to change the clock period of the generated clock in hardware
 * This sequence sets the high and the low duration of the clock
 *
 * @file qclk_period_seq.sv
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


`ifndef QCLK_PERIOD_SEQ__SV
`define QCLK_PERIOD_SEQ__SV

`include "uvm_macros.svh"

import uvm_pkg::*;



/**
 * @brief QCLK period sequence
 * The clock period sequence is a sequence that changes the 
 * hi and low duraiton of the sim accel clock.
 *
 * Usage Notes:<br>
 *
 * @class qclk_period_seq
 *
 */
class qclk_period_seq extends uvm_sequence #(qclk_item);
  `uvm_object_utils(qclk_period_seq)  // Register with Factory

  rand int m_hi_dur;     ///< high duration of the clock
  rand int m_lo_dur;     ///< low duration of the clock
   
  /**
   * @brief Constructor
   * Method to construct this class item
   * required syntax for UVM automation and utilities
   *
   * @param name string - name of class object
   */
  function new(string name = "qclk_period_seq");
    super.new(name);
  endfunction: new

  /**
   * @brief Body
   * Sequence Body Method - main method of sequence
   */
  extern task body();

endclass : qclk_period_seq


//-----------------------------------------------------------------------------
// body
//-----------------------------------------------------------------------------
task qclk_period_seq::body();

  int   hi_dur;
  int   lo_dur;
  REQ   req_sequence_item_h;    ///< handle to request sequence
  RSP   rsp_sequence_item_h;    ///< handle to response sequence
   
  req_sequence_item_h = qclk_item::type_id::create("req_sequence_item_h");

  //Required because some simulators dont support local::
  hi_dur = m_hi_dur;
  lo_dur = m_lo_dur;
   
  start_item(req_sequence_item_h);
  if(!req_sequence_item_h.randomize() with {
    m_trans_type == QCLK_TYPE_ADJUST_CLK_PERIOD;
    m_num_clocks == 0;                                         
    m_high_duration == hi_dur;
    m_low_duration == lo_dur;
  }) begin
    `uvm_info(get_full_name(), $psprintf("Was randomizing with NumCloks::%d, hi_dur::%d, lo_dur::%d", 
      0, hi_dur, lo_dur), UVM_LOW);
    `uvm_fatal(get_full_name(), "Randomize failed");
  end
   
  `uvm_info(get_full_name(), $psprintf("QCLK clk_period seq :%s hi_dur:%d lo_dur:%d",
    req_sequence_item_h.m_trans_type.name(), 
    req_sequence_item_h.m_high_duration, 
    req_sequence_item_h.m_low_duration), UVM_LOW) ;

  finish_item(req_sequence_item_h);
  get_response(rsp_sequence_item_h);
  `uvm_info(get_full_name(), $psprintf("QCLK clk_period seq :%s hi_dur:%d lo_dur:%d",
    rsp_sequence_item_h.m_trans_type.name(), 
    rsp_sequence_item_h.m_high_duration, 
    rsp_sequence_item_h.m_low_duration), UVM_LOW) ;

endtask : body

`endif
