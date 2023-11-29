module WBStage (
    mem_to_reg,
    b,
    jal,
    cache_data_out,
    alu_result,
    PC,
    rt_data,
    mem_to_reg_C,
    complex,
    mem_data1_out_C,
    mem_data2_out_C,
    alu_result2,
    output_format_C,
    rd_data,
    rd_data2,
    rd_data_forwarding_C,
    rd_data2_forwarding_C
);
    input mem_to_reg, b, jal;
    input [31:0] cache_data_out, alu_result, PC, rt_data;
    input mem_to_reg_C, complex;
    input [31:0] mem_data1_out_C, mem_data2_out_C, alu_result2;
    input output_format_C;
    output reg [31:0] rd_data, rd_data2;
    output reg [31:0] rd_data_forwarding_C, rd_data2_forwarding_C;

    reg [31:0] byte_word;
    reg [31:0] bw_result;

    wire signed [31:0] signed_alu_result, signed_alu_result2;
    assign signed_alu_result = alu_result;
    assign signed_alu_result2 = alu_result2;

    always @(*) begin
        if(~complex) begin
            rd_data_forwarding_C = 32'bx;
            rd_data2_forwarding_C = 32'bx;
        end
        else if(mem_to_reg_C) begin
            rd_data_forwarding_C = mem_data1_out_C; 
            rd_data2_forwarding_C = mem_data2_out_C;
        end
        else begin
            rd_data_forwarding_C = alu_result;
            rd_data2_forwarding_C = alu_result2;
        end



    end
    // load
    always @(*) begin
        if (~complex) begin
            if (mem_to_reg) begin
                byte_word = cache_data_out;
                if (b) begin
                    case (alu_result % 4)
                        0: byte_word[7:0] = cache_data_out[31:24];
                        1: byte_word[7:0] = cache_data_out[23:16];
                        2: byte_word[7:0] = cache_data_out[15:8];
                        3: byte_word[7:0] = cache_data_out[7:0];
                    endcase
                end
            end
            else begin
                byte_word = alu_result;
            end
            bw_result[7:0] = byte_word[7:0];
            bw_result[31:8] = b ? rt_data[31:8] : byte_word[31:8];
            rd_data = jal ? PC : bw_result;
            rd_data2 = 32'bx;
        end
        else begin
            if (mem_to_reg_C) begin
                rd_data = output_format_C ? $rtoi($sqrt(mem_data1_out_C ** 2 + mem_data2_out_C ** 2)) : mem_data1_out_C;
                rd_data2 = output_format_C ? $rtoi($atan(mem_data2_out_C/mem_data1_out_C)) : mem_data2_out_C;
            end
            else begin
                rd_data = output_format_C ? $rtoi($sqrt(alu_result ** 2 + alu_result2 ** 2)) : alu_result;
                rd_data2 = output_format_C ? $rtoi($atan(signed_alu_result2/signed_alu_result)) : alu_result2;
            end
        end
    end
    
endmodule