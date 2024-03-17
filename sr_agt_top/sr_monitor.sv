class sr_monitor extends uvm_monitor;
	
	`uvm_component_utils(sr_monitor)
int sr_mon_xtn_cnt;
env_config cfg;
virtual vending_if.SMON_MP vif;
uvm_analysis_port #(sr_xtn)monitor_port;
extern function new(string name="sr_monitor",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data(); 
extern function void report_phase(uvm_phase phase);
			
endclass

function sr_monitor::new(string name="sr_monitor",uvm_component parent);
	super.new(name,parent);
	monitor_port=new("monitor_port",this);
endfunction

function void sr_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
		`uvm_fatal(get_type_name(),"cannot get cfg,have you set it?")	
endfunction

function void sr_monitor::connect_phase(uvm_phase phase);
	vif=cfg.vif;
endfunction
task sr_monitor::run_phase(uvm_phase phase);
	forever 
	begin
	collect_data();
	end
endtask

task sr_monitor::collect_data();
	sr_xtn smon_xtn;
	smon_xtn=sr_xtn::type_id::create("smon_xtn");	
	repeat(2)	
	@(vif.smon_cb);
	smon_xtn.reset=vif.smon_cb.reset;
//	@(vif.smon_cb);
 //	@(vif.smon_cb);
//	@(vif.smon_cb);
	smon_xtn.coin_in=vif.smon_cb.coin_in;
//	repeat(2)
	@(vif.smon_cb);
	sr_mon_xtn_cnt++;
	monitor_port.write(smon_xtn);
	`uvm_info("Source Monitor",$sformatf("%0s",smon_xtn.sprint()),UVM_LOW)
	
endtask
function void sr_monitor::report_phase(uvm_phase phase);
	 `uvm_info("Source Monitor Transaction Count",$sformatf("%0d",sr_mon_xtn_cnt),UVM_LOW)
endfunction



