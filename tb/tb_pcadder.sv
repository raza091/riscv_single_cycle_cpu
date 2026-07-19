`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 08:47:38 PM
// Design Name: 
// Module Name: tb_pcadder
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


module tb_pcadder;

    logic [31:0] pc_out;
    logic [31:0] adder_out;

    pcadder uut(
        .pc_out    (pc_out),
        .adder_out (adder_out)
    );

    initial begin

        // start from 0
        pc_out = 32'h00000000; #10;

        // sequential increments
        pc_out = 32'h00000004; #10;
        pc_out = 32'h00000008; #10;
        pc_out = 32'h0000000C; #10;
        pc_out = 32'h00000010; #10;

        // after branch target
        pc_out = 32'h00000038; #10;
        pc_out = 32'h0000003C; #10;
        pc_out = 32'h00000040; #10;
        pc_out = 32'h00000044; #10;
        pc_out = 32'h00000048; #10;
        pc_out = 32'h0000004C; #10;
        pc_out = 32'h00000050; #10;
        pc_out = 32'h00000054; #10;

        // overflow check
        pc_out = 32'hFFFFFFFC; #10;

        $finish;

    end

    initial begin
        $monitor("Time=%0t | pc_out=%h | adder_out=%h",
                  $time, pc_out, adder_out);
    end

endmodule
