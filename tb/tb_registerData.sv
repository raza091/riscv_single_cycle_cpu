`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 08:25:17 PM
// Design Name: 
// Module Name: tb_registerData
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


module tb_registerData;

    logic        clk;
    logic        reset;
    logic        write_en;
    logic [31:0] inst;
    logic [31:0] data_w;
    logic [31:0] data1;
    logic [31:0] data2;

    registerData uut(
        .clk      (clk),
        .reset    (reset),
        .write_en (write_en),
        .inst     (inst),
        .data_w   (data_w),
        .data1    (data1),
        .data2    (data2)
    );

    always #5 clk = ~clk;

    initial begin

        clk      = 0;
        reset    = 1;
        write_en = 0;
        inst     = 32'h00000000;
        data_w   = 32'h00000000;

        @(posedge clk); #1;
        @(posedge clk); #1;
        reset = 0;

        // write 0xDEADBEEF to x5 (t0)
        // rd=x5=00101, rs1=x0, rs2=x0
        // inst[11:7]=00101
        write_en = 1'b1;
        inst     = 32'h000002B3;
        data_w   = 32'hDEADBEEF;
        @(posedge clk); #1;

        // write 0xCAFEBABE to x6 (t1)
        // inst[11:7]=00110
        inst   = 32'h00000333;
        data_w = 32'hCAFEBABE;
        @(posedge clk); #1;

        // write 0x12345678 to x28 (t3)
        // inst[11:7]=11100
        inst   = 32'h00000E33;
        data_w = 32'h12345678;
        @(posedge clk); #1;
        write_en = 1'b0;

        // read x5 and x6
        // inst[19:15]=00101 ? rs1=x5
        // inst[24:20]=00110 ? rs2=x6
        inst = 32'h00628000;
        #10;

        // read x28 and x5
        // inst[19:15]=11100 ? rs1=x28
        // inst[24:20]=00101 ? rs2=x5
        inst = 32'h005E0000;
        #10;

        // attempt write to x0 — should be ignored
        write_en = 1'b1;
        inst     = 32'h00000033;
        data_w   = 32'hFFFFFFFF;
        @(posedge clk); #1;
        write_en = 1'b0;

        // read x0 — should still be 0
        // inst[19:15]=00000 ? rs1=x0
        inst = 32'h00000000;
        #10;

        // reset all registers
        reset = 1'b1;
        @(posedge clk); #1;
        reset = 1'b0;

        // read x5 after reset — should be 0
        inst = 32'h00628000;
        #10;

        $finish;

    end

    initial begin
        $monitor("Time=%0t | reset=%b | write_en=%b | rd=%b | rs1=%b | rs2=%b | data_w=%h | data1=%h | data2=%h",
                  $time, reset, write_en,
                  inst[11:7], inst[19:15], inst[24:20],
                  data_w, data1, data2);
    end

endmodule
