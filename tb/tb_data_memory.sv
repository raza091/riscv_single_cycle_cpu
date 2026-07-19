`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 08:38:54 PM
// Design Name: 
// Module Name: tb_data_memory
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


module tb_data_memory;

    logic        clk;
    logic        reset;
    logic        mem_write;
    logic        mem_read;
    logic [31:0] alu_out;
    logic [31:0] data2;
    logic [31:0] dmem_out;

    data_memory uut(
        .clk       (clk),
        .reset     (reset),
        .mem_write (mem_write),
        .mem_read  (mem_read),
        .alu_out   (alu_out),
        .data2     (data2),
        .dmem_out  (dmem_out)
    );

    always #5 clk = ~clk;

    initial begin

        clk       = 0;
        reset     = 1;
        mem_write = 0;
        mem_read  = 0;
        alu_out   = 32'h00000000;
        data2     = 32'h00000000;

        @(posedge clk); #1;
        @(posedge clk); #1;
        reset = 0;

        // SW: store array[0]=25 at address 0x00000000
        mem_write = 1'b1;
        mem_read  = 1'b0;
        alu_out   = 32'h00000000;
        data2     = 32'd25;
        @(posedge clk); #1;

        // SW: store array[1]=12 at address 0x00000004
        alu_out = 32'h00000004;
        data2   = 32'd12;
        @(posedge clk); #1;

        // SW: store array[2]=48 at address 0x00000008
        alu_out = 32'h00000008;
        data2   = 32'd48;
        @(posedge clk); #1;

        // SW: store array[3]=7 at address 0x0000000C
        alu_out = 32'h0000000C;
        data2   = 32'd7;
        @(posedge clk); #1;

        // SW: store array[4]=31 at address 0x00000010
        alu_out = 32'h00000010;
        data2   = 32'd31;
        @(posedge clk); #1;
        mem_write = 1'b0;

        // LW: load array[0] from address 0x00000000 ? expect 25
        mem_read = 1'b1;
        alu_out  = 32'h00000000;
        #10;

        // LW: load array[1] from address 0x00000004 ? expect 12
        alu_out = 32'h00000004;
        #10;

        // LW: load array[2] from address 0x00000008 ? expect 48
        alu_out = 32'h00000008;
        #10;

        // LW: load array[3] from address 0x0000000C ? expect 7
        alu_out = 32'h0000000C;
        #10;

        // LW: load array[4] from address 0x00000010 ? expect 31
        alu_out = 32'h00000010;
        #10;
        mem_read = 1'b0;

        // mem_read=0 ? dmem_out should be 0 regardless of address
        alu_out = 32'h00000000;
        #10;

        // reset ? all memory goes to 0
        reset = 1'b1;
        @(posedge clk); #1;
        reset = 1'b0;

        // LW after reset ? expect 0
        mem_read = 1'b1;
        alu_out  = 32'h00000000;
        #10;

        mem_read = 1'b0;

        $finish;

    end

    initial begin
        $monitor("Time=%0t | reset=%b | mem_write=%b | mem_read=%b | alu_out=%h | data2=%0d | dmem_out=%0d",
                  $time, reset, mem_write, mem_read,
                  alu_out, data2, dmem_out);
    end

endmodule
