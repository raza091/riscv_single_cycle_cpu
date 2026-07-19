`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 08:35:28 PM
// Design Name: 
// Module Name: tb_control_path
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


module tb_control_path;

    logic [31:0] inst;
    reg          branch;
    reg          mem_rd;
    reg          mem2reg;
    reg          mem_write;
    reg          alu_scr;
    reg          reg_write;
    reg  [1:0]   alu_op;

    control_path uut(
        .inst      (inst),
        .branch    (branch),
        .mem_rd    (mem_rd),
        .mem2reg   (mem2reg),
        .mem_write (mem_write),
        .alu_scr   (alu_scr),
        .reg_write (reg_write),
        .alu_op    (alu_op)
    );

    initial begin

        // LW: lw t1, 0(t6) = 0x000FB303
        inst = 32'h000FB303; #10;

        // ADDI: addi t0, x0, 0 = 0x00000293
        inst = 32'h00000293; #10;

        // ADDI: addi t1, x0, 25 = 0x01900313
        inst = 32'h01900313; #10;

        // SW: sw t1, 0(t0) = 0x0062A023
        inst = 32'h0062A023; #10;

        // SW: sw t1, 16(t0) = 0x0062A823
        inst = 32'h0062A823; #10;

        // BEQ: beq t3, t4, done = 0x03DE0E63
        inst = 32'h03DE0E63; #10;

        // BEQ: beq x0, x0, loop = 0xFE0004E3
        inst = 32'hFE0004E3; #10;

        // R-type: add t2, t2, t1 = 0x006383B3
        inst = 32'h006383B3; #10;

        // invalid opcode
        inst = 32'hDEADBEEF; #10;

        $finish;

    end

    initial begin
        $monitor("Time=%0t | opcode=%b | branch=%b | mem_rd=%b | mem2reg=%b | mem_write=%b | alu_scr=%b | reg_write=%b | alu_op=%b",
                  $time, inst[6:0],
                  branch, mem_rd, mem2reg,
                  mem_write, alu_scr, reg_write, alu_op);
    end

endmodule
