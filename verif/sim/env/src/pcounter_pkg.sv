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
 * @brief Pcounter Package
 *
 * This file contains the package for the pcounter DUI verification 
 * environment(the DUT UVC).
 *
 * @file pcountere_pkg.sv
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

`ifndef PCOUNTER_PKG__SV
`define PCOUNTER_PKG__SV

`include "uvm_macros.svh"

`timescale 1ns/1ps

/**
 * @brief Pcounter Package
 *
 * The package for the pcounter DUI verification environment(the DUT UVC).
 *
 */
package pcounter_pkg;

  import uvm_pkg::*;

`include "pcounter_env.sv"
`include "pcounter_virtual_sequencer.sv"
`include "pcounter_seq_list.sv"

endpackage: pcounter_pkg

`endif
