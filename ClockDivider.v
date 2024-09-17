//==============================================================================
// Clock Divider for PUnC LC3 Processor
// Note: Use only on an FPGA
//==============================================================================

module ClockDivider
#(
	parameter SLOWDOWN = 1000 // Factor of Divison
)(
	input      rst,       // Reset
	input      sysclk,    // System clock (50Mhz)
	output reg slowclk    // Slow clock
);

	reg [31:0] count;
	
	always @(posedge sysclk) begin
		if (rst) begin
			count <= 0;
			slowclk <= 0;
		end
		else begin
			if (count == SLOWDOWN/2) begin
				count <= 0;
				slowclk <= ~slowclk;
			end else begin
				count <= count + 1;
			end
		end
	end
endmodule