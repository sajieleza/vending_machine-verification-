class dn_xtn extends uvm_sequence_item;

	`uvm_object_utils(dn_xtn)

//properties
bit done_out;
bit [6:0] lsb7seg_out;
bit [6:0] msb7seg_out;
//methods
extern function new(string name="dn_xtn");
extern function void do_print(uvm_printer printer);
//extern function bit do_compare(uvm_object rhs,uvm_comparer comparer);
endclass

function dn_xtn::new(string name="dn_xtn");
	super.new(name);
endfunction 

function void dn_xtn::do_print(uvm_printer printer);
	super.do_print(printer);
	printer.print_field("lsb7seg_out",this.lsb7seg_out,7,UVM_DEC);
	printer.print_field("msb7seg_out",this.msb7seg_out,7,UVM_DEC);
 	printer.print_field("done_out",this.done_out,1,UVM_DEC);

endfunction

//function bit dn_xtn::do_compare(uvm_object rhs,uvm_comparer comparer);
//	dn_xtn rhs_;
//	if($cast(rhs_,rhs))
//	begin
//		`uvm_fatal("do compare","cast of the rhs object failed")
//		return 0;
//	end
//	return super.do_compare(rhs,comparer) && (done_out== rhs_.done_out)&&(msb7seg_out==rhs_.msb7seg_out)&&(lsb7seg_out==rhs_.lsb7seg_out);
//endfunction
