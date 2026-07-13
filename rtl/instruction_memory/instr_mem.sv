`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/13/2026 10:12:11 PM
// Design Name: 
// Module Name: instr_mem
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


module instr_mem #(
    parameter int ADDR_WIDTH = 10,
    parameter int DATA_WIDTH = 32
)(
    input logic[ADDR_WIDTH - 1 : 0] addr,
    output logic[DATA_WIDTH - 1 : 0]instr
    );
    logic [DATA_WIDTH - 1 : 0]mem[0 : (2**ADDR_WIDTH) - 1];
    
    initial begin
        $readmemh("program.hex", mem);
    end
    assign instr = mem[addr >> 2];
endmodule
