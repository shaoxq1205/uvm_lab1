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
 * @brief QRST Item
 *
 * The QRST item class file (qrst_item.sv) contains the QRST item class 
 * implementation and its supporting enums.
 *
 * @file qrst_item.sv
 *
 * @author Sean O'Boyle
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.5 $
 * $Date: Mon May  3 10:32:34 2010 $
 * $Author: c_jcravy $
 */

`ifndef QRST_ITEM__SV
`define QRST_ITEM__SV

`include "ovm_macros.svh"

import ovm_pkg::*;

  typedef enum bit { 
    POLARITY_ACTIVE_LOW  = 0, ///< Reset is active low
    POLARITY_ACTIVE_HIGH = 1  ///< Reset is active high
  } polarity_e;  ///< Reset polarity enum type

  typedef enum bit { 
    MODE_SYNC_TO_CLK = 0, ///< Reset is synchronous to clock
    MODE_ASYNC_TO_CLK = 1 ///< Reset is asynchronous to clock
  } mode_e; ///< Reset mode enum type

/**
 * @brief QRST Item Class.
 *
 * The QRST item Class (qrst_item) is a transaction class that
 * implements different reset behaviors. It has features:
 * <ul>
 *  <li> reset polarity (active high or low) </li>
 *  <li> reset duration </li>
 *  <li> pre-reset duration </li>
 *  <li> post-reset duration </li>
 *  <li> reset start is synchronous or asynchronous to clock </li>
 *  <li> reset end is synchronous or asynchronous to clock </li>
 * </ul>
 * <br>
 *
 * @note The item class is only contrained to valid durations -- and is 
 * otherwise unbounded.
 *       Be sure to either constrain to your desired reset length - or use the 
 *       qrst_typical_seq.
 *
 * @class qrst_item
 *
 */
class qrst_item extends ovm_sequence_item;
  `ovm_object_utils(qrst_item) // register qrst_item with the factory

  rand polarity_e m_qrst_polarity; ///< Reset polarity (HIGH or LOW)
  rand int m_qrst_duration; ///< Reset duration in clock cycles
  rand int m_qrst_pre_rst_duration; ///< Duration before reset is applied
  rand int m_qrst_post_rst_duration; ///< Duration after reset is completed.
  rand mode_e m_qrst_start_rst_sync; ///< Reset start is sync or async to clock.
  rand mode_e m_qrst_end_rst_sync; ///< Reset end is sync or async to clock.

  /**
   * @brief Valid Constraint
   * duration must be a positive value
   * do not disable this constraint
   */
  constraint duration_valid;

  /**
   * @brief Legal Constraint
   * duration doesn't have 'legal' constraints
   * disable if you want to do something illegal (driver may not support it...)
   */
  constraint duration_legal;

  /**
   * @brief Valid Constraint
   * duration is typically less than 100 clocks
   * disable if you want to do something atypical
   */
  constraint duration_typical;


  /**
   * @brief Constructor
   * Method to construct this class item
   * required syntax for OVM automation and utilities
   *
   * @param name string - name of class object
   */
  function new (string name = "qrst_item");
    super.new(name);
  endfunction : new

  /**
   * @brief Do Print
   * Displays item fields to screen
   *
   * @param printer ovm_printer - printer policy
   * @return void
   */
  extern function void   do_print(ovm_printer printer);

  /**
   * @brief Do Copy
   * Deep Copy item from RHS to this item
   *
   * @param printer ovm_object - source object to copy data from.
   * @return void
   */
  extern function void   do_copy(ovm_object rhs);

  /**
   * @brief Do Compare
   * Deep Compare of each of the fields in the RHS with this one.
   *
   * @param rhs ovm_object - other item handle used to compare fields
   * @param comparer ovm_comparer - compare policy
   * @return bit - returns 1 if ojects are same else returns 0
   */
  extern function bit    do_compare(ovm_object rhs, ovm_comparer comparer);

endclass: qrst_item

//-----------------------------------------------------------------------------
// constraint cnstrt_valid
//-----------------------------------------------------------------------------
constraint qrst_item::duration_valid {
  m_qrst_pre_rst_duration >= 0;
  m_qrst_post_rst_duration >= 0;
  m_qrst_duration > 0;
}

//-----------------------------------------------------------------------------
// constraint cnstrt_typical
//-----------------------------------------------------------------------------
constraint qrst_item::duration_legal {
  // nothing here!
}

