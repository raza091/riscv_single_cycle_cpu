`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 08:43:40 PM
// Design Name: 
// Module Name: alu_control
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


module alu_control
(
    input  logic [1:0]  alu_op,
    input  logic [31:0] inst,
    output reg   [3:0]  alu_ctrl
);

    logic [2:0] funct3;
    logic       funct7;

    assign funct3 = inst[14:12];
    assign funct7 = inst[30];

    always_comb begin
        case(alu_op)

            2'b00: begin
                if(inst[14:12] == 3'b001)
                    alu_ctrl = 4'b0011;  // SLLI
                else
                    alu_ctrl = 4'b0010;  // ADD (LW, SW, ADDI)
                end

            2'b01: begin               // BEQ
                alu_ctrl = 4'b0110;    // SUB
            end

            2'b10: begin               // R-type and I-type variants
                case(funct3)
                    3'b000: begin
                        if(funct7)
                            alu_ctrl = 4'b0110;  // SUB
                        else
                            alu_ctrl = 4'b0010;  // ADD
                    end
                    3'b001: alu_ctrl = 4'b0011;  // SLLI
                    3'b010: alu_ctrl = 4'b0111;  // SLT
                    3'b011: alu_ctrl = 4'b1000;  // SGT
                    3'b100: alu_ctrl = 4'b0101;  // XOR
                    3'b110: alu_ctrl = 4'b0001;  // OR
                    3'b111: alu_ctrl = 4'b0000;  // AND
                    default: alu_ctrl = 4'b0010;
                endcase
            end

            default: alu_ctrl = 4'b0010;

        endcase
    end

endmodule
