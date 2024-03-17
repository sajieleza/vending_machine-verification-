class sr_agent extends uvm_agent;
	
	`uvm_component_utils(sr_agent)
	
	sr_monitor monh;
	sr_driver drvh;
	sr_sequencer seqrh;
	env_config cfg;

	extern function new(string name="sr_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass

function sr_agent::new(string name="sr_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void sr_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
		`uvm_fatal(get_type_name(),"cannot get cfg,have you set it?")
	monh=sr_monitor::type_id::create("monh",this);
	if(cfg.is_active==UVM_ACTIVE)
		begin
			drvh=sr_driver::type_id::create("drvh",this);
			seqrh=sr_sequencer::type_id::create("seqrh",this);
		end
endfunction

function void sr_agent::connect_phase(uvm_phase phase);
	if(cfg.is_active==UVM_ACTIVE)
		drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction
