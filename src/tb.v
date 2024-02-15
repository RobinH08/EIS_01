/*
Simple testbench for the counter .
*/

`timescale 1ns/1ns

`include "tt_um_flappy_bird.v"

module tt_um_flappy_bird_tb;

	parameter gs = 8;
 	// define I /O ’ s of the module
 	reg clk_i =1'b0; // clock
 	reg rst_i =1'b0; // reset
	reg ena_i = 1'b0;
 	
 	reg [gs-1:0] ui_in_i = 8'b0 ;
 	reg [gs-1:0] uio_in_i = 8'b0;	//not used
	
 	wire [gs-1:0] uo_out_o;		//col
 	wire [gs-1:0] uio_out_o; 	//row
 	
 	wire [gs-1:0] uio_oe_o;	

	// DUT
	tt_um_flappy_bird
		tt_um_flappy_bird_dut (
		.clk (clk_i),
		.ui_in ( ui_in_i ) ,
		.uo_out ( uo_out_o ) ,
		.uio_in (uio_in_i) ,	//not used	
		.uio_out(uio_out_o),
		.uio_oe(uio_oe_o),
		.ena(ena_i) ,
		.rst_n(rst_i)
		);

	// Generate clock
	/* verilator lint_off STMTDLY */
	always begin
	#5 clk_i = ~clk_i;
	end
	
	/* verilator lint_on STMTDLY */

	always @ (posedge clk_i) begin
		
	end

	initial begin
		$dumpfile("tt_um_flappy_bird_tb.vcd");
		$dumpvars;

		/* verilator lint_off STMTDLY */
		#20 ena_i = 1'b1;
		#20 rst_i = 1'b1 ; // deassert reset
		#500 rst_i = 1'b0;
		#300 ui_in_i = 8'b0000_0010 ;//down
		#300 ui_in_i = 8'b0000_0001 ;//up
		#300 ui_in_i = 8'b0000_0010 ;//up
		#300 ui_in_i = 8'b0000_0010 ;//up
		#300 ui_in_i = 8'b0000_0001 ;//up
		#300 ui_in_i = 8'b0000_0001 ;//up
		#300 ui_in_i = 8'b0000_0010 ;//up
		#300 ui_in_i = 8'b0000_0000 ;//up
		
		#4500 $finish ; // finish
		/* verilator lint_on STMTDLY */
	end

endmodule // counter_tb

