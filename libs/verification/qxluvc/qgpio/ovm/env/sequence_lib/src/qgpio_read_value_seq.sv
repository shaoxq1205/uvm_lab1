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
 * @brief QGPIO Read Value Sequence
 *
 * The QGPIO read value sequence file contains a sequence that can
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
 * $Revision: 1.1 $
 * $Date: Mon Nov 15 11:29:45 2010 $
 * $Author: mironm $
 */

`ifndef QGPIO_READ_VALUE_SEQ_SV
`define QGPIO_READ_VALUE_SEQ_SV

`include "ovm_macros.svh"

import ovm_pkg::*;


/**
 * @brief QGPIO Read value sequence
 * The read value sequence  class is a sequence that initiates a 
 * read of a signal value 
 *
 * Usage Notes:<br>
 *
 * @class qgpio_read_value_seq
 *
 */
class qgpio_read_value_seq extends ovm_sequence #(qgpio_item);
  `ovm_object_utils(qgpio_read_value_seq)  // Register with Factory
  rand int m_sig_loc;                     ///< postion of sig(alias) on pin map file
  string m_signal_name;                   ///< name of signal (alias)
  bit [MAX_GET_VALUE_WIDTH-1:0] m_read_value;           ///< value that has been read from transactor

  /**
   * @brief Constructor
   * Method to construct this class item
   * required syntax for OVM automation and utilities
   *
   * @param name string - name of class object
   */
  function new(string name = "qgpio_read_value_seq");
    super.new(name);
  endfunction: new

  /**
   * @brief Body
   * Sequence Body Method - main method of sequence
   */
  extern task body();


  //-----------------------------------------------------------------------------
  // constraint valid_constraint
  //-----------------------------------------------------------------------------
  constraint valid_constraint;

endclass // qgpio_read_value_seq


//-----------------------------------------------------------------------------
// constraint valid_constraint
//-----------------------------------------------------------------------------
constraint qgpio_read_value_seq::valid_constraint {
  m_sig_loc >= 0;
}

//-----------------------------------------------------------------------------
// body
//-----------------------------------------------------------------------------
task qgpio_read_value_seq::body();

  int sig_loc;
  REQ req_sequence_item_h;
  RSP rsp_sequence_item_h;
  req_sequence_item_h = qgpio_item::type_id::create("req_sequence_item_h");
  
   //Required because some simulators dont support local::
  sig_loc = m_sig_loc;
   
  start_item(req_sequence_item_h);
  if(!req_sequence_item_h.randomize() with {
    m_trans_type == QGPIO_TYPE_READ_VALUE;
    m_sig_loc == /*local::m_*/sig_loc;
  }) begin
    `ovm_fatal(get_full_name(), "randomize failed");
  end
  req_sequence_item_h.m_sig_name = m_signal_name;
   
  `ovm_info(get_full_name(), $psprintf("Qgpio ReadValue - %s sig_loc: %d",
    req_sequence_item_h.m_trans_type.name(),
    req_sequence_item_h.m_sig_loc), OVM_LOW);
   
  finish_item(req_sequence_item_h);
  get_response(rsp_sequence_item_h);
  `ovm_info(get_full_name(), $psprintf("Qgpio Response :: (Time: %t) Signal:%s :: Value: %d" ,
    rsp_sequence_item_h.m_time, rsp_sequence_item_h.m_sig_name, rsp_sequence_item_h.m_read_value),
    OVM_LOW);
	///< Storing the read value locally for any one to read
  m_read_value = rsp_sequence_item_h.m_read_value;
   
endtask : body

`endif
