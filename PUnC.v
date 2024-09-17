//==============================================================================
// Module for PUnC LC3 Processor
//==============================================================================

`include "PUnCDatapath.v"
`include "PUnCControl.v"

module PUnC(
	// External Inputs
	input  wire        clk,            // Clock
	input  wire        rst,            // Reset

	// Debug Signals
	input  wire [15:0] mem_debug_addr,
	input  wire [2:0]  rf_debug_addr,
	output wire [15:0] mem_debug_data,
	output wire [15:0] rf_debug_data,
	output wire [15:0] pc_debug_data
	
);

	//----------------------------------------------------------------------
	// Interconnect Wires
	//----------------------------------------------------------------------
	wire [15:0] ir;

	// PC Controls
	wire pc_mux;
	wire pc_ld;
	wire pc_clr;

	// IR Controls
	wire ir_ld;
	wire ir_clr;

	// Mux Enables
	wire [1:0] rf_r_addr_0_mux;
	wire rf_r_addr_1_mux;
	wire rf_w_addr_mux;
	wire [1:0] rf_w_data_mux;

	wire [2:0] alu_a_mux;
	wire [1:0] alu_b_mux;
	wire [1:0] alu_s;

	wire d_w_addr_mux;
	
	// Write and Reset Memory and RF
	wire d_w_en;
	wire d_rst;
	wire rf_w_en;
	wire rf_rst;

	// NZP Controls
	wire npz_ld;
	wire npz_clr;
	wire n;
	wire p;
	wire z;

	//----------------------------------------------------------------------
	// Control Module
	//----------------------------------------------------------------------
	PUnCControl ctrl(
		.clk (clk),
		.rst (rst),
		.ir (ir),
		.n (n),
		.p (p),
		.z (z),
		.pc_mux (pc_mux),
		.pc_ld (pc_ld),
		.pc_clr (pc_clr),
		.ir_ld (ir_ld),
		.ir_clr (ir_clr),
		.rf_r_addr_0_mux (rf_r_addr_0_mux),
		.rf_r_addr_1_mux (rf_r_addr_1_mux),
		.rf_w_addr_mux (rf_w_addr_mux),
		.rf_w_data_mux (rf_w_data_mux),
		.alu_a_mux (alu_a_mux),
		.alu_b_mux (alu_b_mux),
		.alu_s (alu_s),
		.d_w_addr_mux (d_w_addr_mux),
		.d_w_en (d_w_en),
		.d_rst (d_rst),
		.rf_w_en (rf_w_en),
		.rf_rst (rf_rst),
		.npz_ld (npz_ld),
		.npz_clr (npz_clr)
	);

	//----------------------------------------------------------------------
	// Datapath Module
	//----------------------------------------------------------------------
	PUnCDatapath dpath(
		.clk (clk),
		.rst (rst),
		.mem_debug_addr (mem_debug_addr),
		.rf_debug_addr (rf_debug_addr),
		.mem_debug_data (mem_debug_data),
		.rf_debug_data (rf_debug_data),
		.pc_debug_data (pc_debug_data),
		.ir (ir),
		.n (n),
		.p (p),
		.z (z),
		.pc_mux (pc_mux),
		.pc_ld (pc_ld),
		.pc_clr (pc_clr),
		.ir_ld (ir_ld),
		.ir_clr (ir_clr),
		.rf_r_addr_0_mux (rf_r_addr_0_mux),
		.rf_r_addr_1_mux (rf_r_addr_1_mux),
		.rf_w_addr_mux (rf_w_addr_mux),
		.rf_w_data_mux (rf_w_data_mux),
		.alu_a_mux (alu_a_mux),
		.alu_b_mux (alu_b_mux),
		.alu_s (alu_s),
		.d_w_addr_mux (d_w_addr_mux),
		.d_w_en (d_w_en),
		.d_rst (d_rst),
		.rf_w_en (rf_w_en),
		.rf_rst (rf_rst),
		.npz_ld (npz_ld),
		.npz_clr (npz_clr)
	);
endmodule
