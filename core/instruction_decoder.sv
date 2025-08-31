`timescale 1ns / 1ps

module instruction_decoder(rs1, rs2, rd, immediate, nzimm, offset, opcode, RegWrite, RegDst, instr_i, ALUSrc1, ALUSrc2, ALUOp, MemWrite, MemToReg, Regsrc);
    input logic [2:0] rs1, rs2, rd
    input logic [6:0] immediate;
    input logic [5:0] nzimm;
    input logic [8:0] offset;
    input logic [3:0] opcode;
    output logic RegWrite, RegDst, ALUSrc1, ALUSrc2, MemWrite, MemToReg, Regsrc;
    output logic [15:0] instr_i;
    output logic [3:0] ALUOp;
    
    always_comb begin
        case(opcode)
            4'b0000: begin // lw
                RegWrite = 1;
                RegDst = 1;
                instr_i = {{9{immediate[6]}}, immediate[6:0]};
                ALUSrc1 = 0;
                ALUSrc2 = 1;
                ALUOp = 4'b0000;
                MemWrite = 0;
                MemToReg = 1;
                Regsrc = 0;
            end
            4'b0001: begin // sw
                RegWrite = 0;
                RegDst = 0;
                instr_i = {{9{immediate[6]}}, immediate[6:0]};
                ALUSrc1 = 0;
                ALUSrc2 = 1;
                ALUOp = 4'b0000;
                MemWrite = 1;
                MemToReg = 0;
                Regsrc = 0;
            end 
            4'b0010: begin // add
                RegWrite = 1;
                RegDst = 1;
                instr_i = 16'h0000;
                ALUSrc1 = 0;
                ALUSrc2 = 0;
                ALUOp = 4'b0000;
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 0;
            end                
            4'b0011: begin // addi
                RegWrite = 1;
                RegDst = 1;
                instr_i = {{10{nzimm[5]}}, nzimm};
                ALUSrc1 = 0;
                ALUSrc2 = 1;
                ALUOp = 4'b0000;
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 1; 
            end
            4'b0100: begin // and
                RegWrite = 1;
                RegDst = 1;
                instr_i = 16'h0000;
                ALUSrc1 = 0;
                ALUSrc2 = 0;
                ALUOp = 4'b0010;
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 1; 
            end
            4'b0101: begin // andi
                RegWrite = 1;
                RegDst = 1;
                instr_i = {{9{immediate[6]}}, immediate[6:0]};
                ALUSrc1 = 0;
                ALUSrc2 = 1;
                ALUOp = 4'b0010;
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 1; 
            end 
            4'b0110: begin // or
                RegWrite = 1;
                RegDst = 1;
                instr_i = 16'h0000; 
                ALUSrc1 = 0;
                ALUSrc2 = 0;
                ALUOp = 4'b0011; 
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 1;  
            end 
            4'b0111: begin // xor
                RegWrite = 1;
                RegDst = 1;
                instr_i = 16'h0000;
                ALUSrc1 = 0;
                ALUSrc2 = 0;
                ALUOp = 4'b1000; 
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 1;  
            end  
            4'b1000: begin // srai
                RegWrite = 1;
                RegDst = 1;
                instr_i = {{10{nzimm[5]}}, nzimm}; 
                ALUSrc1 = 0;
                ALUSrc2 = 1;
                ALUOp = 4'b0100; 
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 1;  
            end  
            4'b1001: begin // sll
                RegWrite = 1;
                RegDst = 1;
                instr_i = {{10{nzimm[5]}}, nzimm};
                ALUSrc1 = 0;
                ALUSrc2 = 1;
                ALUOp = 4'b0101;
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 1;  
            end  
            4'b1010: begin // beqz
                RegWrite = 0;
                RegDst = 0;
                instr_i = {{7{offset[8]}}, offset}; 
                ALUSrc1 = 1;
                ALUSrc2 = 0;
                ALUOp = 4'b0110; 
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 0;  
            end  
            4'b1011: begin // bnez
                RegWrite = 0;
                RegDst = 0;
                instr_i = {{7{offset[8]}}, offset}; 
                ALUSrc1 = 1; 
                ALUSrc2 = 0;
                ALUOp = 4'b0111; 
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 0;  
            end              
            default: begin
                RegWrite = 0;
                RegDst = 0;
                instr_i = 16'h0000;
                ALUSrc1 = 0;
                ALUSrc2 = 0;
                ALUOp = 4'b0000;
                MemWrite = 0;
                MemToReg = 0;
                Regsrc = 0;
            end
        endcase
    end
        
endmodule
