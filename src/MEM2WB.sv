module MEM2WB (
    clk,
    rst_b,
    mem_to_reg_in,
    reg_write_en_in,
    b_in,
    jal_in,
    write_register_in,
    cache_data_out_in,
    alu_result_in,
    rt_data_in,
    PC_in,
    reg_write_en_C_in,
    complex_write_register_in,
    complex_write_register2_in,
    mem_data1_out_C_in,
    mem_data2_out_C_in,
    mem_to_reg_C_in,
    alu_result2_in,
    complex_in,
    output_format_C_in,
    input_format_C_in,
    mem_to_reg,
    reg_write_en,
    b,
    jal,
    write_register,
    cache_data_out,
    alu_result,
    rt_data,
    PC,
    reg_write_en_C,
    complex_write_register,
    complex_write_register2,
    mem_data1_out_C,
    mem_data2_out_C,
    mem_to_reg_C,
    alu_result2,
    complex,
    output_format_C,
    input_format_C
);
    input clk, rst_b, mem_to_reg_in, b_in, jal_in, reg_write_en_in;
    input [4:0] write_register_in;
    input [31:0] cache_data_out_in, alu_result_in, rt_data_in, PC_in;
    input reg_write_en_C_in;
    input [3:0] complex_write_register_in, complex_write_register2_in;
    input [31:0] mem_data1_out_C_in, mem_data2_out_C_in;
    input mem_to_reg_C_in, complex_in;
    input [31:0] alu_result2_in;
    input output_format_C_in, input_format_C_in;

    output reg mem_to_reg, b, jal, reg_write_en;
    output reg [4:0] write_register;
    output reg [31:0] cache_data_out, alu_result, rt_data, PC;
    output reg reg_write_en_C;
    output reg [3:0] complex_write_register, complex_write_register2;
    output reg [31:0] mem_data1_out_C, mem_data2_out_C;
    output reg mem_to_reg_C, complex;
    output reg [31:0] alu_result2;
    output reg output_format_C, input_format_C;

    always @(posedge clk, negedge rst_b) begin
        if (rst_b == 1'b0) begin
            {mem_to_reg, b, jal, reg_write_en, write_register, cache_data_out, alu_result, 
            rt_data, PC, reg_write_en_C, complex_write_register, complex_write_register2,
            mem_data1_out_C, mem_data2_out_C, mem_to_reg_C, alu_result2, complex, output_format_C,
            input_format_C} <= 0;
        end
        else begin
            mem_to_reg <= mem_to_reg_in;
            b <= b_in;
            jal <= jal_in;
            reg_write_en <= reg_write_en_in;
            write_register <= write_register_in;
            cache_data_out <= cache_data_out_in;
            alu_result <= alu_result_in;
            rt_data <= rt_data_in;
            PC <= PC_in;
            reg_write_en_C <= reg_write_en_C_in;
            complex_write_register <= complex_write_register_in;
            complex_write_register2 <= complex_write_register2_in;
            mem_data1_out_C <= mem_data1_out_C_in;
            mem_data2_out_C <= mem_data2_out_C_in;
            mem_to_reg_C <= mem_to_reg_C_in;
            alu_result2 <= alu_result2_in;
            complex <= complex_in;
            output_format_C <= output_format_C_in;
            input_format_C <= input_format_C_in;
        end
    end
    
endmodule