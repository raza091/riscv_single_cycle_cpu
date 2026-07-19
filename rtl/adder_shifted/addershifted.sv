`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 08:49:27 PM
// Design Name: 
// Module Name: addershifted
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


module addershifted
(
    input  logic [31:0] pc_out,
    input  logic [31:0] imm_out,
    output logic [31:0] addsh_out
);

    assign addsh_out = pc_out + imm_out;

endmodule
