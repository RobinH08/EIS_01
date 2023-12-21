`default_nettype none

module tt_um_flappy_bird 
#( ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    reg reset = ! rst_n;

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;
	
	parameter gs = 8;
	parameter cr = 2;
	reg [gs*gs-1:0] my_disp;
	reg e_disp ;	//enable display
	wire d_disp;	//disable input
	wire [gs:0] row_d_o;
	
	reg e_inp; // enable input
 	
 	//reg right_i;
 	//reg left_i;

 	wire right_o;
 	wire left_o;
 	
 	wire rst_o;	
 	wire d_inp_o; // disable input

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
		
	get_input
		#(cr)
		get_input_dut (
			.clk_i ( clk ) ,
			.rst_i ( reset ) ,
			.e_inp (e_inp) ,
			
			.right_i(ui_in[0]),
			.left_i(ui_in[1]),
			.right_o(right_o) ,
			.left_o(left_o) ,
			.rst_o(rst_o) ,
			.d_inp_o(d_inp_o) 
		);
		
	
    reg [1:0]State;
	localparam Start = 2'b00;
	localparam Idle = 2'b01;
	localparam Work = 2'b11;
	localparam Done = 2'b10;
	reg tReset;	
    // external clock is 10MHz, so need 24 bit counter
    
    

    // if external inputs are set then use that as compare count
    // otherwise use the hard coded MAX_COUNT
    
	
    always @(posedge clk) begin


	tReset <= reset;
	if(tReset) begin
		e_inp <= 1'b1;
		State <= Start;
	end else begin
		case(State)
			Start: begin
				if(d_inp_o == 1'b1) begin
					e_inp <= 1'b0;
					
					my_disp <= 64'b0;
					my_disp[0] <= 1'b1;
					my_disp[9] <= 1'b1; 
					my_disp[18] <= 1'b1; 
					my_disp[27] <= 1'b1; 
					my_disp[36] <= 1'b1; 
					my_disp[45] <= 1'b1; 
					my_disp[54] <= 1'b1; 
					my_disp[63] <= 1'b1;
					e_disp <= 1'b1;	
					State <= Idle;
				end	

			end
			Idle: begin
			    if (d_disp == 1'b1)  begin
					e_disp <= 1'b0;
					e_inp <= 1'b1;
					State <= Start;
				end

			end
			/*
			Work: begin
				State <= Done;
			end
			Done: begin
				State <= Idle;
			end
			*/
			default:;
		endcase
	end
 
		
	
		

	

		
    end

    
endmodule
