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
 * @brief QIRQ Sequencer
 *
 * The QIRQ sequencer class file (qirq_sequencer.sv) has a
 * class that extends the base sequencer implementation.
 *
 * @file qirq_sequencer.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.1 $
 * $Date: Mon Nov 15 11:31:24 2010 $
 * $Author: mironm $
 */

`ifndef QIRQ_SEQUENCER__SV
`define QIRQ_SEQUENCER__SV

`include "uvm_macros.svh"

import uvm_pkg::*;

/**
 * @brief QIRQ Sequencer
 *
 * The QIRQ sequencer Class (qirq_sequencer) drives random
 * qirq_item's
 *
 * @class qirq_sequencer
 *
 */
class qirq_sequencer extends uvm_sequencer #(qirq_item);

  `uvm_component_utils(qirq_sequencer) // register with factory

  /**
   * @brief Constructor
   * Method to construct this class
   * required syntax for UVM automation and utilities
   *
   * @param name string - name of class object
   * @param parent uvm_component - parent of this class
   */
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  /**
   * @brief Connect
   * Connect Phase - required for extensions of this class the super call chain
   */
  function void connect();
    super.connect();
  endfunction : connect

endclass : qirq_sequencer

`endif // QIRQ_SEQUENCER__SV
