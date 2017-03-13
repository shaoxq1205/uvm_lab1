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
 * @brief QGPIO Write Value Sequence
 *
 * The QGPIO write value sequence file contains a sequence that can
 * read a value of a DUT signal. This signal is synthesized onto the
 * acceleration box. So there is no direct way of reading this signal 
 *
 * @file qgpio_read_value_seq.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.2 $
 * $Date: Tue Mar  8 12:54:49 2011 $
 * $Author: mironm $
 */

`ifndef QGPIO_WRITE_VALUE_SEQ_SV
`define QGPIO_WRITE_VALUE_SEQ_SV

`include "ovm_macros.svh"

import ovm_pkg::*;


/**
 * @brief QGPIO Wait Value Sequence
 * The write value sequence  class is a sequence that initiates a 
 * write  on a signal to obtain a particular value
 *
 * Usage Notes:<br>
 *
 * @class qgpio_write_value_seq
 *
 */
class qgpio_write_value_seq extends ovm_sequence #(qgpio_item);
  `ovm_object_utils(qgpio_write_value_seq)  // Register with Factory
  rand int m_sig_loc;                     ///< postion of sig(alias) on pin map file
  string m_signal_name;                   ///< name of signal (alias)
  rand int m_write_value;                 ///< value to be written
   
  /**
   * @brief Constructor
   * Method to construct this class item
   * required syntax for OVM automation and utilities
   *
   * @param name string - name of class object
   */
  function new(string name = "qgpio_write_value_seq");
    super.new(name);
  endfunction: new

  /**
   * @brief Valid signal select
   * Select signal that is within the list monitored 
   * by XlGpioTransactor hardware
   * 
   **/
    
  constraint valid_constraint;

  
  /**
   * @brief Body
   * Sequence Body Method - main method of sequence
   */
  extern task body();


endclass // qgpio_write_value_seq


//-----------------------------------------------------------------------------
// constraint valid_constraint
//-----------------------------------------------------------------------------
constraint qgpio_write_value_seq::valid_constraint {
  m_sig_loc >= 0;
}


//-----------------------------------------------------------------------------
// body
//-----------------------------------------------------------------------------
task qgpio_write_value_seq::body();

  int sig_loc;
  bit [MAX_SET_VALUE_WIDTH-1:0] write_value;
   
  REQ req_sequence_item_h;
  RSP rsp_sequence_item_h;
   
  req_sequence_item_h = qgpio_item::type_id::create("req_sequence_item_h");

  //Required because some simulators dont support local::
  sig_loc = m_sig_loc;
  write_value = m_write_value;
   
  start_item(req_sequence_item_h);
  if(!req_sequence_item_h.randomize() with {
    m_trans_type == QGPIO_TYPE_WRITE_VALUE;
    m_sig_loc == /*local::m_*/sig_loc;
    m_write_value == /*local::m_*/write_value;
  }) begin
    `ovm_info(get_full_name(), 
      $psprintf("Attempting to randomize QGPIO_WRITE_VALUE seq with: sig_loc %d: Write Value: %x",
        m_sig_loc, m_write_value), OVM_LOW)
    `ovm_fatal(get_full_name(), "Randomize failed");
     
  end
  req_sequence_item_h.m_sig_name = m_signal_name;
   
  `ovm_info(get_full_name(), 
    $psprintf("Qgpio WriteValue: %s sig_loc: %d Value: %x",
      req_sequence_item_h.m_trans_type.name(),
      req_sequence_item_h.m_sig_loc, 
      req_sequence_item_h.m_write_value), OVM_LOW);
  
  finish_item(req_sequence_item_h);
  get_response(rsp_sequence_item_h);
  `ovm_info(get_full_name(), 
    $psprintf("Qgpio WriteValue(Rsp)- %s sig_loc: %d, Value Written: %x at Time:%t" ,
      rsp_sequence_item_h.m_trans_type.name(),
      rsp_sequence_item_h.m_sig_loc, 
      rsp_sequence_item_h.m_write_value,
      rsp_sequence_item_h.m_time), OVM_LOW);
endtask : body

`endif
