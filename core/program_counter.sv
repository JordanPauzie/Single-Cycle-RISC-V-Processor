`timescale 1ns / 1ps

module program_counter(clk, rst, pc, take_branch, offset);
    input logic clk, rst, take_branch;
    input logic signed [8:0] offset;
    output logic [8:0] pc;

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 9'b0; // reset to 0
        else if (take_branch)
            pc <= pc + offset; // branch taken
        else
            pc <= pc + 1; // sequential execution
    end

endmodule