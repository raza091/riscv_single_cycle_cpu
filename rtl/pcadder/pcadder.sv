`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 08:47:19 PM
// Design Name: 
// Module Name: pcadder
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


module pcadder
(
    input  logic [31:0] pc_out,
    output logic [31:0] adder_out
);

    assign adder_out = pc_out + 32'd4;

endmodule
