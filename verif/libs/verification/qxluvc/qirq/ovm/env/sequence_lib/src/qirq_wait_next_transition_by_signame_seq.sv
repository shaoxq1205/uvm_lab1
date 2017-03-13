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
 * @brief QIRQ Wait Next Transition By Signame
 *
 * This file implements the virtual sequence 
 * qirq_wait_next_transition_by_signame.
 *
 * @file qirq_wait_next_transition_by_signame_seq.sv
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

`ifndef QIRQ_WAIT_NEXT_TRANSITION_BY_SIGNAME_SEQ_SV
`define QIRQ_WAIT_NEXT_TRANSITION_BY_SIGNAME_SEQ_SV

`include "ovm_macros.svh"

import ovm_pkg::*;


/**
 * @brief QIRQ Wait Next Transition Signame Sequence
 * The wait next_transition by signame  seqence  class 
 * is a sequence that waits for a single transition on
 * a signal which is specified by its name.
 *
 * Usage Notes:<br>
 *
 * @class qirq_wait_next_transition_by_signame_seq
 *
 */
class qirq_wait_next_transition_by_signame_seq extends ovm_sequence #(qirq_item);
  `ovm_object_utils(qirq_wait_next_transition_by_signame_seq)  // Register with Factory

  rand int m_sig_loc;               ///< postion of sig(alias) on pin map file
  string   m_signal_name;           ///< name of signal (alias)
  rand int m_num_matches;           ///< no of times match should be obtained
   
  /**
   * @brief Constructor
   * Method to construct this class item
   * required syntax for OVM automation and utilities
   *
   * @param name string - name of class object
   */
  function new(string name = "qirq_wait_next_transition_by_signame_seq");
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

endclass // qirq_wait_next_transition_by_signame_seq


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
task qirq_wait_next_transition_by_signame_seq::body();

  int sig_loc;
  int num_matches;
  int num_expected_responses;
   
  REQ req_sequence_item_h;
  RSP rsp_sequence_item_h;
   
  req_sequence_item_h = qirq_item::type_id::create("req_sequence_item_h");

  //Since it is by signame we set sig_loc to zero
  // Since we are looking for the next transition we set
  // the num_matches to be 1. 
  sig_loc     = 0;
  num_matches = 1;

  start_item(req_sequence_item_h);
  
  if(!req_sequence_item_h.randomize() with {
    m_trans_type   == QIRQ_TYPE_WAIT_FOR_TRANSITION;
    m_sig_loc      == /*local::m_*/sig_loc;
    m_num_matches  == /*local::m_*/num_matches;
  }) begin
    `ovm_info(get_full_name(), 
      $psprintf("QIRQ wait edge seq trans: %s sig_loc: %d", req_sequence_item_h.m_trans_type.name(),
        sig_loc), OVM_HIGH);

    `ovm_fatal(get_full_name(), "randomize failed");
  end // if (!req_sequence_item_h.randomize() with {...

  // By default m_signal_name is empty.  We will add an empty string
  // to the sequence_item sig name.
   
  req_sequence_item_h.m_sig_name = m_signal_name;

  `ovm_info(get_full_name(), $psprintf("QIRQ_WAIT_NEXT_TRANSITION_BY_SIGNAME_SEQ_SENT: %s sig_loc: %d",
        req_sequence_item_h.m_trans_type.name(), req_sequence_item_h.m_sig_loc), OVM_HIGH);
   
  finish_item(req_sequence_item_h);
  num_expected_responses = num_matches;

  while(num_expected_responses > 0) begin
    get_response(rsp_sequence_item_h);
    `ovm_info(get_full_name(), 
      $psprintf("QIRQ_WAIT_NEXT_TRANSITION_BY_SIGNAME_RESP_RCVD: %s sig_name: %s, detected Value: %x Rsp Count : %d, Time:%t" ,
        rsp_sequence_item_h.m_trans_type.name(),
        rsp_sequence_item_h.m_sig_name, 
        rsp_sequence_item_h.m_detected_value,
        rsp_sequence_item_h.m_num_matches,                                    
        rsp_sequence_item_h.m_match_time), OVM_HIGH)

    if (num_matches > 0) begin
      num_expected_responses = num_expected_responses - 1;
    end
  end // while (num_expected_responses > 0)
      
endtask : body

`endif
