`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 08:49:46 PM
// Design Name: 
// Module Name: tb_addershifted
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


module tb_addershifted;

    logic [31:0] pc_out;
    logic [31:0] imm_out;
    logic [31:0] addsh_out;

    addershifted uut(
        .pc_out    (pc_out),
        .imm_out   (imm_out),
        .addsh_out (addsh_out)
    );

    initial begin

        // beq t3, t4, done at 0x38, offset=+28=0x1C
        // branch target = 0x38 + 0x1C = 0x54
        pc_out  = 32'h00000038;
        imm_out = 32'h0000001C;
        #10;

        // beq x0, x0, loop at 0x50, offset=-24=0xFFFFFFE8
        // branch target = 0x50 + 0xFFFFFFE8 = 0x38
        pc_out  = 32'h00000050;
        imm_out = 32'hFFFFFFE8;
        #10;

        // beq x0, x0, done at 0x54, offset=0
        // branch target = 0x54 + 0x00 = 0x54
        pc_out  = 32'h00000054;
        imm_out = 32'h00000000;
        #10;

        // positive offset forward branch
        pc_out  = 32'h00000010;
        imm_out = 32'h00000020;
        #10;

        // zero immediate (no offset)
        pc_out  = 32'h00000024;
        imm_out = 32'h00000000;
        #10;

        $finish;

    end

    initial begin
        $monitor("Time=%0t | pc_out=%h | imm_out=%h | addsh_out=%h",
                  $time, pc_out, imm_out, addsh_out);
    end

endmodule
