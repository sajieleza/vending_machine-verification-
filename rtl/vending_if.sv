interface vending_if(input bit clock);
//signals
logic reset;
logic [1:0]coin_in;
logic done_out;
logic [6:0]lsb7seg_out;
logic [6:0]msb7seg_out;
//sdr_cb
clocking sdr_cb@(posedge clock);
	default input #1 output #1;
	output coin_in;
	output reset;
endclocking
//smon_cb
clocking smon_cb@(posedge clock);
	default input #1 output #1;
	input coin_in;
	input reset;
endclocking
//dmon_cb
clocking dmon_cb@(posedge clock);
	default input #1 output #1;
	input done_out;
	input lsb7seg_out;
	input msb7seg_out;
endclocking

//modports
modport SDR_MP(clocking sdr_cb);
modport SMON_MP(clocking smon_cb);
modport DMON_MP(clocking dmon_cb);

endinterface


