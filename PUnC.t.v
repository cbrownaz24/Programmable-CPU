//===============================================================================
// Testbench Module for PUnC - LC3
//===============================================================================
`timescale 1ns/100ps

`include "PUnC.v"

// Start a test using the image file from the /images folder given in NAME
`define START_TEST(NAME)                                                    \
	begin                                                                   \
		$display("\nBeginning Test: %s", (NAME));                           \
		$display("----------------------------");                           \
		#1;                                                                 \
		$readmemh({"images/", (NAME), ".vmh"}, punc.dpath.mem.mem, 0, 127); \
		rst = 1;                                                            \
		@(posedge clk);                                                     \
		#1;                                                                 \
		rst = 0;                                                            \
		test_cnt = test_cnt + 1;                                            \
		@(posedge clk);                                                     \
	end #0

// Wait for the PC to freeze for 10 cycles
`define WAIT_PC_FREEZE    \
	@(posedge pc_frozen); \
	#1

// Print error message if MEM[ADDR] !== VAL
`define ASSERT_MEM_EQ(ADDR, VAL)                                          \
	begin                                                                 \
		#1;                                                               \
		mem_debug_addr = (ADDR);                                          \
		#1;                                                               \
		if (mem_debug_data !== (VAL)) begin                               \
			$display("\t[FAILURE]: Expected MEM[%d] == %d, but found %d", \
			         (ADDR), (VAL), mem_debug_data);                      \
			err_cnt = err_cnt + 1;                                        \
		end                                                               \
	end #0

// Print error message if REG[ADDR] !== VAL
`define ASSERT_REG_EQ(ADDR, VAL)                                          \
	begin                                                                 \
		#1;                                                               \
		rf_debug_addr = (ADDR);                                           \
		#1;                                                               \
		if (rf_debug_data !== (VAL)) begin                                \
			$display("\t[FAILURE]: Expected REG[%d] == %d, but found %d", \
			         (ADDR), (VAL), rf_debug_data);                       \
			err_cnt = err_cnt + 1;                                        \
		end                                                               \
	end #0

