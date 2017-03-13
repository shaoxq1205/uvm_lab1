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
 * @brief QCLK Proxy
 *
 * The QCLK proxy class file (qclk_proxy.sv) has the 
 * qclk_proxy  implementation. This class interfaces
 * to the hardware block through DPI functions. 
 *
 * @file qclk_proxy.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.5 $
 * $Date: Fri Sep  9 10:58:50 2011 $
 * $Author: mironm $
 */

`ifndef QCLK_PROXY__SV
`define QCLK_PROXY__SV

`include "uvm_macros.svh"

import uvm_pkg::*;


/**
 * @brief QCLK Proxy
 *
 * The QCLK proxy Class (qclk_proxy) interfaces the driver
 * to the synthesizeable hardware block (clk_rst_driver)
 * It uses DPI calls to communicate to the hardware block
 *
 * Usage Notes:
 * The functions in this class should not be used 
 * directly by the  testbench writer. It is expected that 
 * the driver is the only class that will call these
 * funcitons. 
 * <br>
 * 
 *
 * @class qclk_proxy
 *
 */



`ifndef PALLADIUM
import XlSvPkg::*;
import XlSvTimeAdvancerPkg::*;
import XlSvResetGeneratorPkg::*;
`include "XlSvClockAdvancer.svh"
`include "XlSvResetGenerator.svh"
typedef  bit [XL_SV_HANDLE_WIDTH-1:0] HANDLE_TYPE;
`else
import Pd_SvPkg::*;
typedef int HANDLE_TYPE;

`endif


  
/**
 * @brief dpii set clock period
 * DPI function that is used to set the clock period on the hardware
 * clk_reset block. 
 *
 * @param handle bit[XL_SV_HANDLE_WIDTH]  
 *                     - handle to the clk driver in hardware
 * @param hi     int   - high duration of the clock
 * @param lo     int   - low duration of the clock
 */

import "DPI-C" context function void dpii_set_clock_period(
  input HANDLE_TYPE  handle,							   
  input int hi, 
  input int lo);

  /**
   * @brief dpii initialize component handle
   * DPI function that is called to initialize the component handles,
   * based on the instance name of the clk_reset_driver
   * block in hardware
   *
   * @param handle bit[XL_SV_HANDLE_WIDTH]  
   *                         - handle to the clk_rst driver module
   * @param hdl_path   string   
   *                        - full instance path of clk_rst driver module
   */

   
`ifndef PALLADIUM
import "DPI-C" context function void dpii_initialize_component_handle(
  input string hdl_path,
  output HANDLE_TYPE handle);
`else
import "DPI-C" context function int dpii_initialize_component_handle(
  input string hdl_path);
`endif

  /**
   * @brief dpii enable clock gating
   * DPI function that is used to enable clock gating functionality 
   * in the clk driver. This method has to be called on the hardware
   * block before the clock can be gated hi or lo
   *
   * @param handle bit[XL_SV_HANDLE_WIDTH]  
   *                          - handle to the clk driver in hardware
   */


import "DPI-C" context function void dpii_enable_clock_gating(
  input HANDLE_TYPE handle );  

  /**
   * @brief dpii disable clock gating
   * DPI function that is used to disable clock gating functionality 
   * in the clk driver. The clock driver will stop gating the clock
   * to high or low when this function is called. The clock driver
   * will continue normal operations after this function is called
   *
   * @param handle bit[XL_SV_HANDLE_WIDTH]  
   *                        - handle to the clk driver in hardware
   */

   
import "DPI-C" context function void dpii_disable_clock_gating(
  input HANDLE_TYPE handle);  

  /**
   * @brief dpii set clock gate high
   * DPI function that is used to gate the clock high, 
   * This function has to be called after enable_clock_gating
   * is called on the hardware. 
   *
   * @param handle bit[XL_SV_HANDLE_WIDTH]  
   *                         - handle to the clk driver in hardware
   */


import "DPI-C" context function void dpii_set_clock_gate_hi(
  input HANDLE_TYPE handle);  
  /**
   * @brief dpii set clock gate low
   * DPI function that is used to gate the clock low
   * This function has to be called after enable_clock_gating
   * is called on the hardware. 
   *
   * @param handle bit[XL_SV_HANDLE_WIDTH]  
   *                         - handle to the clk driver in hardware
   */


import "DPI-C" context function void dpii_set_clock_gate_lo(
  input HANDLE_TYPE handle);     
   

  /**
   * @brief dpii set clock gate z
   * DPI function that is used to gate the clock to z, 
   * This function has to be called after enable_clock_gating
   * is called on the hardware. 
   *
   * @param handle bit[XL_SV_HANDLE_WIDTH]  
   *                         - handle to the clk driver in hardware
   */
import "DPI-C" context function void dpii_set_clock_gate_z(
  input HANDLE_TYPE handle);  

class qclk_proxy extends uvm_object;
  `uvm_object_utils(qclk_proxy)                            /// register qclk_proxy with the factory

  local HANDLE_TYPE m_clk_driver_handle;  		   ///< handle to the clock driver module
  local HANDLE_TYPE m_clk_gater_handle;   		   ///< handle to the clock gater module
  local string             m_clock_advancer_inst_name;     ///< clock advancer inst name. Submodule in clk_rst_module
  local string             m_reset_generator_inst_name;    ///< reset generatorinst name. Submodule in clk_rst_module

  
