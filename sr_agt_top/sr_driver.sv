class sr_driver extends uvm_driver #(sr_xtn);
	
	`uvm_component_utils(sr_driver)
static int sr_drv_xtn_cnt;
env_config cfg;
virtual vending_if.SDR_MP vif;
extern function new(string name="sr_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(sr_xtn xtn); 
extern function void report_phase(uvm_phase phase);
			
endclass

function sr_driver::new(string name="sr_driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void sr_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
		`uvm_fatal(get_type_name(),"cannot get cfg,have you set it?")	
endfunction

function void sr_driver::connect_phase(uvm_phase phase);
	vif=cfg.vif;
endfunction

task sr_driver::run_phase(uvm_phase phase);
//	@(vif.sdr_cb);
//	vif.sdr_cb.reset<=1;
//	@(vif.sdr_cb);
//	vif.sdr_cb.reset<=0;
	forever
	begin
	seq_item_port.get_next_item(req);
	send_to_dut(req);
	seq_item_port.item_done();
	end
endtask

task sr_driver::send_to_dut(sr_xtn xtn);
	@(vif.sdr_cb);
	vif.sdr_cb.reset<=xtn.reset;
//	@(vif.sdr_cb);
//	@(vif.sdr_cb);
	vif.sdr_cb.coin_in<=xtn.coin_in;
        repeat(2)
	@(vif.sdr_cb);
	sr_drv_xtn_cnt++;
	`uvm_info("Source Driver",$sformatf("%0s",xtn.sprint()),UVM_LOW)

endtask
function void sr_driver::report_phase(uvm_phase phase);
	`uvm_info("Source Driver Transaction Count",$sformatf("%0d",sr_drv_xtn_cnt),UVM_LOW)
endfunction


