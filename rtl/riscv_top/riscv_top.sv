`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 08:52:44 PM
// Design Name: 
// Module Name: riscv_top
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


module riscv_top
(
    input  logic clk,
    input  logic reset
);



    // PC wires
    logic [31:0] pc_out;
    logic [31:0] adder_out;
    logic [31:0] addsh_out;
    logic [31:0] pc_next;

    // instruction wires
    logic [31:0] inst;

    // control wires
    logic        branch;
    logic        mem_rd;
    logic        mem2reg;
    logic        mem_write;
    logic        alu_scr;
    logic        reg_write;
    logic [1:0]  alu_op;

    // register file wires
    logic [31:0] data1;
    logic [31:0] data2;
    logic [31:0] data_write;

    // immediate wire
    logic [31:0] imm_out;

    // ALU wires
    logic [3:0]  alu_ctrl;
    logic [31:0] alu_in;
    logic [31:0] alu_out;
    logic        Zero;

    // branch wire
    logic        and_out;

    // data memory wire
    logic [31:0] dmem_out;

   

    // 1. Program Counter
    pc u_pc(
        .clk     (clk),
        .rst     (reset),
        .mux_out (pc_next),
        .pc_out  (pc_out)
    );

    // 2. PC + 4 adder
    pcadder u_pcadder(
        .pc_out    (pc_out),
        .adder_out (adder_out)
    );

    // 3. Instruction Memory
    instructionMemory u_imem(
        .pc_out (pc_out),
        .inst   (inst)
    );

    // 4. Control Path
    control_path u_ctrl(
        .inst      (inst),
        .branch    (branch),
        .mem_rd    (mem_rd),
        .mem2reg   (mem2reg),
        .mem_write (mem_write),
        .alu_scr   (alu_scr),
        .reg_write (reg_write),
        .alu_op    (alu_op)
    );

    // 5. Register File
    registerData u_regfile(
        .clk      (clk),
        .reset    (reset),
        .write_en (reg_write),
        .inst     (inst),
        .data_w   (data_write),
        .data1    (data1),
        .data2    (data2)
    );

    // 6. Immediate Generator
    immediateGenerator u_immgen(
        .inst   (inst),
        .immout (imm_out)
    );

    // 7. ALU Control
    alu_control u_aluctl(
        .alu_op   (alu_op),
        .inst     (inst),
        .alu_ctrl (alu_ctrl)
    );

    // 8. ALU Select MUX
    mux2X1 u_alumux(
        .a       (data2),
        .b       (imm_out),
        .sel     (alu_scr),
        .mux_out (alu_in)
    );

    // 9. ALU
    alu u_alu(
        .alu_ctrl (alu_ctrl),
        .data1    (data1),
        .data2    (alu_in),
        .alu_out  (alu_out),
        .Zero     (Zero)
    );

    // 10. AND Gate (branch decision)
    andGate u_and(
        .a (branch),
        .b (Zero),
        .c (and_out)
    );

    // 11. Branch Target Adder
    addershifted u_branchadd(
        .pc_out    (pc_out),
        .imm_out   (imm_out),
        .addsh_out (addsh_out)
    );

    // 12. PC Select MUX
    mux2X1 u_pcmux(
        .a       (adder_out),
        .b       (addsh_out),
        .sel     (and_out),
        .mux_out (pc_next)
    );

    // 13. Data Memory
    data_memory u_dmem(
        .clk       (clk),
        .reset     (reset),
        .mem_write (mem_write),
        .mem_read  (mem_rd),
        .alu_out   (alu_out),
        .data2     (data2),
        .dmem_out  (dmem_out)
    );

    // 14. Data Write Back MUX
    mux2X1 u_wbmux(
        .a       (alu_out),
        .b       (dmem_out),
        .sel     (mem2reg),
        .mux_out (data_write)
    );

endmodule
