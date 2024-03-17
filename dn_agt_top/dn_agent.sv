class dn_agent extends uvm_agent;
	
	`uvm_component_utils(dn_agent)
	dn_monitor monh;
	env_config cfg;
	
	extern function new(string name="dn_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass

function dn_agent::new(string name="dn_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void dn_agent::build_phase(uvm_phase phase);
	 super.build_phase(phase);
	monh=dn_monitor::type_id::create("monh",this);

endfunction
