`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2026 08:46:16 PM
// Design Name: 
// Module Name: mux_param_tb
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


module mux_param_tb;
    parameter int WIDTH         = 32;
    parameter int NUM_INPUTS    = 2;
    parameter int SEL_WIDTH     = 1;
    
    logic[NUM_INPUTS - 1 : 0][WIDTH - 1 : 0]    inputs;
    logic[SEL_WIDTH - 1 : 0]                    sel;
    logic[WIDTH - 1 : 0]                        mux_out;
    
    mux_param #(.WIDTH(WIDTH), .NUM_INPUTS(NUM_INPUTS), .SEL_WIDTH(SEL_WIDTH)) 
                DUT(.inputs(inputs), .sel(sel), .mux_out(mux_out));
                
    initial begin
        inputs[0] = 32'hAAAAAAAA;   
        inputs[1] = 32'hBBBBBBBB;   
        sel = 1'b0;
        #10;
        $display("sel = 0, mux_out = 0x%8h", mux_out);
        
        sel = 1'b1;
        #10;
        $display("sel = 1, mux_out = 0x%8h", mux_out);
    end
endmodule
