class sr_xtn extends uvm_sequence_item;

	`uvm_object_utils(sr_xtn)

//properties
randc bit[1:0]coin_in;
rand bit reset;

//constraints
//constraint c1{coin_in inside {[0:3]};}
constraint c2{reset dist {1:=20, 0:=80};}

//methods
extern function new(string name="sr_xtn");
extern function void do_print(uvm_printer printer);
//extern function void post_randomize();

endclass 

function sr_xtn::new(string name="sr_xtn");
	super.new(name);
endfunction

function void sr_xtn::do_print(uvm_printer printer);
	super.do_print(printer);
	printer.print_field("coin_in",this.coin_in,2,UVM_DEC);
	printer.print_field("reset",this.reset,1,UVM_DEC);
endfunction


