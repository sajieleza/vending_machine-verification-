package vending_test_pkg;
	//import uvm_pkg.sv

int no_of_xtns=10;
	import uvm_pkg::*;
//include uvm_macros.sv
`include "uvm_macros.svh"
`include "sr_xtn.sv"
`include "env_config.sv"
`include "sr_driver.sv"
`include "sr_monitor.sv"
`include "sr_sequencer.sv"
`include "sr_agent.sv"
`include "sr_seqs.sv"

`include "dn_xtn.sv"
`include "dn_monitor.sv"
`include "dn_agent.sv"

`include "scoreboard.sv"

`include "env.sv"


`include "test.sv"
endpackage
