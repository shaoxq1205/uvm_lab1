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
 * @brief QIRQ Wait Next Value By Sigloc
 *
 * This file implements the virtual sequence 
 * qirq_wait_next_value_by_sigloc.
 *
 * @file qirq_wait_next_value_by_sigloc_seq.sv
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

`ifndef QIRQ_WAIT_NEXT_VALUE_BY_SIGLOC_SEQ_SV
`define QIRQ_WAIT_NEXT_VALUE_BY_SIGLOC_SEQ_SV

`include "uvm_macros.svh"

import uvm_pkg::*;


/**
 * @brief QIRQ Wait Next Value Sigloc Sequence
 * The wait next_value by sigloc  seqence  class 
 * is a sequence that waits for a single value on
 * a signal which is specified by its name.
 *
 * Usage Notes:<br>
 *
 * @class qirq_wait_next_value_by_sigloc_seq
 *
 */
class qirq_wait_next_value_by_sigloc_seq extends uvm_sequence #(qirq_item);
  `uvm_object_utils(qirq_wait_next_value_by_sigloc_seq)  // Register with Factory

  rand int m_sig_loc;               ///< postion of sig(alias) on pin map file
  string   m_signal_name;           ///< name of signal (alias)
  rand int m_num_matches;           ///< no of times match should be obtained
  rand int m_expected_value;        ///< expected value of the signal       
   
  /**
   * @brief Constructor
   * Method to construct this class item
   * required syntax for UVM automation and utilities
   *
   * @param name string - name of class object
   */
  function new(string name = "qirq_wait_next_value_by_sigloc_seq");
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

endclass // qirq_wait_next_value_by_sigloc_seq

//-----------------------------------------------------------------------------
// constraint valid_constraint
//-----------------------------------------------------------------------------
constraint qirq_wait_next_value_by_sigloc_seq::valid_constraint {
	m_sig_loc >= 0;
	// There is no easy way to get the max number of signals monitored
	// by hardware.
	m_num_matches >=0;
}

//-----------------------------------------------------------------------------
// body
//-----------------------------------------------------------------------------
task qirq_wait_next_value_by_sigloc_seq::body();

  int sig_loc;
  int num_matches;
  int num_expected_responses;
  int expected_value;
   
  REQ req_sequence_item_h;
  RSP rsp_sequence_item_h;
   
  req_sequence_item_h = qirq_item::type_id::create("req_sequence_item_h");

  //Since it is by sigloc we set sig_loc to zero
  // Since we are looking for the next value we set
  // the num_matches to be 1. 
  sig_loc     = m_sig_loc;
  num_matches = 1;
  expected_value = m_expected_value;
  

  start_item(req_sequence_item_h);
  
  if(!req_sequence_item_h.randomize() with {
    m_trans_type   == QIRQ_TYPE_WAIT_FOR_VALUE;
    m_sig_loc      == /*local::m_*/sig_loc;
    m_num_matches  == /*local::m_*/num_matches;
    m_expected_value == /*local::m_*/expected_value;
  }) begin
    `uvm_info(get_full_name(), 
      $psprintf("QIRQ wait edge seq trans: %s sig_loc: %d", req_sequence_item_h.m_trans_type.name(),
        sig_loc), UVM_HIGH);

    `uvm_fatal(get_full_name(), "randomize failed");
  end // if (!req_sequence_item_h.randomize() with {...

  // By default m_signal_name is empty.  We will add an empty string
  // to the sequence_item sig name.

  req_sequence_item_h.m_match_time = $time;
  req_sequence_item_h.m_sig_name = m_signal_name;

  `uvm_info(get_full_name(), $psprintf("QIRQ_WAIT_NEXT_VALUE_BY_SIGLOC_SEQ_SENT: %s sig_loc: %d",
    req_sequence_item_h.m_trans_type.name(), req_sequence_item_h.m_sig_loc), UVM_HIGH);
   
  finish_item(req_sequence_item_h);
  num_expected_responses = num_matches;

  while(num_expected_responses > 0) begin
    get_response(rsp_sequence_item_h);
    `uvm_info(get_full_name(), 
      $psprintf("QIRQ_WAIT_NEXT_VALUE_BY_SIGLOC_RESP_RCVD: %s sig_loc: %d, detected Value: %x Rsp Count : %d, Time:%t" ,
        rsp_sequence_item_h.m_trans_type.name(),
        rsp_sequence_item_h.m_sig_loc, 
        rsp_sequence_item_h.m_detected_value,
        rsp_sequence_item_h.m_num_matches,                                    
        rsp_sequence_item_h.m_match_time), UVM_HIGH)

    if (num_matches > 0) begin
      num_expected_responses = num_expected_responses - 1;
    end
  end // while (num_expected_responses > 0)
      
endtask : body

`endif
