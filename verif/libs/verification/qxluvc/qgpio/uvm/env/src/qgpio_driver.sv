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
 * @brief QGPIO Driver
 *
 * The QGPIO driver class file (qgpio_driver.sv) has the qgpio_driver 
 * implementation.
 *
 * @file qgpio_driver.sv
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

`ifndef QGPIO_DRIVER__SV
`define QGPIO_DRIVER__SV

/**
 * @brief QGPIO Driver
 *
 * The QGPIO driver Class (qgpio_item) fetches items
 * from the sequencer and drives the HDL signals by calling
 * appropriate functions in the proxy class
 * <ul>
 *  <li> request handle (to fetch from sequencer) </li>
 *  <li> response handle to sent data back to sequencer if required </li>
 *  <li> handle to the proxy class   </li>
 * </ul>
 * <br>
 * Usage Notes:<br>
 *
 * @class qgpio_driver
 *
 */

`include "uvm_macros.svh"
`include "qgpio_item.sv"
`include "qgpio_proxy.sv"


class qgpio_driver  extends uvm_driver #(qgpio_item);
  `uvm_component_utils( qgpio_driver )


  // analysis port, for connecting this driver to other "static" parts of
  // the enviornment like scoreboards or coverage 
  uvm_analysis_port #(qgpio_item) m_analysis_port; ///< driver analysis port

  // sequence_item handles
  // These are used for request and response from sequences.
  // The sequencer will send a req which contains the signal name and 
  // expected value. The driver will respond with a response transaction
  // after the condition is met. 

  qgpio_item    m_req_h;          ///< Request handle
  qgpio_proxy   m_qgpio_proxy;     ///< proxy class to XlGpioTransactor
                                 

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
  extern function void build();

  /**
  * @brief Connect Method
  * Connect Phase - Method to connect to QGPIO interface to drive and sample 
  * signals.
  * @return void
  */
  extern function void connect();

  /**
  * @brief Run Method
  * Run Phase - Method to start the driver
  */
  extern task run();

  /**
  * @brief Handle incoming Sequences
  * Method that handles one incoming sequence at a time
  */
  extern task  handle_one_sequence(qgpio_item req_h);

  /*
   * @brief create response transaction 
   * Reports the response transaction for each req
   *
   * @param req_h qgpio_item  - request transaction 
   * @param detected_value bit[MAX_GET_VALUE_WIDTH-1:0] 
   *              - value read from the transactor
   * 
   */
  extern task create_rsp_transaction(qgpio_item req_h, bit[MAX_GET_VALUE_WIDTH-1:0] value,  int rsp_cnt);

   
endclass: qgpio_driver

//-----------------------------------------------------------------------------
// build
//-----------------------------------------------------------------------------
function void qgpio_driver::build();
  super.build();
   /// Only constructing the analysis port
   /// Assuming that the seq_item_port is already constructed
   /// as part of the super.build()
  m_analysis_port = new ( "m_analysis_port", this );
endfunction:      build


