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
 * @brief QRST Active Low Async Seq
 *
 * The QRST seq class file (qrst_act_low_async_seq.sv) contains
 * sequence class implementation.
 *
 * @file qrst_act_low_async_seq.sv
 *
 * @author Sean O'Boyle
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.5 $
 * $Date: Mon May  3 10:33:30 2010 $
 * $Author: c_jcravy $
 */

`ifndef QRST_ACT_LOW_ASYNC_SEQ__SV
`define QRST_ACT_LOW_ASYNC_SEQ__SV

`include "ovm_macros.svh"

import ovm_pkg::*;

/**
 * @brief Active Low Async Reset Sequence Class.
 *
 * The Active low async sequence Class is a sequence
 * that uses the qrst_act_low_async_item class
 *
 * @class qrst_act_low_async_seq
 *
 */
class qrst_act_low_async_seq extends ovm_sequence #(qrst_item);
  `ovm_object_utils(qrst_act_low_async_seq) // Register this sequence with the factory

  /**
   * @brief Constructor
   * Method to construct this class item
   * required syntax for OVM automation and utilities
   *
   * @param name string - name of class object
   */
  function new(string name = "qrst_act_low_async_seq");
    super.new(name);
  endfunction : new

  /**
  * @brief Body
  * Body of Sequence - Method that executes 1 sequence item.
  */
  extern task body();

endclass : qrst_act_low_async_seq

//-----------------------------------------------------------------------------
// body
//-----------------------------------------------------------------------------
task qrst_act_low_async_seq::body();

  qrst_typical_seq  rst_nominal_seq_h;

  `ovm_info(get_full_name(), "Apply Reset", OVM_MEDIUM);
  rst_nominal_seq_h       = qrst_typical_seq::type_id::create("rst_nominal_seq_h" );
  assert(rst_nominal_seq_h.randomize() with {
    m_polarity == POLARITY_ACTIVE_LOW;
    m_start_rst_sync == MODE_ASYNC_TO_CLK;
    m_end_rst_sync   == MODE_ASYNC_TO_CLK;
  }) else begin
    ovm_report_fatal("qrst_act_low_async_seq", "Failed In-Line Randomization");
  end
  rst_nominal_seq_h.start( m_sequencer, this );

endtask : body


`endif
