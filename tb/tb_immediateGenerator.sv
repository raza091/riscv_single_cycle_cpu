`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 08:29:20 PM
// Design Name: 
// Module Name: tb_immediateGenerator
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


module tb_immediateGenerator;

    logic [31:0] inst;
    logic [31:0] immout;

    immediateGenerator uut(
        .inst   (inst),
        .immout (immout)
    );

    initial begin

        // I-type: addi t1, x0, 25 ? expect 0x00000019
        inst = 32'h01900313; #10;

        // I-type: addi t0, x0, 0 ? expect 0x00000000
        inst = 32'h00000293; #10;

        // I-type: lw t1, 0(t6) ? expect 0x00000000
        inst = 32'h000FB303; #10;

        // S-type: sw t1, 0(t0) ? expect 0x00000000
        inst = 32'h0062A023; #10;

        // S-type: sw t1, 4(t0) ? expect 0x00000004
        inst = 32'h0062A223; #10;

        // S-type: sw t1, 8(t0) ? expect 0x00000008
        inst = 32'h0062A423; #10;

        // S-type: sw t1, 16(t0) ? expect 0x00000010
        inst = 32'h0062A823; #10;

        // B-type: beq t3, t4, done offset=+28 ? expect 0x0000001C
        inst = 32'h03DE0E63; #10;

        // B-type: beq x0, x0, loop offset=-24 ? expect 0xFFFFFFE8
        inst = 32'hFE0004E3; #10;

        // B-type: beq x0, x0, done offset=0 ? expect 0x00000000
        inst = 32'h00000063; #10;

        $finish;

    end

    initial begin
        $monitor("Time=%0t | inst=%h | immout=%h",
                  $time, inst, immout);
    end

endmodule
