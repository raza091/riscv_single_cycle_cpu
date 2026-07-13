`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/13/2026 07:34:09 PM
// Design Name: 
// Module Name: pc_tb
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


module tb_pc;

    logic        clk;
    logic        rst;
    logic [31:0] mux_out;
    logic [31:0] pc_out;

    pc #(
        .WIDTH(32)
    ) uut (
        .clk     (clk),
        .rst     (rst),
        .mux_out (mux_out),
        .pc_out  (pc_out)
    );

    always #5 clk = ~clk;

    initial begin

        clk     = 0;
        rst     = 1;
        mux_out = 32'h00000000;

        @(posedge clk); #1;
        @(posedge clk); #1;
        rst = 0;

        mux_out = 32'h00000004;
        @(posedge clk); #1;

        mux_out = 32'h00000008;
        @(posedge clk); #1;

        mux_out = 32'h0000000C;
        @(posedge clk); #1;

        mux_out = 32'h00000010;
        @(posedge clk); #1;

        mux_out = 32'h00000040;
        @(posedge clk); #1;

        mux_out = 32'h00000044;
        @(posedge clk); #1;

        rst = 1;
        @(posedge clk); #1;
        rst = 0;

        mux_out = 32'h00000004;
        @(posedge clk); #1;

        mux_out = 32'h00000008;
        @(posedge clk); #1;

        $finish;

    end

    initial begin
        $monitor("Time=%0t | rst=%b | mux_out=%h | pc_out=%h",
                  $time, rst, mux_out, pc_out);
    end

endmodule
