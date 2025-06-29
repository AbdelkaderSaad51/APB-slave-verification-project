
package apb_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

import slave_apb_agent_pkg::*;
import apb_scoreboard_pkg::*;
import apb_coverage_pkg::*;
import slave_apb_sequencer_pkg::*; 
import apb_config_pkg::*;

class apb_env extends uvm_env;
   `uvm_component_utils(apb_env)
   
   slave_apb_agent slv_agt;
   apb_scoreboard sb;
   apb_coverage cov;


   function new(string name = "apb_env", uvm_component parent = null);
      super.new(name, parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
	   slv_agt = slave_apb_agent::type_id::create("slv_agt", this);
      sb = apb_scoreboard::type_id::create("sb", this);
      cov = apb_coverage::type_id::create("cov", this);
   endfunction // build_phase
   
   function void connect_phase(uvm_phase phase);
      slv_agt.agt_ap.connect(sb.analysis_export);
      slv_agt.agt_ap.connect(cov.analysis_export);
   endfunction
endclass
endpackage
