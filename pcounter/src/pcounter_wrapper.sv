// A simple counter with two interfaces
//  configuration - SRAM like interface
//  data_out - current count
//

`timescale 1ns/1ps



module pcounter_wrapper(
  input         clk,
  input         rst,
  input [39:0]  data_in,
  output [39:0] data_out
);

// pragma attribute pcounter partition_module_xrtl  

//  logic		cfg_enable_sig;
//  logic         cfg_rd_wr_sig;
//  logic [2:0] 	cfg_addr_sig;
//  logic [9:0] 	cfg_wdata_sig;
//  logic [9:0] 	cfg_rdata_sig;
//  logic [9:0] 	counter_o_sig;
//  logic [1:0] 	curr_state_o_sig;
//  logic [39:0] data_in_sig;
// logic [39:0] data_out_sig;

  pcounter pcounter_i(
    .clk(clk), 
    .rst(rst),
    .data_in(data_in),
    .data_out(data_out)
 //   .cfg_enable(cfg_enable_sig),
 //   .cfg_rd_wr(cfg_rd_wr_sig),
 //   .cfg_addr(cfg_addr_sig),
 //   .cfg_wdata(cfg_wdata_sig),
 //   .cfg_rdata(cfg_rdata_sig),
 //   .counter_o(counter_o_sig),
 //   .curr_state_o(curr_state_o_sig)
  );
		
		
endmodule // pcounter_wrapper

