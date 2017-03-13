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
 * @brief Demo Testbench Environment
 *
 * Demo testbench file for QRST OVC.
 *
 * @file demo_tb.sv
 *
 * @author Sean O'Boyle
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.1 $
 * $Date: Fri Nov  6 09:28:06 2009 $
 * $Author: joboyle $
 */

`ifndef DEMO_TB_SV
`define DEMO_TB_SV

/**
 * @brief Demonstration Testbench Environment
 *
 * The demo_tb is a class that
 * instantiates the qrst environment (QRST OVC).
 * Usage Notes:<br>
 *
 * @class demo_tb
 *
 */
class demo_tb extends ovm_env;

  // Provide implementations of virtual methods such as get_type_name and create
  `ovm_component_utils(demo_tb)

  qrst_env qrst; ///< QRST OVC

  /**
   * @brief Constructor
   * Method to construct this class
   * required syntax for OVM automation and utilities
   *
   * @param name string - name of class object
   * @param parent ovm_component - parent of this class
   */
  function new (string name, ovm_component parent=null);
    super.new(name, parent);
  endfunction : new

  /**
   * @brief Build
   * Build Phase - Method to create the QRST environment
   * using the OVM factory
   */
  function void build();
    super.build();
    qrst = qrst_env::type_id::create("qrst", this);
  endfunction : build

endclass : demo_tb

`endif // DEMO_TB_SV

