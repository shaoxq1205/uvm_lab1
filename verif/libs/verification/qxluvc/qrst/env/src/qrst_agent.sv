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
 * @brief QRST Agent
 *
 * The QRST agent class file (qrst_agent.sv) is the QRST toplevel agent.
 *
 * @file qrst_agent.sv
 *
 * @author Sean O'Boyle
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.3 $
 * $Date: Mon May  3 10:27:39 2010 $
 * $Author: c_jcravy $
 */

`ifndef QRST_AGENT__SV
`define QRST_AGENT__SV

import ovm_pkg::*;

/**
 * @brief QRST agent
 *
 * The QRST agent Class (qrst_agent) is a class that
 * instantiates different OVM sub-components:
 * <ul>
 *  <li> configuration object </li>
 *  <li> driver instance </li>
 *  <li> sequencer instance </li>
 * </ul>
 * <br>
 *
 * @class qrst_agent
 *
 */
class qrst_agent extends ovm_agent;
  `ovm_component_utils(qrst_agent) // register with factory

  qrst_cfg m_cfg_h; ///< Common configuration object for the OVC
  qrst_driver m_driver_h; ///< Driver instance (required by OVM)
  qrst_sequencer m_sequencer_h; ///< Sequencer instance (required by OVM)

  ///< Driver Analysis Port
  ovm_analysis_port #(qrst_item) m_driver_analysis_port; 

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

endclass: qrst_agent

//-----------------------------------------------------------------------------
// build
//-----------------------------------------------------------------------------
function void qrst_agent::build();
  ovm_object tmp;

  super.build();

  // Get the Configuration
  assert(get_config_object("qrst_cfg", tmp)) else begin
    `ovm_fatal(get_type_name(), "Can't get the cfg object from factory");
  end
  if( !$cast(m_cfg_h, tmp) ) begin
    `ovm_fatal(get_type_name(), "cast failed for m_cfg(qrst_cfg)");
  end
  if (m_cfg_h == null) begin
    `ovm_fatal(get_type_name(), "cfg is null!");
  end

  // Make decisions based on the cfg
  //  TODO...

  // Build the driver
  `ovm_info(get_type_name(), "Getting RST driver from Factory", OVM_HIGH);
  m_driver_h = qrst_driver::type_id::create("m_driver_h", this );
  // Build the sequencer
  `ovm_info(get_type_name(), "Newing RST item sequencer", OVM_HIGH);
  m_sequencer_h = qrst_sequencer::type_id::create("m_sequencer_h", this );

  // Build the analysis port
  `ovm_info(get_type_name(), "Newing the analysis port ", OVM_HIGH)
  m_driver_analysis_port = new("m_driver_analysis_port", this);


endfunction: build

//-----------------------------------------------------------------------------
// connect
//-----------------------------------------------------------------------------
function void qrst_agent::connect();
  super.connect();
  // Connect the driver's input port to the sequencer output port
  m_driver_h.seq_item_port.connect( m_sequencer_h.seq_item_export );
  // Connec the driver's analysis port to agent's analysis port
  m_driver_h.m_analysis_port.connect (m_driver_analysis_port);
endfunction: connect

`endif
