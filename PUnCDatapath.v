//==============================================================================
// Datapath for PUnC LC3 Processor
//==============================================================================

`include "Memory.v"
`include "RegisterFile.v"
`include "Defines.v"

module PUnCDatapath(
	// External Inputs
	input  wire        clk,            // Clock
	input  wire        rst,            // Reset

	// DEBUG Signals
	input  wire [15:0] mem_debug_addr,
	input  wire [2:0]  rf_debug_addr,
	output wire [15:0] mem_debug_data,
	output wire [15:0] rf_debug_data,
	output wire [15:0] pc_debug_data,

	// INPUTS FROM CONTROLLER
	// PC Controls
	input wire pc_mux,
	input wire pc_ld,
	input wire pc_clr,

	// IR Controls
	input wire ir_ld,
	input wire ir_clr,

	// Mux Enables
	input wire [1:0] rf_r_addr_0_mux,
	input wire rf_r_addr_1_mux,
	input wire rf_w_addr_mux,
	input wire [1:0] rf_w_data_mux,

	input wire [2:0] alu_a_mux,
	input wire [1:0] alu_b_mux,
	input wire [1:0] alu_s,

	input wire d_w_addr_mux,
	
	// Write and Reset Memory and RF
	input wire d_w_en,
	input wire d_rst,
	input wire rf_w_en,
	input wire rf_rst,

	// NZP Controls
	input wire npz_ld,
	input wire npz_clr,

	// OUTPUTS TO CONTROLLER
	output reg [15:0] ir,
	// output reg [15:0] pc,

	output reg n,
	output reg z,
	output reg p
);

	// LOCAL REGISTERS
	reg  [15:0] pc;
	// reg  [15:0] ir;
	
	// INTERNAL WIRES AND REGISTERS
	// PC Load Value
	wire [15:0] pc_mux_value;

	// Memory
	wire [15:0] d_w_addr;
	wire [15:0] d_w_data;
	wire [15:0] d_r_addr;
	wire [15:0] d_r_data;

	// Register File
	wire [2:0] rf_w_addr;
	wire [15:0] rf_w_data;
	wire [2:0] rf_r_addr_0;
	wire [2:0] rf_r_addr_1;
	wire [15:0] rf_r_data_0;
	wire [15:0] rf_r_data_1;

	// ALU
	wire [15:0] alu_a;
	wire [15:0] alu_b;
	wire [15:0] alu_output;

	// Assign PC debug net
	assign pc_debug_data = pc;

	//----------------------------------------------------------------------
	// Memory Module
	//----------------------------------------------------------------------
	assign d_w_data = rf_r_data_0;
	assign d_w_addr = (d_w_addr_mux == 1'b0) ? alu_output : (d_w_addr_mux == 1'b1) ? d_r_data : 1'b0;
	assign d_r_addr = (ir_ld == 1'b1) ? pc : alu_output;

	// 1024-entry 16-bit memory (connect other ports)
	Memory mem(
		.clk      (clk),
		.rst      (rst),
		.r_addr_0 (d_r_addr),
		.r_addr_1 (mem_debug_addr),
		.w_addr   (d_w_addr),
		.w_data   (d_w_data),
		.w_en     (d_w_en),
		.r_data_0 (d_r_data),
		.r_data_1 (mem_debug_data)
	);

	//----------------------------------------------------------------------
	// Register File Module
	//----------------------------------------------------------------------
	assign rf_w_data = (rf_w_data_mux == 2'b00) ? alu_output : (rf_w_data_mux == 2'b01) ? d_r_data : (rf_w_data_mux == 2'b10) ? pc : 1'b0;
	assign rf_w_addr = (rf_w_addr_mux == 1'b0) ? ir[11:9] : (rf_w_addr_mux == 1'b1) ? 3'd7 : 1'b0;
	assign rf_r_addr_0 = (rf_r_addr_0_mux == 2'b00) ? ir[11:9] : (rf_r_addr_0_mux == 2'b01) ? ir[8:6] : (rf_r_addr_0_mux == 1) ? 3'd7 : 1'b0;
	assign rf_r_addr_1 = (rf_r_addr_1_mux == 1'b0) ? ir[2:0] : (rf_r_addr_1_mux == 1'b1) ?  ir[8:6] : 1'b0;

	// 8-entry 16-bit register file (connect other ports)
	RegisterFile rfile(
		.clk      (clk),
		.rst      (rst),
		.r_addr_0 (rf_r_addr_0),
		.r_addr_1 (rf_r_addr_1),
		.r_addr_2 (rf_debug_addr),
		.w_addr   (rf_w_addr),
		.w_data   (rf_w_data),
		.w_en     (rf_w_en),
		.r_data_0 (rf_r_data_0),
		.r_data_1 (rf_r_data_1),
		.r_data_2 (rf_debug_data)
	);

	//----------------------------------------------------------------------
   	// Instruction Register
   	//----------------------------------------------------------------------
	always @(posedge clk) begin
		if (ir_clr) begin
			ir <= 16'd0;
		end
		else if (ir_ld) begin
			ir <= d_r_data;
		end
	end

	//----------------------------------------------------------------------
   	// Program Counter
   	//----------------------------------------------------------------------
	assign pc_mux_value = (pc_mux == 1'b0) ? (pc + 16'd1) : (pc_mux == 1'b1) ? alu_output : 1'b0;

	always @(posedge clk) begin
		if (pc_clr) begin
			pc <= 16'd0;
		end
		else if (pc_ld) begin
			pc <= pc_mux_value;
		end
	end

	//----------------------------------------------------------------------
	// ALU
	//----------------------------------------------------------------------
	assign alu_a = (alu_a_mux == 3'b000) ? rf_r_data_1 : (alu_a_mux == 3'b001) ? {{11{ir[4]}},ir[4:0]} : (alu_a_mux == 3'b010) ? {{10{ir[5]}},ir[5:0]} : (alu_a_mux == 3'b011) ? {{7{ir[8]}},ir[8:0]} : (alu_a_mux == 3'b100) ? {{{5{ir[10]}},ir[10:0]}} : 1'b0;
	assign alu_b = (alu_b_mux == 2'b00) ? pc : (alu_b_mux == 2'b01) ? rf_r_data_0 : (alu_b_mux == 2'b10) ? rf_r_data_1 : 1'b0;
	assign alu_output = (alu_s == 2'b00) ? (alu_b) : (alu_s == 2'b01) ? (alu_a + alu_b) : (alu_s == 2'b10) ? (alu_a & alu_b) : (alu_s == 2'b11) ? (~alu_b) : 1'b0;

	//----------------------------------------------------------------------
	// NPZ Logic
	//----------------------------------------------------------------------
	always @ (*) begin
		if (npz_ld) begin
			if (alu_output[15] == 1'b1) begin
				n = 1'b1;
				z = 1'b0;
				p = 1'b0;
			end
			else if (alu_output > 16'b0) begin
				n = 1'b0;
				z = 1'b0;
				p = 1'b1;
			end
			else if (alu_output == 16'b0) begin
				n = 1'b0;
				z = 1'b1;
				p = 1'b0;
			end
		end
		if (npz_clr) begin
			n = 1'b0;
			z = 1'b0;
			p = 1'b0;
		end
	end
endmodule
