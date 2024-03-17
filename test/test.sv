class btest extends uvm_test;
//factory registration
	`uvm_component_utils(btest)
env envh;
env_config cfg;

bit has_dagent=1;
bit has_sagent=1;

extern function new(string name="btest",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void end_of_elaboration_phase(uvm_phase phase);

endclass

function btest::new(string name="btest",uvm_component parent);
	super.new(name,parent);
endfunction

function void btest::build_phase(uvm_phase phase);
	cfg=env_config::type_id::create("cfg");
	if(!uvm_config_db#(virtual vending_if)::get(this,"","vif",cfg.vif))
		`uvm_info(get_type_name(),"cannot get vif,have you set it?",UVM_LOW)
	cfg.has_sagent=has_sagent;
	cfg.has_dagent=has_dagent;
	super.build_phase(phase);
	uvm_config_db #(env_config)::set(this,"*","env_config",cfg);
	envh=env::type_id::create("envh",this);
endfunction

function void btest::end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction

class test1 extends btest;

	`uvm_component_utils(test1)
	sr_seq1 s1;
extern function new(string name="test1",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function test1::new(string name="test1",uvm_component parent);
	super.new(name,parent);
endfunction

function void test1::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task test1::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	s1=sr_seq1::type_id::create("sr_seq1");
	s1.start(envh.sagt.seqrh);
	#30;
	phase.drop_objection(this);
endtask

	
