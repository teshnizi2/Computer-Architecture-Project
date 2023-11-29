
module mips_core(
    inst_addr,
    inst,
    mem_addr,
    mem_data_out,
    mem_data_in,
    mem_write_en,
    halted,
    clk,
    rst_b
);
    //output reg [31:0] inst_addr;
    output  [31:0] inst_addr;
    input   [31:0] inst;
    output  [31:0] mem_addr;
    input   [7:0]  mem_data_out[0:3];
    output  [7:0]  mem_data_in[0:3];
    output         mem_write_en;
    output reg     halted;
    input          clk;
    input          rst_b;

    // WIRE DEFINING - 
    // INSTRUCTIONS
    wire [5:0] opcode;
    wire [4:0] rd_num;
    wire [4:0] shift_amount;
    wire [5:0] func;
    wire [15:0] immediate;
    wire [31:0] signed_extend_immediate;
    wire [31:0] zero_extend_immediate;
    wire [31:0] alu_input2_immediate;
    wire [31:0] shifted_immediate;
    wire [27:0] jump_shifted;
    wire [31:0] jump_address;
    wire [31:0] byte_number;
    // wire [31:0] bit_number;

    // CONTROL UNIT
    wire reg_write_en;
    wire [1:0] reg_dst;
    wire alu_src;
    wire [4:0] alu_op;
    wire mem_read_en;
    wire mem_to_reg;
    wire branch;
    wire b;
    wire jr;
    wire jal;
    wire jump;
    wire unsign;
    wire [31:0] bw_result;

    // ALU CONTROL
    wire [5:0] alu_select;

    // ALU
    wire zero;
    wire [31:0] alu_result;

    // REGISTER FILE

    reg [31:0] PC;
    reg [31:0] alu_input2;
    wire [31:0] byte_word;
    wire [31:0] PC_add_4;
    wire [31:0] PC_4_immediate;
    reg [31:0] PC_4_immediate_branch;
    reg [31:0] PC_jump;
    reg [31:0] PC_next;

    //CACHE
    wire hit;
    reg [31:0] cache_addr;
    wire [31:0] cache_data_in;
    wire load;
    wire cache_en;

    //ASSIGNMENTS
    assign rd_num = inst[15:11];
    assign shift_amount = inst[10:6];
    assign func = inst[5:0];
    assign immediate = inst[15:0];
    assign signed_extend_immediate = {{16{inst[15]}}, inst[15:0]};
    assign zero_extend_immediate = {16'b0, inst[15:0]};
    assign alu_input2_immediate = unsign ? zero_extend_immediate : signed_extend_immediate;
    assign shifted_immediate = signed_extend_immediate << 2;
    assign jump_shifted = {inst[25:0], 2'b0};
    assign PC_add_4 = PC + 4;
    assign PC_4_immediate = PC_add_4 + shifted_immediate;
    assign jump_address = {PC_add_4[31:28], jump_shifted};

    assign inst_addr = PC_IF;

    wire is_hazard_detected;
    wire [31:0] PC_IF, PC_ID, new_PC_ID, PC_EXE, PC_MEM, PC_WB;
    wire [31:0] inst_IF, inst_ID;
    wire prog_fl_chg_tkn_ID, flush_IF;
    wire mem_read_en_ID, mem_read_en_EXE, mem_read_en_MEM;
    wire mem_to_reg_ID, mem_to_reg_EXE, mem_to_reg_MEM, mem_to_reg_WB;
    wire reg_write_en_ID, reg_write_en_EXE, reg_write_en_MEM, reg_write_en_WB;
    wire b_ID, b_EXE, b_MEM, b_WB;
    wire jal_ID, jal_EXE, jal_MEM, jal_WB;
    wire is_load_ID, is_load_EXE, is_load_MEM;
    wire cache_en_ID, cache_en_EXE, cache_en_MEM;
    wire [4:0] alu_op_ID, alu_op_EXE;
    wire [4:0] rs_num_ID, rt_num_ID, src2_forwarding_ID, src1_forwarding_EXE, src2_forwarding_EXE;
    wire [5:0] opcode_ID, opcode_EXE;
    wire [31:0] val1_ID, val1_EXE;
    wire [31:0] val2_ID, val2_EXE;
    wire [31:0] rs_data_ID;
    wire [31:0] rt_data_ID, rt_data_EXE, rt_data_MEM, rt_data_WB;
    wire [4:0] write_register_ID, write_register_EXE, write_register_MEM, write_register_WB;
    wire [5:0] inst_func_ID, inst_func_EXE;
    wire [31:0] alu_result_EXE, alu_result_MEM, alu_result_WB;
    wire [31:0] alu_result2_EXE, alu_result2_MEM, alu_result2_WB;
    wire [31:0] rd_data_WB;
    wire [7:0] store_val_MEM [0:3];
    wire [31:0] store_val_EXE, store_val_EXE2MEM;
    wire [1:0] alu_input1_sel, alu_input2_sel, store_val_sel;
    wire [4:0] shift_amount_ID, shift_amount_EXE;
    wire [31:0] cache_data_out_MEM, cache_data_out_WB;
    wire halted_ID, halted_EXE, halted_MEM;
    reg [31:0] store_val_ID;
    
    // COMPLEX
    wire [31:0] rs1_data_C_ID, rs2_data_C_ID;
    wire [31:0] rt1_data_C_ID, rt2_data_C_ID;
    wire [31:0] rd_data2_WB;
    wire [31:0] store_val2_EXE, store_val2_EXE2MEM;
    wire [7:0] store_val2_MEM [0:3];
    wire [31:0] val3_ID, val3_EXE;
    wire [31:0] val4_ID, val4_EXE;
    wire [3:0] complex_write_register_ID, complex_write_register_EXE, complex_write_register_MEM, complex_write_register_WB;
    wire [3:0] complex_write_register2_ID, complex_write_register2_EXE, complex_write_register2_MEM, complex_write_register2_WB;
    wire [3:0] rs1_num_C_ID, rs2_num_C_ID, rt1_num_C_ID, rt2_num_C_ID;
    wire [3:0] rd1_num_C_ID, rd2_num_C_ID;
    wire [2:0] store_val2_sel;
    wire mem_write_en_C_ID, mem_write_en_C_EXE, mem_write_en_C_MEM;
    wire complex_ID, complex_EXE, complex_MEM, complex_WB;
    wire forwarding_en_ID, forwarding_en_EXE, forwarding_en_MEM;
    wire complex_forwarding_en_ID, complex_forwarding_en_EXE, complex_forwarding_en_MEM;
    wire reg_write_en_C_ID, reg_write_en_C_EXE, reg_write_en_C_MEM, reg_write_en_C_WB;
    wire [3:0] src3_forwarding_C_ID, src3_forwarding_C_EXE;
    wire [3:0] src4_forwarding_C_ID, src4_forwarding_C_EXE;
    wire [3:0] src1_forwarding_C_EXE, src2_forwarding_C_EXE;
    wire [2:0] alu_input1_sel_C_EXE, alu_input2_sel_C_EXE, alu_input3_sel_C_EXE, alu_input4_sel_C_EXE;
    wire [2:0] store_val_sel_C_EXE, store_val2_sel_C_EXE;
    wire [7:0] mem_data1_out_C_MEM [0:3];
    wire [7:0] mem_data2_out_C_MEM [0:3];
    wire [31:0] mem_data1_out_C_WB, mem_data2_out_C_WB;
    wire mem_to_reg_C_ID, mem_to_reg_C_EXE, mem_to_reg_C_MEM, mem_to_reg_C_WB;
    wire input_format_C_ID, input_format_C_EXE, input_format_C_MEM, input_format_C_WB;
    wire output_format_C_ID, output_format_C_EXE, output_format_C_MEM, output_format_C_WB;
    wire [31:0] rd_data_forwarding_C_WB, rd_data2_forwarding_C_WB;
    wire [31:0] mem_data1_out_C_P_WB, mem_data2_out_C_P_WB;
    reg [31:0] store_val2_ID;


    //complex assignment
    assign mem_data1_out_C_P_WB = input_format_C_WB ? $rtoi(mem_data1_out_C_WB * $cos(mem_data2_out_C_WB)) : mem_data1_out_C_WB;
    assign mem_data2_out_C_P_WB = input_format_C_WB ? $rtoi(mem_data1_out_C_WB * $sin(mem_data2_out_C_WB)) : mem_data2_out_C_WB;

    always @(*) begin
        if (~complex_ID) begin
            store_val_ID = rt_data_ID;
            store_val2_ID = 32'bx;
        end
        else if (output_format_C_ID == input_format_C_ID) begin
            store_val_ID = rt1_data_C_ID;
            store_val2_ID = rt2_data_C_ID;
        end
        else if (output_format_C_ID == 1'b1) begin // pol2exp
            store_val_ID = $rtoi($sqrt(rt1_data_C_ID ** 2 + rt2_data_C_ID ** 2));
            store_val2_ID = $rtoi($atan(rt2_data_C_ID/rt1_data_C_ID));
        end
        else begin // exp2pol
            store_val_ID = $rtoi(rt1_data_C_ID * $cos(rt2_data_C_ID));
            store_val2_ID = $rtoi(rt1_data_C_ID * $sin(rt2_data_C_ID));
        end 
    end

    IFStage ifstage(
        // input
        .clk(clk),
        .rst_b(rst_b),
        .is_hazard_detected(is_hazard_detected),
        .is_cache_missed(~hit),
        .new_PC(new_PC_ID),
        // output
        .PC(PC_IF)
    );

    assign flush_IF = prog_fl_chg_tkn_ID;
    assign inst_IF = inst;

    // freeze happened when we have hazard or cache miss!!!
    IF2ID if2id(
        // input
        .clk(clk),
        .rst_b(rst_b),
        // .freeze(is_hazard_detected || ~hit),
        .freeze(is_hazard_detected),
        .flush(flush_IF),
        .PC_in(PC_IF),
        .inst_in(inst_IF),
        // output
        .inst(inst_ID),
        .PC(PC_ID)
    );

    IDStage idstage(
        // input
        .is_hazard_detected(is_hazard_detected),
        .inst(inst_ID),
        .PC(PC_ID),
        .rs_data(rs_data_ID),
        .rt_data(rt_data_ID),
        .rs1_data_C(rs1_data_C_ID), 
        .rs2_data_C(rs2_data_C_ID), 
        .rt1_data_C(rt1_data_C_ID), 
        .rt2_data_C(rt2_data_C_ID),
        // output
        .halted(halted_ID),
        .mem_read_en(mem_read_en_ID),
        .mem_to_reg(mem_to_reg_ID),
        .reg_write_en(reg_write_en_ID),
        .b(b_ID),
        .jal(jal_ID),
        .is_load(is_load_ID),
        .cache_en(cache_en_ID),
        .program_flow_change_taken(prog_fl_chg_tkn_ID),
        .alu_op(alu_op_ID),
        .rs_num(rs_num_ID),
        .rt_num(rt_num_ID),
        .src2_forwarding(src2_forwarding_ID),
        .opcode(opcode_ID),
        .val1(val1_ID),
        .val2(val2_ID),
        .new_PC(new_PC_ID),
        .write_register(write_register_ID),
        .shift_amount(shift_amount_ID),
        .func(inst_func_ID),
        .rs1_num_C(rs1_num_C_ID), 
        .rs2_num_C(rs2_num_C_ID), 
        .rt1_num_C(rt1_num_C_ID), 
        .rt2_num_C(rt2_num_C_ID), 
        .rd1_num_C(rd1_num_C_ID), 
        .rd2_num_C(rd2_num_C_ID),
        .complex_write_register(complex_write_register_ID),
        .complex_write_register2(complex_write_register2_ID),
        .complex(complex_ID),
        .complex_forwarding_en(complex_forwarding_en_ID),
        .forwarding_en(forwarding_en_ID),
        .reg_write_en_C(reg_write_en_C_ID),
        .val3(val3_ID),
        .val4(val4_ID),
        .src3_forwarding_C(src3_forwarding_C_ID),
        .src4_forwarding_C(src4_forwarding_C_ID),
        .mem_to_reg_C(mem_to_reg_C_ID),
        .mem_write_en_C(mem_write_en_C_ID),
        .input_format_C(input_format_C_ID),
        .output_format_C(output_format_C_ID)
    );

    ID2EXE id2exe(
        // input
        .clk(clk),
        .rst_b(rst_b),
        .mem_read_en_in(mem_read_en_ID),
        .mem_to_reg_in(mem_to_reg_ID),
        .reg_write_en_in(reg_write_en_ID),
        .write_register_in(write_register_ID),
        .val1_in(val1_ID),
        .val2_in(val2_ID),
        .val3_in(val3_ID),
        .val4_in(val4_ID),
        .store_val_in(store_val_ID),
        .store_val2_in(store_val2_ID),
        .rt_data_in(rt_data_ID),
        .inst_func_in(inst_func_ID),
        .jal_in(jal_ID),
        .b_in(b_ID),
        .alu_op_in(alu_op_ID),
        .PC_in(new_PC_ID),
        .is_load_in(is_load_ID),
        .cache_en_in(cache_en_ID),
        .src1_in(rs_num_ID),
        .src2_in(src2_forwarding_ID),
        .shift_amount_in(shift_amount_ID),
        .halted_in(halted_ID),
        .complex_in(complex_ID),
        .complex_forwarding_en_in(complex_forwarding_en_ID),
        .forwarding_en_in(forwarding_en_ID),
        .complex_write_register_in(complex_write_register_ID),
        .complex_write_register2_in(complex_write_register2_ID),
        .reg_write_en_C_in(reg_write_en_C_ID),
        .src1_C_in(rs1_num_C_ID),
        .src2_C_in(rs2_num_C_ID),
        .src3_C_in(src3_forwarding_C_ID),
        .src4_C_in(src4_forwarding_C_ID),
        .mem_to_reg_C_in(mem_to_reg_C_ID),
        .mem_write_en_C_in(mem_write_en_C_ID),
        .output_format_C_in(output_format_C_ID),
        .input_format_C_in(input_format_C_ID),
        // output
        .mem_read_en(mem_read_en_EXE),
        .mem_to_reg(mem_to_reg_EXE),
        .reg_write_en(reg_write_en_EXE),
        .write_register(write_register_EXE),
        .val1_out(val1_EXE),
        .val2_out(val2_EXE),
        .val3_out(val3_EXE),
        .val4_out(val4_EXE),
        .store_value(store_val_EXE),
        .store_value2(store_val2_EXE),
        .rt_data(rt_data_EXE),
        .inst_func(inst_func_EXE),
        .jal(jal_EXE),
        .b(b_EXE),
        .alu_op(alu_op_EXE),
        .PC(PC_EXE),
        .is_load(is_load_EXE),
        .cache_en(cache_en_EXE),
        .src1_out(src1_forwarding_EXE),
        .src2_out(src2_forwarding_EXE),
        .shift_amount(shift_amount_EXE),
        .halted(halted_EXE),
        .complex(complex_EXE),
        .complex_forwarding_en(complex_forwarding_en_EXE),
        .forwarding_en(forwarding_en_EXE),
        .complex_write_register(complex_write_register_EXE),
        .complex_write_register2(complex_write_register2_EXE),
        .reg_write_en_C(reg_write_en_C_EXE),
        .src1_C_out(src1_forwarding_C_EXE),
        .src2_C_out(src2_forwarding_C_EXE),
        .src3_C_out(src3_forwarding_C_EXE),
        .src4_C_out(src4_forwarding_C_EXE),
        .mem_to_reg_C(mem_to_reg_C_EXE),
        .mem_write_en_C(mem_write_en_C_EXE),
        .output_format_C(output_format_C_EXE),
        .input_format_C(input_format_C_EXE)
    );

    EXEStage exestage(
        // input
        .val1(val1_EXE),
        .val2(val2_EXE),
        .val3(val3_EXE),
        .val4(val4_EXE),
        .alu_result_MEM(alu_result_MEM),
        .alu_result2_MEM(alu_result2_MEM),
        .rd_data_WB(rd_data_WB),
        .rd_data_forwarding_C_WB(rd_data_forwarding_C_WB),
        .rd_data2_forwarding_C_WB(rd_data2_forwarding_C_WB),
        .store_val_in(store_val_EXE),
        .store_val2_in(store_val2_EXE),
        .alu_input1_sel(alu_input1_sel),
        .alu_input2_sel(alu_input2_sel),
        .store_val_sel(store_val_sel),
        .store_val2_sel(store_val2_sel),
        .alu_op(alu_op_EXE),
        .func(inst_func_EXE),
        .shift_amount(shift_amount_EXE),
        .alu_input1_sel_C(alu_input1_sel_C_EXE),
        .alu_input2_sel_C(alu_input2_sel_C_EXE),
        .alu_input3_sel_C(alu_input3_sel_C_EXE),
        .alu_input4_sel_C(alu_input4_sel_C_EXE),
        .complex(complex_EXE),
        .store_val_sel_C(store_val_sel_C_EXE),
        // output
        .alu_result(alu_result_EXE),
        .alu_result2(alu_result2_EXE),
        .store_val_out(store_val_EXE2MEM),
        .store_val2_out(store_val2_EXE2MEM)
    );

    EXE2MEM exe2mem(
        // input
        .clk(clk),
        .rst_b(rst_b),
        .mem_to_reg_in(mem_to_reg_EXE),
        .mem_read_en_in(mem_read_en_EXE),
        .reg_write_en_in(reg_write_en_EXE),
        .is_load_in(is_load_EXE),
        .cache_en_in(cache_en_EXE),
        .jal_in(jal_EXE),
        .b_in(b_EXE),
        .write_register_in(write_register_EXE),
        .store_val_in(store_val_EXE2MEM),
        .store_val2_in(store_val2_EXE2MEM),
        .rt_data_in(rt_data_EXE),
        .PC_in(PC_EXE),
        .alu_result_in(alu_result_EXE),
        .alu_result2_in(alu_result2_EXE),
        .halted_in(halted_EXE),
        .complex_in(complex_EXE),
        .complex_forwarding_en_in(complex_forwarding_en_EXE),
        .forwarding_en_in(forwarding_en_EXE),
        .reg_write_en_C_in(reg_write_en_C_EXE),
        .complex_write_register_in(complex_write_register_EXE),
        .complex_write_register2_in(complex_write_register2_EXE),
        .mem_to_reg_C_in(mem_to_reg_C_EXE),
        .mem_write_en_C_in(mem_write_en_C_EXE),
        .output_format_C_in(output_format_C_EXE),
        .input_format_C_in(input_format_C_EXE),
        // output
        .mem_to_reg(mem_to_reg_MEM),
        .mem_read_en(mem_read_en_MEM),
        .reg_write_en(reg_write_en_MEM),
        .is_load(is_load_MEM),
        .cache_en(cache_en_MEM),
        .jal(jal_MEM),
        .b(b_MEM),
        .write_register(write_register_MEM),
        .store_val({store_val_MEM[3], store_val_MEM[2], store_val_MEM[1], store_val_MEM[0]}),
        .store_val2({store_val2_MEM[3], store_val2_MEM[2], store_val2_MEM[1], store_val2_MEM[0]}),
        .rt_data(rt_data_MEM),
        .PC(PC_MEM),
        .alu_result(alu_result_MEM),
        .alu_result2(alu_result2_MEM),
        .halted(halted),
        .complex(complex_MEM),
        .complex_forwarding_en(complex_forwarding_en_MEM),
        .forwarding_en(forwarding_en_MEM),
        .reg_write_en_C(reg_write_en_C_MEM),
        .complex_write_register(complex_write_register_MEM),
        .complex_write_register2(complex_write_register2_MEM),
        .mem_to_reg_C(mem_to_reg_C_MEM),
        .mem_write_en_C(mem_write_en_C_MEM),
        .output_format_C(output_format_C_MEM),
        .input_format_C(input_format_C_MEM)
    );

    MEMStage memstage(
        // input
        .clk(clk),
        .rst_b(rst_b),
        .cache_addr(alu_result_MEM),
        .store_val({store_val_MEM[3], store_val_MEM[2], store_val_MEM[1], store_val_MEM[0]}),
        .cache_en(cache_en_MEM),
        .is_load(is_load_MEM),
        .b(b_MEM),
        .mem_data_out(mem_data_out),
        // output
        .mem_addr(mem_addr),
        .hit(hit),
        .mem_write_en(mem_write_en),
        .cache_data_out(cache_data_out_MEM),
        .mem_data_in(mem_data_in)
    );

    MEM2WB mem2wb(
        // input
        .clk(clk),
        .rst_b(rst_b),
        .mem_to_reg_in(mem_to_reg_MEM),
        .reg_write_en_in(reg_write_en_MEM),
        .b_in(b_MEM),
        .jal_in(jal_MEM),
        .write_register_in(write_register_MEM),
        .cache_data_out_in(cache_data_out_MEM),
        .alu_result_in(alu_result_MEM),
        .rt_data_in(rt_data_MEM),
        .PC_in(PC_MEM),
        .reg_write_en_C_in(reg_write_en_C_MEM),
        .complex_write_register_in(complex_write_register_MEM),
        .complex_write_register2_in(complex_write_register2_MEM),
        .mem_data1_out_C_in({mem_data1_out_C_MEM[0], mem_data1_out_C_MEM[1],
        mem_data1_out_C_MEM[2], mem_data1_out_C_MEM[3]}),
        .mem_data2_out_C_in({mem_data2_out_C_MEM[0], mem_data2_out_C_MEM[1],
        mem_data2_out_C_MEM[2], mem_data2_out_C_MEM[3]}),
        .mem_to_reg_C_in(mem_to_reg_C_MEM),
        .complex_in(complex_MEM),
        .alu_result2_in(alu_result2_MEM),
        .output_format_C_in(output_format_C_MEM),
        .input_format_C_in(input_format_C_MEM),
        // output
        .mem_to_reg(mem_to_reg_WB),
        .reg_write_en(reg_write_en_WB),
        .b(b_WB),
        .jal(jal_WB),
        .write_register(write_register_WB),
        .cache_data_out(cache_data_out_WB),
        .alu_result(alu_result_WB),
        .rt_data(rt_data_WB),
        .PC(PC_WB),
        .reg_write_en_C(reg_write_en_C_WB),
        .complex_write_register(complex_write_register_WB),
        .complex_write_register2(complex_write_register2_WB),
        .mem_data1_out_C(mem_data1_out_C_WB),
        .mem_data2_out_C(mem_data2_out_C_WB),
        .mem_to_reg_C(mem_to_reg_C_WB),
        .complex(complex_WB),
        .alu_result2(alu_result2_WB),
        .output_format_C(output_format_C_WB),
        .input_format_C(input_format_C_WB)
    );

    WBStage wbstage(
        // input
        .mem_to_reg(mem_to_reg_WB),
        .b(b_WB),
        .jal(jal_WB),
        .cache_data_out(cache_data_out_WB),
        .alu_result(alu_result_WB),
        .PC(PC_WB),
        .rt_data(rt_data_WB),
        .complex(complex_WB),
        .mem_to_reg_C(mem_to_reg_C_WB),
        .mem_data1_out_C(mem_data1_out_C_P_WB),
        .mem_data2_out_C(mem_data2_out_C_P_WB),
        .alu_result2(alu_result2_WB),
        .output_format_C(output_format_C_WB),
        // output
        .rd_data(rd_data_WB),
        .rd_data2(rd_data2_WB),
        .rd_data_forwarding_C(rd_data_forwarding_C_WB),
        .rd_data2_forwarding_C(rd_data2_forwarding_C_WB)
    );

    regfile RegisterFile(
        .rs_data(rs_data_ID),
        .rt_data(rt_data_ID),
        .rs_num(rs_num_ID),
        .rt_num(rt_num_ID),
        .rd_num(write_register_WB),
        .rd_data(rd_data_WB),
        .rd_we(reg_write_en_WB),
        .clk(clk),
        .rst_b(rst_b),
        .halted(halted)
    );
    // COMPLEX Register File
    complex_reg_file C_register_file(
        // input
        .rs1_num(rs1_num_C_ID),
        .rs2_num(rs2_num_C_ID),
        .rt1_num(rt1_num_C_ID),
        .rt2_num(rt2_num_C_ID),
        .rd1_num(complex_write_register_WB),
        .rd2_num(complex_write_register2_WB),
        .rd1_data(rd_data_WB),
        .rd2_data(rd_data2_WB),
        .rd_we(reg_write_en_C_WB),
        .clk(clk),
        .rst_b(rst_b),
        .halted(halted),
        // output
        .rs1_data(rs1_data_C_ID),
        .rs2_data(rs2_data_C_ID),
        .rt1_data(rt1_data_C_ID),
        .rt2_data(rt2_data_C_ID)
    );
    // COMPLEX Memory
    complex_memory C_memory(
        .data1_out(mem_data1_out_C_MEM),
        .data2_out(mem_data2_out_C_MEM),
        .addr1(alu_result_MEM),
        .addr2(alu_result2_MEM),
        .data1_in(store_val_MEM),
        .data2_in(store_val2_MEM),
        .we(mem_write_en_C_MEM),
        .clk(clk),
        .rst_b(rst_b)
    );

    Forwarding_EXE forwarding_EXE(
        // input
        .src1_EXE(src1_forwarding_EXE),
        .src2_EXE(src2_forwarding_EXE),
        .store_src_EXE(write_register_EXE),
        .write_reg_MEM(write_register_MEM),
        .write_reg_WB(write_register_WB),
        .reg_write_en_MEM(reg_write_en_MEM),
        .reg_write_en_WB(reg_write_en_WB),
        // output
        .alu_input1_sel(alu_input1_sel),
        .alu_input2_sel(alu_input2_sel),
        .store_val_sel(store_val_sel)
    );

    hazard_detection hazard_detection_unit(
        // input
        .src1_ID(rs_num_ID),
        .src2_ID(rt_num_ID),
        .write_reg_EXE(write_register_EXE),
        .write_reg_MEM(write_register_MEM),
        .reg_write_en_EXE(reg_write_en_EXE),
        .reg_write_en_MEM(reg_write_en_MEM),
        .mem_to_reg_EXE(mem_to_reg_EXE),
        .opcode_ID(opcode_ID),
        .opcode_EXE(opcode_EXE),
        .funct(inst_func_ID),
        // output
        .is_hazard_detected(is_hazard_detected)
    );

    complex_forwarding_EXE C_forwarding_EXE(
        //input
        .src1_EXE(src1_forwarding_C_EXE),
        .src2_EXE(src2_forwarding_C_EXE),
        .src3_EXE(src3_forwarding_C_EXE),
        .src4_EXE(src4_forwarding_C_EXE),
        .store_src_EXE(complex_write_register_EXE),
        .store_src2_EXE(complex_write_register2_EXE),
        .write_reg_MEM(complex_write_register_MEM),
        .write_reg2_MEM(complex_write_register2_MEM),
        .write_reg_WB(complex_write_register_WB),
        .write_reg2_WB(complex_write_register2_WB),
        .reg_write_en_MEM(reg_write_en_C_MEM),
        .reg_write_en_WB(reg_write_en_C_WB),
        //output
        .alu_input1_sel(alu_input1_sel_C_EXE),
        .alu_input2_sel(alu_input2_sel_C_EXE),
        .alu_input3_sel(alu_input3_sel_C_EXE),
        .alu_input4_sel(alu_input4_sel_C_EXE),
        .store_val_sel(store_val_sel_C_EXE),
        .store_val2_sel (store_val2_sel_C_EXE)
    );

endmodule
