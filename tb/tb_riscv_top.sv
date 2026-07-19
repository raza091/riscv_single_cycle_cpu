`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 08:54:27 PM
// Design Name: 
// Module Name: tb_riscv_top
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


module tb_riscv_top;

    logic clk;
    logic reset;

    riscv_top uut(
        .clk   (clk),
        .reset (reset)
    );

    always #5 clk = ~clk;

    initial begin

        clk   = 0;
        reset = 1;

        @(posedge clk); #1;
        @(posedge clk); #1;
        reset = 0;

        // run 100 cycles to for full progra
        repeat(100) @(posedge clk);

        $finish;

    end
endmodule