`ifndef PALLADIUM
  local XlSvBridgeSync m_advance_is_done;                  ///< BridgeSync handle to tracking clock advancement
  local XlSvBridgeSync m_reset_is_done;                    ///< BridgeSync handle to tracking reset

  local XlSvClockAdvancer  m_clock_advancer_handle;        ///< handle to the clock advancer module
  local XlSvResetGenerator m_reset_generator_handle;       ///< handle to the reset generator
`else
  local Pd_SvClockAdvancer  m_clock_advancer_handle;        ///< handle to the clock advancer module
  local Pd_SvResetGenerator m_reset_generator_handle;       ///< handle to the reset generator
  
`endif
  
   

  /**
   * @brief Constructor
   * Method to construct this class
   * This requires the instance path to the clk_rst_driver
   * module
   *
   * @param name string - name of class object
   * @param hdl_path string - hdl instance path name 
   */
   

  function new(string name ="qclk_proxy", string hdl_path= "");
    HANDLE_TYPE  proxy_handle;
  
//    bit [XL_SV_HANDLE_WIDTH-1:0] proxy_handle;

    // Given the top level path of the clk_rst_driver module
    // we determine the instance path of some of the submodules
    // within the clk_rst_driver block. We initialze
    // component handles to the clk_driver and clk_gate modules. 

`ifndef PALLADIUM    
    string                       clk_driver_path = {hdl_path, ".p1.clkDriver.i1"};
`else
    string                       clk_driver_path = {hdl_path, ".i1"};
`endif
    
    string                       clk_gater_path = {hdl_path, ".clkGater"};
    super.new(name);

`ifndef PALLADIUM    
    dpii_initialize_component_handle(clk_driver_path, m_clk_driver_handle);
    dpii_initialize_component_handle(clk_gater_path, m_clk_gater_handle);      

    // Initialize the BridgeSync handles used in this class
    m_reset_is_done = new();
    m_advance_is_done = new();
`else
    m_clk_driver_handle =     dpii_initialize_component_handle(clk_driver_path);
    m_clk_gater_handle =     dpii_initialize_component_handle(clk_gater_path);
`endif    

    // Initialize the clock advancer component 
    m_clock_advancer_inst_name = {hdl_path, ".clockAdvancer"};
    `uvm_info(get_type_name(),  $psprintf("Creating proxy class for ClockAdvancer %s\n", 
      m_clock_advancer_inst_name), UVM_LOW )
    m_clock_advancer_handle = new(m_clock_advancer_inst_name);


    // Initialize the reset_generatorr component 
    m_reset_generator_inst_name = {hdl_path, ".resetGenerator"};
    `uvm_info(get_type_name(),  $psprintf("Creating proxy class for ResetGenerator %s\n", 
      m_reset_generator_inst_name), UVM_LOW )      
    m_reset_generator_handle = new(m_reset_generator_inst_name);
      
  endfunction

   /**
   * @brief set clock period task 
   * Task method to set the clock period. 
   * This task in turn calls the DPI method to set the clock period
   * on the hardware block
   *
   * @param hi int  - desired high duration of the clk
   * @param lo int  - desired low duration of the clk
   */
  extern task set_clock_period(int hi, int lo);

   /**
   * @brief disable clock gating 
   * Task to disable clock gating 
   * This task in turn calls the DPI method to disable clock
   * gating on the hardware block
   *
   * @param none
   */
  extern task disable_clock_gating();

   /**
   * @brief enable clock gating 
   * Task to enable clock gating 
   * This task in turn calls the DPI method to enable clock
   * gating on the hardware block
   *
   * @param none
   */
  extern task enable_clock_gating();

   /**
   * @brief wait for n clock cycles
   * Task to make the testbench thread wait for
   * n clock cycles, where disable clock gating 
   * This task in turn calls the DPI method which communicates  
   * to the clk advancer on the hardware side. This method returns
   * after it counts "n" clock ticks in the hardware
   *
   * @param n int  - number of cycles to wait
   */
  extern task wait_for_n_cycles(longint unsigned n);

   /**
   * @brief wait for reset
   * Task that waits for reset from XlResetGenerator
   * The XlResetGnerator in hardware generates a reset
   * after n clock cycles. This number "n" is specified
   * as a parameter during instantiation of the  hardware
   * module.  In the software side, use this method
   * to make the testbench thread wait for the reset signal.
   *
   * @param none
   */
  extern task wait_for_reset();

   /**
   * @brief set clock gate lo
   * Task to set the clock to gated lo. 
   * This task in turn calls the DPI method to enable clock
   * gating lo
   *
   * @param none
   */
  extern task set_clock_gate_lo();

   /**
   * @brief set clock gate high
   * Task to set the clock to gated high
   * This task in turn calls the DPI method to enable clock
   * gating to high
   *
   * @param none
   */
  extern task set_clock_gate_hi();
   
   /**
   * @brief set clock gate z
   * Task to set the clock to gated z
   * This task in turn calls the DPI method to enable clock
   * gating to z
   *
   * @param none
   */
  extern task set_clock_gate_z();

   /**
   * @brief restart
   * Task that performs dynamic reset in the middle of simulation
   *
   * @param none
   */
  extern task restart();
endclass // qclk_proxy
   

//------------------------------------------------------------
//   restart
//------------------------------------------------------------   

task qclk_proxy::restart();
  `uvm_info(get_type_name(),  $psprintf("Calling restart"), UVM_LOW )
