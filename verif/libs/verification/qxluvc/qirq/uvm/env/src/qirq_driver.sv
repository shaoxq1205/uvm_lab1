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
 * @brief QIRQ Driver
 *
 * The QIRQ driver class file (qirq_driver.sv) has the qirq_driver 
 * implementation.
 *
 * @file qirq_driver.sv
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

`ifndef QIRQ_DRIVER__SV
`define QIRQ_DRIVER__SV

/**
 * @brief QIRQ Driver
 *
 * The QIRQ driver Class (qirq_item) fetches items
 * from the sequencer and drives or monitors the 
 * appropriate  HDL signals by calling
 * equivalent functions in the proxy class
 * <ul>
 *  <li> request handle (to fetch from sequencer) </li>
 *  <li> handle to the proxy class </li>
 * </ul>
 * <br>
 * Usage Notes:<br>
 *
 * @class qirq_driver
 *
 */

`include "uvm_macros.svh"
`include "qirq_item.sv"
`include "qirq_proxy.sv"


class qirq_driver  extends uvm_driver #(qirq_item);
  `uvm_component_param_utils( qirq_driver)


  // analysis port, for connecting this driver to other "static" parts of
  // the enviornment like scoreboards or coverage 
  uvm_analysis_port #(qirq_item) m_analysis_port;         ///< driver analysis port

  // sequence_item handles
  // These are used for request and response from sequences.
  // The sequencer will send a req which contains the signal name and 
  // expected value. The driver will respond with a response transaction
  // after the condition is met. 

  qirq_item    m_req_h;          ///< Request handle
  qirq_proxy   m_qirq_proxy;     ///< proxy class to XlEdgeDetector
                                 

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
  * Connect Phase - Method to connect to QIRQ interface to drive and sample 
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
  * @brief Handle  single incoming  Sequences
  * Method that handles one incoming sequence at a time.
  * This method is forked off for each incoming transaction
  * making several of these run in parallel threads. 
  */
  extern task  handle_one_sequence(qirq_item req_h);   

  /*
   * @brief create response transaction 
   * Reports the response transaction for each req
   *
   * @param req_h qirq_item  - request transaction 
   * @param detected_value bit[MAX_EDGE_VALUE_WIDTH-1:0] 
   *              - value detected after signal has  changed
   * $param rsp_nt int - response count increments for each response
   *                     to a given transaction
   * 
   */
  extern task create_rsp_transaction(qirq_item req_h, 
    bit[MAX_EDGE_VALUE_WIDTH-1:0] detected_value, 
    int rsp_cnt);

   
endclass: qirq_driver

//-----------------------------------------------------------------------------
// build
//-----------------------------------------------------------------------------
function void qirq_driver::build();
  super.build();
  /// Only constructing the analysis port
  /// Assuming that the seq_item_port is already constructed
  /// as part of the super.build()
  m_analysis_port = new ( "m_analysis_port", this );
endfunction:      build


