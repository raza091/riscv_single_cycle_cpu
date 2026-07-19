`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 08:33:09 PM
// Design Name: 
// Module Name: tb_alu
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


module tb_alu;

    logic [3:0]  alu_ctrl;
    logic [31:0] data1;
    logic [31:0] data2;
    logic [31:0] alu_out;
    logic        Zero;

    alu uut(
        .alu_ctrl (alu_ctrl),
        .data1    (data1),
        .data2    (data2),
        .alu_out  (alu_out),
        .Zero     (Zero)
    );

    initial begin

        // AND: 0xF0F0F0F0 & 0x0F0F0F0F = 0x00000000, Zero=1
        data1 = 32'hF0F0F0F0; data2 = 32'h0F0F0F0F; alu_ctrl = 4'b0000; #10;

        // AND: 0xFF00FF00 & 0xFF00FF00 = 0xFF00FF00, Zero=0
        data1 = 32'hFF00FF00; data2 = 32'hFF00FF00; alu_ctrl = 4'b0000; #10;

        // OR: 0xF0F0F0F0 | 0x0F0F0F0F = 0xFFFFFFFF, Zero=0
        data1 = 32'hF0F0F0F0; data2 = 32'h0F0F0F0F; alu_ctrl = 4'b0001; #10;

        // OR: 0x00000000 | 0x00000000 = 0x00000000, Zero=1
        data1 = 32'h00000000; data2 = 32'h00000000; alu_ctrl = 4'b0001; #10;

        // ADD: 25 + 12 = 37, Zero=0
        data1 = 32'd25; data2 = 32'd12; alu_ctrl = 4'b0010; #10;

        // ADD: 0 + 0 = 0, Zero=1
        data1 = 32'd0; data2 = 32'd0; alu_ctrl = 4'b0010; #10;

        // ADD: base + offset (LW address calculation)
        data1 = 32'h00000000; data2 = 32'h0000000C; alu_ctrl = 4'b0010; #10;

        // SUB: 10 - 10 = 0, Zero=1 (BEQ equal case)
        data1 = 32'd10; data2 = 32'd10; alu_ctrl = 4'b0110; #10;

        // SUB: 10 - 5 = 5, Zero=0 (BEQ not equal)
        data1 = 32'd10; data2 = 32'd5; alu_ctrl = 4'b0110; #10;

        // SUB: negative result -5, Zero=0
        data1 = 32'd5; data2 = 32'd10; alu_ctrl = 4'b0110; #10;

        // SLT: 5 < 10 = 1, Zero=0
        data1 = 32'd5; data2 = 32'd10; alu_ctrl = 4'b0111; #10;

        // SLT: 10 < 5 = 0, Zero=1
        data1 = 32'd10; data2 = 32'd5; alu_ctrl = 4'b0111; #10;

        // SLT: -1 < 1 = 1 (signed), Zero=0
        data1 = 32'hFFFFFFFF; data2 = 32'h00000001; alu_ctrl = 4'b0111; #10;

        // SGT: 10 > 5 = 1, Zero=0
        data1 = 32'd10; data2 = 32'd5; alu_ctrl = 4'b1000; #10;

        // SGT: 5 > 10 = 0, Zero=1
        data1 = 32'd5; data2 = 32'd10; alu_ctrl = 4'b1000; #10;

        // SGT: 1 > -1 = 1 (signed), Zero=0
        data1 = 32'h00000001; data2 = 32'hFFFFFFFF; alu_ctrl = 4'b1000; #10;

        // NOR: ~(0xF0F0F0F0 | 0x0F0F0F0F) = ~0xFFFFFFFF = 0x00000000, Zero=1
        data1 = 32'hF0F0F0F0; data2 = 32'h0F0F0F0F; alu_ctrl = 4'b1100; #10;

        // NOR: ~(0x00000000 | 0x00000000) = 0xFFFFFFFF, Zero=0
        data1 = 32'h00000000; data2 = 32'h00000000; alu_ctrl = 4'b1100; #10;

        // default: unknown ctrl = 0x00000000, Zero=1
        data1 = 32'hDEADBEEF; data2 = 32'hCAFEBABE; alu_ctrl = 4'b1111; #10;

        $finish;

    end

    initial begin
        $monitor("Time=%0t | alu_ctrl=%b | data1=%h | data2=%h | alu_out=%h | Zero=%b",
                  $time, alu_ctrl, data1, data2, alu_out, Zero);
    end

endmodule
