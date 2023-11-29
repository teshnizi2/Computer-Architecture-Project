module ID2EXE (
    clk,
    rst_b,
    mem_read_en_in,
    mem_to_reg_in,
    reg_write_en_in,
    write_register_in,
    val1_in,
    val2_in,
    val3_in,
    val4_in,
    store_val_in,
    store_val2_in,
    rt_data_in,
    inst_func_in,
    shift_amount_in,
    jal_in,
    b_in,
    alu_op_in,
    PC_in,
    is_load_in,
    cache_en_in,
    src1_in,
    src2_in,
    halted_in,
    complex_in,
    forwarding_en_in,
    complex_forwarding_en_in,
    complex_write_register_in,
    complex_write_register2_in,
    reg_write_en_C_in,
    src1_C_in,
    src2_C_in,
    src3_C_in,
    src4_C_in,
    mem_to_reg_C_in,
    mem_write_en_C_in,
    output_format_C_in,
    input_format_C_in,
    mem_read_en,
    mem_to_reg,
    reg_write_en,
    write_register,
    val1_out,
    val2_out,
    val3_out,
    val4_out,
    store_value,
    store_value2,
    rt_data,
    inst_func,
    shift_amount,
    jal,
    b,
    alu_op,
    PC,
    is_load,
    cache_en,
    src1_out,
    src2_out,
    halted,
    complex,
    forwarding_en,
    complex_forwarding_en,
    complex_write_register,
    complex_write_register2,
    reg_write_en_C,
    src1_C_out,
    src2_C_out,
    src3_C_out,
    src4_C_out,
    mem_to_reg_C,
    mem_write_en_C,
    output_format_C,
    input_format_C
);

    input clk, rst_b, mem_read_en_in, mem_to_reg_in, reg_write_en_in, jal_in, b_in, is_load_in, cache_en_in, halted_in;
    input [4:0] write_register_in, alu_op_in, src1_in, src2_in, shift_amount_in;
    input [5:0] inst_func_in;
    input [31:0] val1_in, val2_in, val3_in, val4_in, store_val_in, store_val2_in, rt_data_in, PC_in;
    input complex_in;
    input forwarding_en_in;
    input complex_forwarding_en_in;
    input [3:0] complex_write_register_in, complex_write_register2_in;
    input reg_write_en_C_in;
    input [3:0] src1_C_in, src2_C_in, src3_C_in, src4_C_in;
    input mem_to_reg_C_in, mem_write_en_C_in;
    input output_format_C_in, input_format_C_in;
    
    
    output reg mem_read_en, mem_to_reg, reg_write_en, jal, b, is_load, cache_en, halted;
    output reg [4:0] write_register, alu_op, src1_out, src2_out, shift_amount;
    output reg [5:0] inst_func;
    output reg [31:0] val1_out, val2_out, val3_out, val4_out, store_value, store_value2, rt_data, PC;
    output reg complex;
    output reg forwarding_en;
    output reg complex_forwarding_en;
    output reg [3:0] complex_write_register, complex_write_register2;
    output reg reg_write_en_C;
    output reg [3:0] src1_C_out, src2_C_out, src3_C_out, src4_C_out;
    output reg mem_to_reg_C, mem_write_en_C;
    output reg output_format_C, input_format_C;

    always @(posedge clk, negedge rst_b) begin
        if (rst_b == 1'b0) begin
            {mem_read_en, mem_to_reg, reg_write_en, jal, b, is_load, cache_en, write_register, alu_op, inst_func,
             src1_out, src2_out, shift_amount, val1_out, val2_out, val3_out, val4_out, 
             store_value, store_value2, rt_data, PC, halted, complex, forwarding_en, complex_forwarding_en, complex_write_register,
             complex_write_register2, reg_write_en_C, src1_C_out, src2_C_out, src3_C_out, src4_C_out,
             mem_to_reg_C, mem_write_en_C, output_format_C, input_format_C} <= 0;
             
        end
        else begin
            mem_read_en <= mem_read_en_in;
            mem_to_reg <= mem_to_reg_in;
            reg_write_en <= reg_write_en_in;
            jal <= jal_in;
            b <= b_in;
            is_load <= is_load_in;
            cache_en <= cache_en_in;
            write_register <= write_register_in;
            alu_op <= alu_op_in;
            inst_func <= inst_func_in;
            val1_out <= val1_in;
            val2_out <= val2_in;
            val3_out <= val3_in;
            val4_out <= val4_in;
            store_value <= store_val_in;
            store_value2 <= store_val2_in;
            PC <= PC_in;
            src1_out <= src1_in;
            src2_out <= src2_in;
            shift_amount <= shift_amount_in;
            rt_data <= rt_data_in;
            halted <= halted_in;
            complex <= complex_in;
            forwarding_en <= forwarding_en_in;
            complex_forwarding_en <= complex_forwarding_en_in;
            complex_write_register <= complex_write_register_in;
            complex_write_register2 <= complex_write_register2_in;
            reg_write_en_C <= reg_write_en_C_in;
            src1_C_out <= src1_C_in;
            src2_C_out <= src2_C_in;
            src3_C_out <= src3_C_in;
            src4_C_out <= src4_C_in;
            mem_to_reg_C <= mem_to_reg_C_in;
            mem_write_en_C <= mem_write_en_C_in;
            output_format_C <= output_format_C_in;
            input_format_C <= input_format_C_in;
        end
    end
    
endmodule