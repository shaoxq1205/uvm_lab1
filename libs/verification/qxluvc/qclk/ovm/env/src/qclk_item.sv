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
 * $Revision: 1.3 $
 * $Date: Wed Sep 21 17:54:02 2011 $
 * $Author: mironm $
 */

`ifndef QCLK_ITEM__SV
`define QCLK_ITEM__SV

`include "ovm_macros.svh"

import ovm_pkg::*;

/**
 *
 * The qclk transaction type is defined in QCLK_TYPE_e.
 * There are 4 different types of qclk transactions
 * <ul>
 * <li> QCLK_TYPE_GATE_CLK_HI : gates clock hi </li>
 * <li> QCLK_TYPE_GATE_CLK_LO : gates clock lo </li> 
 * <li> QCLK_TYPE_GATE_CLK_Z : gates clock z </li>
 * <li> QCLK_TYPE_DISABLE_GATING: disables clock gating </li>
 * <li> QCLK_TYPE_ADJUST_CLK_PERIOD: adjust clock period  </li>
 * <li> QCLK_TYPE_AVANCE_CLK  : advances n clock cycles </li> 
 * <li> QCLK_TYPE_DYNAMIC_RESET: issues dynamic reset </li>
 * </ul>
 * 
 **/



typedef  enum bit[2:0] { 
  QCLK_TYPE_ADJUST_CLK_PERIOD   = 3'b000,     ///< Set Clock Period
  QCLK_TYPE_GATE_CLK_HI         = 3'b001,     ///< Gate clock Hi for N cycles
  QCLK_TYPE_GATE_CLK_LO         = 3'b010,     ///< Gate clock Lo for N cycles
  QCLK_TYPE_ADVANCE_CLK         = 3'b011,     ///< Advance_clock for N cycles
  QCLK_TYPE_GATE_CLK_Z          = 3'b100,     ///< Gate clock Z for N cycles
  QCLK_TYPE_DISABLE_GATING      = 3'b101,     ///< Disable clock gating
  QCLK_TYPE_DYNAMIC_RESET       = 3'b110      ///< Dynamic Reset
}  QCLK_TYPE_e;                  ///< Transaction type

      
 
/**
 * @brief QCLK Item Class.
 *
 * The QCLK item Class (qclk) is a transaction class that
 * implements different clock behaviors. It has features:
 *  * 
 * <ul>
 * <li> Gates clock hi </li>
 * <li> Gates clock lo </li> 
 * <li> Gates clock z </li>
 * <li> Disables clock gating </li>
 * <li> Adjust clock period  </li>
 * <li> Advances clock for n clock cycles </li> 
 *  </ul>
 * <br>
 *
 *
 * @class qclk_item
 *
 */

class qclk_item extends ovm_sequence_item;
  `ovm_object_utils(qclk_item)          ///< register qclk_item with the factory

  rand QCLK_TYPE_e m_trans_type;       ///< transaction type;
  rand longint unsigned m_num_clocks;            ///< number of clocks for the setting to be active
  rand int    m_high_duration;         ///< high clock duration
  rand int    m_low_duration;          ///< low clock duration

   /**
   * @brief Valid Constraint
   * duration must be a positive value
   * do not disable this constraint
   */
  constraint duration_valid;

  /**
   * @brief Constructor
   * Method to construct this class item
   * required syntax for OVM automation and utilities
   *
   * @param name string - name of class object
   */
  function new (string name = "qclk_item");
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

endclass: qclk_item

//-----------------------------------------------------------------------------
// constraint duration_valid
//-----------------------------------------------------------------------------
constraint qclk_item::duration_valid {
  m_high_duration > 0;
  m_low_duration > 0;
  m_num_clocks  >=  0;   
}

//-----------------------------------------------------------------------------
// do_print
//-----------------------------------------------------------------------------
function void qclk_item::do_print(ovm_printer printer);
  printer.print_string("Trans type    ", $psprintf( "%s", m_trans_type.name() ),  
    $bits( m_trans_type        ));
  printer.print_field("High duration  ", m_high_duration,          $bits( m_high_duration     ));
  printer.print_field("Low  duration  ", m_low_duration,           $bits( m_low_duration      ));   
  printer.print_field("Num Clk cycles ", m_num_clocks,             $bits( m_num_clocks        ));

endfunction: do_print

//-----------------------------------------------------------------------------
// do_copy
//-----------------------------------------------------------------------------
function void qclk_item::do_copy(ovm_object rhs);
  qclk_item rhs_;
  super.do_copy(rhs);
  assert( $cast(rhs_, rhs) ) else begin
    `ovm_fatal( get_type_name(), "Cast failed" );
  end

  // Copy over all the fields from the rhs object to "this" object 
   
  m_high_duration     = rhs_.m_high_duration;
  m_low_duration      = rhs_.m_low_duration;
  m_num_clocks        = rhs_.m_num_clocks;
  m_trans_type        = rhs_.m_trans_type;
  
endfunction: do_copy


//-----------------------------------------------------------------------------
// do_compare
//-----------------------------------------------------------------------------
function bit qclk_item::do_compare(ovm_object rhs, ovm_comparer comparer);
  bit status = 1;
  qclk_item rhs_;
  assert( $cast(rhs_, rhs) ) else begin
    `ovm_fatal( get_type_name(), "Cast failed" );
  end

   // Compare each field  of  the rhs object to "this" object
   // and update the status after each field compare. 
   //   
  status &= comparer.compare_field( "m_high_duration", m_high_duration, rhs_.m_high_duration, 
    $bits( m_high_duration ), OVM_DEC );
  status &= comparer.compare_field( "m_low_duration", m_low_duration, rhs_.m_low_duration, 
    $bits( m_low_duration  ), OVM_DEC );
  status &= comparer.compare_field( "m_trans_type", m_trans_type, rhs_.m_trans_type,
    $bits( m_trans_type    ), OVM_DEC );      
  status &= comparer.compare_field( "m_num_clocks", m_num_clocks, rhs_.m_num_clocks,
    $bits( m_num_clocks    ), OVM_DEC );      
  return(status);
endfunction: do_compare

`endif

