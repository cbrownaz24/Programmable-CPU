//==============================================================================
// Seven-Segment Program Counter Display for PUnC LC3 Processor
// Note: Use only on an FPGA
//==============================================================================
module SSEG(
   
   // External Inputs
   input  wire        sysclk,          // System Clock (50MHz)
   input  wire [15:0] data,            // Program Counter

   output reg [7:0]  SSEG_CA,          // Cathode
   output reg [3:0]  SSEG_AN           // Anode

);

   localparam DIGIT_A = 4'b1110;
   localparam DIGIT_B = 4'b1101;
   localparam DIGIT_C = 4'b1011;
   localparam DIGIT_D = 4'b0111;

   reg clk;
   reg [3:0] digit;
   reg [31:0] count;

   // Clock divider for display
   always @(posedge sysclk) begin
      if (count == 500000/2) begin
         count <= 0;
         clk <= ~clk;
      end else begin
         count <= count + 1;
      end
   end

   // Select Digit To Decode
   always@( * ) begin
      case (SSEG_AN)
      DIGIT_A: digit = data[7:4];
      DIGIT_B: digit = data[11:8];
      DIGIT_C: digit = data[15:12];
      DIGIT_D: digit = data[3:0];
      default: digit = 4'b0000;
      endcase
   end

   // Update Each Digit Individually
   always@(posedge clk) begin
      case (SSEG_AN)
      DIGIT_A: SSEG_AN <= DIGIT_B;
      DIGIT_B: SSEG_AN <= DIGIT_C;
      DIGIT_C: SSEG_AN <= DIGIT_D;
      DIGIT_D: SSEG_AN <= DIGIT_A;
      default: SSEG_AN <= DIGIT_A;
      endcase
   end

   // Decode Digit
   always@(posedge clk) begin
      case (digit)
      0: SSEG_CA <= 8'b11000000; // 0
      1: SSEG_CA <= 8'b11111001; // 1
      2: SSEG_CA <= 8'b10100100; // 2
      3: SSEG_CA <= 8'b10110000; // 3
      4: SSEG_CA <= 8'b10011001; // 4
      5: SSEG_CA <= 8'b10010010; // 5
      6: SSEG_CA <= 8'b10000010; // 6
      7: SSEG_CA <= 8'b11111000; // 7
      8: SSEG_CA <= 8'b10000000; // 8
      9: SSEG_CA <= 8'b10010000; // 9
      10: SSEG_CA <= 8'b10001000; // A
      11: SSEG_CA <= 8'b10000011; // b
      12: SSEG_CA <= 8'b11000110; // C
      13: SSEG_CA <= 8'b10100001; // d
      14: SSEG_CA <= 8'b10000110; // E
      15: SSEG_CA <= 8'b10001110; // F
      default: SSEG_CA <= 8'b10111111;
      endcase
   end

endmodule