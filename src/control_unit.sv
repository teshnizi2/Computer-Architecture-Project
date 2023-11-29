module control_unit(
    is_hazard_detected,
    opcode,
    funct,
    reg_write_en,
    reg_dst,
    alu_src,
    alu_op,
    mem_write_en,
    mem_read_en,
    mem_to_reg,
    branch,
    halted,
    jr,
    jal,
    b,
    jump,
    unsign,
    load,
    cache_en,
    complex,
    reg_write_en_C,
    forwarding_en,
    complex_forwarding_en,
    complex_reg_dst,
    alu_src_C,
    mem_write_en_C,
    mem_to_reg_C
);
    input is_hazard_detected;
    input [5:0] opcode;
    input [5:0] funct;
    output reg reg_write_en;
    output reg [1:0] reg_dst;
    output reg alu_src;
    output reg [4:0] alu_op;
    output reg mem_write_en;
    output reg mem_read_en;
    output reg mem_to_reg;
    output reg branch;
    output reg halted;
    output reg b;
    output reg jr;
    output reg jal;
    output reg jump;
    output reg unsign;
    output reg load;
    output reg cache_en;
    output reg complex;
    output reg reg_write_en_C;
    output reg forwarding_en;
    output reg complex_forwarding_en;
    output reg complex_reg_dst;
    output reg alu_src_C;
    output reg mem_write_en_C;
    output reg mem_to_reg_C;

    always @(opcode) begin
        // default: if we have hazard, we should prevent any writes to register and memory 
        reg_write_en = 1'b0;
        reg_dst = 2'b00; 
        alu_src = 1'b0;
        alu_op = 5'b00000;
        mem_write_en = 1'b0;
        mem_read_en = 1'b0;
        mem_to_reg = 1'b0;
        branch = 1'b0;
        halted = 1'b0;
        b = 1'b0;
        jr = 1'b0;
        jal = 1'b0;
        jump = 1'b0;
        unsign = 1'b0;
        load = 1'b0;
        cache_en = 1'b0;
        complex = 1'b0;
        reg_write_en_C = 1'b0;
        complex_forwarding_en = 1'b0;
        forwarding_en = 1'b1;
        alu_src_C = 1'b0;
        mem_write_en_C = 1'b0;
        mem_to_reg_C = 1'b0;
        complex_reg_dst = 1'b0;


        if (is_hazard_detected == 1'b0) begin
            case(opcode)
                6'b000000 : // FORMAT R
                    // alu_op = 0
                    case(funct)
                        6'b001100 : // syscall
                            begin
                                reg_dst = 2'b01;
                                halted = 1'b1;
                            end
                        6'b001000 : // jr
                            begin
                                jr = 1'b1;
                            end
                        default : 
                            begin 
                                reg_write_en = 1'b1;
                                reg_dst = 2'b01;
                            end
                    endcase

                6'b001000 : // ADDi - FORMAT I
                begin
                    reg_write_en = 1'b1;
                    alu_src = 1'b1;
                    alu_op = 5'b00001;
                end

                6'b001001 : // ADDiu
                begin 
                    // reg_dst = 2'b00;
                    reg_write_en = 1'b1;
                    alu_src = 1'b1;
                    alu_op = 5'b00010;
                    unsign = 1'b1;
                end

                6'b001100 : // ANDi
                begin
                    // reg_dst = 2'b00;
                    reg_write_en = 1'b1;
                    alu_src = 1'b1;
                    alu_op = 5'b00011;
                    // unsign = 1'b1;
                end

                6'b001110 : // XORi
                begin
                    // reg_dst = 2'b00;
                    reg_write_en = 1'b1;
                    alu_src = 1'b1;
                    alu_op = 5'b00100;
                    // unsign = 1'b1;
                end

                6'b001101 : // ORi
                begin
                    // reg_dst = 2'b00;
                    reg_write_en = 1'b1;
                    alu_src = 1'b1;
                    alu_op = 5'b00101;
                    unsign = 1'b1;
                end

                6'b000100 : // BRANCHES - BEQ
                begin
                    // reg_dst = 2'b00;
                    alu_src = 1'b0;
                    alu_op = 5'b00110;       // rs == rt
                    branch = 1'b1;
                end

                6'b000101 : // BNE
                begin
                    // reg_dst = 2'b00;
                    alu_src = 1'b0;
                    alu_op = 5'b00111;       // rs != rt
                    branch = 1'b1;
                end

                6'b000110 : // BLEZ
                begin
                    // reg_dst = 2'b00;
                    alu_src = 1'b1;
                    alu_op = 5'b01000;       // rs <= rt
                    branch = 1'b1;
                end

                6'b000111 : // BGTZ
                begin
                    // reg_dst = 2'b00;
                    alu_src = 1'b1;
                    alu_op = 5'b01001;       // rs > rt
                    branch = 1'b1;
                end

                6'b000001 : // BGEZ
                begin
                    // reg_dst = 2'b00;
                    alu_src = 1'b1;
                    alu_op = 5'b01010;       // rs >= rt
                    branch = 1'b1;
                end

                6'b100011 : // lw
                begin
                    reg_write_en = 1'b1;
                    //supposed that reg_dst to 2'b00 is rt
                    reg_dst = 2'b00;
                    alu_src = 1'b1;
                    alu_op = 5'b01011;
                    mem_read_en = 1'b1;
                    mem_to_reg = 1'b1;
                    load = 1'b1;
                    cache_en = 1'b1;
                    // cache_read_en = 1'b1;
                end

                6'b101011 : // sw
                begin
                    // reg_dst = 2'b00;
                    alu_src = 1'b1;
                    alu_op = 5'b01100;
                    cache_en = 1'b1;
                    // mem_write_en = 1'b1;
                    // cache_write_en = 1'b1;
                end

                6'b100000 : // lb - same as lw
                begin
                    reg_write_en = 1'b1;
                    // reg_dst = 2'b00;
                    alu_src = 1'b1;
                    alu_op = 5'b01101;
                    mem_read_en = 1'b1;
                    mem_to_reg = 1'b1;
                    b = 1'b1;
                    load = 1'b1;
                    cache_en = 1'b1;
                    // cache_read_en = 1'b1;
                end

                6'b101000 : // sb - same as sw
                begin
                    // PC_Src = 0;
                    // reg_dst = 2'b00;
                    alu_src = 1'b1;
                    alu_op = 5'b01110;
                    // mem_write_en = 1'b1;
                    b = 1'b1;
                    cache_en = 1'b1;
                    // cache_write_en = 1'b1;
                end

                6'b001010 : // slti
                begin
                    // PC_Src = 0;
                    reg_write_en = 1'b1;
                    // reg_dst = 2'b00;
                    alu_src = 1'b1;
                    alu_op = 5'b01111;

                end

                6'b001111 : // lui
                begin
                    reg_write_en = 1'b1;
                    // reg_dst = 2'b00;
                    alu_src = 1'b1;
                    alu_op = 5'b10000;
                end

                6'b000010 : // jump - j - form J
                begin
                    alu_src = 1'b1;
                    jump = 1'b1;
                end

                6'b000011 : // jal
                begin
                    reg_write_en = 1'b1;
                    reg_dst = 2'b10; 
                    alu_op = 5'b10010;
                    jal = 1'b1;
                    jump = 1'b1;
                end

                //complex

                6'b101100: // add-c
                begin
                    alu_op = 5'b10011;
                    reg_write_en_C = 1'b1;
                    complex = 1'b1;
                    forwarding_en = 1'b0;
                    complex_forwarding_en = 1'b1;
                    complex_reg_dst = 1'b1;
                end

                6'b101101: // sub-c
                begin
                    alu_op = 5'b10100;
                    reg_write_en_C = 1'b1;
                    complex = 1'b1;
                    forwarding_en = 1'b0;
                    complex_forwarding_en = 1'b1;
                    complex_reg_dst = 1'b1;
                end

                6'b101110: // mul-c
                begin
                    alu_op = 5'b10101;
                    reg_write_en_C = 1'b1;
                    complex = 1'b1;
                    forwarding_en = 1'b0;
                    complex_forwarding_en = 1'b1;
                    complex_reg_dst = 1'b1;
                end

                6'b101111: // div-c
                begin
                    alu_op = 5'b10110;
                    reg_write_en_C = 1'b1;
                    complex = 1'b1;
                    forwarding_en = 1'b0;
                    complex_forwarding_en = 1'b1;
                    complex_reg_dst = 1'b1;
                end

                6'b110000: // invc-c
                begin
                    alu_op = 5'b10111;
                    reg_write_en_C = 1'b1;
                    complex = 1'b1;
                    forwarding_en = 1'b0;
                    complex_forwarding_en = 1'b1;
                end

                6'b110001: // conjc-c
                begin
                    alu_op = 5'b11000;
                    reg_write_en_C = 1'b1;
                    complex = 1'b1;
                    forwarding_en = 1'b0;
                    complex_forwarding_en = 1'b1;
                end
                
                6'b110010: // compare-c
                begin
                    alu_op = 5'b11001;
                    reg_write_en_C = 1'b1;
                    complex = 1'b1;
                    forwarding_en = 1'b0;
                    complex_forwarding_en = 1'b1;
                    complex_reg_dst = 1'b1;
                end

                6'b110011: // exp2pol-c
                begin
                    alu_op = 5'b11010;
                    reg_write_en_C = 1'b1;
                    complex = 1'b1;
                    forwarding_en = 1'b0;
                    complex_forwarding_en = 1'b1;
                end

                6'b110100: // pol2exp-c
                begin
                    alu_op = 5'b11011;
                    reg_write_en_C = 1'b1;
                    complex = 1'b1;
                    forwarding_en = 1'b0;
                    complex_forwarding_en = 1'b1;
                end

                6'b110101: // addi_c
                begin
                    alu_op = 5'b11100;
                    reg_write_en_C = 1'b1;
                    complex = 1'b1;
                    forwarding_en = 1'b0;
                    complex_forwarding_en = 1'b1;
                    alu_src_C = 1'b1;
                end

                 6'b110110: // load_c
                begin
                    alu_op = 5'b11101;
                    reg_write_en_C = 1'b1;
                    complex = 1'b1;
                    forwarding_en = 1'b0;
                    complex_forwarding_en = 1'b1;
                    alu_src_C = 1'b1;
                    mem_to_reg_C = 1'b1;
                end

                 6'b110111: // store_c
                begin
                    alu_op = 5'b11110;
                    complex = 1'b1;
                    forwarding_en = 1'b0;
                    complex_forwarding_en = 1'b1;
                    alu_src_C = 1'b1;
                    mem_write_en_C = 1'b1;
                end
                default : ;

            endcase
        end
    end

endmodule
