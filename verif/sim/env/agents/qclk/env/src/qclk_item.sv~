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
 * @brief qclk_item
 *
 * The  QCLK  item class file (qclk_item.sv) contains 
 * the QCLK item class 
 * implementation.
 *
 * @file qclk_item.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.1 $
 * $Date: Mon Nov 15 11:27:29 2010 $
 * $Author: mironm $
 */

`ifndef QCLK_ITEM__SV
`define QCLK_ITEM__SV

`include "uvm_macros.svh"

import uvm_pkg::*;

/**
 *
 * The qclk transaction type is defined in QCLK_TYPE_e.
 * There are 4 different types of qclk transactions
 * <ul>
 * <li> QCLK_TYPE__HI_LOW :            flips the high and low duration values </li>
 * <li> QCLK_TYPE_HALF_FREQUENCY:      flips the high and low duration values </li>
 * <li> QCLK_TYPE_ADJUST_CLK_PERIOD: adjust clock period  </li>
 * <li> QCLK_TYPE_AVANCE_CLK  : advances n clock cycles </li> 
 * </ul>
 * 
 **/



typedef  enum bit[1:0] { 
  QCLK_TYPE_ADJUST_CLK_PERIOD   = 2'b00,     ///< Set Clock Period
  QCLK_TYPE_ADVANCE_CLK         = 2'b11      ///< Advance_clock for N cycles

}  QCLK_TYPE_e;               

      
 
/**
 * @brief QCLK Item Class.
 *
 * The QCLK item Class (qclk) is a transaction class that
 * implements different clock behaviors. It has features:
 *  * 
 * <ul>
 * <li> Adjust clock period  </li>
 * <li> Advances clock for n clock cycles </li> 
 *  </ul>
 * <br>
 *
 *
 * @class qclk_item
 *
 */

class qclk_item extends uvm_sequence_item;

//  rand QCLK_TYPE_e m_trans_type;       ///< transaction type;
//  rand int    m_num_clocks;          ///< low clock duration

//Fixme(A) - lab1 - begin

// Instructions
//  The qclk_item class contains two member variables both of type int
//  Add the following  member variables to this transaction
//   1.  int m_high_duration     which stores the high duration of the clock
//   2.  int m_low_duration      which stores the low duration of the clock

//  rand int m_high_duration;
//  rand int m_low_duration;

  rand int value;

//Fixme(A) - lab1 - end


   /**
   * @brief Valid Constraint
   * duration must be a positive value
   * do not disable this constraint
   */
//  constraint duration_valid;

   /**
   * @brief frequency constraint
   * duration must be a positive value
   * do not disable this constraint
   */
//   constraint frequency_range; 
   
//   `uvm_object_utils_begin (qclk_item) ///< register qclk_item with the factory
//     `uvm_field_enum (QCLK_TYPE_e, m_trans_type, UVM_DEFAULT)
//     `uvm_field_int  (m_num_clocks, UVM_DEFAULT)
//     `uvm_field_int (m_high_duration, UVM_DEFAULT) 
//    `uvm_field_int (m_low_duration, UVM_DEFAULT)

//   `uvm_object_utils_end

   constraint value_small;
     `uvm_object_utils_begin (qclk_item) ///< register qclk_item with the factory
     `uvm_field_int  (value, UVM_DEFAULT)
   `uvm_object_utils_end

  /**
   * @brief Constructor
   * Method to construct this class item
   * required syntax for UVM automation and utilities
   *
   * @param name string - name of class object
   */
  function new (string name = "qclk_item");
    super.new(name);
  endfunction : new

endclass: qclk_item

//-----------------------------------------------------------------------------
// constraint duration_valid
//-----------------------------------------------------------------------------
//constraint qclk_item::duration_valid {
//  m_high_duration > 0;
//  m_low_duration > 0;
//  m_num_clocks >= 0;
//}

//-----------------------------------------------------------------------------
// constraint frequency_range
//-----------------------------------------------------------------------------
//constraint qclk_item::frequency_range {
//m_high_duration + m_low_duration > 10;
//m_high_duration + m_low_duration < 100;
//}
//-----------------------------------------------------------------------------
// constraint value_small
//-----------------------------------------------------------------------------
    constraint qclk_item::value_small{
    value > 0;
    value < 10;
}



`endif

