package apb_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import slave_apb_seq_item_pkg::*;
import apb_config_pkg::*;

class apb_scoreboard extends uvm_subscriber #(slave_apb_seq_item);
  `uvm_component_utils(apb_scoreboard)

  // Counters
  int write_count = 0;
  int read_count = 0;

  function new(string name = "apb_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void write(slave_apb_seq_item t);
    if (t.i_pwrite) begin
      write_count++;
      `uvm_info("WRITE_XACT",
        $sformatf("Write Transaction: ADDR=0x%0h, WDATA=0x%0h",
                   t.i_paddr, t.i_pwdata), UVM_MEDIUM)
    end else begin
      read_count++;
      `uvm_info("READ_XACT",
        $sformatf("Read Transaction: ADDR=0x%0h, RDATA=0x%0h",
                   t.i_paddr, t.o_prdata), UVM_MEDIUM)
    end
  endfunction

  virtual function void report_phase(uvm_phase phase);
    `uvm_info("REPORT", $sformatf("Total Transactions:\n  Writes: %0d\n  Reads: %0d", write_count, read_count), UVM_LOW)
  endfunction

endclass
endpackage