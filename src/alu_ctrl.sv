module alu_ctrl (
    funct,
    alu_op,
    alu_select
);
    input [5:0] funct;
    input [4:0] alu_op;
    output reg [5:0] alu_select;

    always @(alu_op) begin
        case(alu_op)
        5'b00000 : begin
            case(funct)
                6'b100110 : alu_select = 6'b000000; // 0 - xor
                6'b100101 : alu_select = 6'b000001; // 1 - or
                6'b100111 : alu_select = 6'b000010; // 2 - nor
                6'b100100 : alu_select = 6'b000011; // 3 - and
                6'b100000 : alu_select = 6'b000100; // 4 - add
                6'b100010 : alu_select = 6'b000101; // 5 - sub
                6'b100001 : alu_select = 6'b000110; // 6 - addu
                6'b100011 : alu_select = 6'b000111; // 7 - subu
                6'b011000 : alu_select = 6'b001000; // 8 - mult
                6'b011010 : alu_select = 6'b001001; // 9 - div
                6'b000000 : alu_select = 6'b001010; // 10 - shift left, shift amount
                6'b000100 : alu_select = 6'b001011; // 11 - shift left, vaiable (register)
                6'b000010 : alu_select = 6'b001100; // 12 - shift right, shift amount
                6'b000110 : alu_select = 6'b001101; // 13 - shift right, variable (register)
                6'b000011 : alu_select = 6'b001110; // 14 - shift right signed  
                6'b101010 : alu_select = 6'b001111; // 15 - SLT
                6'b001100 : alu_select = 6'b010000; // 16 - syscall
                6'b001000 : alu_select = 6'b010001; // 17 - jr
                default : alu_select = 6'b000000;
            endcase
        end
        5'b00001 : alu_select = 6'b000100; // ADDi - FORMAT I   
        5'b00010 : alu_select = 6'b000110; // ADDiu
        5'b00011 : alu_select = 6'b000011; // ANDi
        5'b00100 : alu_select = 6'b000000; // XORi
        5'b00101 : alu_select = 6'b000001; // ORi
        /////////////////////////////////////////////////////////
        5'b00110 : alu_select = 6'b010110; // BEQ
        5'b00111 : alu_select = 6'b010111; // BNE
        5'b01000 : alu_select = 6'b011000; // BLEZ
        5'b01001 : alu_select = 6'b011001; // BGTZ
        5'b01010 : alu_select = 6'b011010; // BGEZ
        /////////////////////////////////////////////////////////
        5'b01011 : alu_select = 6'b000100; // LW
        5'b01100 : alu_select = 6'b000100; // SW 
        5'b01101 : alu_select = 6'b000100; // LB  
        5'b01110 : alu_select = 6'b000100; // SB
        5'b01111 : alu_select = 6'b010010; // 18 - SLTi
        5'b10000 : alu_select = 6'b010011; // 19 - Lui
        5'b10001 : alu_select = 6'b010100; // 20 - j - don't care
        5'b10010 : alu_select = 6'b010101; // 21 - jal
        // complex operation
        5'b10011 : alu_select = 6'b010110; // 22 - addc.p
        5'b10100 : alu_select = 6'b010111; // 23 - subc.p
        5'b10101 : alu_select = 6'b011000; // 24 - mulc.p
        5'b10110 : alu_select = 6'b011001; // 25 - divc.p
        5'b10111 : alu_select = 6'b011010; // 26 - invc.p
        5'b11000 : alu_select = 6'b011011; // 27 - conjc.p
        5'b11001 : alu_select = 6'b011100; // 28 - compare.p
        5'b11010 : alu_select = 6'b011101; // 29 - exp2pol
        5'b11011 : alu_select = 6'b011110; // 30 - pol2exp
        5'b11100 : alu_select = 6'b010110; // 31 - addi_c
        5'b11101 : alu_select = 6'b010110; // 32 - load_c
        5'b11110 : alu_select = 6'b010110; // 33 - store_c

        default : alu_select = 6'b000000;
        endcase
    end
//test
endmodule