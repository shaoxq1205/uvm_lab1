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
 * @brief QRST Driver
 *
 * The QRST driver class file (qrst_driver.sv) has the qrst_driver 
 * implementation.
 *
 * @file qrst_driver.sv
 *
 * @author Sean O'Boyle
 * @par Contact:
 * seanoboyle@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.8 $
 * $Date: Fri Apr  2 10:28:32 2010 $
 * $Author: c_jcravy $
 */

`ifndef QRST_DRIVER__SV
`define QRST_DRIVER__SV

/**
 * @brief QRST Driver
 *
 * The QRST driver Class (qrst_item) fetches items
 * from the sequencer are drive the HDL signals to implement
 * the sequence item.  It has features:
 * <ul>
 *  <li> request handle (to fetch from sequencer) </li>
 *  <li> response handle to sent data back to sequencer if required </li>
 *  <li> determines clock period to generate async resets </li>
 * </ul>
 * <br>
 * Usage Notes:<br>
 *
 * @class qrst_driver
 *
 */
class qrst_driver extends ovm_driver #(qrst_item);
  `ovm_component_utils(qrst_driver) // register qrst_driver with factory

  ovm_analysis_port #(qrst_item) m_analysis_port; ///< ...

  qrst_item m_qrst_item_req_h; ///< Request handle
  qrst_item m_qrst_item_rsp_h; ///< Response handle

  virtual qrst_if.bfm_mp m_qrst_mp; ///< Virtual interface Modport

  int m_clk_period; ///< Clock period reference to generate async reset
  int m_async_delay; ///< Async delay in "ns" to add before applying reset

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
  * @brief Build
  * Build Phase - Method to call the build function of the parent.
  * @return void
  */
  extern function void build();

  /**
  * @brief Connect Method
  * Connect Phase - Method to connect to QRST interface to drive and sample 
  * signals.
  * @return void
  */
  extern function void connect();

  /**
  * @brief Run Method
  * Run Phase - Method to start the driver
  */
  extern task run();

  /**
  * @brief Drive Reset Method
  * BFM Method that fetches reset sequence from the sequencer and
  * executes the item by toggling the HDL signal of the interface.
  */
  extern virtual protected task bfm_drive_reset();

  /**
  * @brief Determine Clock Period Method
  * Method that determines the current clock period on order
  * to generate an async reset (not aligned with the clock).
  */
  extern virtual protected task determine_m_clk_period();

endclass: qrst_driver

//-----------------------------------------------------------------------------
// build
//-----------------------------------------------------------------------------
function void qrst_driver::build();
  super.build();
  m_analysis_port = new( "m_analysis_port", this );
endfunction: build

//-----------------------------------------------------------------------------
// connect
//-----------------------------------------------------------------------------
function void qrst_driver::connect();
  ovm_object tmp;
  qovm_vif_container #( virtual qrst_if.bfm_mp) qrst_bfm_vif_container_h;

  `ovm_info(get_type_name(), "connecting virtual interface", OVM_FULL );
  if(!get_config_object("rst_bfm_vif_container", tmp)) begin
    `ovm_fatal(get_type_name(), "Can't get the rst_bfm_vif_container object from factory");
  end
  if(!$cast(qrst_bfm_vif_container_h, tmp)) begin
    `ovm_fatal(get_type_name(), "Cast failed for rst_bfm_vif_container");
  end
  if (qrst_bfm_vif_container_h == null) begin
    `ovm_fatal(get_type_name(), "DUT virtual interface is null!");
  end
  m_qrst_mp = qrst_bfm_vif_container_h.m_vif_h;
endfunction: connect

//-----------------------------------------------------------------------------
// run
//-----------------------------------------------------------------------------
task qrst_driver::run();
  `ovm_info(get_type_name(),  "QRST driver starting", OVM_HIGH);

  fork: qrst_driver_fork
    begin
      bfm_drive_reset();
    end
    begin
      determine_m_clk_period();
    end
  join: qrst_driver_fork

endtask: run