//-----------------------------------------------------------------------------
// connect
//-----------------------------------------------------------------------------
function void qirq_driver::connect();
  uvm_object tmp;
  
  /// In the connect phase we will get an handle to the proxy class
  /// from the global config space. The env class has actually built
  /// the proxy class and has updated the global config space.

   
  /// The object is stored in a parameterized vif_container object
  typedef quvm_vif_container #( qirq_proxy ) qirq_proxy_vif_container_t;
  qirq_proxy_vif_container_t  qirq_proxy_vif_container_h;

  ///FIXME:  What happens when there are two separate XlEdgeDetector in simulation

  `uvm_info( get_type_name(), "Getting handle to  proxy class", UVM_HIGH );
  if( !get_config_object("m_qirq_proxy_vif_container", tmp) ) begin
    `uvm_fatal( get_type_name(), "Can't get the qirq_proxy_vif_container" );
  end
   
  if( !$cast(qirq_proxy_vif_container_h, tmp) ) begin
    `uvm_fatal( get_type_name(), "Cast failed for qirq_proxy_vif_container" );
  end
   
  if ( qirq_proxy_vif_container_h == null ) begin
    `uvm_fatal( get_type_name(), "DUT virtual interface is null!");
  end

   //Extract the actual proxy class from the container
  m_qirq_proxy = qirq_proxy_vif_container_h.m_vif_h;
  if( m_qirq_proxy == null ) begin
    `uvm_fatal ( get_type_name(), "Error extracting proxy" );
  end
  
endfunction: connect

//-----------------------------------------------------------------------------
// run
//-----------------------------------------------------------------------------
task qirq_driver::run();
  `uvm_info(get_type_name(),  "QIRQ driver starting", UVM_HIGH);

  forever begin
    // Get a new transaction from the sequencer
    seq_item_port.get_next_item( m_req_h );
    `uvm_info(get_type_name(),   $psprintf("Received IRQ Transaction \n%s",
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
task qirq_driver::handle_one_sequence(qirq_item req_h);
  
  bit[MAX_EDGE_VALUE_WIDTH-1:0] detected_value;

   
  int            count_remaining;        /// indicates the number of times
                                         /// remaing to be monitored
  int            rsp_count = 0;          /// response count

  // if the request has m_num_matches set to zero we will
  // treat this as something that needs to be monitored for
  // ever. Otherwise we will treat it as a request to monitor
  // n ocurrences of the event.

  if(req_h.m_num_matches == 0) begin
    count_remaining = 1;
  end
  else begin
    count_remaining = req_h.m_num_matches;
  end
   
  do begin
    rsp_count = rsp_count + 1;    // Increment the rsp count for each rsp transaction
    // Handle each type of transaction by calling appropriate proxy method(s).
    case (req_h.m_trans_type)

      // Waiting for any transition on the signal specificed in the transaction
      QIRQ_TYPE_WAIT_FOR_TRANSITION: begin
        m_qirq_proxy.wait_for_edge( req_h.m_sig_name, req_h.m_sig_loc, detected_value);


        //For the response transaction, we will set num_matches to current count
        create_rsp_transaction(req_h, detected_value, rsp_count);
        if(req_h.m_num_matches != 0) begin
          count_remaining = count_remaining - 1 ;
        end
      end

      // Waiting for the signal specified in the transaction to reach a a given value
      QIRQ_TYPE_WAIT_FOR_VALUE: begin
        m_qirq_proxy.wait_for_value( req_h.m_sig_name, req_h.m_sig_loc, req_h.m_expected_value);
        create_rsp_transaction(req_h, req_h.m_expected_value, rsp_count);
        count_remaining   = 0;      /// We will not honor this for wait for value transaction
      end

      QIRQ_TYPE_DISABLE_MON_ALL: begin
        /// Not yet implemented.. useful only for multiple oustanding tranascations. 
      end

      default ;
      
    endcase // case (m_req_h.m_trans_type)
  end // UNMATCHED !!
   
  while(count_remaining > 0);
   

endtask // qirq_driver

   

//-----------------------------------------------------------------------------
// create_rsp_transaction
//-----------------------------------------------------------------------------
task qirq_driver::create_rsp_transaction(qirq_item req_h, bit[MAX_EDGE_VALUE_WIDTH-1:0] detected_value, int rsp_cnt);

  qirq_item rsp_h;
   
      // Construct a response item to store drivered item
  rsp_h = qirq_item::type_id::create("rsp_h");

      // Copy relevant values from req transaction
  rsp_h.set_id_info(req_h);
  rsp_h.m_trans_type = req_h.m_trans_type;
  rsp_h.m_sig_loc = req_h.m_sig_loc;   

  // Add additional information to rsp transaction
  // For a WAIT_FOR_TRANSITION transaction, the detected_value is the
  // value of the signal after the transition was observed
  // For a WAIT_FOR_VALUE transaction the detected_value is really
  // the value that we were waiting for. 
  rsp_h.m_detected_value = detected_value;
  rsp_h.m_match_time = $time();
  rsp_h.m_num_matches = rsp_cnt;

  `uvm_info(get_type_name(),   $psprintf("Creating Response transaction \n%s",
					 rsp_h.sprint()), UVM_LOW );
  
  
  //Write the rsp item to the analyais port and also to the sequencer
  seq_item_port.put( rsp_h );
  m_analysis_port.write( rsp_h);
endtask // qirq_driver::create_rsp_transaction


`endif


