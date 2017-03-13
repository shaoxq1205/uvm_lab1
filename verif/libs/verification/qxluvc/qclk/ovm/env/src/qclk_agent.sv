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
 * @brief QCLK Agent
 *
 * The QCLK agent class file (qclk_agent.sv) is the 
 * QCLK toplevel agent. 
 *
 * @file qclk_agent.sv
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

`ifndef QCLK_AGENT__SV
`define QCLK_AGENT__SV

`include "qclk_item.sv"
`include "qclk_driver.sv"
`include "qclk_sequencer.sv"

`include "ovm_macros.svh"
import ovm_pkg::*;

/**
 * @brief QCLK agent
 *
 * The QCLK agent Class (qclk_agent) is a class that
 * instantiates different OVM sub-components:
 * <ul>
 *  <li> driver instance </li>
 *  <li> sequencer instance </li>
 * </ul>
 * <br>
 *
 * @class qclk_agent
 *
 */
class qclk_agent extends ovm_agent;
  `ovm_component_utils(qclk_agent)  // register with factory

  qclk_driver    m_driver_h;       ///< Driver instance (required by OVM)   
  qclk_sequencer m_sequencer_h;    ///< Sequencer instance (required by OVM)

  ovm_analysis_port  #(qclk_item)   m_agent_analysis_port;
                                    ///< Analysis port at the agent level
  /**
   * @brief Constructor
   * Method to construct this class, 
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
   * Build Phase - Method to create the sequencer, driver and monitor
   * using the OVM factory
   */
  extern virtual function void build();

  /**
   * @brief connect method
   * Connect Phase - Method to connect the driver and sequencer
   *
   */
  extern virtual function void connect();

endclass: qclk_agent

//-----------------------------------------------------------------------------
// build
//-----------------------------------------------------------------------------
function void qclk_agent::build();
  ovm_object tmp;

  super.build();

  // Build the driver and controller
  `ovm_info(get_type_name(), "Constructing the qclk_driver", OVM_HIGH )
  m_driver_h              = qclk_driver::type_id::create( "m_driver_h", this );

  `ovm_info(get_type_name(), "Constructing the analysis export port ",OVM_LOW )
  m_agent_analysis_port  = new( "m_agent_analysis_port",     this );

  `ovm_info(get_type_name(), "Cconstructing the qclk sequencer",  OVM_LOW )
  m_sequencer_h          = qclk_sequencer::type_id::create( "m_sequencer_h", this );
  
endfunction: build
   
//-----------------------------------------------------------------------------
// connect
//-----------------------------------------------------------------------------
function void qclk_agent::connect();
  super.connect();
  // Connect the driver's input port to the sequencer output port
  m_driver_h.seq_item_port.connect( m_sequencer_h.seq_item_export );

  // Connect the driver's analysis port to the agents analysis port   
  m_driver_h.m_analysis_port.connect( m_agent_analysis_port );   
endfunction: connect

`endif



