`timescale 1ns / 1ps

module regfile(rst, clk, wr_en, rd0_addr, rd1_addr, wr_addr, wr_data, rd0_data, rd1_data);
    input logic rst, clk, wr_en;
    input logic [2:0] rd0_addr;
    input logic [2:0] rd1_addr;
    input logic [2:0] wr_addr;
    input logic [15:0] wr_data;
    output logic [15:0] rd1_data;
    output logic [15:0] rd0_data;
    
    logic [15:0] REG [0:7];
    
    always @(posedge clk) begin
        rd0_data=REG[rd0_addr];
        rd1_data=REG[rd1_addr];
    end
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst == 1'b1) begin 
            for (int i = 0; i < 7; i = i + 1) 
                REG[i]=1'b0;
        end 
        else if (wr_en == 1) begin
            REG[wr_addr] <= wr_data;
        end
    end 
endmodule
