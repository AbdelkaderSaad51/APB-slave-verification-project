package slave_apb_seq_item_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

class slave_apb_seq_item extends uvm_sequence_item;


parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 32;
///////////// right side ///////////////////////
bit [DATA_WIDTH-1:0] o_wr_data;
bit [ADDR_WIDTH-1:0] o_addr;
bit  o_valid, o_rd0_wr1;
rand bit [DATA_WIDTH-1:0] i_rd_data;
rand bit i_rstn_apb,i_rd_valid, i_ready;

////////// left side /////////////
rand bit [DATA_WIDTH-1:0] i_pwdata;
rand bit [ADDR_WIDTH-1:0] i_paddr;
rand bit i_psel, i_penable, i_pwrite;
bit [DATA_WIDTH-1:0] o_prdata;
bit o_pslverr, o_pready;



// UVM Utility Macros
  `uvm_object_utils_begin(slave_apb_seq_item)
    `uvm_field_int(o_wr_data, UVM_DEFAULT)
    `uvm_field_int(o_addr, UVM_DEFAULT)
    `uvm_field_int(i_rstn_apb, UVM_DEFAULT)
    `uvm_field_int(o_valid, UVM_DEFAULT)
    `uvm_field_int(o_rd0_wr1, UVM_DEFAULT)

    `uvm_field_int(o_prdata, UVM_DEFAULT)
    `uvm_field_int(i_rd_valid, UVM_DEFAULT)
    `uvm_field_int(i_ready, UVM_DEFAULT)

    `uvm_field_int(i_pwdata, UVM_DEFAULT)
    `uvm_field_int(i_paddr, UVM_DEFAULT)
    `uvm_field_int(i_psel, UVM_DEFAULT)
    `uvm_field_int(i_penable, UVM_DEFAULT)
    `uvm_field_int(i_pwrite, UVM_DEFAULT)

    `uvm_field_int(i_rd_data, UVM_DEFAULT)
    `uvm_field_int(o_pslverr, UVM_DEFAULT)
    `uvm_field_int(o_pready, UVM_DEFAULT)
  `uvm_object_utils_end



function new(string name ="slave_apb_seq_item");
super.new(name);
endfunction


function string convert2string(); 
return $sformatf("%s i_rstn_apb = 0b%0b,o_wr_data = 0b%0b, o_addr = 0b%0b, o_valid = 0b%0b, o_rd0_wr1 = 0b%0b, i_rd_data = 0b%0b , i_rd_valid = 0b%0b, i_ready = 0b%0b, i_pwdata = 0b%0b, i_paddr = 0b%0b, i_psel = 0b%0b, i_penable = 0b%0b, i_pwrite = 0b%0b, o_prdata = 0b%0b, o_pslverr = 0b%0b, o_pready = 0b%0b",super.convert2string, i_rstn_apb,o_wr_data, o_addr, o_valid, o_rd0_wr1,i_rd_data,i_rd_valid,i_ready,i_pwdata,i_paddr,i_psel,i_penable,i_pwrite,o_prdata,o_pslverr,o_pready);
endfunction


function string convert2string_stimulus(); 
return $sformatf("i_rstn_apb = 0b%0b,o_wr_data = 0b%0b, o_addr = 0b%0b, o_valid = 0b%0b, o_rd0_wr1 = 0b%0b, o_rd_data = 0b%0b , o_rd_valid = 0b%0b, o_ready = 0b%0b, o_pwdata = 0b%0b, o_paddr = 0b%0b, o_psel = 0b%0b, i_penable = 0b%0b, i_pwrite = 0b%0b, o_prdata = 0b%0b, o_pslverr = 0b%0b, o_pready = 0b%0b", i_rstn_apb,o_wr_data, o_addr, o_valid, o_rd0_wr1, i_rd_data,i_rd_valid,i_ready,i_pwdata,i_paddr,i_psel,i_penable,i_pwrite,o_prdata,o_pslverr,o_pready);
endfunction


////////////////////////////////


    // Separate constraints for read and write transactions
    constraint read_c {
       i_pwrite == 1'b0;
   
    }

    constraint write_c {
        i_pwrite == 1'b1;
        i_pwdata inside {[0 : (1<<DATA_WIDTH)-1]};  // Range constraint for data width
    }

    // Address constraint common to both read and write
    constraint addr_c {
        i_paddr inside {[0 : (1<<ADDR_WIDTH)-1]};
    }

endclass

endpackage
