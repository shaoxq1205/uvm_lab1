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
 * @brief QGPIO Agent
 *
 * The QGPIO agent class file (qgpio_agent.sv) is the 
 * QGPIO toplevel agent. 
 *
 * @file qgpio_agent.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.1 $
 * $Date: Mon Nov 15 11:29:46 2010 $
 * $Author: mironm $
 */

`ifndef QGPIO_AGENT__SV
`define QGPIO_AGENT__SV

`include "qgpio_item.sv"
`include "qgpio_driver.sv"
`include "uvm_macros.svh"

import uvm_pkg::*;

/**
 * @brief QGPIO agent
 *
 * The QGPIO agent Class (qgpio_agent) is a class that
 * instantiates different UVM sub-components:
 * <ul>
 *  <li> driver instance </li>
 *  <li> sequencer instance </li>
 * </ul>
 * <br>
 *
 * @class qgpio_agent
 *
 */
class qgpio_agent extends uvm_agent;
  `uvm_component_utils(qgpio_agent) // register with factory

  qgpio_driver      m_driver_h;       ///< Driver instance (required by UVM)   
  qgpio_sequencer   m_sequencer_h;    ///< Sequencer instance (required by UVM)
  uvm_analysis_port #(qgpio_item)  m_analysis_port;
                                       ///< Analysis port at the agent level   

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
   * @brief Build Method
   * Build Phase - Method to create the sequencer, driver and driver
   * using the UVM factory
   */
  extern virtual function void build();

  /**
   * @brief connect method
   * Connect Phase - Method to connect the driver and sequencer
   *
   */
  extern virtual function void connect();

endclass: qgpio_agent

//-----------------------------------------------------------------------------
// build
//-----------------------------------------------------------------------------
function void qgpio_agent::build();
  uvm_object tmp;

  super.build();
  // Build the driver and controller
  `uvm_info(get_type_name(), "constructing the qgpio driver", UVM_HIGH )
  m_driver_h    = qgpio_driver::type_id::create("m_driver_h", this );

  `uvm_info(get_type_name(), "constructing the analysis export port ",UVM_LOW )
  m_analysis_port     = new("m_analysis_port",     this );

  `uvm_info(get_type_name(),  "constructing qgpio sequencer",    UVM_LOW )
  m_sequencer_h    = qgpio_sequencer::type_id::create("m_sequencer_h", this );
  
endfunction: build
   
//-----------------------------------------------------------------------------
// connect
//-----------------------------------------------------------------------------
function void qgpio_agent::connect();
  super.connect();
  // Connect the driver's input port to the sequencer output port
  m_driver_h.seq_item_port.connect( m_sequencer_h.seq_item_export );
  m_driver_h.m_analysis_port.connect(m_analysis_port);   
endfunction: connect

`endif



