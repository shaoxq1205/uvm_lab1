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
 * @brief QCLK Driver
 *
 * The QCLK driver class file (qclk_driver.sv) has the 
 * qclk_driver implementation.
 *
 * @file qclk_driver.sv
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

`ifndef QCLK_DRIVER__SV
`define QCLK_DRIVER__SV

/**
 * @brief QCLK Driver
 *
 * The QCLK driver Class (qclk_item) fetches items
 * from the sequencer. It drives a proxy class which
 * in turn interfaces to the hardware blocks through 
 * a DPI layer. It has the following members
 * <ul>
 *  <li> request handle (to fetch from sequencer) </li>
 *  <li> response handle to sent data back to sequencer  </li>
 *  <li> handle to the proxy class </li>
 * </ul>
 * <br>
 * Usage Notes:<br>
 *
 * @class qclk_driver
 *
 */

`include "uvm_macros.svh"
`include "qclk_item.sv"
`include "qclk_proxy.sv"


class qclk_driver extends uvm_driver #(qclk_item);
  `uvm_component_utils (qclk_driver)             ///< register qclk_driver with factory

  // analysis port, for connecting this driver to other "static" parts of
  // the enviornment like scoreboards or coverage 
  uvm_analysis_port #(qclk_item) m_analysis_port;      ///< analysis port to connect to agent
  qclk_item                      m_req_h;              ///< handle to the inocoming request
  qclk_item                      m_rsp_h;              ///< handle of the outgoing request
  qclk_proxy                     m_qclk_proxy;         ///< handle to the proxy class                  
    
  /**
   * @brief Constructor
   * Method to construct this class
   * required syntax for UVM automation and utilities
   *
   * @param name string - name of class object
   * @param parent uvm_component - parent of this class
   */
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  /**
  * @brief Build
  * Build Phase - Method to call the build function of the parent.
  * @return void
  */
  extern function void build_phase (uvm_phase phase);

  /**
  * @brief Connect Method
  * Connect Phase - Method to connect to QCLK interface  
  * @return void
  */
  extern function void connect_phase(uvm_phase phase);

  /**
  * @brief Run Method
  * Run Phase - Method to start the driver
  */
  extern task run_phase (uvm_phase phase);

  /**
  * @brief Drives transaction on proxy
  * BFM Method that  executes the transaction
  * by callilng appropriate DPI functions. 
  * param m_req_h qclk_item - item to be handle 
  */
  extern virtual protected task qclk_drive_transaction(qclk_item req_h);

endclass: qclk_driver

//-----------------------------------------------------------------------------
// build
//-----------------------------------------------------------------------------
function void qclk_driver::build_phase (uvm_phase phase);
  super.build_phase(phase);
  /// Only constructing the analysis port
  /// Assuming that the seq_item_port is already constructed
  /// as part of the super.build_phase()
  m_analysis_port = new( "m_analysis_port", this );
endfunction: build_phase

//-----------------------------------------------------------------------------
// connect
//-----------------------------------------------------------------------------
function void qclk_driver::connect_phase (uvm_phase phase);

  /// During the connect phase,  an handle to the proxy class is obtained
  /// from the global config space. The env class has actually built
  /// the proxy class and has updated the global config space.

   
  /// The object is stored in uvm_config_db database

  `uvm_info(get_type_name(), "Getting handle to proxy class from config space ", UVM_HIGH );
  if(!uvm_config_db#(qclk_proxy)::get (this, "", "m_qclk_proxy", m_qclk_proxy)) begin
    `uvm_fatal( get_type_name(), "Can't get the qclk_proxy object handle." );
  end
   
  if (m_qclk_proxy == null) begin
    `uvm_fatal( get_type_name(), "Proxy class handle is null." );
  end

endfunction: connect_phase

//-----------------------------------------------------------------------------
// run
//-----------------------------------------------------------------------------
task qclk_driver::run_phase (uvm_phase phase);
  `uvm_info(get_type_name(),  "QCLK driver starting", UVM_HIGH);

  forever begin: forever_loop
    // Get a new transaction from the sequencer
    seq_item_port.get_next_item(m_req_h);
    `uvm_info(get_type_name(),   $psprintf("Received QCLK Transaction \n%s", m_req_h.sprint()), UVM_LOW )   

    // Update the analysis port to indicate that a transaction was received
    // Useful for logging transactions and coverage calculations
    m_analysis_port.write(m_req_h);
    qclk_drive_transaction(m_req_h);

    // Send a response back to the sequencer
    m_rsp_h = qclk_item::type_id::create( "m_rsp_h" );
    m_rsp_h.set_id_info( m_req_h );
    seq_item_port.put( m_rsp_h );
    `uvm_info( get_type_name( ),  "Sent QCLK response to sequencer" , UVM_LOW )
    seq_item_port.item_done();
      
      
  end: forever_loop

endtask: run_phase

//-----------------------------------------------------------------------------
// qclk_drive_transaction
//-----------------------------------------------------------------------------
task qclk_driver::qclk_drive_transaction(qclk_item req_h);

  // Handle each type of transaction by calling appropriate proxy method(s). 
  case(req_h.m_trans_type)

    // Adjusting the clock period
    QCLK_TYPE_ADJUST_CLK_PERIOD: begin

      m_qclk_proxy.set_clock_period(req_h.m_high_duration, req_h.m_low_duration);

    end
        
        
    // Advance the clock for n cycles. Can be used like
    // a wait for n clocks in testbench. 
    QCLK_TYPE_ADVANCE_CLK:  begin
      m_qclk_proxy.wait_for_n_cycles( req_h.m_num_clocks );
    end

    default ;
          
  endcase // case (req_h.m_trans_type)

endtask: qclk_drive_transaction

`endif


