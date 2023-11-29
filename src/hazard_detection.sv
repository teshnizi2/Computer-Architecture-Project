module hazard_detection (
    src1_ID,
    src2_ID,
    write_reg_EXE,
    write_reg_MEM,
    reg_write_en_EXE,
    reg_write_en_MEM,
    mem_to_reg_EXE,
    opcode_ID,
    opcode_EXE,
    funct,
    is_hazard_detected
);
    input [4:0] src1_ID, src2_ID;
    input [4:0] write_reg_EXE, write_reg_MEM;
    input reg_write_en_EXE, reg_write_en_MEM, mem_to_reg_EXE;
    input [5:0] opcode_ID, funct, opcode_EXE;
    output is_hazard_detected;

    wire src1_is_valid, src2_is_valid, exe_has_hazard, mem_has_hazard, hazard, inst_is_branch, inst_is_store_or_beq_or_bne;
    assign inst_is_store_or_beq_or_bne = (opcode_ID == 6'b000100) || (opcode_ID == 6'b000101) || // BEQ - BNE 
    (opcode_ID == 6'b101011) || (opcode_ID == 6'b101000); // SW - SB

    // rt_data is valid when we have R-type inst (except syscall and JR) or SW or SB or BEQ or BNE
    assign src2_is_valid = inst_is_store_or_beq_or_bne ||
    ((opcode_ID == 6'b000000) && (funct != 6'b001100) && (funct != 6'b001000));

    assign src1_is_valid = (opcode_ID != 6'b000010) && (opcode_ID != 6'b000011) && 
    ((opcode_ID == 6'b000000) && (funct != 6'b001100));

    // instruction is branch when we have BEQ or BNE or BLEZ or BGTZ or BGEZ
    assign inst_is_branch = (opcode_ID == 6'b000100) || (opcode_ID == 6'b000101) || 
    (opcode_ID == 6'b000110) || (opcode_ID == 6'b000111) || (opcode_ID == 6'b000001);


    // we have hazard in EXE stage when reg_write_en signal is activated in EXE stage and src1 in ID stage is equal to the register we want to write
    // or rt_data is valid and rt_data in ID stage is equal to the register we want to write
    assign exe_has_hazard = reg_write_en_EXE && write_reg_EXE != 5'b00000 && ((src1_is_valid && (src1_ID == write_reg_EXE)) || (src2_is_valid && (src2_ID == write_reg_EXE)));
    
    // we have hazard in MEM stage when reg_write_en signal is activated in MEM stage and src1 in ID stage is equal to the register we want to write
    // or rt_data is valid and rt_data in ID stage is equal to the register we want to write
    assign mem_has_hazard = reg_write_en_MEM && write_reg_MEM != 5'b00000 && ((src1_is_valid && (src1_ID == write_reg_MEM)) || (src2_is_valid && (src2_ID == write_reg_MEM)));

    assign hazard = exe_has_hazard || mem_has_hazard;
    assign is_hazard_detected = (inst_is_branch && hazard) || (mem_to_reg_EXE && mem_has_hazard);
    
endmodule