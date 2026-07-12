`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2026 07:50:25 PM
// Design Name: 
// Module Name: mux_param
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


module mux_param #(
    parameter int WIDTH         = 32,
    parameter int NUM_INPUTS    = 2,
    parameter int SEL_WIDTH     = 1
)(
    input logic[NUM_INPUTS - 1 : 0][WIDTH - 1 : 0]  inputs,
    input logic[SEL_WIDTH - 1 : 0]                  sel,
    output logic[WIDTH - 1 : 0]                     mux_out
    );
    
    assign mux_out = inputs[sel];
endmodule
