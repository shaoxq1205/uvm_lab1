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
 * The QRST item class file (qrst_typical_seq.sv) contains a class
 * that executes a specific reset sequence.
 *
 * @file qrst_typical_seq.sv
 *
 * @author Sean O'Boyle
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.3 $
 * $Date: Wed Mar 24 15:05:03 2010 $
 * $Author: c_jcravy $
 */
`ifndef QRST_TYPICAL_SEQ__SV
`define QRST_TYPICAL_SEQ__SV

`include "ovm_macros.svh"

import ovm_pkg::*;

/**
 * @brief Typical Reset Sequence Class.
 *
 * Constrains the reset_item to a reasonable length reset.  (The item has a 
 * much longer reset.)
 *
 * @class qrst_typical_seq
 *
 */
class qrst_typical_seq extends ovm_sequence #(qrst_item);
  `ovm_object_utils(qrst_typical_seq) // Register this sequence with the factory

  rand polarity_e m_polarity; ///< Reset polarity (HIGH or LOW)
  rand int m_duration; ///< Reset duration in clock cycles
  rand int m_pre_rst_duration; ///< Duration before reset is applied
  rand int m_post_rst_duration; ///< Duration after reset is completed.
  rand mode_e m_start_rst_sync; ///< Reset start is sync or async to clock.
  rand mode_e m_end_rst_sync; ///< Reset end is sync or async to clock.

  constraint qrst_pre_rst_dur_typical;  ///< Constraint: Typical Pre-Reset Duration
  constraint qrst_post_rst_dur_typical; ///< Constraint: Typical Post-Reset Duration
  constraint qrst_rst_dur_typical;      ///< Constraint: Typical Reset Duration

  /**
   * @brief Constructor
   * Method to construct this class item
   * required syntax for OVM automation and utilities
   *
   * @param name string - name of class object
   */
  function new(string name = "qrst_typical_seq");
    super.new(name);
  endfunction : new

  /**
  * @brief Body
  * Sequence Body - executes two active low resets.
  */
  extern task body();

endclass : qrst_typical_seq

//-----------------------------------------------------------------------------
// constraint qrst_pre_rst_dur_typical
//-----------------------------------------------------------------------------
constraint qrst_typical_seq::qrst_pre_rst_dur_typical {
  m_pre_rst_duration < 10;
  m_pre_rst_duration >= 0;
}

//-----------------------------------------------------------------------------
// constraint qrst_post_rst_dur_typical
//-----------------------------------------------------------------------------
constraint qrst_typical_seq::qrst_post_rst_dur_typical {
  m_post_rst_duration < 10;
  m_post_rst_duration >= 0;
}

//-----------------------------------------------------------------------------
// constraint qrst_rst_dur_typical
//-----------------------------------------------------------------------------
constraint qrst_typical_seq::qrst_rst_dur_typical {
  m_duration < 20;
  m_duration > 0;
}


//-----------------------------------------------------------------------------
// body
//-----------------------------------------------------------------------------
task qrst_typical_seq::body();

  qrst_item req_qrst_item_h;
  qrst_item rsp_qrst_item_h;

  // Drive the reset
  req_qrst_item_h  = qrst_item::type_id::create("req_qrst_item_h",,get_full_name());
  start_item(req_qrst_item_h);

  assert (req_qrst_item_h.randomize() with {
    m_qrst_polarity          == /*local::*/m_polarity         ;
    m_qrst_duration          == /*local::*/m_duration         ;
    m_qrst_pre_rst_duration  == /*local::*/m_pre_rst_duration ;
    m_qrst_post_rst_duration == /*local::*/m_post_rst_duration;
    m_qrst_start_rst_sync    == /*local::*/m_start_rst_sync   ;
    m_qrst_end_rst_sync      == /*local::*/m_end_rst_sync     ;
  }) else begin
    `ovm_fatal(get_full_name(), "Failed In-Line Randomization");
  end
  finish_item(req_qrst_item_h);
  get_response(rsp_qrst_item_h);

endtask : body

`endif
