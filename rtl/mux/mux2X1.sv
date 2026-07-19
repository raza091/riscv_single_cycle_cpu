`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 08:40:46 PM
// Design Name: 
// Module Name: mux2X1
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


module mux2X1
(
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic        sel,
    output reg   [31:0] mux_out
);

    always_comb begin
        case(sel)
            1'b0: mux_out = a;
            1'b1: mux_out = b;
        endcase
    end

endmodule
