`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 08:32:23 PM
// Design Name: 
// Module Name: alu
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


module alu
(
    input  logic [3:0]  alu_ctrl,
    input  logic [31:0] data1,
    input  logic [31:0] data2,
    output logic [31:0] alu_out,
    output logic        Zero
);

    always_comb begin
        case(alu_ctrl)
            4'b0000: alu_out = data1 & data2;
            4'b0001: alu_out = data1 | data2;
            4'b0011: alu_out = data1 << data2[4:0];
            4'b0010: alu_out = data1 + data2;
            4'b0110: alu_out = data1 - data2;
            4'b0111: alu_out = ($signed(data1) < $signed(data2)) ? 32'h00000001 : 32'h00000000;
            4'b1000: alu_out = ($signed(data1) > $signed(data2)) ? 32'h00000001 : 32'h00000000;
            4'b1100: alu_out = ~(data1 | data2);
            default: alu_out = 32'h00000000;
        endcase
    end

    assign Zero = (alu_out == 32'h00000000);

endmodule
