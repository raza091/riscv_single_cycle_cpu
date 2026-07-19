`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 08:43:59 PM
// Design Name: 
// Module Name: tb_alu_control
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


module tb_alu_control;

    logic [1:0]  alu_op;
    logic [31:0] inst;
    reg   [3:0]  alu_ctrl;

    alu_control uut(
        .alu_op   (alu_op),
        .inst     (inst),
        .alu_ctrl (alu_ctrl)
    );

    initial begin

        // =============================================
        // alu_op=00: LW, SW ? always ADD
        // =============================================

        // LW: lw t1, 0(t6)
        alu_op = 2'b00; inst = 32'h000FB303; #10;

        // SW: sw t1, 0(t0)
        alu_op = 2'b00; inst = 32'h0062A023; #10;

        // ADDI default path
        alu_op = 2'b00; inst = 32'h01900313; #10;

        // =============================================
        // alu_op=01: BEQ ? always SUB
        // =============================================

        // BEQ: beq t3, t4, done
        alu_op = 2'b01; inst = 32'h03DE0E63; #10;

        // BEQ: beq x0, x0, loop
        alu_op = 2'b01; inst = 32'hFE0004E3; #10;

        // =============================================
        // alu_op=10: funct3/funct7 based
        // =============================================

        // ADD: funct3=000, funct7=0 ? 0010
        // add t2, t2, t1 = 0x006383B3
        alu_op = 2'b10; inst = 32'h006383B3; #10;

        // SUB: funct3=000, funct7=1 ? 0110
        // sub x5, x6, x7 (funct7=0100000)
        alu_op = 2'b10; inst = 32'h40730233; #10;

        // SLLI: funct3=001 ? 0011
        // slli t5, t3, 2 = 0x002E1F13
        alu_op = 2'b10; inst = 32'h002E1F13; #10;

        // SLT: funct3=010 ? 0111
        // slt x1, x2, x3
        alu_op = 2'b10; inst = 32'h003120B3; #10;

        // SGT: funct3=011 ? 1000
        alu_op = 2'b10; inst = 32'h003130B3; #10;

        // XOR: funct3=100 ? 0101
        // xor x1, x2, x3
        alu_op = 2'b10; inst = 32'h003140B3; #10;

        // OR: funct3=110 ? 0001
        // or x1, x2, x3
        alu_op = 2'b10; inst = 32'h003160B3; #10;

        // AND: funct3=111 ? 0000
        // and x1, x2, x3
        alu_op = 2'b10; inst = 32'h003170B3; #10;

        $finish;

    end

    initial begin
        $monitor("Time=%0t | alu_op=%b | funct3=%b | funct7=%b | alu_ctrl=%b",
                  $time, alu_op,
                  inst[14:12], inst[30],
                  alu_ctrl);
    end

endmodule
