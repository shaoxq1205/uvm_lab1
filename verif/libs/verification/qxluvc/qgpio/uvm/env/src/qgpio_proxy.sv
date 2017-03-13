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
 * @brief QGPIO Proxy
 *
 * The QGPIO proxy class file (qgpio_proxy.sv) has the qgpio_proxy 
 * implementation.
 *
 * @file qgpio_proxy.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.2 $
 * $Date: Tue Mar  8 12:54:52 2011 $
 * $Author: mironm $
 */
`ifndef QGPIO_PROXY__SV
`define QGPIO_PROXY__SV

`include "uvm_macros.svh"

import uvm_pkg::*;

/**
 * @brief QGPIO Proxy
 *
 * The QGPIO proxy Class (qgpio_item) fetches items
 * from the sequencer are drive the HDL signals to implement
 * the sequence item.  It uses a XlGpioTransactor proxy
 * to communicate to the hardware side
 * Usage Notes:<br>
 *
 * @class qgpio_proxy
 *
 */

`ifndef PALLADIUM
import XlSvPkg::*;
`include "XlSvGpioTransactor.svh"
`else
import Pd_SvPkg::*;
`endif

/**
 * @brief dpii init signal table
 * DPI function that is used to parse the pin map file and initialize
 * the signal table in this class. The signal table maintains a list
 * of signals that can be driven by this proxy
 *
 * @param pin_map_file string   - the path to the pin map file that will be 
 *                                parsed in C code
 * @param num_items  int        - number of items in the  pin map file
 * @param sig_array[NUM_EDGE_DETECTS] string 
 *                              - list of all the signal names that is created
 *                                after parsing the pin map file. 
 */

import "DPI-C" context function void qgpio_dpii_init_signal_table(
  input string pin_map_file,
  output int    num_items,
`ifndef PALLADIUM
  output string sig_array[MAX_NUM_SIGNALS],
  output int xdir_array[MAX_NUM_SIGNALS]
`else	
 output string  sig_array[],
 output int  xdir_array[]						
`endif							  
   						  
);


class qgpio_proxy extends uvm_object;
  `uvm_object_utils(qgpio_proxy)                   ///< register qgpio_proxy with the factory
  int    m_num_items;                              ///< maintains the number of items in signaltable
`ifndef PALLADIUM  
  XlSvGpioTransactor m_gpio_transactor_handle;     ///< handle to the XlGpioTransactor(proxy)
`else
  Pd_SvGpioTransactor m_gpio_transactor_handle;     ///< handle to the XlGpioTransactor(proxy)
`endif
//   
//  string m_sig_array[MAX_NUM_SIGNALS];             ///< list of signals in pin map file
  string m_sig_array[] = new[MAX_NUM_SIGNALS];             ///< list of signals in pin map file  
  int  	 m_dir_array[] = new[MAX_NUM_SIGNALS];
   
  /**
   * @brief Constructor
   * Method to construct this class
   * This requires the instance path to the XlEdgeDetector
   * module
   *
   * @param name string                        - name of class object
   * @param gpio_transactor_hdl_path string    - hdl instance path name 
   * @param gpio_transactor_pin_map  string    - pathname to the pin map file
   */

  function new(string name= "qgpio_proxy",
    string  gpio_transactor_hdl_path = "", 
    string  gpio_transactor_pin_map_file  =""
  );

    string  sigtable_elements;
    super.new(name);

    /// Initialize the XlGpioTransactor handle 
    m_gpio_transactor_handle = new(gpio_transactor_hdl_path, gpio_transactor_pin_map_file);

    /// Initalize the sig_array by calling the DPI function to parse the pin map file      
    qgpio_dpii_init_signal_table(gpio_transactor_pin_map_file, m_num_items, m_sig_array, m_dir_array);
    `uvm_info(get_type_name(),  
      $psprintf("SigTable obtained from %s(%3d)  \n", gpio_transactor_pin_map_file, m_num_items),  
      UVM_LOW )

      /// Print out the signals obtained from pinmap file       
    for (int ii = 0; ii < m_num_items; ii++) begin
      
      sigtable_elements = {sigtable_elements, " ",  m_sig_array[ii]};
      if(m_dir_array[ii] == 0)
	sigtable_elements = {sigtable_elements,  "(output)" };
      else
	sigtable_elements = {sigtable_elements,  "(input)"};

    end
    `uvm_info(get_type_name(),  $psprintf("SigTable: %s  \n",  sigtable_elements),  UVM_LOW )
  endfunction

  /**
   * @brief read value of a signal
   * This method  will determine the value of a particular signal. 
   * This value is gotten from the hardware by making use of GpioTransactor
   * transactor. 
   *
   * @param alias_name string  - name of the alias in the probegroup file
   * @param sig_loc int   - location of the sig in the probegroup file
   * @param get_value  bit[MAX_GET_VALUE_WIDTH-1:0]  - the value that
   *                     is obtained
   */
  extern task read_value(input string alias_name, input int sig_loc, output bit[MAX_GET_VALUE_WIDTH-1:0] get_value);

  /**
   * @brief write value of a signal
   * This method when will update the value of a particular signal 
   * This value is written to the hardware by making use of GpioTransactor
   *
   * @param alias_name string  - name of the alias in the probegroup file
   * @param sig_loc int   - location of the sig in the probegroup file
   * @param set_value  bit[MAX_GET_VALUE_WIDTH-1:0]  - the value that
   *                     will be set on the signal 
   */
  extern task write_value(input string alias_name, input int sig_loc, input bit[MAX_SET_VALUE_WIDTH-1:0] set_value);   
   
