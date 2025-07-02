module top_module(
    input wire Resetn,
    input wire PClock,
	 input wire MClock,
    input wire Run,
    output wire Done,
    output [8:0] BusWires); 
	
	wire [8:0] data;
	wire [19:0] addr;
	
	
	 counter top_counter(.Resetn(Resetn), .MClock(MClock), .count(addr));
	 inst_mem top_mem(.address(addr), .clock(MClock), .q(data));
	procc top_proc(.DIN(data), .Resetn(Resetn), .Clock(PClock), .Run(Run)
	 , .Done(Done), .BusWires(BusWires));
	 
	 

	 
endmodule
