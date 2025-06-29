import uvm_pkg::*; 
`include "uvm_macros.svh"
import apb_test_pkg::*; 

module apb_top ();

bit i_clk_apb;
bit i_rstn_apb;

initial begin
       i_clk_apb = 0;
        forever begin 
            #5 i_clk_apb = ~i_clk_apb;
        end
    end

// Reset generation
  initial begin
    i_rstn_apb = 0;            // Start with reset asserted
    repeat (5) @(posedge i_clk_apb);  // Hold reset for 5 clocks
    i_rstn_apb = 1;            // Deassert reset
  end    

	slave_arb_if slv_inter(i_clk_apb,i_rstn_apb);
    apb_slave dut2(slv_inter); 


initial begin 
uvm_config_db#(virtual slave_arb_if)::set(null,"uvm_test_top","apb_IF",slv_inter);
run_test("apb_slave_test");
end
	
endmodule



  