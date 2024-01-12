// Part 2 skeleton

//module fill
//	(
//		CLOCK_50,						//	On Board 50 MHz
//		// Your inputs and outputs here
//		KEY,
//		SW,		// On Board Keys
//		// The ports below are for the VGA output.  Do not change.
//		VGA_CLK,   						//	VGA Clock
//		VGA_HS,							//	VGA H_SYNC
//		VGA_VS,							//	VGA V_SYNC
//		VGA_BLANK_N,						//	VGA BLANK
//		VGA_SYNC_N,						//	VGA SYNC
//		VGA_R,   						//	VGA Red[9:0]
//		VGA_G,	 						//	VGA Green[9:0]
//		VGA_B,
//		AUD_ADCDAT,
//		AUD_BCLK,
//		AUD_ADCLRCK,
//		AUD_DACLRCK,
//		FPGA_I2C_SDAT,
//		AUD_XCK,
//		AUD_DACDAT,
//		FPGA_I2C_SCLK
//		//	VGA Blue[9:0]
//	);
//
//	input			CLOCK_50;				//	50 MHz
//	input	[3:0]	KEY;
//	input [4:0] SW;
//	// Declare your inputs and outputs here
//	// Do not change the following outputs
//	output			VGA_CLK;   				//	VGA Clock
//	output			VGA_HS;					//	VGA H_SYNC
//	output			VGA_VS;					//	VGA V_SYNC
//	output			VGA_BLANK_N;				//	VGA BLANK
//	output			VGA_SYNC_N;				//	VGA SYNC
//	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
//	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
//	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
//	input				AUD_ADCDAT;
//
//	// Bidirectionals
//	inout				AUD_BCLK;
//	inout				AUD_ADCLRCK;
//	inout				AUD_DACLRCK;
//
//	inout				FPGA_I2C_SDAT;
//
//	// Outputs
//	output				AUD_XCK;
//	output				AUD_DACDAT;
//
//	output				FPGA_I2C_SCLK;
//		wire resetn;
//		assign resetn = !SW[4];
//		
//		// Create the colour, x, y and writeEn wires that are inputs to the controller.
//
//	wire [5:0] colour;
//	wire [8:0] x;
//	wire [7:0] y;
//	wire writeEn;
//	wire done_background, done_leftplayer, done_rightplayer, done_ball, done_lgoal, done_rgoal, done_ground;
//
//	// Create an Instance of a VGA controller - there can be only one!
//	// Define the number of colours as well as the initial background
//	// image file (.MIF) for the controller.
//	vga_adapter VGA(
//			.resetn(resetn),
//			.clock(CLOCK_50),
//			.colour(colour),
//			.x(x),
//			.y(y),
//			.plot(writeEn),
//			/* Signals for the DAC to drive the monitor. */
//			.VGA_R(VGA_R),
//			.VGA_G(VGA_G),
//			.VGA_B(VGA_B),
//			.VGA_HS(VGA_HS),
//			.VGA_VS(VGA_VS),
//			.VGA_BLANK(VGA_BLANK_N),
//			.VGA_SYNC(VGA_SYNC_N),
//			.VGA_CLK(VGA_CLK));
//		defparam VGA.RESOLUTION = "320x240";
//		defparam VGA.MONOCHROME = "FALSE";
//		defparam VGA.BITS_PER_COLOUR_CHANNEL = 2;
//		defparam VGA.BACKGROUND_IMAGE = "black.mif";
//			
//	// Put your code here. Your code should produce signals x,y,colour and writeEn
//	// for the VGA controller, in addition to any other functionality your design may require.
//	datapath u0(CLOCK_50, resetn,writeEn, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, done_background, done_leftplayer, done_rightplayer, done_ball, done_lgoal, done_rgoal, done_ground, colour, y, x);
//	DE2_Audio_Example (CLOCK_50, KEY, AUD_ADCDAT,AUD_BCLK, AUD_ADCLRCK, AUD_DACLRCK, FPGA_I2C_SDAT, AUD_XCK, AUD_DACDAT, FPGA_I2C_SCLK, SW[3:0]);
//endmodule

// Part 2 skeleton

module fill
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		KEY,							// On Board Keys
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,    						//	VGA Blue[9:0]
		PS2_CLK,
		PS2_DAT
	);
	
	wire A, D, ENTER;

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;		
	input PS2_CLK, PS2_DAT;
	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [5:0] colour;
	wire [8:0] x;
	wire [7:0] y;
	wire writeEn;
	wire done_background, done_leftplayer, done_rightplayer, done_ball;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	
	wire moveIntrA = {!KEY[2], !KEY[1], !KEY[0]};
	wire moveIntrB;
	PlotTwoPlayer ptp0(CLOCK_50, resetn, moveIntrA, moveIntrB, colour, x, y, writeEn);
	Keyboard k0(PS2_CLK, PS2_DAT, A, D, ENTER, moveIntrB);
	
endmodule
