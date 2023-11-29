module IDStage (
    is_hazard_detected,
    inst,
    PC,
    rs_data,
    rt_data,
    rs1_data_C, 
    rs2_data_C, 
    rt1_data_C, 
    rt2_data_C,
    halted,
    mem_read_en,
    mem_to_reg,
    reg_write_en,
    b,
    jal,
    is_load,
    cache_en,
    program_flow_change_taken,
    alu_op,
    rs_num,
    rt_num,
    src2_forwarding,
    opcode,
    val1,
    val2,
    new_PC,
    write_register,
    shift_amount,
    func,
    rs1_num_C, 
    rs2_num_C, 
    rt1_num_C, 
    rt2_num_C, 
    rd1_num_C, 
    rd2_num_C,
    complex_write_register,
    complex_write_register2,
    complex,
    complex_forwarding_en,
    forwarding_en,
    reg_write_en_C,
    mem_write_en_C,
    mem_to_reg_C,
    val3,
    val4,
    src3_forwarding_C,
    src4_forwarding_C,
    input_format_C,
    output_format_C
);
    input is_hazard_detected;
    input [31:0] inst, PC, rs_data, rt_data;
    output reg halted;
    output mem_read_en, mem_to_reg, reg_write_en, b, jal, is_load, cache_en, program_flow_change_taken;
    output [4:0] alu_op;
    output [5:0] opcode, func;
    output [31:0] new_PC;
    output [4:0] shift_amount;
    output [4:0] rs_num, rt_num, src2_forwarding;
    output reg [4:0] write_register;
    output reg [31:0] val1, val2;

    // COMPLEX inputs
    input [31:0] rs1_data_C, rs2_data_C, rt1_data_C, rt2_data_C;

    // COMPLEX outputs
    output [3:0] rs1_num_C, rs2_num_C, rt1_num_C, rt2_num_C, rd1_num_C, rd2_num_C;
    output reg [3:0] complex_write_register, complex_write_register2;
    output complex, forwarding_en, complex_forwarding_en, reg_write_en_C;
    output mem_write_en_C, mem_to_reg_C;
    output reg [31:0] val3,val4;
    output [3:0] src3_forwarding_C, src4_forwarding_C;
    output input_format_C, output_format_C;
    
    
    

    // COMPLEX ASSIGNMENTS
    assign rs1_num_C = inst[25:22];
    assign rs2_num_C = inst[21:18];
    assign rt1_num_C = inst[17:14];
    assign rt2_num_C = inst[13:10];
    assign rd1_num_C = inst[9:6];
    assign rd2_num_C = inst[5:2];
    assign input_format_C = inst[1];
    assign output_format_C = inst[0];
    assign signed_extend_immediate_C = {{28{inst[9]}}, inst[9:6]};
    assign signed_extend2_immediate_C = {{28{inst[5]}}, inst[5:2]};
    assign src3_forwarding_C = alu_src_C == 1'b0 ? rt1_num_C : 4'b0000;
    assign src4_forwarding_C = alu_src_C == 1'b0 ? rt2_num_C : 4'b0000;
    assign input_format_C = inst[0];
    assign output_format_C = inst[1];


    // TODO: handle different I/O formats (polar vs exponential)

    // WIRE DEFINING - 
    // INSTRUCTIONS
    wire [4:0] rd_num;
    wire [15:0] immediate;
    wire [31:0] signed_extend_immediate;
    wire [31:0] zero_extend_immediate;
    wire [31:0] shifted_immediate;
    wire [27:0] jump_shifted;
    wire [31:0] jump_address;
    wire [31:0] PC_add_4;
    wire [31:0] PC_4_immediate;
    wire [31:0] extended_immediate;

    //ASSIGNMENTS
    assign opcode = inst[31:26];
    assign rs_num = inst[25:21];
    assign rt_num = inst[20:16];
    assign rd_num = inst[15:11];
    assign shift_amount = inst[10:6];
    assign func = inst[5:0];
    assign immediate = inst[15:0];
    assign signed_extend_immediate = {{16{inst[15]}}, inst[15:0]};
    assign zero_extend_immediate = {16'b0, inst[15:0]};
    assign extended_immediate = unsign ? zero_extend_immediate : signed_extend_immediate;
    assign shifted_immediate = signed_extend_immediate << 2;
    assign PC_add_4 = PC + 4;
    assign PC_4_immediate = PC_add_4 + shifted_immediate;
    assign jump_shifted = {inst[25:0], 2'b0};
    assign jump_address = {PC_add_4[31:28], jump_shifted};
    assign program_flow_change_taken = (branch && zero) || jump || jr;

    // CONTROL UNIT
    wire branch;
    wire alu_src;
    wire jr;
    wire jump;
    wire unsign;
    wire mem_write_en;
    wire [1:0] reg_dst;
    wire complex_reg_dst;

    // COMPARISON UNIT
    wire [5:0] compare_select;
    wire zero;
    wire [31:0] PC_temp1, PC_temp2;

    //COMPLEX
    wire [31:0] signed_extend_immediate_C;
    wire [31:0] signed_extend2_immediate_C;
    wire alu_src_C;


    control_unit controlUnit(
        .is_hazard_detected(is_hazard_detected),
        .opcode(opcode),
        .funct(func),
        .reg_write_en(reg_write_en),
        .reg_dst(reg_dst),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .mem_write_en(mem_write_en),
        .mem_read_en(mem_read_en),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .halted(halted),
        .b(b),
        .jr(jr),
        .jal(jal),
        .jump(jump),
        .unsign(unsign),
        .load(is_load),
        .cache_en(cache_en),
        .complex(complex),
        .forwarding_en(forwarding_en),
        .complex_forwarding_en(complex_forwarding_en),
        .complex_reg_dst(complex_reg_dst),
        .reg_write_en_C(reg_write_en_C),
        .alu_src_C(alu_src_C),
        .mem_write_en_C(mem_write_en_C),
        .mem_to_reg_C(mem_to_reg_C)
    );

    comparison_control compare_ctrl(
        .compare_op(alu_op),
        .compare_select(compare_select)
    );

    comparison_unit compare_unit(
        .compare_select(compare_select),
        .data1(rs_data),
        .data2(rt_data),
        .zero(zero)
    );

    assign PC_temp1 = (branch && zero) ? PC_4_immediate : PC_add_4;
    assign PC_temp2 = (jump) ? jump_address : PC_temp1;
    assign new_PC = (jr) ? rs_data : PC_temp2;

    always @(reg_dst, complex) begin
        if (complex)
            write_register = 5'bx;
        else begin
            case (reg_dst) 
                2'b0 : write_register = rt_num;
                2'b01 : write_register = rd_num;
                2'b10 : write_register = 5'b11111;
                default : write_register = 5'b00000;
            endcase

            end
    end

    always @(complex_reg_dst, complex) begin
        if (~complex) begin
            complex_write_register = 4'bx;
            complex_write_register2 = 4'bx;
        end

        else if (complex_reg_dst == 1'b0) begin
            complex_write_register = rt1_num_C;
            complex_write_register2 = rt2_num_C;
        end

        else begin
            complex_write_register = rd1_num_C;
            complex_write_register2 = rd2_num_C;
        end
    end

    always @(*) begin
        if(~complex) begin
            val3 = 32'bx;
            val4 = 32'bx;
        end
        else if(alu_src_C == 1'b0) begin
            val3 = input_format_C ? $rtoi($signed(rs1_data_C) * $cos($signed(rs2_data_C))) : rt1_data_C;
            val4 = input_format_C ? $rtoi($signed(rs1_data_C) * $sin($signed(rs2_data_C))) : rt2_data_C;
        end 
        else begin
            val3 = signed_extend_immediate_C;
            val4 = signed_extend2_immediate_C;
        end
    end

    always @(*) begin
        if(~complex) begin
            val1 = rs_data;
            if (alu_src == 1'b0)
                val2 = rt_data;
            else 
                val2 = extended_immediate;
        end
        else begin
            val1 = input_format_C ? $rtoi($signed(rs1_data_C) * $cos($signed(rs2_data_C))) : rs1_data_C;
            val2 = input_format_C ? $rtoi($signed(rs1_data_C) * $sin($signed(rs2_data_C))) : rs2_data_C;
        end 
    end

    // when alu_src is 0 or the instruction is SW, SB, then src2 is valid
    assign src2_forwarding = ((alu_src == 1'b0) || (opcode == 6'b101011) || (opcode == 6'b101000)) ? rt_num : 5'b00000;

endmodule