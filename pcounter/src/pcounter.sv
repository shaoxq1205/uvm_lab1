// A simple counter with two interfaces
//  configuration - SRAM like interface
//  data_out - current count
//

`timescale 1ns/1ps


module pcounter (// Clocks / Reset
  input         clk,
  input         rst,
  // Configuration Interface - SRAM like
  input         cfg_enable, 
  input         cfg_rd_wr,   // rd = 1, wr = 0
  input  [2:0]  cfg_addr,    // address
  input  [9:0]  cfg_wdata,   // write data
  output [9:0]  cfg_rdata,   // read data
  // Counter output
  output  [9:0]  counter_o,
  output  [1:0]  curr_state_o
);
// pragma attribute pcounter_int partition_module_xrtl  
   // Typedefs
  typedef enum 	 logic[1:0] { CFG_COUNT_UP, CFG_COUNT_DOWN, CFG_SUSPEND } cfg_e;

   // Signal Declaration
  logic [1:0] 	 csr_dir;  //count up or down
  logic [9:0] 	 csr_min;  // min value
  logic [9:0] 	 csr_max;  // max value
  logic [9:0] 	 csr_step;  // step
  reg [9:0] 	 count ;

  reg [9:0] 	 tmpcount;  
  
  logic [1:0] 	 curr_state;
  logic [1:0] 	 next_state;
  logic [9:0] 	 rdata;

  // Assign Local to Outputs
  assign counter_o = count;
  assign curr_state_o = curr_state;
  assign cfg_rdata = rdata;
   

   // CFG Interface FSM - just to have an FSM in the design
  always_comb begin
      
    case (csr_dir)
      2'b00: begin
	next_state = CFG_COUNT_UP;
      end
      2'b01:  begin
        next_state = CFG_COUNT_DOWN;
      end
      2'b10:  begin
	next_state = CFG_SUSPEND;
      end
      default: begin
	next_state = CFG_COUNT_UP;
      end
    endcase
  end


  always @(negedge clk) begin
    
    if(rst) begin
      csr_dir <= 0;  //count up 
      csr_min <= 10; // min value
      csr_max <= 100;  //max_value
      csr_step <= 1;  //max_value
      count <= csr_min;  
    end
    else begin
       
      curr_state = next_state;

      //Update registers for read and Updte 
      if(cfg_enable) begin	// Set cfg_enable = 1 for reading and writing registers
	if(cfg_rd_wr) begin   // Reading data from internal registers
	  case (cfg_addr)
	    2'b00: begin
	      rdata <= csr_dir;
	      $display("Reading  CSR_DIR register (value = %b)", rdata);	      
	    end
	    2'b01: begin
	      rdata <= csr_min;
	      $display("Reading  CSR_MIN register (value = %b)", rdata);	      	      
	    end
	    2'b10: begin
	      rdata <= csr_max;
	      $display("Reading  CSR_MAX register (value = %b)", rdata);	      	      
	    end	    
	    2'b11: begin
	      rdata <= csr_step;
	      $display("Reading  CSR_STEP register (value = %b)", rdata);	      	      
	    end	    
	  endcase // case (cfg_addr)
	end // if (cfg_rd_wr)
	else begin         // Writing data to registers
	  case (cfg_addr)
	    2'b00: begin
	      csr_dir <= cfg_wdata;
	      $display("Wrote CSR_DIR register with %b", cfg_wdata);
	    end
	    2'b01: begin
	      csr_min <= cfg_wdata;
	      $display("Wrote CSR_MIN register with %b", cfg_wdata);	      
	    end
	    2'b10: begin
	      csr_max <= cfg_wdata ;
	      $display("Wrote CSR_MAX register with %b", cfg_wdata);	      	      
	    end	    
	    2'b11: begin
	      csr_step <= cfg_wdata;
	      $display("Wrote CSR_STEP register with %b", cfg_wdata);	      	      	      
	    end	    
	  endcase // case (cfg_addr)
	end // else: !if(cfg_rd_wr)
      end // if (cfg_enable)
      
      case (csr_dir) 
	2'b00: begin
	  if(count >= csr_max) begin
	    count <= csr_min;	
	  end
	  else begin  
	    count <= count + csr_step;
	  end
	end
     
	2'b01: begin
	  if(count <= csr_min) begin	
	    count <= csr_max;
	  end	
	  else begin
	    count <= count - csr_step;
	  end
	 end

	default: begin
	end
	
      endcase // case csr_dir)
      $display("(%t)Count value =  %d", $time, count);
    end // else: !if(~rst)
  end // always @ (posedge clk)
endmodule

