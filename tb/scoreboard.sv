class scoreboard extends uvm_scoreboard;

	`uvm_component_utils(scoreboard)

	uvm_tlm_analysis_fifo#(sr_xtn) fifo_srh;
	uvm_tlm_analysis_fifo#(dn_xtn) fifo_dth;
	env_config cfg;
	sr_xtn sr_data,sr_cov_data;
	dn_xtn dn_data;
	dn_xtn expected_output;
	int dn_pkt;
	int sr_pkt;
	int data_verified_count;
	extern function new(string name="scoreboard",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task ref_logic(); 
	extern task check_data();
	extern function void report_phase(uvm_phase phase);

covergroup fcov1;
	option.per_instance=1;
	RESET:coverpoint sr_cov_data.reset{bins rst1={1};
					   bins rst0={0};}
	COIN_IN:coverpoint sr_cov_data.coin_in{bins low={2'b00};
						bins mid={2'b01};
						bins high={2'b10};}
	RESET_X_COIN_IN:cross RESET,COIN_IN;
endgroup


endclass

function scoreboard::new(string name="scoreboard",uvm_component parent);
	super.new(name,parent);
	fcov1=new();
endfunction

function void scoreboard::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(env_config)::get(this,"","env_config",cfg))
		`uvm_info(get_type_name(),"cannot get env,have you set it?",UVM_LOW)
	sr_data=sr_xtn::type_id::create("sr_data");
	dn_data=dn_xtn::type_id::create("dn_data");
	expected_output=dn_xtn::type_id::create("expected_output");
	fifo_srh=new("fifo_srh",this);
	fifo_dth=new("fifo_dth",this);
endfunction

task scoreboard::run_phase(uvm_phase phase);
	forever
	begin
	fifo_srh.get(sr_data);
	sr_pkt++;
	`uvm_info(get_type_name(),$sformatf("SCOREBOARD SOURCE TRANSACTION %s",sr_data.sprint()),UVM_LOW)
	
	fifo_dth.get(dn_data);
	dn_pkt++;
	`uvm_info(get_type_name(),$sformatf("SCOREBOARD DESTINATION TRANSACTION %s",dn_data.sprint()),UVM_LOW)
	
	ref_logic();
	`uvm_info(get_type_name(),$sformatf("Expected output in sb %s",expected_output.sprint()),UVM_LOW)
	check_data();
	
	end	
endtask

task scoreboard::ref_logic();
	begin
//	bit [2:0] ps,ns;
	typedef  enum bit[2:0]{s0=3'b000,s1=3'b001,s2=3'b010,s3=3'b011,s4=3'b100} state;
	state ps,ns;
	
	ps=ns;
 if((!sr_data.reset) && sr_data.coin_in===2'b10)
	ns=s4;
	else if((!sr_data.reset) && sr_data.coin_in===2'b00)
	ns=ps.next(ps+1);
	else if((!sr_data.reset) && sr_data.coin_in===2'b01)
	ns=ps.next(2);
	else if((!sr_data.reset) && sr_data.coin_in===2'b11)
	ns=ps;
	else
	ns=s0;

//go to state 25
        case(ns)
	s0:
         begin
        expected_output.done_out=1'b0;
        expected_output.lsb7seg_out=7'b1000000;//64
        expected_output.msb7seg_out=7'b1000000;//64
	ps=ns;
        end
       s1: begin
        expected_output.done_out=1'b0;
        expected_output.lsb7seg_out=7'b0100100;//36
        expected_output.msb7seg_out=7'b0010100;//20
        ps=ns;
	end
//go to100
        
        
//go to 50
       s2:
        begin
        expected_output.done_out=1'b0;
        expected_output.lsb7seg_out=7'b0100010;//34
        expected_output.msb7seg_out=7'b1000000;//64
        ps=ns;
	end
//go to 75
        s3:
        begin
        expected_output.done_out=1'b0;
        expected_output.lsb7seg_out=7'b1111000;//120
        expected_output.msb7seg_out=7'b0010010;//18
        ps=ns;
	end
	  s4:begin
        expected_output.done_out=1'b1;
        expected_output.lsb7seg_out=7'b0001001;//9
        expected_output.msb7seg_out=7'b0001000;//8
        ps=ns;	
	end

	default:
         begin
        expected_output.done_out=1'b0;
        expected_output.lsb7seg_out=7'b1000000;//64
        expected_output.msb7seg_out=7'b1000000;//64
        ps=ns;
	end

endcase
end
endtask

task scoreboard::check_data();
	if(expected_output.done_out==dn_data.done_out)
		`uvm_info(get_type_name(),"COMPARISON SUCCESS",UVM_LOW)
	else
		`uvm_info(get_type_name(),"COMPARISON FAIL",UVM_LOW)
	if(expected_output.lsb7seg_out==dn_data.lsb7seg_out)
                `uvm_info(get_type_name(),"COMPARISON SUCCESS",UVM_LOW)
        else
                `uvm_info(get_type_name(),"COMPARISON FAIL",UVM_LOW)

	if(expected_output.msb7seg_out==dn_data.msb7seg_out)
                `uvm_info(get_type_name(),"COMPARISON SUCCESS",UVM_LOW)
        else
                `uvm_info(get_type_name(),"COMPARISON FAIL",UVM_LOW)
	data_verified_count++;
	sr_cov_data=sr_data;
	fcov1.sample();
	

endtask

function void scoreboard::report_phase(uvm_phase phase);
	$display("\n....................SCOREBOARD REPORT..............................\n");
	$display("SOURCE MONITOR TRANSACTION IN SB: %0d \n",sr_pkt);
	$display("DESTINATION MONITOR TRANSACTION IN SB: %0d \n",dn_pkt);
	$display("NO OF TRANSACTIONS COMPARED IN SB: %0d \n",data_verified_count);
	$display("\n...................................................................\n");
endfunction



	
