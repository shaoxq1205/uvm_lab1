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
 * @brief Pcounter Virtual Sequencer
 *
 * File that contains the implementation of the pcounter virtual sequencer.
 *
 * @file pcounter_virtual_sequencer.sv
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

`ifndef PCOUNTER_VIRTUAL_SEQUENCER__SV
`define PCOUNTER_VIRTUAL_SEQUENCER__SV

`include "uvm_macros.svh"

import uvm_pkg::*;
import qclk_pkg::*;

/**
 * @brief Pcounter Virtual Sequencer
 *
 * The pcounter virtual sequencer holds handles
 * to all the sequencers in the environment
 * Sequencers:
 * <ul>
 *  <li> QC Reset sequencer </li>
 *  <li> Config sequencer </li>
 *  <li> Din sequencer </li>
 *  <li> Dout sequencer </li>
 * </ul>
 * <br>
 * Usage Notes:<br>
 *
 * @class pcounter_virtual_sequencer
 *
 */
class pcounter_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
  `uvm_component_utils(pcounter_virtual_sequencer)

  qclk_sequencer                       m_qclk_sequencer_h;       ///< qclk sequencer

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
  endfunction : new

  /**
   * @brief Connect
   * Connect Method - Required for sequencer extension and layering
   */
  function void connect();
    super.connect();
  endfunction : connect

endclass : pcounter_virtual_sequencer


`endif

