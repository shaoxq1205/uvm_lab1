
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
 * @brief QIRQ Proxy
 *
 * The QIRQ proxy class file (qirq_proxy.sv) has the qirq_proxy 
 * implementation.
 *
 * @file qirq_proxy.sv
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SCL
 *
 * $Revision: 1.2 $
 * $Date: Tue Mar  8 12:54:50 2011 $
 * $Author: mironm $
 */

`ifndef QIRQ_PROXY__SV
`define QIRQ_PROXY__SV

`include "ovm_macros.svh"

import ovm_pkg::*;

/**
 * @brief QIRQ Proxy
 *
 * The QIRQ proxy Class (qirq_item) fetches items
 * from the sequencer and drives the HDL signals to implement
 * the sequence item.  It uses a XlSVEdgeDetector proxy
 * class to communicate to the hardware side. 
 * 
 * Usage Notes:<br>
 *
 * @class qirq_proxy
 *
 */
`ifndef PALLADIUM
import XlSvPkg::*;
  `include "XlSvEdgeDetector.svh"
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
   * @param num_items  int        - number of items that is expected in the 
   *                                pin map file
   * @param sig_array[MAX_NUM_SIGNALS] string 
   *                              - list of all the signal names that is created
   *                                after parsing the pin map file. 
   */
import "DPI-C" context function void qirq_dpii_init_signal_table(
  input string   pin_map_file,
  output int      num_items,                 
`ifndef PALLADIUM                                            
  output string  sig_array[MAX_NUM_SIGNALS]
`else
  output string  sig_array[]
`endif								 
);

   
class qirq_proxy  extends ovm_object;
  `ovm_object_utils(qirq_proxy)  ///< register qirq_proxy with the factory

  int            m_num_items;                    ///< maintains the number of items in signaltable
`ifndef PALLADIUM  
  XlSvEdgeDetector m_edge_detector_handle;         ///< handle to the XlSvEdgeDetector (proxy)
`else
  Pd_SvEdgeDetector m_edge_detector_handle;
`endif  
  string         m_sig_array[] = new[MAX_NUM_SIGNALS];  ///< list of signals in pin map file 

  /**
   * @brief Constructor
   * Method to construct this class
   * This requires the instance path to the XlEdgeDetector
   * module
   *
   * @param name string                        - name of class object
   * @param edge_detector_hdl_path string      - hdl instance path name 
   * @param edge_detector_pin_map_file string  - pathname to the pin map file
   */

  function new(string name= "qirq_proxy",
    string  edge_detector_hdl_path = "", 
    string  edge_detector_pin_map_file  =""
  );

    string  sigtable_elements;
    super.new(name);

    /// Initialize the XlSvEddgeDetector handle
    m_edge_detector_handle = new(edge_detector_hdl_path, edge_detector_pin_map_file);

    /// Initalize the sig_array by calling the DPI function to parse the pin map file
    qirq_dpii_init_signal_table(edge_detector_pin_map_file, m_num_items, m_sig_array);
    `ovm_info(get_type_name(), 
      $psprintf("SigTable obtained from %s(%d)  \n", edge_detector_pin_map_file, m_num_items),  
        OVM_LOW )

    /// Print out the signals obtained from pinmap file 
    for (int ii = 0; ii < m_num_items; ii++) begin
      sigtable_elements = {sigtable_elements, " ", m_sig_array[ii]};
    end
    $display("Sigtable_elements  = %s", sigtable_elements);          
    `ovm_info(get_type_name(),  $psprintf("SigTable: %s  \n",  sigtable_elements),  OVM_LOW )
  endfunction

  /**
   * @brief wait for any event on a given signal
   * This method when will go into blocking state till the given
   * signal changes state.  
   *
   * @param alias_name string  - name of the alias in the probegroup file
   * @param sig_loc int   - location of the sig in the probegroup file
   * @param expected_value bit[MAX_EDGE_VALUE_WIDTH-1:0]  - the value that
   *                     the simulator is waiting for on the given signal
   */

  extern task wait_for_edge(string alias_name,  int sig_loc,  output  bit[MAX_EDGE_VALUE_WIDTH-1:0] detected_value);   


   /**
   * @brief wait for a particular value on a given signal
   * This method when will go into blocking state till the given
   * signal is assigned a particular value
   *
   * @param alias_name string  - name of the alias in the probegroup file
   * @param sig_loc int   - location of the sig in the probegroup file
   * @param expected_value bit[MAX_EDGE_VALUE_WIDTH-1:0]  - the value that
   *                     the simulator is waiting for on the given signal
   */
  extern task wait_for_value(string alias_name,  int sig_loc,  bit[MAX_EDGE_VALUE_WIDTH-1:0] expected_value);   
   
