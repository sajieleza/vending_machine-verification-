class sr_sequencer extends uvm_sequencer #(sr_xtn);

	`uvm_component_utils(sr_sequencer)

extern function new(string name="sr_sequencer",uvm_component parent);

endclass

function sr_sequencer::new(string name="sr_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction
