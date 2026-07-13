`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2026 08:40:06 PM
// Design Name: 
// Module Name: adder_tb
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


module adder_tb;
    logic [31:0] a;
    logic [31:0] b;
    logic        cin;
    logic [31:0] sum;
    logic        cout;
    
    adder DUT(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));
    
    initial begin
        a = 32'h00000020;
        b = 32'h00000005;
        cin = 1'b0;
        #10;
        
        a = 32'hFFFFFFFF;
        b = 32'h00000001;
        cin = 1'b1;
        #10;
        
        a = 32'h00000000;
        b = 32'h00000000;
        cin = 1'b0;
        #10;
        
        
    end
endmodule