`ifndef PALLADIUM
  m_reset_generator_handle.restart();
`endif
  `uvm_info(get_type_name(),  $psprintf("Calling restart"), UVM_LOW )
endtask

//------------------------------------------------------------
//   wait_for_reset
//------------------------------------------------------------   

task qclk_proxy::wait_for_reset();
  `uvm_info(get_type_name(),  $psprintf("Waiting for reset initiated"), UVM_LOW )
`ifndef PALLADIUM
  m_reset_generator_handle.waitForReset();
`else
  m_reset_generator_handle.wait_for_reset();
`endif
  `uvm_info(get_type_name(),  $psprintf("Waiting for reset completed"), UVM_LOW )
endtask

//------------------------------------------------------------
//   wait_for_n_cycles
//------------------------------------------------------------   

task qclk_proxy::wait_for_n_cycles(longint unsigned n);
  `uvm_info(get_type_name(),  $psprintf("Waiting for %d clock cycles initiated", n), UVM_LOW )
`ifndef PALLADIUM  
  m_clock_advancer_handle.advance(n);
`else  
  m_clock_advancer_handle.advance_by_n_cycles(n);
`endif
  
  `uvm_info(get_type_name(),  $psprintf("Waiting for %d clock cycles completed", n), UVM_LOW )                  
endtask

//------------------------------------------------------------
//   set_clock_gate_hi
//------------------------------------------------------------   
   
task qclk_proxy::set_clock_gate_hi();
  `uvm_info(get_type_name(),  $psprintf("Setting ClockGating to Hi initiated"), UVM_LOW )
  dpii_set_clock_gate_hi(m_clk_gater_handle);
  `uvm_info(get_type_name(),  $psprintf("Setting ClockGating to Hi completed"), UVM_LOW )      
endtask

//------------------------------------------------------------
//   set_clock_gate_lo
//------------------------------------------------------------   

task  qclk_proxy::set_clock_gate_lo();
  `uvm_info(get_type_name(),  $psprintf("Setting ClockGating to Lo"), UVM_LOW )
  dpii_set_clock_gate_lo(m_clk_gater_handle);
endtask

//------------------------------------------------------------
//   set_clock_gate_z
//------------------------------------------------------------   
   
task qclk_proxy::set_clock_gate_z();
  `uvm_info(get_type_name(),  $psprintf("Setting ClockGating to Z initiated"), UVM_LOW )
  dpii_set_clock_gate_z(m_clk_gater_handle);
  `uvm_info(get_type_name(),  $psprintf("Setting ClockGating to Z completed"), UVM_LOW )      
endtask

//------------------------------------------------------------
//   set_clock_period
//------------------------------------------------------------   

task  qclk_proxy::set_clock_period(int hi, int lo);
  `uvm_info(get_type_name(),  $psprintf("Setting clock parameters (hi=%d, lo=%d) \n", hi, lo), UVM_LOW )
  dpii_set_clock_period(m_clk_driver_handle  , hi, lo);
endtask
   
//------------------------------------------------------------
//   enable_clock_gating
//------------------------------------------------------------   

task  qclk_proxy::enable_clock_gating();
  `uvm_info(get_type_name(),  $psprintf("Enabling Clock Gating \n"), UVM_LOW )
  dpii_enable_clock_gating(m_clk_gater_handle);
  `uvm_info(get_type_name(),  $psprintf("Enabled Clock Gating  \n"), UVM_LOW )      
endtask

//------------------------------------------------------------
//   disable_clock_gating
//------------------------------------------------------------   
   
task  qclk_proxy::disable_clock_gating();
  `uvm_info(get_type_name(),  $psprintf("Disabling Clock Gating \n"), UVM_LOW )
  dpii_disable_clock_gating(m_clk_gater_handle);
  `uvm_info(get_type_name(),  $psprintf("Disabled Clock Gating \n"), UVM_LOW )      
endtask
   
`endif //  `ifndef QCLK_PROXY__SV
   
