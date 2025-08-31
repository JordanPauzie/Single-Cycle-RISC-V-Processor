`timescale 1ns / 1ps

module TwoToOneMux(a,b,sel_mux,out);
    input logic sel_mux;
    input logic [15:0] a;
    input logic [15:0] b;
    output logic [15:0] out;
    
    always_comb begin 
        case (sel_mux)
             1'b0 : out = a;
             1'b1 : out = b;
        endcase 
    end
endmodule
