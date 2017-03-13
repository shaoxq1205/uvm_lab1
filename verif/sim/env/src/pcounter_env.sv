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
 * @brief Pcounter Verification Environment
 *
 * The Pcounter Verification Environment (pcounter_env.sv) contains the
 * environment implementation for the pcounter DUT.
 *
 * @file pcounter_env.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.3 $
 * $Date: Mon Nov 15 12:05:21 2010 $
 * $Author: mironm $
 */

`ifndef PCOUNTER_ENV__SV
`define PCOUNTER_ENV__SV

`include "uvm_macros.svh"
`include "pcounter_virtual_sequencer.sv"

import uvm_pkg::*;
import quvm_addons_pkg::*;
import qclk_pkg::*;


/**
 * @brief Pcounter Verification Environment
 *
 * This file contains all the verification components required to
 * verify the pcounter DUT.  Components are:
 * <ul>
 *  <li> pcounter virtual sequencer </li>
 *  <li> QC Reset UVC </li>
 *  <li> Config UVC </li>
 *  <li> Data In UVC </li>
 *  <li> Data Out UVC </li>
 *  <li> Pcounter Scoreboard </li>
 *  <li> Pcounter Coverage </li>
 * </ul>
 * <br>
 * Usage Notes:<br>
 *
 * @class pcounter_env
 *
 */
class pcounter_env extends uvm_env;
  `uvm_component_utils(pcounter_env) // Register the Environment with the factory

  pcounter_virtual_sequencer m_pcounter_virtual_sequencer_h; ///< Pcounter Virtual Sequencer Handle
 
  qclk_agent                  m_qclk_agent_h;
   
  qclk_proxy                  m_qclk_proxy;


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
   * Build Phase - Method to create the environment components
   * using the UVM factory
   */
  extern function void build_phase (uvm_phase phase);

  /**
   * @brief Connect
   * Connect Phase - Method to connect the virtual sequencer and scoreboard
   */
  extern function void connect_phase (uvm_phase phase);

  /**
   * @brief Report
   * Report Phase - Method to print the factory overrides
   *
   * @return void
   */
  extern  function void report_phase (uvm_phase phase);
endclass: pcounter_env

//-----------------------------------------------------------------------------
// report
//-----------------------------------------------------------------------------

function void pcounter_env::report_phase (uvm_phase phase);
  if( get_report_verbosity_level() >= UVM_FULL ) begin
    factory.print(1); // print everything
  end
  else begin
    if( get_report_verbosity_level() >= UVM_MEDIUM ) begin
      factory.print(0); // only print the overrides
    end
  end
  super.report_phase(phase);
endfunction: report_phase


//-----------------------------------------------------------------------------
// build
//-----------------------------------------------------------------------------
function void pcounter_env::build_phase(uvm_phase phase);
  super.build_phase(phase);
   
  // create a sequencer that can be passed down the hierarchy of
  // sequences and holds a list of where all the other sequencers are
  `uvm_info( get_type_name(), "Getting sequencer list from the Factory", UVM_HIGH );
  m_pcounter_virtual_sequencer_h  = pcounter_virtual_sequencer::type_id::create("m_pcounter_virtual_sequencer_h", this);

  //Create the components in the environment using the Factory
  `uvm_info( get_type_name(), "Getting qclk Agent from the Factory", UVM_HIGH );
  m_qclk_agent_h = qclk_agent::type_id::create("m_qclk_agent_h", this);


  // For the qclk_agent, we create a proxy object qclk_proxy and
  // wrap it inside a assign it to the vif container. 
  m_qclk_proxy = new ("m_qclk_proxy", "test_bench.u_clock.intf1");
  `uvm_info( get_type_name(), "Set config object in pcounter_env", UVM_LOW );   
  uvm_config_db#(qclk_proxy)::set (this, "m_qclk_agent_h.m_driver_h", "m_qclk_proxy", m_qclk_proxy);


endfunction: build_phase

//-----------------------------------------------------------------------------
// connect
//-----------------------------------------------------------------------------
function void pcounter_env::connect_phase (uvm_phase phase);
  super.connect_phase(phase);

  `uvm_info( get_type_name(), "Setting qclk_sequencer in the sequencer list", UVM_HIGH );   
  m_pcounter_virtual_sequencer_h.m_qclk_sequencer_h = m_qclk_agent_h.m_sequencer_h;
endfunction: connect_phase

`endif

