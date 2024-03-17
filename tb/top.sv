module top;

	import vending_test_pkg::*;
	import uvm_pkg::*;
	
	bit clock;
	always
		#10 clock=!clock;

	vending_if in(clock);
	
	coincol DUV(.clock(in.clock),.reset(in.reset),.coin_in(in.coin_in),.done_out(in.done_out),.lsb7seg_out(in.lsb7seg_out),.msb7seg_out(in.msb7seg_out));

	initial
	begin
	`ifdef VCS
	$fsdbDumpvars(0,top);
	`endif

	uvm_config_db #(virtual vending_if)::set(null,"*","vif",in);
	run_test();
	end
endmodule
	
