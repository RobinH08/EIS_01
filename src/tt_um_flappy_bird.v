`default_nettype none

module flappy_bird 
#( parameter MAX_COUNT = 24'd10_000_000 ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire reset = ! rst_n;

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;
	
	parameter gs;
	reg [gs*gs-1:0] my_disp;
	reg e_disp ;
	wire d_disp;
	wire [gs:0] row_d_o;
	
	//DUT
	display
		#(gs)
		display_dut (
			.clk_i ( clk ) ,
			.matrix_i(my_disp) ,
			.e_disp(e_disp) ,
			.col_val_o(uo_out) ,
			.row_val_o(uio_out) ,
			.d_disp_o(d_disp),

			.row_d_o(row_d_o)
		);
		
		
    // external clock is 10MHz, so need 24 bit counter
    reg [23:0] second_counter;
    reg [3:0] digit;

    // if external inputs are set then use that as compare count
    // otherwise use the hard coded MAX_COUNT
    wire [23:0] compare = ui_in == 0 ? MAX_COUNT: {6'b0, ui_in[7:0], 10'b0};
	
    always @(posedge clk) begin
    
		gs <= 8;
		e_disp <= 1'b1;
		my_disp <= {1,0,0,0,0,0,0,1,0,1,0,0,0,0,1,0
        if (d_disp == 1'b1)  begin
		e_disp = 1'b0;
	end
    end

    // instantiate segment display
    seg7 seg7(.counter(digit), .segments(led_out));

endmodule