//-----------------------------------------------------------------------------
// constraint cnstrt_typical
//-----------------------------------------------------------------------------
constraint qrst_item::duration_typical {
  m_qrst_pre_rst_duration < 100;
  m_qrst_post_rst_duration < 100;
  m_qrst_duration < 200;
}


//-----------------------------------------------------------------------------
// do_print
//-----------------------------------------------------------------------------
function void qrst_item::do_print(ovm_printer printer);
  printer.print_string( "m_qrst_polarity", $psprintf( "%s(%0d)", m_qrst_polarity.name(), m_qrst_polarity ), $bits(m_qrst_polarity) );
  printer.print_field( "m_qrst_pre_rst_duration", m_qrst_pre_rst_duration, $bits(m_qrst_pre_rst_duration), OVM_DEC );
  printer.print_field( "m_qrst_duration", m_qrst_duration, $bits(m_qrst_duration), OVM_DEC );
  printer.print_field( "m_qrst_post_rst_duration", m_qrst_post_rst_duration, $bits(m_qrst_post_rst_duration), OVM_DEC );
  printer.print_string( "m_qrst_start_rst_sync", $psprintf( "%s(%0d)", m_qrst_start_rst_sync.name(), m_qrst_start_rst_sync ), $bits(m_qrst_start_rst_sync) );
  printer.print_string( "m_qrst_end_rst_sync", $psprintf( "%s(%0d)", m_qrst_end_rst_sync.name(), m_qrst_end_rst_sync ), $bits(m_qrst_end_rst_sync) );
endfunction

//-----------------------------------------------------------------------------
// do_copy
//-----------------------------------------------------------------------------
function void qrst_item::do_copy(ovm_object rhs);
  qrst_item rhs_;
  super.do_copy(rhs);
  assert( $cast(rhs_, rhs) ) else begin
    `ovm_fatal( get_type_name(), "Cast failed" );
  end

  m_qrst_polarity = rhs_.m_qrst_polarity;
  m_qrst_duration = rhs_.m_qrst_duration;
  m_qrst_pre_rst_duration = rhs_.m_qrst_pre_rst_duration;
  m_qrst_post_rst_duration = rhs_.m_qrst_post_rst_duration;
  m_qrst_start_rst_sync = rhs_.m_qrst_start_rst_sync;
  m_qrst_end_rst_sync = rhs_.m_qrst_end_rst_sync;
endfunction: do_copy

//-----------------------------------------------------------------------------
// do_compare
//-----------------------------------------------------------------------------
function bit qrst_item::do_compare(ovm_object rhs, ovm_comparer comparer);
  bit status = 1;
  qrst_item rhs_;
  assert( $cast(rhs_, rhs) ) else begin
    `ovm_fatal( get_type_name(), "Cast failed" );
  end

  status &= comparer.compare_string( "m_qrst_polarity", $psprintf( "%s(%0d)", m_qrst_polarity.name(), m_qrst_polarity ), $psprintf( "%s(%0d)", rhs_.m_qrst_polarity.name(), rhs_.m_qrst_polarity ) );
  status &= comparer.compare_field( "m_qrst_pre_rst_duration", m_qrst_pre_rst_duration, rhs_.m_qrst_pre_rst_duration, $bits(m_qrst_pre_rst_duration), OVM_DEC );
  status &= comparer.compare_field( "m_qrst_duration", m_qrst_duration, rhs_.m_qrst_duration, $bits(m_qrst_duration), OVM_DEC );
  status &= comparer.compare_field( "m_qrst_post_rst_duration", m_qrst_post_rst_duration, rhs_.m_qrst_post_rst_duration, $bits(m_qrst_post_rst_duration), OVM_DEC );
  status &= comparer.compare_field( "m_qrst_start_rst_sync", m_qrst_start_rst_sync, rhs_.m_qrst_start_rst_sync, $bits(m_qrst_start_rst_sync) );
  status &= comparer.compare_string( "m_qrst_end_rst_sync", $psprintf( "%s(%0d)", m_qrst_end_rst_sync.name(), m_qrst_end_rst_sync ), $psprintf( "%s(%0d)", rhs_.m_qrst_end_rst_sync.name(), rhs_.m_qrst_end_rst_sync ) );
  return(status);
endfunction: do_compare

`endif