endclass // qgpio_proxy

   
//----------------------------------------------------------------------------------
//  TASK:  read_value
//----------------------------------------------------------------------------------   
task  qgpio_proxy::read_value(input string alias_name, input  int sig_loc, output bit [MAX_GET_VALUE_WIDTH-1:0] get_value);
  string sig_name = alias_name;
  int 	 unsigned gvalue[];
  int i,j;

  
  int len = (MAX_GET_VALUE_WIDTH/32) + 1;
  gvalue = new[len];
   
  if(alias_name.len() == 0) begin
    // check if the sig loc is valid
    if (sig_loc > m_num_items) begin
      `uvm_error(get_type_name(), $psprintf("Invalid sig number in transaction "));
    end
    else
      if(m_dir_array[sig_loc] == 1) begin
	`uvm_error(get_type_name(), 
		   $psprintf("Signal %s cannot be used in read_value functions", m_sig_array[sig_loc]));
      end
      else begin
	sig_name = m_sig_array[sig_loc];
	
      end
  end // if (alias_name.len() == 0)

  /// make call to the GPIOTransactor
  `uvm_info(get_type_name(), $psprintf("getValue called on sig %s", sig_name), UVM_LOW)
`ifndef PALLADIUM  
//oldAPI  m_gpio_transactor_handle.getValue(sig_name, get_value);
  m_gpio_transactor_handle.getValue(sig_name, gvalue);

  get_value = {MAX_GET_VALUE_WIDTH{1'b0}};
  
  for( j=0; j<len; j++) begin
    get_value[j*32 +:  32] = gvalue[j];
  end	
  $display("get_value %h", get_value);

`else
  m_gpio_transactor_handle.readValue(sig_name, get_value);  
`endif
  
  `uvm_info(get_type_name(), $psprintf("getValue finished on sig %s with value %b", sig_name, get_value), UVM_LOW)      
endtask


 //----------------------------------------------------------------------------------
//  TASK:  write_value
//----------------------------------------------------------------------------------   
task  qgpio_proxy::write_value(input string alias_name, input int sig_loc,  input bit[MAX_SET_VALUE_WIDTH-1:0] set_value);
  string sig_name = alias_name;
  int 	 unsigned svalue[];

  int 	 j;

  int len = (MAX_GET_VALUE_WIDTH/32) + 1;
  svalue = new[len];

  for( j=0; j<len; j++) begin
    svalue[j] = set_value[j*32 +:  32];
  end	

  if(alias_name.len() == 0) begin
    // check if the sig loc is valid
    if (sig_loc > m_num_items) begin
      `uvm_error(get_type_name(), $psprintf("Invalid sig number in transaction "));
    end
    else
      if(m_dir_array[sig_loc] == 0) begin
	`uvm_error(get_type_name(), 
		   $psprintf("Signal %s cannot be used in write_value functions", m_sig_array[sig_loc]));
      end
      else begin
	sig_name = m_sig_array[sig_loc];
      end
  end // if (alias_name.len() == 0)
  
   /// make call to the GPIOTransactor
  `uvm_info(get_type_name(), $psprintf("setValue called on sig %s (val = %b)", sig_name, set_value), UVM_LOW)      
`ifndef PALLADIUM 
//oldapi  m_gpio_transactor_handle.setValue(sig_name, set_value);
    m_gpio_transactor_handle.setValue(sig_name, svalue);
`else
  m_gpio_transactor_handle.writeValue(sig_name, set_value);  
`endif
  `uvm_info(get_type_name(), $psprintf("setValue called on sig %s (val = %b)", sig_name, set_value), UVM_LOW)         


endtask

   
`endif //  `ifndef QGPIO_PROXY__SV
   
