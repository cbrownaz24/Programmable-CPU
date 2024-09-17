//==============================================================================
// Synthesis Top Module for PUnC LC3 Processor
//==============================================================================

`include "PUnC.v"
`include "ButtonDebouncer.v"
`include "ClockDivider.v"
`include "SSEG.v"

module TopModule (
	// FPGA Inputs
	input  wire       rst,
	input  wire       clk_sel,
	input  wire 	  disp_sel,
	input  wire [7:0] mem_debug_addr,
	input  wire [2:0] rf_debug_addr,
	input  wire       sysclk,
	input  wire       pclk,

	// FPGA Outputs
	output wire [15:0] pc_led,
	output wire [7:0]  SSEG_CA,
	output wire [3:0]  SSEG_AN
);


	//----------------------------------------------------------------------
	// Interconnect Wires
	//----------------------------------------------------------------------

	// Clocking
	wire uclk;
	wire clk;
	wire slowclk;

	// Debug Signals
	wire [15:0] mem_debug_data;
	wire [15:0] rf_debug_data;
	wire [15:0] pc_debug_data;
	wire [15:0] disp_data;

	//----------------------------------------------------------------------
	// Clock Selection and Debouncing
	//----------------------------------------------------------------------

	ClockDivider divider(
		.rst(rst),
		.sysclk(sysclk),
		.slowclk(slowclk)
	);

	ButtonDebouncer debouncer(
		.sysclk(sysclk),
		.noisy_btn(pclk),
		.clean_btn(uclk)
	);

	assign clk = (clk_sel == 1'd1) ? slowclk : uclk;

	//----------------------------------------------------------------------
	// PUnC Top Module
	//----------------------------------------------------------------------

	PUnC punc(
		.clk              (clk),
		.rst              (rst),

		.mem_debug_addr   (mem_debug_addr),  
		.rf_debug_addr    (rf_debug_addr),
		.mem_debug_data   (mem_debug_data),
		.rf_debug_data    (rf_debug_data),
		.pc_debug_data    (pc_debug_data)
	);

	//----------------------------------------------------------------------
	// FPGA Data Display
	//----------------------------------------------------------------------

	assign disp_data = (disp_sel) ? mem_debug_data : rf_debug_data;

	SSEG sseg(
		.sysclk     (sysclk),
		.data       (disp_data),
		.SSEG_CA    (SSEG_CA),
		.SSEG_AN	(SSEG_AN)
	);

	//----------------------------------------------------------------------
	// FPGA LED Interface
	//----------------------------------------------------------------------

	assign pc_led = pc_debug_data;

endmodule
