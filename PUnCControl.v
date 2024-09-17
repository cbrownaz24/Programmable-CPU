//==============================================================================
// Control Unit for PUnC LC3 Processor
//==============================================================================

`include "Defines.v"

module PUnCControl(
	// External Inputs
	input  wire        clk,            // Clock
	input  wire        rst,            // Reset
	
	// INPUTS FROM DATAPATH
	input wire [15:0] ir,
	// input reg [15:0] pc,
	input wire n,
	input wire p,
	input wire z,

	// OUTPUTS TO DATAPATH
	// PC Controls
	output reg pc_mux,
	output reg pc_ld,
	output reg pc_clr,

	// IR Controls
	output reg ir_ld,
	output reg ir_clr,

	// Mux Enables
	output reg [1:0] rf_r_addr_0_mux,
	output reg rf_r_addr_1_mux,
	output reg rf_w_addr_mux,
	output reg [1:0] rf_w_data_mux,
	output reg [2:0] alu_a_mux,
	output reg [1:0] alu_b_mux,
	output reg [1:0] alu_s,
	output reg d_w_addr_mux,
	
	// Write and Reset Memory and RF
	output reg d_w_en,
	output reg d_rst,
	output reg rf_w_en,
	output reg rf_rst,

	// NZP Controls
	output reg npz_ld,
	output reg npz_clr
);

	// FSM States
	localparam STATE_INIT = 3'd0;
	localparam STATE_FETCH = 3'd1;
	localparam STATE_DECODE = 3'd2;
	localparam STATE_EXECUTE1 = 3'd3;
	localparam STATE_EXECUTE2 = 3'd4;
	localparam STATE_HALT = 3'd5;

	// State, Next State
	reg [2:0] state, next_state;

	// Output Combinational Logic
	always @( * ) begin
		// DEFAULT VALUES
		pc_mux = 1'b0;
		pc_ld = 1'b0;
		pc_clr = 1'b0;
		ir_ld = 1'b0;
		ir_clr = 1'b0;
		rf_r_addr_0_mux = 2'b00;
		rf_r_addr_1_mux = 1'b0;
		rf_w_addr_mux = 1'b0;
		rf_w_data_mux = 2'b00;
		alu_a_mux = 3'b000;
		alu_b_mux = 2'b00;
		alu_s = 2'b00;
		d_w_en = 1'b0;
		d_rst = 1'b0;
		rf_w_en = 1'b0;
		rf_rst = 1'b0;
		npz_ld = 1'b0;
		npz_clr = 1'b0;

		case (state)
			STATE_INIT: begin
				ir_clr = 1'b1;
				pc_clr = 1'b1;
				npz_clr = 1'b1;
				d_rst = 1'b1;
				rf_rst = 1'b1;
			end
			STATE_FETCH: begin
				ir_ld = 1'b1;
			end
			STATE_DECODE: begin
				pc_mux = 1'b0;
				pc_ld = 1'b1;
			end

			STATE_EXECUTE1: begin
				case (ir[15:12])
					// ADD
					4'b0001: begin
						if (ir[5] == 1'b0) begin
							rf_w_addr_mux = 1'b0;
							rf_r_addr_0_mux = 2'b01; // SR1
							rf_r_addr_1_mux = 1'b0; // SR2
							alu_a_mux = 3'b000; // SR2
							alu_b_mux = 2'b01; // SR1
							alu_s = 2'b01;
							npz_ld = 1'b1;
							rf_w_data_mux = 2'b00;
							rf_w_en = 1'b1;
						end
						else begin
							rf_w_addr_mux = 1'b0;
							rf_r_addr_0_mux = 2'b01; // SR1
							alu_a_mux = 3'b001; // imm5
							alu_b_mux = 2'b01; // SR1
							alu_s = 2'b01;
							npz_ld = 1'b1;
							rf_w_data_mux = 2'b00;
							rf_w_en = 1'b1;
						end
					end

					// AND
					4'b0101: begin
						if (ir[5] == 1'b0) begin
							rf_w_addr_mux = 1'b0;
							rf_r_addr_0_mux = 2'b01; // SR1
							rf_r_addr_1_mux = 1'b0; // SR2
							alu_a_mux = 3'b000; // SR2
							alu_b_mux = 2'b01; // SR1
							alu_s = 2'b10;
							npz_ld = 1'b1;
							rf_w_data_mux = 2'b00;
							rf_w_en = 1'b1;
						end
						else begin
							rf_w_addr_mux = 1'b0;
							rf_r_addr_0_mux = 2'b01; // SR1
							alu_a_mux = 3'b001; // imm5
							alu_b_mux = 2'b01; // SR1
							alu_s = 2'b10;
							npz_ld = 1'b1;
							rf_w_data_mux = 2'b00;
							rf_w_en = 1'b1;
						end
					end

					// BR
					4'b0000: begin
						if ((n & ir[11]) | (z & ir[10]) | (p & ir[9])) begin
							alu_a_mux = 3'b011; // offset9
							alu_b_mux = 2'b00; // pc
							alu_s = 2'b01;
							pc_mux = 1'b1;
							pc_ld = 1'b1;
						end
					end

					// JMP
					4'b1100: begin
						rf_r_addr_0_mux = 2'b01;
						alu_b_mux = 2'b01;
						alu_s = 2'b00;
						pc_mux = 1'b1;
						pc_ld = 1'b1;
					end

					// JSR/JSRR1
					4'b0100: begin
						rf_w_addr_mux = 1'b1;
						alu_b_mux = 2'b00;
						alu_s = 2'b00;
						rf_w_data_mux = 2'b00;
						rf_w_en = 1'b1;
					end

					// LD
					4'b0010: begin
						rf_w_addr_mux = 1'b0;
						alu_a_mux = 3'b011;
						alu_b_mux = 2'b00;
						alu_s = 2'b01;
						npz_ld = 1'b1;
						rf_w_data_mux = 2'b01;
						rf_w_en = 1'b1;
					end

					// LDI1
					4'b1010: begin
						rf_w_addr_mux = 1'b0;
						alu_a_mux = 3'b011;
						alu_b_mux = 2'b00;
						alu_s = 2'b01;
						npz_ld = 1'b1;
						rf_w_data_mux = 2'b01;
						rf_w_en = 1'b1;
					end

					// LDR
					4'b0110: begin
						rf_w_addr_mux = 1'b0;
						rf_r_addr_0_mux = 2'b01;
						alu_b_mux = 2'b01;
						alu_a_mux = 3'b010;
						alu_s = 2'b01;
						rf_w_data_mux = 2'b01;
						rf_w_en = 1'b1;
					end
					
					// LEA
					4'b1110: begin
						rf_w_addr_mux = 1'b0; 
						alu_a_mux = 3'b011;
						alu_b_mux = 2'b00;
						alu_s = 2'b01;
						npz_ld = 1'b1;
						rf_w_data_mux = 2'b00;
						rf_w_en = 1'b1;
					end

					// NOT
					4'b1001: begin
						rf_w_addr_mux = 1'b0;
						rf_r_addr_0_mux = 2'b01;
						alu_b_mux = 2'b01;
						alu_s = 2'b11;
						rf_w_data_mux = 2'b00;
						rf_w_en = 1'b1;
					end

					// RET
					4'b1100: begin
						rf_r_addr_0_mux = 2'b10;
						alu_b_mux = 2'b01;
						alu_s = 2'b00;
						pc_mux = 1'b1;
						pc_ld = 1'b1;
					end

					// ST
					4'b0011: begin
						rf_r_addr_0_mux = 2'b00;
						alu_a_mux = 3'b011;
						alu_b_mux = 2'b00;
						alu_s = 2'b01;
						d_w_addr_mux = 1'b0;
						d_w_en = 1'b1;
					end

					// STI
					4'b1011: begin
						alu_a_mux = 3'b011;
						alu_b_mux = 2'b00;
						alu_s = 2'b01;
						rf_r_addr_0_mux = 2'b00;
						d_w_addr_mux = 1'b1;
						d_w_en = 1'b1;
					end

					// STR
					4'b0111: begin
						rf_r_addr_0_mux = 2'b00;
						rf_r_addr_1_mux = 1'b1;
						alu_a_mux = 3'b010;
						alu_b_mux = 2'b10;
						alu_s = 2'b01;
						d_w_addr_mux = 1'b0;
						d_w_en = 1'b1;
					end
				endcase

			end
			STATE_EXECUTE2: begin
				case(ir[15:12])
					// JSR/JSRR2
					4'b0100: begin
						if (ir[11] == 1'b0) begin
							rf_r_addr_0_mux = 2'b01;
							alu_b_mux = 2'b01;
							alu_s = 2'b00;
							pc_mux = 1'b1;
							pc_ld = 1'b1;
						end
						else begin
							alu_a_mux = 3'b100;
							alu_b_mux = 2'b00;
							alu_s = 2'b01;
							pc_mux = 1'b1;
							pc_ld = 1'b1;
						end
					end
					
					// LDI2
					4'b1010: begin
						rf_r_addr_0_mux = 2'b00;
						alu_b_mux = 2'b01;
						alu_s = 2'b00;
						npz_ld = 1'b1;
						rf_w_data_mux = 2'b01;
						rf_w_addr_mux = 1'b0;
						rf_w_en = 1'b1;
					end
				endcase
			end
			STATE_HALT: begin
				pc_ld = 1'b0;
			end
			
			default: begin

         	end
		endcase
	end

	// Next State Combinational Logic
	always @( * ) begin
		// Set default value for next state here
		next_state = state;

		// Add your next-state logic here
		case (state)
			STATE_INIT: begin
				next_state = STATE_FETCH;
			end
			STATE_FETCH: begin
				next_state = STATE_DECODE;
			end
			STATE_DECODE: begin
				if (ir[15:12] == 4'b1111) begin
					next_state = STATE_HALT;
				end
				else begin
					next_state = STATE_EXECUTE1;
				end
			end
			STATE_EXECUTE1: begin
				// JSR, LTI, STI
				if (ir[15:12] == 4'b0100 | 4'b1010) begin
					next_state = STATE_EXECUTE2;
				end
				else if (ir[15:12] == 1111) begin
					next_state = STATE_HALT;
				end
				else begin
					next_state = STATE_FETCH;
				end
			end
			STATE_EXECUTE2: begin
				next_state = STATE_FETCH;
			end
			STATE_HALT: begin
				if (rst) begin
					next_state = STATE_FETCH;
				end
				else begin
					next_state = STATE_HALT;
				end
			end
		endcase
	end

	// State Update Sequential Logic
	always @(posedge clk) begin
		if (rst) begin
			state <= STATE_INIT;
		end
		else begin
			state <= next_state;
		end
	end
endmodule
