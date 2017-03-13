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
 * $Revision: 1.3 $
 * $Date: Wed Sep 21 17:54:02 2011 $
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

`include "ovm_macros.svh"
`include "qclk_item.sv"
`include "qclk_proxy.sv"


class qclk_driver extends ovm_driver #(qclk_item);
  `ovm_component_utils(qclk_driver)                    ///< register qclk_driver with factory

  // analysis port, for connecting this driver to other "static" parts of
  // the enviornment like scoreboards or coverage 
  ovm_analysis_port #(qclk_item) m_analysis_port;      ///< analysis port to connect to agent
  qclk_item                      m_req_h;              ///< handle to the inocoming request
  qclk_item                      m_rsp_h;              ///< handle of the outgoing request
  qclk_proxy                     m_qclk_proxy;         ///< handle to the proxy class                  
   
  /**
   * @brief Constructor
   * Method to construct this class
   * required syntax for OVM automation and utilities
   *
   * @param name string - name of class object
   * @param parent ovm_component - parent of this class
   */
  function new(string name, ovm_component parent);
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
  * Connect Phase - Method to connect to QCLK interface  
  * @return void
  */
  extern function void connect();

  /**
  * @brief Run Method
  * Run Phase - Method to start the driver
  */
  extern task run();

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
function void qclk_driver::build();
  super.build();
  /// Only constructing the analysis port
  /// Assuming that the seq_item_port is already constructed
  /// as part of the super.build()
  m_analysis_port = new( "m_analysis_port", this );
endfunction: build

//-----------------------------------------------------------------------------
// connect
//-----------------------------------------------------------------------------
function void qclk_driver::connect();
  ovm_object tmp;

  /// During the connect phase,  an handle to the proxy class is obtained
  /// from the global config space. The env class has actually built
  /// the proxy class and has updated the global config space.

   
  /// The object is stored in a parameterized vif_container object
  typedef qovm_vif_container #(qclk_proxy) qclk_proxy_vif_container_t;
  qclk_proxy_vif_container_t  qclk_proxy_vif_container_h;

  `ovm_info(get_type_name(), "Getting handle to proxy class from config space ", OVM_HIGH );
  if(!get_config_object( "m_qclk_proxy_vif_container", tmp )) begin
    `ovm_fatal( get_type_name(), "Can't get the qclk_proxy_vif_container." );
  end
   
  if(!$cast(qclk_proxy_vif_container_h, tmp)) begin
    `ovm_fatal( get_type_name(), "Cast failed for qclk_proxy_vif_container." );
  end
   
  if (qclk_proxy_vif_container_h == null) begin
    `ovm_fatal( get_type_name(), "Proxy class handle is null." );
  end

  //Extract the actual proxy class from the container
  m_qclk_proxy = qclk_proxy_vif_container_h.m_vif_h;
  if( m_qclk_proxy == null ) begin
    `ovm_fatal ( get_type_name(), "Error extracting proxy" );
  end
  

endfunction: connect

//-----------------------------------------------------------------------------
// run
//-----------------------------------------------------------------------------
task qclk_driver::run();
  `ovm_info(get_type_name(),  "QCLK driver starting", OVM_HIGH);

  forever begin: forever_loop
    // Get a new transaction from the sequencer
    seq_item_port.get_next_item(m_req_h);
    `ovm_info(get_type_name(),   $psprintf("Received QCLK Transaction \n%s", m_req_h.sprint()), OVM_LOW )   

    // Update the analysis port to indicate that a transaction was received
    // Useful for logging transactions and coverage calculations
    m_analysis_port.write(m_req_h);
    qclk_drive_transaction(m_req_h);

    // Send a response back to the sequencer
    m_rsp_h = qclk_item::type_id::create( "m_rsp_h" );
    m_rsp_h.set_id_info( m_req_h );
    seq_item_port.put( m_rsp_h );
    `ovm_info( get_type_name( ),  "Sent QCLK response to sequencer" , OVM_LOW )
    seq_item_port.item_done();
      
      
  end: forever_loop

endtask: run

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
        
    // Setting the clk gate hi for n cycles. Disable this gating
    // after n cycles
    QCLK_TYPE_GATE_CLK_HI:  begin
      m_qclk_proxy.enable_clock_gating( );
      m_qclk_proxy.set_clock_gate_hi( );

      // if m_num_clocks is 0, the clock will be gated indefinitely
      // the disable gating sequence can be used to turn off the gating
      if (req_h.m_num_clocks > 0 ) begin
        m_qclk_proxy.wait_for_n_cycles( req_h.m_num_clocks );
        m_qclk_proxy.disable_clock_gating( );
      end
    end

    // Setting the clk gate lo for n cycles. Disable this gating
    // after n cycles
    QCLK_TYPE_GATE_CLK_LO:  begin
      m_qclk_proxy.enable_clock_gating( );
      m_qclk_proxy.set_clock_gate_lo( );

      // if m_num_clocks is 0, the clock will be gated indefinitely
      // the disable gating sequence can be used to turn off the gating
      if (req_h.m_num_clocks > 0 ) begin
        m_qclk_proxy.wait_for_n_cycles( req_h.m_num_clocks );
        m_qclk_proxy.disable_clock_gating( );
      end
    end

    // Setting the clk gate hi for n cycles. Disable this gating
    // after n cycles
    QCLK_TYPE_GATE_CLK_Z:  begin
      m_qclk_proxy.enable_clock_gating( );
      m_qclk_proxy.set_clock_gate_z( );

      // if m_num_clocks is 0, the clock will be gated indefinitely
      // the disable gating sequence can be used to turn off the gating
      if (req_h.m_num_clocks > 0 ) begin
        m_qclk_proxy.wait_for_n_cycles( req_h.m_num_clocks );
        m_qclk_proxy.disable_clock_gating( );
      end
    end

    // Disabling the clk gating
    QCLK_TYPE_DISABLE_GATING:  begin
      m_qclk_proxy.disable_clock_gating( );
    end

    // Advance the clock for n cycles. Can be used like
    // a wait for n clocks in testbench. 
    QCLK_TYPE_ADVANCE_CLK:  begin
      m_qclk_proxy.wait_for_n_cycles( req_h.m_num_clocks );
    end

    // Perform Dynamic Reset
    QCLK_TYPE_DYNAMIC_RESET:  begin
      m_qclk_proxy.restart( );
    end 
    default ;
          
  endcase // case (req_h.m_trans_type)

endtask: qclk_drive_transaction

`endif


