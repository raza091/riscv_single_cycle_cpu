`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/13/2026 10:22:22 PM
// Design Name: 
// Module Name: tb_instr_mem
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


module tb_instr_mem;

    logic [9:0]  addr;
    logic [31:0] instr;

    instr_mem #(
        .ADDR_WIDTH(10),
        .DATA_WIDTH(32)
    ) uut (
        .addr  (addr),
        .instr (instr)
    );

    initial begin

        addr = 10'h000;
        #10;

        addr = 10'h004;
        #10;

        addr = 10'h008;
        #10;

        addr = 10'h00C;
        #10;

        addr = 10'h010;
        #10;

        $finish;

    end

    initial begin
        $monitor("Time=%0t | addr=%h | instr=%h",
                  $time, addr, instr);
    end

endmodule
