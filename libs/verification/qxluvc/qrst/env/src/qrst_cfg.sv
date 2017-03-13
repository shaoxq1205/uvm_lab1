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
 * @brief QRST Configuration
 *
 * The QRST configuration class file (qrst_driver.sv) has the reset 
 * configuration object class.
 *
 * @file qrst_driver.sv
 *
 * @author Sean O'Boyle
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.5 $
 * $Date: Wed Mar 24 15:05:02 2010 $
 * $Author: c_jcravy $
 */
`ifndef QRST_CFG__SV
`define QRST_CFG__SV

`include "ovm_macros.svh"

import ovm_pkg::*;

/**
 * @brief QRST Configuration Class File.
 *
 * The QRST config class file (qrst_cfg.sv) contains
 * a class with fields to configure the overall behavior of the OVC.
 *
 * @note This is an example cfg class - it's fields are not used in this OVC.
 *
 * @file qrst_cfg.sv
 *
 * @author Sean O'Boyle
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.5 $
 * $Date: Wed Mar 24 15:05:02 2010 $
 * $Author: c_jcravy $
 */
class qrst_cfg extends ovm_object;
  `ovm_object_utils(qrst_cfg)

  rand bit m_has_coverage; ///< enable functional coverage (note - this is just an example, it's not used)

  extern function new( string name = "qrst_cfg" );

  /**
   * @brief Do Print
   * Displays item fields to screen
   *
   * @param printer ovm_printer - printer policy
   * @return void
   */
  extern function void   do_print(ovm_printer printer);

  /**
   * @brief Do Copy
   * Deep Copy of RHS item to this item
   *
   * @param printer ovm_object - source object to copy data from.
   * @return void
   */
  extern function void   do_copy(ovm_object rhs);

  /**
   * @brief Do Compare
   * Deep Copy of RHS item to this item
   *
   * @param rhs ovm_object - source object to compare data from.
   * @param comparer ovm_comparer - compare policy
   * @return void
   */
  extern function bit do_compare(ovm_object rhs, ovm_comparer comparer);

endclass: qrst_cfg

//-----------------------------------------------------------------------------
// new
//-----------------------------------------------------------------------------
function qrst_cfg::new( string name = "qrst_cfg" );
  super.new( name );
  m_has_coverage = 1;
endfunction: new

//-----------------------------------------------------------------------------
// do_print
//-----------------------------------------------------------------------------
function void qrst_cfg::do_print(ovm_printer printer);
  printer.print_field( "m_has_coverage", m_has_coverage, $bits( m_has_coverage ) );
endfunction

//-----------------------------------------------------------------------------
// do_copy
//-----------------------------------------------------------------------------
function void qrst_cfg::do_copy(ovm_object rhs);
  qrst_cfg rhs_;
  super.do_copy(rhs);
  if(! $cast(rhs_, rhs) ) begin
    `ovm_fatal( get_type_name(), "Unable to cast rhs to qrst_cfg" )
  end
  m_has_coverage     = rhs_.m_has_coverage;
endfunction: do_copy

//-----------------------------------------------------------------------------
// do_compare
//-----------------------------------------------------------------------------
function bit qrst_cfg::do_compare(ovm_object rhs, ovm_comparer comparer);
  qrst_cfg rhs_;
  bit status = 1;
  if(!$cast(rhs_, rhs) ) begin
    `ovm_fatal( get_type_name(), "Unable to cast rhs to qrst_cfg" )
  end
  status &= super.do_compare( rhs, comparer );
  status &= comparer.compare_field( "m_has_coverage", m_has_coverage, rhs_.m_has_coverage, $bits( m_has_coverage ) );
  return status;
endfunction: do_compare

`endif


