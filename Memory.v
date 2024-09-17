//==============================================================================
// Memory with 2 read ports, 1 write port
//==============================================================================

module Memory
#(
	parameter N_ELEMENTS = 128,      // Number of Memory Elements
	parameter ADDR_WIDTH = 16,        // Address Width (in bits)
	parameter DATA_WIDTH = 16         // Data Width (in bits)
)(
	// Clock + Reset
	input                   clk,      // Clock
	input                   rst,      // Reset (All entries -> 0)

	// Read Address Channel
	input  [ADDR_WIDTH-1:0] r_addr_0, // Read Address 0
	input  [ADDR_WIDTH-1:0] r_addr_1, // Read Address 1

	// Write Address, Data Channel
	input  [ADDR_WIDTH-1:0] w_addr,   // Write Address
	input  [DATA_WIDTH-1:0] w_data,   // Write Data
	input                   w_en,     // Write Enable

	// Read Data Channel
	output [DATA_WIDTH-1:0] r_data_0, // Read Data 0
	output [DATA_WIDTH-1:0] r_data_1  // Read Data 1

);

	// Memory Unit
	reg [DATA_WIDTH-1:0] mem[N_ELEMENTS-1:0];


	//---------------------------------------------------------------------------
	// BEGIN MEMORY INITIALIZATION BLOCK
	//   - Paste the code you generate for memory initialization in synthesis
	//     here, deleting the current code.
	//   - Use the LC3 Assembler on Blackboard to generate your Verilog.
	//---------------------------------------------------------------------------
	localparam PROGRAM_LENGTH = 0;
	wire [DATA_WIDTH-1:0] mem_init[0:0];
	//---------------------------------------------------------------------------
	// END MEMORY INITIALIZATION BLOCK
	//---------------------------------------------------------------------------

	// Continuous Read
	assign r_data_0 = mem[r_addr_0];
	assign r_data_1 = mem[r_addr_1];

	// Synchronous Reset + Write
	genvar i;
	generate
		for (i = 0; i < N_ELEMENTS; i = i + 1) begin : wport
			always @(posedge clk) begin
				if (rst) begin
					if (i < PROGRAM_LENGTH) begin
						`ifndef SIM
							mem[i] <= mem_init[i];
						`endif
					end
					else begin
						`ifndef SIM
							mem[i] <= 0;
						`endif
					end
				end
				else if (w_en && w_addr == i) begin
					mem[i] <= w_data;
				end
			end
		end
	endgenerate

endmodule
