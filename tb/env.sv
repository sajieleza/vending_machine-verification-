class env extends uvm_env;

	`uvm_component_utils(env)

	sr_agent sagt;
	dn_agent dagt;
	scoreboard sb;
	env_config cfg;

	extern function new(string name="env",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass
function env::new(string name="env",uvm_component parent);
	super.new(name,parent);
endfunction

function void env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
		`uvm_fatal(get_type_name(),"cannot get cfg,have you set it?")
	if(cfg.has_sagent)
		sagt=sr_agent::type_id::create("sagt",this);
	if(cfg.has_dagent)
		dagt=dn_agent::type_id::create("dagt",this);
	if(cfg.has_sb)
		sb=scoreboard::type_id::create("sb",this);
endfunction

function void env::connect_phase(uvm_phase phase);
	if(cfg.has_sb)
		begin
			if(cfg.has_sagent)
				sagt.monh.monitor_port.connect(sb.fifo_srh.analysis_export);
			if(cfg.has_dagent)
				dagt.monh.monitor_port.connect(sb.fifo_dth.analysis_export);
		end
endfunction
