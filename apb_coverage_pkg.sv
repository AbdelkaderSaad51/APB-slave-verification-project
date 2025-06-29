package apb_coverage_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_config_pkg::*;
import slave_apb_seq_item_pkg::*;

class apb_coverage extends uvm_subscriber#(slave_apb_seq_item);
  `uvm_component_utils(apb_coverage)

  slave_apb_seq_item slv_seq_item_cov;


    covergroup cov;
    slv_out_valid: coverpoint slv_seq_item_cov.o_valid {
			                  bins mast_out_valid_1 = {1};
        }
    slv_out_rd0_wr1: coverpoint slv_seq_item_cov.o_rd0_wr1 {
                        bins slv_out_rd0_wr1_1 = {0};
					            	bins slv_out_rd0_wr1_2 = {1};
        }
		slv_in_rd_valid: coverpoint slv_seq_item_cov.i_rd_valid {
                        bins slv_in_rd_valid_1 = {1};
        }
		slv_in_ready: coverpoint slv_seq_item_cov.i_ready {
                        bins slv_in_ready_1 = {1};
        }
		/////////////////////////////////////////////////////////////////////////
		slv_in_psel: coverpoint slv_seq_item_cov.i_psel {
                        bins slv_in_psel_1 = {1};
        }
		slv_in_penable: coverpoint slv_seq_item_cov.i_penable {
                        bins slv_in_penable_1 = {1};
        }
		slv_in_pwrite: coverpoint slv_seq_item_cov.i_pwrite {
			bins slv_read = {0};
			bins slv_write= {1};
        }
		
		slv_out_pready: coverpoint slv_seq_item_cov.o_pready {
			bins slv_out_pready_1 = {1};
        }
		//////////////////////////////////////////////////////////////////////////////////////////////	
        slv_l_0: cross slv_out_rd0_wr1,slv_out_valid;
        slv_l_1: cross slv_in_ready, slv_in_rd_valid ;
		
		slv_r_0: cross slv_in_psel, slv_in_penable;
     	slv_r_1: cross slv_in_psel, slv_in_pwrite ;
	    slv_r_2: cross slv_in_penable, slv_in_pwrite ;
	    slv_r_3: cross slv_in_pwrite, slv_out_pready ;
    endgroup

  function new(string name = "apb_coverage", uvm_component parent = null);
    super.new(name, parent);
    slv_seq_item_cov = slave_apb_seq_item::type_id::create("slv_seq_item_cov");
    cov = new(); // Ensure cov is instantiated here
  endfunction

	
  function void write(slave_apb_seq_item t);
    slv_seq_item_cov.copy(t);
    cov.sample();
  endfunction

endclass
endpackage

