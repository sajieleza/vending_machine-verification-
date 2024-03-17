class env_config extends uvm_object;

	`uvm_object_utils(env_config)
	
	virtual vending_if vif;
	
	bit has_sagent=1;
	bit has_dagent=1;
	bit has_sb=1;
 	uvm_active_passive_enum is_active=UVM_ACTIVE;

extern function new(string name="env_config");

endclass

function env_config::new(string name="env_config");
	super.new(name);
endfunction
