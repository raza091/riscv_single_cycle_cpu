`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 08:41:07 PM
// Design Name: 
// Module Name: tb_mux2X1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_mux2X1;

    // shared signals
    logic [31:0] a;
    logic [31:0] b;
    logic        sel;
    logic [31:0] mux_out;

    // signals for alu select instance
    logic [31:0] data2;
    logic [31:0] immout;
    logic        alu_scr;
    logic [31:0] alu_in;

    // signals for pc select instance
    logic [31:0] pc_next;
    logic [31:0] addout;
    logic        and_out;
    logic [31:0] pc_mux_out;

    // signals for data select instance
    logic [31:0] alu_output;
    logic [31:0] readdata;
    logic        mem_reg;
    logic [31:0] datawrite;

    // instance 1: alu select
    // sel=0 ? a=data2 (register)
    // sel=1 ? b=immout (immediate)
    mux2X1 alu_select(
        .a       (data2),
        .b       (immout),
        .sel     (alu_scr),
        .mux_out (alu_in)
    );

    // instance 2: pc select
    // sel=0 ? a=pc_next (PC+4)
    // sel=1 ? b=addout  (branch target)
    mux2X1 pc_select(
        .a       (pc_next),
        .b       (addout),
        .sel     (and_out),
        .mux_out (pc_mux_out)
    );

    // instance 3: data select
    // sel=0 ? a=alu_output (ALU result)
    // sel=1 ? b=readdata   (memory data)
    mux2X1 data_select(
        .a       (alu_output),
        .b       (readdata),
        .sel     (mem_reg),
        .mux_out (datawrite)
    );

    initial begin

        // ============================================
        // ALU SELECT MUX
        // sel=alu_scr: 0=data2(register), 1=immout
        // ============================================

        // ADDI: alu_scr=1 ? use immediate
        data2   = 32'h00000064;
        immout  = 32'h00000019;
        alu_scr = 1'b1;
        #10;

        // R-type: alu_scr=0 ? use register data2
        data2   = 32'h0000000A;
        immout  = 32'h00000005;
        alu_scr = 1'b0;
        #10;

        // LW: alu_scr=1 ? use immediate offset
        data2   = 32'h00000000;
        immout  = 32'h0000000C;
        alu_scr = 1'b1;
        #10;

        // SW: alu_scr=1 ? use immediate offset
        data2   = 32'h000003E8;
        immout  = 32'h00000010;
        alu_scr = 1'b1;
        #10;

        // ============================================
        // PC SELECT MUX
        // sel=and_out: 0=pc_next(PC+4), 1=addout(branch)
        // ============================================

        // normal execution: and_out=0 ? PC+4
        pc_next = 32'h00000008;
        addout  = 32'h00000054;
        and_out = 1'b0;
        #10;

        // branch taken: and_out=1 ? branch target
        pc_next = 32'h00000054;
        addout  = 32'h00000038;
        and_out = 1'b1;
        #10;

        // branch not taken: and_out=0 ? PC+4
        pc_next = 32'h0000003C;
        addout  = 32'h00000054;
        and_out = 1'b0;
        #10;

        // ============================================
        // DATA SELECT MUX
        // sel=mem_reg: 0=alu_output, 1=readdata(memory)
        // ============================================

        // ADDI result: mem_reg=0 ? write ALU result
        alu_output = 32'h00000019;
        readdata   = 32'h00000000;
        mem_reg    = 1'b0;
        #10;

        // LW result: mem_reg=1 ? write memory data
        alu_output = 32'h00000000;
        readdata   = 32'h00000030;
        mem_reg    = 1'b1;
        #10;

        // SW: mem_reg=0 ? no writeback (reg_write=0 handles this)
        alu_output = 32'h00000004;
        readdata   = 32'h00000000;
        mem_reg    = 1'b0;
        #10;

        $finish;

    end

    initial begin
        $display("=== ALU SELECT MUX ===");
        $monitor("Time=%0t | alu_scr=%b | data2=%h | immout=%h | alu_in=%h",
                  $time, alu_scr, data2, immout, alu_in);
    end

    initial begin
        #60;
        $display("=== PC SELECT MUX ===");
        $monitor("Time=%0t | and_out=%b | pc_next=%h | addout=%h | pc_mux_out=%h",
                  $time, and_out, pc_next, addout, pc_mux_out);
    end

    initial begin
        #90;
        $display("=== DATA SELECT MUX ===");
        $monitor("Time=%0t | mem_reg=%b | alu_output=%h | readdata=%h | datawrite=%h",
                  $time, mem_reg, alu_output, readdata, datawrite);
    end

endmodule
