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
 * @brief QRST Basic Sequence
 *
 * The QRST item class file (qrst_act_low_async.sv) contains a class
 * that executes a specific reset sequence.
 *
 * @file qrst_act_low_async.sv
 *
 * @author Sean O'Boyle
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.5 $
 * $Date: Thu Mar 25 10:15:27 2010 $
 * $Author: c_jcravy $
 */
`ifndef QRST_BASIC_SEQ__SV
`define QRST_BASIC_SEQ__SV

`include "ovm_macros.svh"

import ovm_pkg::*;
`include "qrst_item.sv"

/**
 * @brief Basic Reset Sequence Class.
 *
 * The Active low async sequence Class is a sequence
 * that generates 2 resets.
 *
 * @class qrst_basic_seq
 *
 */
class qrst_basic_seq extends ovm_sequence #(qrst_item);
  `ovm_object_utils(qrst_basic_seq) // Register this sequence with the factory

  /**
   * @brief Constructor
   * Method to construct this class item
   * required syntax for OVM automation and utilities
   *
   * @param name string - name of class object
   */
  function new(string name = "qrst_basic_seq");
    super.new(name);
  endfunction : new

  /**
   * @brief Body
   * Sequence Body - executes two active low resets.
   */
  extern task body();

endclass : qrst_basic_seq

//-----------------------------------------------------------------------------
// body
//-----------------------------------------------------------------------------
task qrst_basic_seq::body();

  qrst_item req_qrst_item_h;
  qrst_item rsp_qrst_item_h;

  qrst_typical_seq  qrst_typical_seq_h;

  // Drive first reset (ACTIVE_LOW)
  `ovm_info(get_full_name(), "Apply Reset", OVM_MEDIUM);
  qrst_typical_seq_h = qrst_typical_seq::type_id::create("qrst_typical_seq_h",,get_full_name() );
  assert(qrst_typical_seq_h.randomize() with {
    m_polarity == POLARITY_ACTIVE_LOW;
    m_start_rst_sync == MODE_ASYNC_TO_CLK;
  }) else begin
    `ovm_fatal(get_full_name(), "Failed In-Line Randomization");
  end
  qrst_typical_seq_h.start( m_sequencer, this );

  // Drive second reset (ACTIVE_LOW)
  `ovm_info(get_full_name(), "Apply Reset", OVM_MEDIUM);
  qrst_typical_seq_h = qrst_typical_seq::type_id::create("qrst_typical_seq_h",,get_full_name() );
  assert(qrst_typical_seq_h.randomize() with {
    m_polarity       == POLARITY_ACTIVE_LOW;
    m_start_rst_sync == MODE_SYNC_TO_CLK;
    m_end_rst_sync   == MODE_SYNC_TO_CLK;
  }) else begin
    `ovm_fatal(get_full_name(), "Failed In-Line Randomization");
  end
  qrst_typical_seq_h.start( m_sequencer, this );

endtask : body

`endif
