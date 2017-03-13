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
 * @brief qgpio_item
 *
 * The  QGPIO  item class file (qgpio_item.sv) contains the QGPIO item class 
 * implementation.
 *
 * @file qgpio_item.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.2 $
 * $Date: Tue Mar  8 12:54:52 2011 $
 * $Author: mironm $
 */

`ifndef QGPIO_ITEM__SV
`define QGPIO_ITEM__SV

`include "ovm_macros.svh"

import ovm_pkg::*;


/**
 *
 * The qgpio transaction type is defined in QGPIO_TYPE_e.
 * There are 2 different types of qgpio transactions
 * <ul>
 * <li>  QGPIO_TYPE_READ_VALUE   : Reading value from gpio signal
 * <li>  QGPIO_TYPE_WRITE_VALUE  : Writing value to gpio signal
 * 
 * </ul>
 * 
 **/

typedef  enum bit[1:0] {  
  QGPIO_TYPE_READ_VALUE      = 2'b00,  ///< Reading value from gpio signal
  QGPIO_TYPE_WRITE_VALUE     = 2'b01   ///< Writing value to gpio signal
}  QGPIO_TYPE_e;             ///< Transaction type  
      
/**
 * @brief QGPIO Item Class.
 *
 * The QGPIO item Class (qgpio) is a transaction class that
 * implements read and write transaction to any signal in the
 * DUT. There are two types of transactions
 * <ul>
 *  <li> Getting the value from any gpio signal <li>
 *  <li> Setting the value of any gpio signal  </li>
 * </ul>
 * <br>
 *
 *
 * @class qgpio_item
 *
 */

class qgpio_item extends ovm_sequence_item;
  `ovm_object_utils(qgpio_item)                         ///< register qgpio_item with the factory

  rand QGPIO_TYPE_e                   m_trans_type;     ///< transaction type
  rand int                            m_sig_loc;        ///< signal loc in the probegroup file[starting from 0]
  rand bit [MAX_SET_VALUE_WIDTH-1:0]  m_write_value;    ///< expected value for the signal
  time        m_time;                                   ///< $time at which transaction completed
  string      m_sig_name;                               ///< name of the alias
  bit [MAX_GET_VALUE_WIDTH-1:0] m_read_value;           ///< value that has been read from transactor

  /**
   * @brief Valid signal select
   * Select signal that is within the list monitored 
   * by XlGpioTransactor hardware
   * 
   **/
    
  constraint signal_valid;
     

  /**
   * @brief Constructor
   * Method to construct this class item
   * required syntax for OVM automation and utilities
   *
   * @param name string - name of class object
   */
  function new (string name = "qgpio_item");
    super.new(name);
    m_time = $time();
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

endclass: qgpio_item

//-----------------------------------------------------------------------------
// constraint signal_valid
//-----------------------------------------------------------------------------
constraint qgpio_item::signal_valid {
  m_sig_loc >= 0;
}


//-----------------------------------------------------------------------------
// do_print
//-----------------------------------------------------------------------------
function void qgpio_item::do_print(ovm_printer printer);
  string                        time_string;
  time_string = $psprintf("%t",  m_time);

  printer.print_string( "Trans type    ", $psprintf( "%s", m_trans_type.name() ));
  printer.print_string( "Signal Name   ", m_sig_name);

  printer.print_field ( "Signal Loc    ", m_sig_loc,         $bits( m_sig_loc         ));   
  printer.print_time  ( "Time          ", m_time,            $bits( m_time           ));
  printer.print_field ( "Write Val     ", m_write_value,     $bits( m_write_value     ));     
  printer.print_field ( "Read  Val     ", m_read_value,      $bits( m_read_value      ));
endfunction: do_print

//-----------------------------------------------------------------------------
// do_copy
//-----------------------------------------------------------------------------
function void qgpio_item::do_copy(ovm_object rhs);
  qgpio_item rhs_;
  super.do_copy(rhs);
  assert( $cast(rhs_, rhs) ) else begin
    `ovm_fatal( get_type_name(), "Cast failed" );
  end

  // Copy over all the fields from the rhs object to "this" object    
  m_trans_type     = rhs_.m_trans_type;
  m_time           = rhs_.m_time;
  m_sig_name       = rhs_.m_sig_name;
  m_sig_loc        = rhs_.m_sig_loc;
  m_write_value    = rhs_.m_write_value;
  m_read_value     = rhs_.m_read_value;

   
endfunction: do_copy


//-----------------------------------------------------------------------------
// do_compare
//-----------------------------------------------------------------------------
function bit qgpio_item::do_compare(ovm_object rhs, ovm_comparer comparer);
  bit status = 1;
  qgpio_item rhs_;
  assert( $cast(rhs_, rhs) ) else begin
    `ovm_fatal( get_type_name(), "Cast failed" );
  end 

  // Compare each field  of  the rhs object to "this" object
  // and update the status after each field compare. 

   
  status &=  comparer.compare_field("m_trans_type", m_trans_type, rhs_.m_trans_type  ,
    $bits( m_trans_type ), OVM_DEC);
  status &=  comparer.compare_field("m_time      ", m_time,       rhs_.m_time        ,
    $bits( m_time ), OVM_DEC);
  status &= comparer.compare_string("m_sig_name", m_sig_name, rhs_.m_sig_name);	
  status &=  comparer.compare_field("m_sig_loc", m_sig_loc, rhs_.m_sig_loc,
    $bits( m_sig_loc ), OVM_DEC);
  status &=  comparer.compare_field("m_write_value", m_write_value, rhs_.m_write_value,
    $bits( m_write_value ), OVM_DEC);
  status &=  comparer.compare_field("m_read_value", m_read_value, rhs_.m_read_value,
    $bits( m_read_value ), OVM_DEC);
   
  return(status);
endfunction: do_compare

`endif