endclass // qirq_proxy


//----------------------------------------------------------------------------------
//   disable_clock_gating
//----------------------------------------------------------------------------------   

  task  qirq_proxy::wait_for_edge(string alias_name, int sig_loc, 
    output bit [MAX_EDGE_VALUE_WIDTH-1:0] detected_value
  );

    int	  unsigned dValue[];
    int   i, j;
    
    string sig_name = alias_name;

    int    len = (MAX_EDGE_VALUE_WIDTH/32)+1;
    dValue = new[len];
    
      
    if(alias_name.len() == 0) begin
      // check if the sig loc is valid
      if (sig_loc < m_num_items) begin
        sig_name = m_sig_array[sig_loc];
      end
      else begin
        `ovm_error(get_type_name(), $psprintf("Invalid sig number in transaction "));     
      end
    end
    `ovm_info(get_type_name(), $psprintf("waitForEdge called on sig %s", sig_name), OVM_LOW)
`ifndef PALLADIUM    
//oldAPI    m_edge_detector_handle.waitForEdge(sig_name, detected_value);
    m_edge_detector_handle.waitForEdge(sig_name, dValue);
    detected_value = {MAX_EDGE_VALUE_WIDTH{1'b0}};
  
    for( j=0; j<len; j++) begin
      detected_value[j*32 +:  32] = dValue[j];
    end	
   
`else
    m_edge_detector_handle.waitForTransition(sig_name, detected_value);
`endif    
  endtask

//----------------------------------------------------------------------------------
//   disable_clock_gating
//----------------------------------------------------------------------------------   

  task qirq_proxy::wait_for_value(string alias_name,  int sig_loc, 
      bit[MAX_EDGE_VALUE_WIDTH-1:0] expected_value
  );

    
    int	    unsigned dValue[];
    int     i, j;
    
	   
    string sig_name = alias_name;

    int    len = (MAX_EDGE_VALUE_WIDTH/32)+1;
    dValue = new[len];
    for( j=0; j<len; j++) begin
      dValue[j] = expected_value[j*32 +:  32];
    end	
    
    if(alias_name.len()== 0) begin
      // check if the sig loc is valid
      if (sig_loc < m_num_items) begin
        sig_name = m_sig_array[sig_loc];
      end
      else begin
        `ovm_error(get_type_name(), $psprintf("Invalid sig number in transaction "));     
      end
    end
      
    /// make call to the EdgeTransactor
    `ovm_info(get_type_name(), $psprintf("waitForValue called on sig %s (value :%b)", sig_name, expected_value), OVM_LOW)
`ifndef PALLADIUM
//oldAPI    m_edge_detector_handle.waitForValue(sig_name, expected_value);
    m_edge_detector_handle.waitForValue(sig_name, dValue);
`else
    m_edge_detector_handle.waitForValue(sig_name, expected_value);
`endif    
    `ovm_info(get_type_name(), $psprintf("waitForValue finished on sig %s", sig_name), OVM_LOW)      
  endtask
   
`endif //  `ifndef QIRQ_PROXY__SV
   
