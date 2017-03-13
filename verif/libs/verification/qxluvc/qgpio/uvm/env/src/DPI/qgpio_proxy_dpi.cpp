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
 * @brief QGPIO PROXY DPI functions
 *
 * The QGPIO PROXY DPI functions c++ implementation. 
 *
 * @file qgpio_proxy_dpi.cpp
 *
 * @author Loganath Ramachandran
 * @par Contact:
 * c_lramac@qualcomm.com
 * @par Location:
 * QC-SD
 *
 * $Revision: 1.2 $
 * $Date: Tue Mar  8 12:54:51 2011 $
 * $Author: mironm $
 */

#ifndef QGPIO_PROXY_DPI__CPP
#define QGPIO_PROXY_DPI__CPP



#include <string> 
#include <stdio.h>
#include <fstream>
#include <iostream>
#include <sstream>
#include <cstdlib>
#include <vector>
#include "svdpi.h"
#include <vpi_user.h>

using namespace std;
using std::string;


extern "C" {

//---------------------------------------------------------
// Exported DPI-C functions
//------------------------------------------------

  /**
   * @brief qgpio_dpii_initi_signal_table
   * DPI function to parse the pin map file and return the 
   * alias names specified in the file 
   *
   * @param pin_map_file (const char *) - pin map file location 
   * @param num_items    (int) - number of elements returned
   * @param sigtable[]  (char *) - array containaing the returned items
   */


void qgpio_dpii_init_signal_table( const char *pin_map_file,
				   int *num_items, 
#ifndef PALLADIUM
				   char * sigtable[],
				   int  dir_array[]
#else
				   svOpenArrayHandle str_array_handle, 
				   svOpenArrayHandle str_dir_handle
#endif
)
{

  ifstream ifile;    ///<filestream for the pin map file
  string line_read;  ///< each line read from the file 
  string temp_buffer;     ///< temp string buffer 
  vector<string> tokens;   ///< vector of tokens created during parsing
  int curr_line; /// curr_line  being processed

#ifdef PALLADIUM
  char** str_array = (char**)svGetArrayPtr(str_array_handle);
  int*  dir_array = (int*)svGetArrayPtr(str_dir_handle);
#endif

  vpi_printf("Parsing the file %s\n", pin_map_file);

  curr_line = 0;
  // Open the file and check if it exists
  ifile.open(pin_map_file);
  if (!ifile) {
    cout << "Error: Could not open pin map file " << pin_map_file << endl;
  }

  // Read each line 
  while (std::getline(ifile, line_read))
  {

    // We are going to store the tokens in a vector
    // We need to clean this vector for each iteration
    tokens.clear();

    istringstream iss (line_read, istringstream::in);
    //    ss.clear();
    //    ss.str("");

    // cout << "line Read " << line_read  << endl;

    // update the vector of tokens
    while (iss >> temp_buffer){
      tokens.push_back(temp_buffer);
    }
 
    if(tokens.size() == 0) {
      // empty line
      continue;
    }
      

    // First let us check if this is a comment string 
    // If so we will ignore the line

    if(tokens.size() >= 1) {
      int pos = tokens[0].find("#");
      if(pos == 0) {     
	// First token contains a 0 in zeroth position
	// So this is a comment line. Ignore and continue
	continue;
      }
    }

    /// Now let us search for valid lines. 
    // A valid line should have 4 tokens exactly

    if(tokens.size() != 4) { //probably invalid line
      cout << "Error: Invalid line in pinmap file  " << curr_line <<  endl;
      return;
    }

    // tokens[2] contains the alias name 
    // Update the sig_table array with tokens[2] value
    string alias_name(tokens[2]);
    string dir(tokens[1]);

    char *new_str_ptr = (char *) malloc(tokens[2].size()+1);
    strcpy(new_str_ptr,  tokens[2].c_str());
#ifndef PALLADIUM
    sigtable[curr_line]= new_str_ptr;
#else
    str_array[curr_line] = new_str_ptr;
#endif

    if(!strcmp(dir.c_str(),  "input"))
      dir_array[curr_line] = 1;
    else
      dir_array[curr_line] = 0;

    curr_line++;


  }

  *num_items = curr_line;
  vpi_printf("Completed  reading the .dat  file\n");

}

};

#endif 
