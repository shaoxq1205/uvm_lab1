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
 * @brief QIRQ Wait Value Sequence
 *
 * The QIRQ wait value sequence file contains a sequence that enables
 * wait for a signal to obtain a required value
 *
 * @file qirq_wait_value_seq.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.1 $
 * $Date: Mon Nov 15 11:31:25 2010 $
 * $Author: mironm $
 */

`ifndef QIRQ_WAIT_VALUE_SEQ_SV
`define QIRQ_WAIT_VALUE_SEQ_SV

`include "ovm_macros.svh"

import ovm_pkg::*;


/**
 * @brief QIRQ Wait Value Sequence
 * The wait value sequence  class is a sequence that initiates a 
 * wait on a signal to obtain a particular value
 *
 * Usage Notes:<br>
 *
 * @class qirq_wait_value_seq
 *
 */
class qirq_wait_value_seq extends ovm_sequence #(qirq_item);
  `ovm_object_utils(qirq_wait_value_seq)  // Register with Factory

  rand int m_sig_loc;               ///< postion of sig(alias) on pin map file
  rand int m_expected_value;        ///< expected value of the signal     
  string m_signal_name;             ///< name of signal (alias)


  /**
   * @brief Constructor
   * Method to construct this class item
   * required syntax for OVM automation and utilities
   *
   * @param name string - name of class object
   */
  function new(string name = "qirq_wait_value_seq");
    super.new(name);
  endfunction: new

  /**
   * @brief Body
   * Sequence Body Method - main method of sequence
   */
  extern task body();


  //-----------------------------------------------------------------------------
  // constraint valid_constraint : cannot name it signal_valid otherwise it
	// will override the parent constraint
  //-----------------------------------------------------------------------------
  constraint valid_constraint;

endclass // qirq_wait_value_seq



//-----------------------------------------------------------------------------
// constraint valid_constraint
//-----------------------------------------------------------------------------
constraint qirq_wait_edge_seq::valid_constraint {
	m_sig_loc >= 0;
	// There is no easy way to get the max number of signals monitored
	// by hardware.
	m_num_matches >=0;
}


//-----------------------------------------------------------------------------
// body
//-----------------------------------------------------------------------------
task qirq_wait_value_seq::body();

  int sig_loc;
  bit [MAX_EDGE_VALUE_WIDTH-1:0] expected_value;
   
  REQ req_sequence_item_h;
  RSP rsp_sequence_item_h;
   
  req_sequence_item_h = qirq_item::type_id::create("req_sequence_item_h");

  //Required because some simulators dont support local::
  sig_loc = m_sig_loc;
  expected_value = m_expected_value;
   
  start_item(req_sequence_item_h);
  if(!req_sequence_item_h.randomize() with {
    m_trans_type == QIRQ_TYPE_WAIT_FOR_VALUE;
    m_num_matches == 1;
    m_sig_loc == /*local::m_*/sig_loc;
    m_expected_value == /*local::m_*/expected_value;
  }) begin
    `ovm_fatal(get_full_name(), "Randomize failed");
  end
  req_sequence_item_h.m_sig_name = m_signal_name;
   
  `ovm_info(get_full_name(), $psprintf("Qirq wait edge seq trans: %s sig_loc: %d",
    req_sequence_item_h.m_trans_type.name(),
    req_sequence_item_h.m_sig_loc), OVM_LOW);
   
  finish_item(req_sequence_item_h);
  get_response(rsp_sequence_item_h);
  `ovm_info(get_full_name(), 
    $psprintf("Qirq wait edge seq rsp: %s sig_loc: %d, Detected Value: %x Rsp Count: %d Time:%t" ,
      rsp_sequence_item_h.m_trans_type.name(),
      rsp_sequence_item_h.m_sig_loc, 
      rsp_sequence_item_h.m_detected_value,
      rsp_sequence_item_h.m_num_matches,                                      
      rsp_sequence_item_h.m_match_time), OVM_LOW);
endtask : body

`endif