//-----------------------------------------------------------------------------
// bfm_drive_reset
//-----------------------------------------------------------------------------
task qrst_driver::bfm_drive_reset();
  forever begin: forever_loop

  // Get a new transaction from the sequencer
  seq_item_port.get_next_item(m_qrst_item_req_h);
  m_analysis_port.write(m_qrst_item_req_h);
  `ovm_info(get_type_name(), $psprintf("Starting Reset Sequence, pre-reset duration = %0d clocks",
    m_qrst_item_req_h.m_qrst_pre_rst_duration), OVM_HIGH);

  // Drive not reset - initially (and drive to non active asynchronously)
  m_qrst_mp.rst_pin <= (m_qrst_item_req_h.m_qrst_polarity == POLARITY_ACTIVE_HIGH) ? 1'b0:1'b1;
  // Handle pre-reset duration
  repeat (m_qrst_item_req_h.m_qrst_pre_rst_duration) begin
    @(m_qrst_mp.bfm_cb);
  end

  // Check if we need to make the reset enable async to the clock.
  if(m_qrst_item_req_h.m_qrst_start_rst_sync == MODE_ASYNC_TO_CLK) begin
    m_async_delay = m_clk_period / 2;
    `ovm_info(get_type_name(), $psprintf("Adding async delay of %0d ns before enabling reset",
      m_async_delay), OVM_HIGH);
    #(m_async_delay * 1ns);
    // Drive async reset
    m_qrst_mp.rst_pin <= (m_qrst_item_req_h.m_qrst_polarity == POLARITY_ACTIVE_HIGH) ? 1'b1:1'b0;
  end
  else begin
    // Drive Sync reset
    m_qrst_mp.bfm_cb.rst_pin <= (m_qrst_item_req_h.m_qrst_polarity == POLARITY_ACTIVE_HIGH) ? 1'b1:1'b0;
  end


  // Handle reset duration
  `ovm_info(get_type_name(), $psprintf("Driving Reset, duration = %0d clocks",
    m_qrst_item_req_h.m_qrst_duration), OVM_MEDIUM);
  repeat (m_qrst_item_req_h.m_qrst_duration) begin
    @(m_qrst_mp.bfm_cb);
  end

  // Check if we need to make the reset disable async to the clock.
  if(m_qrst_item_req_h.m_qrst_end_rst_sync == MODE_ASYNC_TO_CLK) begin
    m_async_delay = m_clk_period / 2;
    `ovm_info(get_type_name(), $psprintf("Adding async delay of %0d ns before ending reset",
      m_async_delay), OVM_HIGH);
    #(m_async_delay * 1ns);
    // Deassert Async
    m_qrst_mp.rst_pin <= (m_qrst_item_req_h.m_qrst_polarity == POLARITY_ACTIVE_HIGH) ? 1'b0:1'b1;
  end
  else begin
    // Deassert Sync
    m_qrst_mp.bfm_cb.rst_pin <= (m_qrst_item_req_h.m_qrst_polarity == POLARITY_ACTIVE_HIGH) ? 1'b0:1'b1;
  end

  // Handle post-reset duration
  `ovm_info(get_type_name(), $psprintf("End Reset, post-reset duration = %0d clocks",
    m_qrst_item_req_h.m_qrst_post_rst_duration), OVM_HIGH);
  repeat (m_qrst_item_req_h.m_qrst_post_rst_duration) begin
    @(m_qrst_mp.bfm_cb);
  end
  `ovm_info(get_type_name(), "End of Reset Sequence", OVM_MEDIUM);

  // return a sequence item to let the sequence know that this is complete
  m_qrst_item_rsp_h = qrst_item::type_id::create("m_qrst_item_rsp_h",this);
  m_qrst_item_rsp_h.set_id_info(m_qrst_item_req_h);
  seq_item_port.item_done(m_qrst_item_rsp_h);

  end: forever_loop

endtask: bfm_drive_reset

//-----------------------------------------------------------------------------
// determine_m_clk_period
//-----------------------------------------------------------------------------
task qrst_driver::determine_m_clk_period();
  int current_time;
  @(m_qrst_mp.bfm_cb);
  current_time = $time;
  @(m_qrst_mp.bfm_cb);
  m_clk_period = $time - current_time;
  `ovm_info(get_type_name(), $psprintf("Clock Period = %0d", m_clk_period), OVM_HIGH);
endtask: determine_m_clk_period

`endif

