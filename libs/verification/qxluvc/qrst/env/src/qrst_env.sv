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
 * @brief QRST Environment
 *
 * The QRST environment class file (qrst_env.sv) has the toplevel implementation
 * of the QRST OVC.
 *
 * @file qrst_env.sv
 *
 * @author Sean O'Boyle
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.3 $
 * $Date: Thu Mar  4 16:34:17 2010 $
 * $Author: joboyle $
 */

`ifndef QRST_ENV__SV
`define QRST_ENV__SV

/**
 * @brief QRST Environment
 *
 * The QRST environment Class (qrst_env) is a class that
 * instantiates all of the agent(s) in the QRST OVC.
 * <ul>
 *  <li> m_agent contains the driver and sequencer of the OVC </li>
 * </ul>
 * <br>
 * Usage Notes:<br>
 *
 * @class qrst_env
 *
 */
class qrst_env extends ovm_env;
  `ovm_component_utils(qrst_env)  // register with the factory

  qrst_agent m_agent_h; ///< Agent component of the environment

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
  endfunction : new

  /**
   * @brief Build
   * Build Phase - Method to create the agent(s) using the OVM factory
   */
  extern function void build();

  /**
   * @brief Connect
   * Connect Phase - Method to create connect child components
   */
  extern function void connect();

endclass : qrst_env

//-----------------------------------------------------------------------------
// build
//-----------------------------------------------------------------------------
function void qrst_env::build();
  super.build();
  m_agent_h = qrst_agent::type_id::create("m_agent_h", this);
endfunction : build

//-----------------------------------------------------------------------------
// connect
//-----------------------------------------------------------------------------
function void qrst_env::connect();
  super.connect();
endfunction : connect

`endif // QRST_ENV__SV
