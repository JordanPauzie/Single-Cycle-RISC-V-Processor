`timescale 1ns / 1ps

module cpu(clk, reset, pc_out, alu_out);
    input logic clk;    
    input logic reset;   
    output logic [8:0] pc_out;
    output logic [15:0] alu_out;

    logic [15:0] alu_input1, alu_input2, alu_input2_instr_src;
    logic [3:0] ALUOp;
    logic RegWrite;
    logic alu_ovf_flag, alu_take_branch;

    logic [2:0] regfile_ReadAddress1;
    logic [2:0] regfile_ReadAddress2;
    logic [2:0] regfile_WriteAddress;
    logic [15:0] regfile_WriteData;
    logic [15:0] regfile_ReadData1;
    logic [15:0] regfile_ReadData2;
    logic ALUSrc1, ALUSrc2;
    logic [15:0] DataMemOut;
    logic [15:0] zero_register = 0;
    logic MemWrite;

    logic Regdst, Regsrc;
    logic [2:0] rs1, rs2, rd;
    logic [6:0] immediate;
    logic [8:0] offset;
    logic [3:0] opcode;
    logic [5:0] nzimm;
    logic [15:0] instruction;
    logic MemToReg;

    assign pc_out = pc_out;
    assign alu_out = alu_out;

    instruction_memory inst_mem(.a(pc_out), .spo(instruction));

    program_counter prog_count(
        .clk(clk),
        .rst(reset),
        .pc(pc_out),
        .take_branch(alu_take_branch),
        .offset(offset)
    );

    mapper map_inst(
        .instruction(instruction),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .immediate(immediate),
        .nzimm(nzimm),
        .offset(offset),
        .opcode(opcode)
    );

    instruction_decoder inst_dec(
        .nzimm(nzimm),
        .opcode(opcode),
        .immediate(immediate),
        .offset(offset),
        .RegWrite(RegWrite),
        .RegDst(Regdst),
        .ALUSrc1(ALUSrc1),
        .ALUSrc2(ALUSrc2),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .Regsrc(Regsrc),
        .instr_i(alu_input2_instr_src),
        .ALUOp(ALUOp)
    );

    regfile reg1(
        .rst(reset),
        .clk(clk),
        .wr_en(RegWrite),
        .rd0_addr(regfile_ReadAddress1),
        .rd1_addr(regfile_ReadAddress2),
        .wr_addr(regfile_WriteAddress),
        .wr_data(regfile_WriteData),
        .rd0_data(regfile_ReadData1),
        .rd1_data(regfile_ReadData2)
    );

    TwoToOneMux mux1(.a(regfile_ReadData1), .b(zero_register), .sel_mux(ALUSrc1), .out(alu_input1));
    TwoToOneMux mux2(.a(regfile_ReadData2), .b(alu_input2_instr_src), .sel_mux(ALUSrc2), .out(alu_input2));
    TwoToOneMux mux3(.a(alu_output), .b(DataMemOut), .sel_mux(MemToReg), .out(regfile_WriteData));
    TwoToOneMux mux4(.a(rs1), .b(rd), .sel_mux(Regsrc), .out(regfile_ReadAddress1));
    TwoToOneMux mux5(.a(rs2), .b(rd), .sel_mux(Regdst), .out(regfile_WriteAddress));

    assign regfile_ReadAddress2 = rs2;

    alu sixteenbit_alu(
        .s(ALUOp),
        .a(alu_input1),
        .b(alu_input2),
        .f(alu_out),
        .ovf(alu_ovf_flag),
        .take_branch(alu_take_branch)
    );

    data_mem data(
        .clk(clk),
        .we(MemWrite),
        .a(alu_out),
        .d(regfile_ReadData2),
        .spo(DataMemOut)
    );

endmodule
