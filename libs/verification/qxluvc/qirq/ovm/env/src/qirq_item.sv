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
 * @brief qirq_item
 *
 * The  QIRQ  item class file (qirq_item.sv) contains the QIRQ item class 
 *implementation.
 *
 * @file qirq_item.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.2 $
 * $Date: Tue Mar  8 12:54:50 2011 $
 * $Author: mironm $
 */

`ifndef QIRQ_ITEM__SV
`define QIRQ_ITEM__SV

`include "ovm_macros.svh"

import ovm_pkg::*;

/**
 *
 * The qirq transaction type is defined in QIRQ_TYPE_e.
 * There are 3 different types of qirq transactions
 * <ul>
 * <li>  QIRQ_TYPE_WAIT_FOR_TRANSITION : Waiting for any transition on a signal
 * <li>  QIRQ_TYPE_WAIT_FOR_VALUE      : Waiting for a given value
 * <li>  QIRQ_TYPE_DISABLE_MON_ALL     : Disable monitoring of all signals
 * </ul>
 * 
 **/



typedef  enum bit[1:0] {  
  QIRQ_TYPE_WAIT_FOR_TRANSITION  = 2'b00,  ///< Waiting for any transition
  QIRQ_TYPE_WAIT_FOR_VALUE       = 2'b01,  ///< Waiting for a given value
  QIRQ_TYPE_DISABLE_MON_ALL      = 2'b11   ///< Disable monitoring 
}  QIRQ_TYPE_e;                            ///< Transaction type  
      

 
/**
 * @brief QIRQ Item Class.
 *
 * The QIRQ item Class (qirq) is a transaction class that
 * implements IRQ behavior.  Two different IRQ behviors
 * are implemented
 * <ul> 
 * <li> waiting for a signal to attain a certain value </li>
 * <li> waiting for a signal to transition from one state to another </li>
 * </ul>
 * <br>
 *
 *
 * @class qirq_item
 *
 */

class qirq_item extends ovm_sequence_item;
  `ovm_object_utils(qirq_item)                              ///< register qirq_item with the factory

  rand QIRQ_TYPE_e                     m_trans_type;       ///< transaction type
  rand int                             m_sig_loc;          ///< signal loc in the probegroup file
  rand int                             m_num_matches;      ///< number of matches (only for edge mode)
  rand bit [MAX_EDGE_VALUE_WIDTH-1:0]  m_expected_value;   ///< expected value for the signal
  time                                 m_match_time;       ///< $time at which condition was met
  string                               m_sig_name;         ///< name of the alias
  bit [MAX_EDGE_VALUE_WIDTH-1:0]       m_detected_value;   ///< expected value for the signal   

   /**
    *
    * @brief Valid signal select
    * Select signal that is within the list monitored by XlEdgeDetector hardware
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
  function new (string name = "qirq_item");
    super.new(name);
         //Set this to initial time when the transaction was created
    m_match_time = $time();
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

endclass: qirq_item

//-----------------------------------------------------------------------------
// constraint signal_valid
//-----------------------------------------------------------------------------
constraint qirq_item::signal_valid {
  m_sig_loc >= 0;
  // There is no easy way to get the max number of signals monitored
  // by hardware.
  m_num_matches >=0;
}

//-----------------------------------------------------------------------------
// do_print
//-----------------------------------------------------------------------------
function void qirq_item::do_print(ovm_printer printer);
  string      time_string;
  time_string = $psprintf("%t",  m_match_time);

  printer.print_string( "Trans type    ", $psprintf( "%s", m_trans_type.name() ));
  printer.print_string( "Signal Name   ", m_sig_name);
  printer.print_field ( "Signal Loc    ", m_sig_loc,         $bits( m_sig_loc         ));
  printer.print_field ( "Num matches   ", m_num_matches,     $bits( m_num_matches     ));   
  printer.print_time ( "Match Time    ", m_match_time,       $bits( m_match_time      ));
  printer.print_field ( "Detected Value  ", m_detected_value,   $bits( m_detected_value ));      
  printer.print_field ( "Expected Val  ", m_expected_value,  $bits( m_expected_value  ));     

endfunction: do_print

//-----------------------------------------------------------------------------
// do_copy
//-----------------------------------------------------------------------------
function void qirq_item::do_copy(ovm_object rhs);
  qirq_item rhs_;
  super.do_copy(rhs);
  assert( $cast(rhs_, rhs) ) else begin
    `ovm_fatal( get_type_name(), "Cast failed" );
  end

  // Copy over all the fields from the rhs object to "this" object
   
  m_match_time     = rhs_.m_match_time;
  m_sig_name       = rhs_.m_sig_name;
  m_sig_loc        = rhs_.m_sig_loc;
  m_expected_value = rhs_.m_expected_value;
  m_num_matches    = rhs_.m_num_matches;
  m_trans_type     = rhs_.m_trans_type;
  m_detected_value = rhs_.m_detected_value;
   
  
   
   
endfunction: do_copy


//-----------------------------------------------------------------------------
// do_compare
//-----------------------------------------------------------------------------
function bit qirq_item::do_compare(ovm_object rhs, ovm_comparer comparer);
  bit status = 1;
  qirq_item rhs_;
  assert( $cast(rhs_, rhs) ) else begin
    `ovm_fatal( get_type_name(), "Cast failed" );
  end

   // Compare each field  of  the rhs object to "this" object
   // and update the status after each field compare. 

  status  &=  comparer.compare_field("m_match_time", m_match_time, rhs_.m_match_time,
    $bits( m_match_time ), OVM_DEC );
  status &=  comparer.compare_string("m_sig_name  ",  m_sig_name  , rhs_.m_sig_name );

  status  &=  comparer.compare_field("m_sig_loc   ", m_sig_loc   , rhs_.m_sig_loc   ,
    $bits( m_sig_loc    ), OVM_DEC );
  status  &=  comparer.compare_field("m_expected_value ", m_expected_value , rhs_.m_expected_value ,
    $bits( m_expected_value  ), OVM_DEC );
  status  &=  comparer.compare_field("m_num_matches ", m_num_matches , rhs_.m_num_matches,
    $bits( m_num_matches  ), OVM_DEC );
  status  &=  comparer.compare_field("m_detected_value ", m_detected_value , rhs_.m_detected_value,
    $bits( m_detected_value  ), OVM_DEC );
  status  &=  comparer.compare_field("m_trans_type ", m_trans_type , rhs_.m_trans_type,
    $bits( m_trans_type  ), OVM_DEC );
   
  return(status);
endfunction: do_compare

`endif

