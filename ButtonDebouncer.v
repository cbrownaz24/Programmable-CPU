//==============================================================================
// Button Debouncer for PUnC LC3 Processor
// Note: Use only on an FPGA
//==============================================================================

module ButtonDebouncer
#(
	parameter TIME_DELAY = 500000 // Length of button depression required
	                              // (measured in cycles on sysclk)
	                              // Default: 0.01 seconds
)(
	input      sysclk,    // System clock (50Mhz)
	input      noisy_btn, // Physical button
	output reg clean_btn  // Debounced button
);

	reg [31:0] count;
	reg xnew;

	always @(posedge sysclk) begin
		if (noisy_btn != xnew) begin
			xnew <= noisy_btn;
			count <= 0;
		end else if (count == TIME_DELAY) begin
			clean_btn <= xnew;
		end else begin
			count <= count + 1;
		end
	end
endmodule

