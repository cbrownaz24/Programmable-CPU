//==============================================================================
// Register File with 3 read ports, 1 write port
//==============================================================================

module RegisterFile
#(
	parameter N_ELEMENTS = 8,         // Number of Memory Elements
	parameter ADDR_WIDTH = 3,         // Address Width (in bits)
	parameter DATA_WIDTH = 16         // Data Width (in bits)
)(
	// Clock + Reset
	input                   clk,      // Clock
	input                   rst,      // Reset (All entries -> 0)

	// Read Address Channel
	input  [ADDR_WIDTH-1:0] r_addr_0, // Read Address 0
	input  [ADDR_WIDTH-1:0] r_addr_1, // Read Address 1
	input  [ADDR_WIDTH-1:0] r_addr_2, // Read Address 2

	// Write Address, Data Channel
	input  [ADDR_WIDTH-1:0] w_addr,   // Write Address
	input  [DATA_WIDTH-1:0] w_data,   // Write Data
	input                   w_en,     // Write Enable

	// Read Data Channel
	output [DATA_WIDTH-1:0] r_data_0, // Read Data 0
	output [DATA_WIDTH-1:0] r_data_1, // Read Data 1
	output [DATA_WIDTH-1:0] r_data_2  // Read Data 2

);

	// Memory Unit
	reg [DATA_WIDTH-1:0] rfile[N_ELEMENTS-1:0];

	// Continuous Read
	assign r_data_0 = rfile[r_addr_0];
	assign r_data_1 = rfile[r_addr_1];
	assign r_data_2 = rfile[r_addr_2];

	// Synchronous Reset + Write
	genvar i;
	generate
		for (i = 0; i < N_ELEMENTS; i = i + 1) begin : wport
			always @(posedge clk) begin
				if (rst) begin
					rfile[i] <= 0;
				end
				else if (w_en && w_addr == i) begin
					rfile[i] <= w_data;
				end
			end
		end
	endgenerate

endmodule