// Print error message if PC !== VAL
`define ASSERT_PC_EQ(VAL)                                                 \
	begin                                                                 \
		if (pc_debug_data !== (VAL)) begin                                \
			$display("\t[FAILURE]: Expected PC == %d, but found %d",      \
			         (VAL), pc_debug_data);                               \
			err_cnt = err_cnt + 1;                                        \
		end                                                               \
	end #0

module PUnCTATest;

	localparam CLK_PERIOD = 10;

	// Testing Variables
	reg  [15:0] pc_cnt = 0;
	reg  [15:0] prev_pc = 0;
	reg  [5:0]  test_cnt = 0;
	reg  [5:0]  err_cnt = 0;
	wire        pc_frozen = (pc_cnt > 16'd10);


	// PUnC Interface
	reg         clk = 0;
	reg         rst = 0;
	reg  [15:0] mem_debug_addr = 0;
	reg  [2:0]  rf_debug_addr  = 0;
	wire [15:0] mem_debug_data;
	wire [15:0] rf_debug_data;
	wire [15:0] pc_debug_data;

	// Clock
	always begin
		#5 clk = ~clk;
	end

	// Keep track of how long PC has stayed at the same value
	// (For telling when PC is frozen)
	always @(posedge clk) begin
		if (prev_pc == pc_debug_data) begin
			pc_cnt <= pc_cnt + 1;
		end
		else begin
			pc_cnt <= 0;
		end
		prev_pc <= pc_debug_data;
	end


	integer m_i, r_i;
	initial begin
		$dumpfile("PUnCTATest.vcd");
		$dumpvars;
		for (m_i = 0; m_i < 128; m_i = m_i + 1) begin
			$dumpvars(0, punc.dpath.mem.mem[m_i]);
		end
		for (r_i = 0; r_i < 8; r_i = r_i + 1) begin
			$dumpvars(0, punc.dpath.rfile.rfile[r_i]);
		end
	end

	// PUnC Main Module
	PUnC punc(
		.clk              (clk),
		.rst              (rst),

		.mem_debug_addr   (mem_debug_addr),
		.rf_debug_addr    (rf_debug_addr),
		.mem_debug_data   (mem_debug_data),
		.rf_debug_data    (rf_debug_data),
		.pc_debug_data    (pc_debug_data)
	);

	initial begin
		$display("\n\n\n===========================");
		$display("=== Beginning All Tests ===");
		$display("===========================");

		// `START_TEST("addi");
		// `WAIT_PC_FREEZE;
		// `ASSERT_REG_EQ(0, 16'd3);
		// `ASSERT_REG_EQ(1, 16'd5);
		// `ASSERT_REG_EQ(2, 16'd4);

		// `START_TEST("addr");
		// `WAIT_PC_FREEZE;
		// `ASSERT_REG_EQ(2, 16'd8);
		// `ASSERT_REG_EQ(3, 16'd13);

		// `START_TEST("andi");
		// `WAIT_PC_FREEZE;
		// `ASSERT_REG_EQ(1, 16'd2);
		// `ASSERT_REG_EQ(3, 16'd0);

		// `START_TEST("andr");
		// `WAIT_PC_FREEZE;
		// `ASSERT_REG_EQ(2, 16'd2);

		// `START_TEST("not");
		// `WAIT_PC_FREEZE;
		// `ASSERT_REG_EQ(2, 16'd0);
		// `ASSERT_REG_EQ(3, 16'hFFF0);

		// `START_TEST("ld");
		// `WAIT_PC_FREEZE;
		// `ASSERT_REG_EQ(0, 16'd1);
		// `ASSERT_REG_EQ(1, 16'd2);
		// `ASSERT_REG_EQ(2, 16'd4);
		// `ASSERT_REG_EQ(3, 16'h2402);

		// `START_TEST("ldi");
		// `WAIT_PC_FREEZE;
		// `ASSERT_REG_EQ(0, 16'h00FF);
		// `ASSERT_REG_EQ(1, 16'hFFFF);

		// `START_TEST("ldr");
		// `WAIT_PC_FREEZE;
		// `ASSERT_REG_EQ(2, 16'd2);
		// `ASSERT_REG_EQ(3, 16'd3);

		// `START_TEST("lea");
		// `WAIT_PC_FREEZE;
		// `ASSERT_REG_EQ(0, 16'd4);
		// `ASSERT_REG_EQ(1, 16'd6);
		// `ASSERT_REG_EQ(2, 16'd1);

		// `START_TEST("st");
		// `WAIT_PC_FREEZE;
		// `ASSERT_MEM_EQ(16'd0, 16'd15);
		// `ASSERT_MEM_EQ(16'd1, 16'd10);

		// `START_TEST("sti");
		// `WAIT_PC_FREEZE;
		// `ASSERT_MEM_EQ(16'd0, 16'd15);

		// `START_TEST("str");
		// `WAIT_PC_FREEZE;
		// `ASSERT_MEM_EQ(16'd4, 16'd15);

		// `START_TEST("jmp");
		// `WAIT_PC_FREEZE;
		// `ASSERT_REG_EQ(1, 16'd1);

		// `START_TEST("jsr");
		// `WAIT_PC_FREEZE;
		// `ASSERT_REG_EQ(0, 16'd1);
		// `ASSERT_REG_EQ(7, 16'd1);

		// `START_TEST("jsrr");
		// `WAIT_PC_FREEZE;
		// `ASSERT_REG_EQ(1, 16'd3);

		// `START_TEST("ret");
		// `WAIT_PC_FREEZE;
		// `ASSERT_REG_EQ(1, 16'd1);

		// `START_TEST("br");
		// `WAIT_PC_FREEZE;
		// `ASSERT_REG_EQ(1, 16'd5);

		// `START_TEST("gcd");
		// `WAIT_PC_FREEZE;
		// `ASSERT_REG_EQ(0, 16'd3);
		// `ASSERT_REG_EQ(1, 16'd3);
		// `ASSERT_MEM_EQ(23, 16'd3);

 		`START_TEST("nSum");
		`WAIT_PC_FREEZE;
		`ASSERT_MEM_EQ(15, 16'd0);
		`ASSERT_MEM_EQ(16, 16'd1);
		`ASSERT_MEM_EQ(17, 16'd2);
		`ASSERT_MEM_EQ(18, 16'd3);
		`ASSERT_MEM_EQ(19, 16'd4);
		`ASSERT_MEM_EQ(20, 16'd5);
		`ASSERT_MEM_EQ(21, 16'd6);
		`ASSERT_MEM_EQ(22, 16'd7);
	
		$display("\n----------------------------");
		$display("--- Completed %d Tests  ----", test_cnt);
		$display("--- Found     %d Errors ----", err_cnt);
		$display("----------------------------");
		$display("\n============================");
		$display("===== End of All Tests =====");
		$display("============================");
		$finish;
	end
endmodule
