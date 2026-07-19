`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 08:28:31 PM
// Design Name: 
// Module Name: immediateGenerator
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

module immediateGenerator
(
    input  logic [31:0] inst,
    output logic [31:0] immout
);

    logic [6:0] opcode;
    assign opcode = inst[6:0];

    always_comb begin
        case(opcode)

            7'b0000011: begin  // I-type: LW
                immout = {{20{inst[31]}}, inst[31:20]};
            end

            7'b0010011: begin  // I-type: ADDI, SLLI
                immout = {{20{inst[31]}}, inst[31:20]};
            end

            7'b0100011: begin  // S-type: SW
                immout = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            end

            7'b1100011: begin  // B-type: BEQ
                immout = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            end

            default: begin
                immout = 32'h00000000;
            end

        endcase
    end

endmodule
