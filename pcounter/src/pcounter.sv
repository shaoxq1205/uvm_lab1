// A simple counter with two interfaces
//  configuration - SRAM like interface
//  data_out - current count
//

`timescale 1ns/1ps


module pcounter (// Clocks / Reset
  input         clk,
  input         rst,
  // Configuration Interface - SRAM like
//  input         cfg_enable, 
//  input         cfg_rd_wr,   // rd = 1, wr = 0
//  input  [2:0]  cfg_addr,    // address
//  input  [9:0]  cfg_wdata,   // write data
//  output [9:0]  cfg_rdata,   // read data
  // Counter output
//  output  [9:0]  counter_o,
//  output  [1:0]  curr_state_o
  input [39:0]	data_in,
  output [39:0] data_out

);
// pragma attribute pcounter_int partition_module_xrtl  
   // Typedefs
//  typedef enum 	 logic[1:0] { CFG_COUNT_UP, CFG_COUNT_DOWN, CFG_SUSPEND } cfg_e;

   // Signal Declaration
//  logic [1:0] 	 csr_dir;  //count up or down
//  logic [9:0] 	 csr_min;  // min value
//  logic [9:0] 	 csr_max;  // max value
//  logic [9:0] 	 csr_step;  // step
//  reg [9:0] 	 count ;

//  reg [9:0] 	 tmpcount;  
  
//  logic [1:0] 	 curr_state;
//  logic [1:0] 	 next_state;
//  logic [9:0] 	 rdata;

  logic [39:0]	value;

  // Assign Local to Outputs
//  assign counter_o = count;
//  assign curr_state_o = curr_state;
//  assign cfg_rdata = rdata;
  assign data_out = value;
   

 
  always @(negedge clk) begin
    
    if(rst) begin
    	value <= 0; 
    end
    else begin
       value <= data_in + 1;
    end 
      $display("(%t)---------------------------------Current value =  %d--------------------------------------", $time, value);
    end // else: !if(~rst)

endmodule

