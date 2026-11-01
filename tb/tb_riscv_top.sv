`timescale 1ns / 1ps
// Self-checking top-level testbench.
// Program stores {25,12,48,7,31} to memory, then sums them into t2 (x7).
module tb_riscv_top;

    logic clk;
    logic reset;
    int   errors = 0;

    riscv_top uut (.clk(clk), .reset(reset));

    always #5 clk = ~clk;

    task automatic check(string name, int actual, int expected);
        if (actual !== expected) begin
            $display("FAIL: %s = %0d (expected %0d)", name, actual, expected);
            errors++;
        end else
            $display("%-10s = %0d (expect %0d)", name, actual, expected);
    endtask

    initial begin
        clk   = 0;
        reset = 1;
        repeat (2) @(posedge clk);
        #1 reset = 0;

        // 100 cycles is enough for the full program (about 60 instructions)
        repeat (100) @(posedge clk);

        $display("-----------------------------------");
        check("t2 (sum)",  uut.u_regfile.reg_file[7],  123);
        check("t3 (i)",    uut.u_regfile.reg_file[28], 5);
        check("t4 (size)", uut.u_regfile.reg_file[29], 5);
        if (errors == 0) $display("PASS");
        else             $display("FAIL");
        $display("-----------------------------------");
        $finish;
    end
endmodule
