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
 * @brief QIRQ Agent
 *
 * The QIRQ agent class file (qirq_agent.sv) is the 
 * QIRQ toplevel agent. 
 *
 * @file qirq_agent.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.1 $
 * $Date: Mon Nov 15 11:31:24 2010 $
 * $Author: mironm $
 
 */

`ifndef QIRQ_AGENT__SV
`define QIRQ_AGENT__SV

`include "qirq_item.sv"
`include "qirq_driver.sv"
`include "ovm_macros.svh"

import ovm_pkg::*;

/**
 * @brief QIRQ agent
 *
 * The QIRQ agent Class (qirq_agent) is a class that
 * instantiates different OVM sub-components:
 * <ul>
 *  <li> driver instance </li>
 *  <li> sequencer instance </li>
 * </ul>
 * <br>
 *
 * @class qirq_agent
 *
 */
class qirq_agent extends ovm_agent;
  `ovm_component_utils(qirq_agent)  // register with factory

  qirq_driver     m_driver_h;     ///< Driver instance (required by OVM)   
  qirq_sequencer  m_sequencer_h;  ///< Sequencer instance (required by OVM)
  ovm_analysis_port  #(qirq_item) m_analysis_port;

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
   * @brief Build Method
   * Build Phase - Method to create the sequencer, driver and driver
   * using the OVM factory
   */
  extern virtual function void build();

  /**
   * @brief connect method
   * Connect Phase - Method to connect the driver and sequencer
   *
   */
  extern virtual function void connect();

endclass: qirq_agent

//-----------------------------------------------------------------------------
// build
//-----------------------------------------------------------------------------
function void qirq_agent::build();
  ovm_object tmp;

  super.build();

  // Build the driver and controller
  `ovm_info(get_type_name(), "constructing the qirq driver", OVM_HIGH )
  m_driver_h    = qirq_driver::type_id::create("m_driver_h", this );
  
  `ovm_info(get_type_name(), "constructing the analysis export port ",OVM_LOW )
  m_analysis_port     = new("m_analysis_port",     this );

  `ovm_info(get_type_name(),  "constructing qirq sequencer",    OVM_LOW )
  m_sequencer_h    = qirq_sequencer::type_id::create("m_sequencer_h", this );
  
endfunction: build
   
//-----------------------------------------------------------------------------
// connect
//-----------------------------------------------------------------------------
function void qirq_agent::connect();
  super.connect();
  // Connect the driver's input port to the sequencer output port
  m_driver_h.seq_item_port.connect( m_sequencer_h.seq_item_export );
  m_driver_h.m_analysis_port.connect(m_analysis_port);   
endfunction: connect

`endif