//-----------------------------------------------------------------------------
// connect
//-----------------------------------------------------------------------------
function void qgpio_driver::connect();
  uvm_object tmp;

   /// In the connect phase we will get an handle to the proxy class
   /// from the global config space. The env class has actually built
   /// the proxy class and has updated the global config space.


   /// The object is stored in a parameterized vif_container object
  typedef quvm_vif_container #( qgpio_proxy ) qgpio_proxy_vif_container_t;
  qgpio_proxy_vif_container_t  qgpio_proxy_vif_container_h;

   ///FIXME:  What happens when there are two separate XlGPIOTransactors in simulation

  `uvm_info( get_type_name(), "Getting handle to  proxy class", UVM_HIGH );
  if( !get_config_object("m_qgpio_proxy_vif_container", tmp) ) begin
    `uvm_fatal( get_type_name(), "Can't get the qgpio_proxy_vif_container" );
  end
   
  if( !$cast(qgpio_proxy_vif_container_h, tmp) ) begin
    `uvm_fatal( get_type_name(), "Cast failed for qgpio_proxy_vif_container" );
  end
   
  if ( qgpio_proxy_vif_container_h == null ) begin
    `uvm_fatal( get_type_name(), "DUT virtual interface is null!");
  end

   //Extract the actual proxy class from the container
  m_qgpio_proxy = qgpio_proxy_vif_container_h.m_vif_h;
  if( m_qgpio_proxy == null )
    `uvm_fatal ( get_type_name(), "Error extracting proxy" );
   
endfunction: connect

//-----------------------------------------------------------------------------
// run
//-----------------------------------------------------------------------------
task qgpio_driver::run();
  bit[MAX_GET_VALUE_WIDTH-1:0] read_value;   
   
  `uvm_info(get_type_name(),  "QGPIO driver starting", UVM_HIGH);

  forever begin
    // Get a new transaction from the sequencer
    seq_item_port.get_next_item( m_req_h );
    `uvm_info(get_type_name(),   $psprintf("Received GPIO Transaction \n%s",
      m_req_h.sprint()), UVM_LOW )         

    // Update the analysis port to indicate that a transaction was received
    // Useful for logging transactions and coverage calculations
    m_analysis_port.write(m_req_h);

    // We will create a new thread to handle this request and move on
    // to the next request. 
    fork: handle_one_seq
      begin
        handle_one_sequence(m_req_h);
      end
    join_none;

    seq_item_port.item_done();

  end


endtask: run

//-----------------------------------------------------------------------------
// handle_one_sequence
//-----------------------------------------------------------------------------
task qgpio_driver::handle_one_sequence(qgpio_item req_h);
  bit[MAX_GET_VALUE_WIDTH-1:0] read_value;
  int            count_remaining;        /// indicates the number of times
                                          /// remaing to be monitored
  int            rsp_count = 0;          /// response count

   // if the request has m_num_matches set to zero we will
   // treat this as something that needs to be monitored for
   // ever. Otherwise we will treat it as a request to monitor
   // n ocurrences of the event.

  count_remaining = 1; // We expect one response per transaction
   
  do begin
    rsp_count = rsp_count + 1;    // Increment the rsp count for each rsp transaction
      // Handle each type of transaction by calling appropriate proxy method(s).
    case (req_h.m_trans_type)

      // Calling a read_value transaction
      QGPIO_TYPE_READ_VALUE: begin
        m_qgpio_proxy.read_value( req_h.m_sig_name, req_h.m_sig_loc, read_value);
        create_rsp_transaction(req_h, read_value, rsp_count);
      end

      // Calling a write_value transaction    
      QGPIO_TYPE_WRITE_VALUE: begin
        m_qgpio_proxy.write_value( req_h.m_sig_name, req_h.m_sig_loc, req_h.m_write_value);
        create_rsp_transaction(req_h,req_h.m_write_value, rsp_count);    
      end

      default ;
        
    endcase // case (m_req_h.m_trans_type)
    count_remaining = count_remaining -1 ;
    
    
  end // UNMATCHED !!
   
  while(count_remaining > 0);
endtask // handle_sequences


//-----------------------------------------------------------------------------
// create_rsp_transaction
//-----------------------------------------------------------------------------
task qgpio_driver::create_rsp_transaction(qgpio_item req_h, bit[MAX_GET_VALUE_WIDTH-1:0] value, int rsp_cnt);

  qgpio_item   rsp_h;

      // Construct a response item to store drivered item
  rsp_h = qgpio_item::type_id::create("rsp_h");

      // Copy relevant values from req transaction
  rsp_h.set_id_info(m_req_h);
  rsp_h.m_trans_type = m_req_h.m_trans_type;
  rsp_h.m_sig_loc = m_req_h.m_sig_loc;
  rsp_h.m_write_value = 0;

   // Add additional information to rsp transaction
   // For a READ_VALUE transaction, the value is the
   // value of the signal that is read by the transactor
   // For a WRITE_VALUE transaction, the value is the
   // value that was being written
  rsp_h.m_read_value = value;

  rsp_h.m_time = $time();

  //Write the rsp item to the analyais port and also to the sequencer
  seq_item_port.put( rsp_h );
  m_analysis_port.write( rsp_h);

  `uvm_info(get_type_name(),   $psprintf("Created Response  GPIO Transaction \n%s",
      rsp_h.sprint()), UVM_LOW )           
endtask // qgpio _driver::complete_rsp_transaction


`endif


