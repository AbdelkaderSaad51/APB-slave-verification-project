package slave_apb_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import slave_apb_seq_item_pkg::*;
import apb_config_pkg::*;

class slave_apb_driver extends uvm_driver #(slave_apb_seq_item);
   `uvm_component_utils(slave_apb_driver)

   virtual slave_arb_if vif;
   

   function new(string name = "slave_apb_driver", uvm_component parent = null);
      super.new(name, parent);
   endfunction


task run_phase(uvm_phase phase);
  slave_apb_seq_item slv_stim_seq_item;

  forever begin
    // Create a new transaction each time
    slv_stim_seq_item = slave_apb_seq_item::type_id::create("slv_stim_seq_item");

    // Wait for reset deassertion
    @(posedge vif.i_clk_apb);
    while (vif.i_rstn_apb == 0)
    @(posedge vif.i_clk_apb);

    // Optional: Random delay before starting transaction
    repeat ($urandom_range(0, 2)) @(posedge vif.i_clk_apb); // 0–2 idle clocks

    // Get next item from sequencer
    seq_item_port.get_next_item(slv_stim_seq_item);

    // SETUP PHASE
    vif.i_paddr   <= slv_stim_seq_item.i_paddr;
    vif.i_pwdata  <= slv_stim_seq_item.i_pwdata;
    vif.i_pwrite  <= slv_stim_seq_item.i_pwrite;
    vif.i_psel    <= 1'b1;
    vif.i_penable <= 1'b0;
    vif.i_ready   <= 1'b0; // Default to not ready

    @(posedge vif.i_clk_apb);

    // ACCESS PHASE
    vif.i_penable <= 1'b1;

    // Optional: Random delay before asserting i_ready (simulate backpressure)
    repeat ($urandom_range(0, 3)) @(posedge vif.i_clk_apb); // 0–3 clock delay
    vif.i_ready <= 1'b1;

    if (slv_stim_seq_item.i_pwrite == 0) begin // Read
      `uvm_info("DRV", "Starting APB Read Transaction", UVM_LOW)
      vif.i_rd_data<=slv_stim_seq_item.i_rd_data;
      vif.i_rd_valid <= 1'b1;


      // Wait for DUT to respond with o_pready
      while (!vif.o_pready)
        @(posedge vif.i_clk_apb);
        
       vif.i_rd_valid <= 1'b0;
      // Deassert i_ready after transaction
      vif.i_ready <= 1'b0;

    end else begin // Write
      `uvm_info("DRV", "Starting APB Write Transaction", UVM_LOW)

      // Wait for DUT to respond with o_pready
      while (!vif.o_pready)
        @(posedge vif.i_clk_apb);

      // Deassert i_ready after transaction
      vif.i_ready <= 1'b0;
    end

    // Deassert control signals
    vif.i_penable <= 1'b0;
    vif.i_psel    <= 1'b0;

    // Optional: Delay before next transaction
    repeat ($urandom_range(0, 2)) @(posedge vif.i_clk_apb);

    // Log completion
    `uvm_info("Driver", $sformatf("Transaction completed: %s", slv_stim_seq_item.convert2string()), UVM_HIGH)

    // Finish transaction
    seq_item_port.item_done();
  end
endtask
endclass
endpackage

