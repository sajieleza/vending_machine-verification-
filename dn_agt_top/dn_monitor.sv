class dn_monitor extends uvm_monitor;

	`uvm_component_utils(dn_monitor)

uvm_analysis_port #(dn_xtn)monitor_port;
env_config cfg;
int dn_mon_xtn_cnt;
virtual vending_if.DMON_MP vif;
extern function new(string name="dn_monitor",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data(); 
extern function void report_phase(uvm_phase phase);
			
endclass

function dn_monitor::new(string name="dn_monitor",uvm_component parent);
	super.new(name,parent);
	monitor_port=new("monitor_port",this);
endfunction

function void dn_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
		`uvm_fatal(get_type_name(),"cannot get cfg,have you set it?")	
endfunction

function void dn_monitor::connect_phase(uvm_phase phase);
	vif=cfg.vif;
endfunction

task dn_monitor::run_phase(uvm_phase phase);
	forever
	collect_data();
endtask

task dn_monitor::collect_data();
	dn_xtn dmon_xtn;
	dmon_xtn=dn_xtn::type_id::create("dmon_xtn");
	repeat(3)	
	@(vif.dmon_cb);
//	@(vif.dmon_cb);
	dmon_xtn.done_out=vif.dmon_cb.done_out;
//	@(vif.dmon_cb);
        dmon_xtn.lsb7seg_out=vif.dmon_cb.lsb7seg_out;
//	@(vif.dmon_cb);
        dmon_xtn.msb7seg_out=vif.dmon_cb.msb7seg_out;
//	@(vif.dmon_cb);
	monitor_port.write(dmon_xtn);
	dn_mon_xtn_cnt++;
	//repeat(2)
		`uvm_info("Destination Monitor",$sformatf("%s",dmon_xtn.sprint()),UVM_LOW)


endtask

function void dn_monitor::report_phase(uvm_phase phase);
	`uvm_info("Destination Monitor Transaction Count",$sformatf("%0d",dn_mon_xtn_cnt),UVM_LOW)
endfunction

