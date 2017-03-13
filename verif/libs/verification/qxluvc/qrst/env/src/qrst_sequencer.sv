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
 * @brief QRST Sequencer
 *
 * The QRST sequencer class file (qrst_sequencer.sv) has a
 * class that extends the base sequencer implementation.
 *
 * @file qrst_sequencer.sv
 *
 * @author Sean O'Boyle
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.5 $
 * $Date: Mon May  3 10:32:34 2010 $
 * $Author: c_jcravy $
 */

`ifndef QRST_SEQUENCER__SV
`define QRST_SEQUENCER__SV

`include "ovm_macros.svh"

import ovm_pkg::*;

/**
 * @brief QRST Sequencer
 *
 * The QRST sequencer Class (qrst_sequencer) drives random
 * qrst_item's
 *
 * @class qrst_sequencer
 *
 */
class qrst_sequencer extends ovm_sequencer #(qrst_item);

  `ovm_component_utils(qrst_sequencer) // register with factory

  /**
   * @brief Constructor
   * Method to construct this class
   * required syntax for OVM automation and utilities
   *
   * @param name string - name of class object
   * @param parent ovm_component - parent of this class
   */
  function new (string name, ovm_component parent);
    super.new(name, parent);
  endfunction : new

  /**
   * @brief Connect
   * Connect Phase - required for extensions of this class the super call chain
   */
  function void connect();
    super.connect();
  endfunction : connect

endclass : qrst_sequencer

`endif // QRST_SEQUENCER__SV

