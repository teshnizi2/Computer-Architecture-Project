module EXE2MEM (
    clk,
    rst_b,
    mem_to_reg_in,
    mem_read_en_in,
    reg_write_en_in,
    is_load_in,
    cache_en_in,
    jal_in,
    b_in,
    write_register_in,
    store_val_in,
    store_val2_in,
    rt_data_in,
    PC_in,
    alu_result_in,
    alu_result2_in,
    halted_in,
    complex_in,
    forwarding_en_in,
    complex_forwarding_en_in,
    complex_write_register_in,
    complex_write_register2_in,
    reg_write_en_C_in,
    mem_to_reg_C_in,
    mem_write_en_C_in,
    output_format_C_in,
    input_format_C_in,
    mem_to_reg,
    mem_read_en,
    reg_write_en,
    is_load,
    cache_en,
    jal,
    b,
    write_register,
    store_val,
    store_val2,
    rt_data,
    PC,
    alu_result,
    alu_result2,
    halted,
    complex,
    forwarding_en,
    complex_forwarding_en,
    reg_write_en_C,
    complex_write_register,
    complex_write_register2,
    mem_to_reg_C,
    mem_write_en_C,
    output_format_C,
    input_format_C
);

    input clk, rst_b, mem_to_reg_in, mem_read_en_in, reg_write_en_in, is_load_in, cache_en_in, jal_in, b_in, halted_in;
    input [4:0] write_register_in;
    input [31:0] store_val_in, PC_in, alu_result_in, alu_result2_in, rt_data_in;
    input complex_in, forwarding_en_in, complex_forwarding_en_in, reg_write_en_C_in;
    input [3:0] complex_write_register_in, complex_write_register2_in;
    input [31:0] store_val2_in;
    input mem_to_reg_C_in, mem_write_en_C_in;
    input output_format_C_in, input_format_C_in;

    output reg mem_to_reg, mem_read_en, reg_write_en, is_load, cache_en, jal, b, halted;
    output reg [4:0] write_register;
    output reg [31:0] store_val, PC, alu_result, alu_result2, rt_data;
    output reg complex, forwarding_en, complex_forwarding_en, reg_write_en_C;
    output reg [3:0] complex_write_register, complex_write_register2;
    output reg [31:0] store_val2;
    output reg mem_to_reg_C, mem_write_en_C;
    output reg output_format_C, input_format_C;

    always @(posedge clk, negedge rst_b) begin
        if (rst_b == 1'b0) begin
            {mem_to_reg, mem_read_en, reg_write_en, is_load, cache_en, jal, b, 
            write_register, store_val, PC, alu_result, alu_result2, rt_data, halted,
            complex, forwarding_en, complex_forwarding_en, reg_write_en_C,
            complex_write_register, complex_write_register2, store_val2,
            mem_to_reg_C, mem_write_en_C, output_format_C, input_format_C} <= 0;
        end
        else begin
            mem_to_reg <= mem_to_reg_in;
            mem_read_en <= mem_read_en_in;
            reg_write_en <= reg_write_en_in;
            is_load <= is_load_in;
            cache_en <= cache_en_in;
            jal <= jal_in;
            b <= b_in;
            write_register <= write_register_in;
            store_val <= store_val_in;
            PC <= PC_in;
            alu_result <= alu_result_in;
            alu_result2 <= alu_result2_in;
            rt_data <= rt_data_in;
            halted <= halted_in;
            complex <= complex_in;
            forwarding_en <= forwarding_en_in;
            complex_forwarding_en <= complex_forwarding_en_in;
            reg_write_en_C <= reg_write_en_C_in;
            complex_write_register <= complex_write_register_in;
            complex_write_register2 <= complex_write_register2_in;
            store_val2 <= store_val2_in;
            mem_to_reg_C <= mem_to_reg_C_in;
            mem_write_en_C <= mem_write_en_C_in;
            output_format_C <= output_format_C_in;
            input_format_C <= input_format_C_in;
        end
    end
    
endmodule