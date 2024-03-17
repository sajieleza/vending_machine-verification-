class source_seqs extends uvm_sequence#(sr_xtn);

	`uvm_object_utils(source_seqs)

extern function new(string name="source_seqs");

endclass
	
function source_seqs::new(string name="source_seqs");
	super.new(name);
endfunction

class sr_seq1 extends source_seqs;

	`uvm_object_utils(sr_seq1)
	static bit[1:0] xtn_num;

extern function new(string name="sr_seq1");
extern task body();

endclass
	
function sr_seq1::new(string name="sr_seq1");
	super.new(name);
endfunction

task sr_seq1::body();
	repeat(no_of_xtns)
	begin
	req=sr_xtn::type_id::create("req");
	start_item(req);
	//if(xtn_num==1)
	//begin
	//assert(req.randomize() with {reset==1;})
	//xtn_num++;
	//end
	//else
	assert(req.randomize() with {coin_in==xtn_num;})
	xtn_num++;
	finish_item(req);
	end
endtask


