`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 08:45:55 PM
// Design Name: 
// Module Name: tb_andGate
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


module tb_andGate;

    logic a;
    logic b;
    logic c;

    andGate gate(
        .a (a),
        .b (b),
        .c (c)
    );

    initial begin

        // branch=0, Zero=0 ? and_out=0 (no branch)
        a = 1'b0; b = 1'b0; #10;

        // branch=0, Zero=1 ? and_out=0 (no branch signal)
        a = 1'b0; b = 1'b1; #10;

        // branch=1, Zero=0 ? and_out=0 (BEQ not equal)
        a = 1'b1; b = 1'b0; #10;

        // branch=1, Zero=1 ? and_out=1 (BEQ equal, branch taken)
        a = 1'b1; b = 1'b1; #10;

        $finish;

    end

    initial begin
        $monitor("Time=%0t | branch=%b | Zero=%b | and_out=%b",
                  $time, a, b, c);
    end

endmodule
