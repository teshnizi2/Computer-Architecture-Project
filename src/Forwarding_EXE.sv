module Forwarding_EXE (
    src1_EXE,
    src2_EXE,
    store_src_EXE,
    write_reg_MEM,
    write_reg_WB,
    reg_write_en_MEM,
    reg_write_en_WB,
    alu_input1_sel,
    alu_input2_sel,
    store_val_sel
);
    input [4:0] src1_EXE, src2_EXE, store_src_EXE;
    input [4:0] write_reg_MEM, write_reg_WB;
    input reg_write_en_MEM, reg_write_en_WB;
    output reg [1:0] alu_input1_sel, alu_input2_sel, store_val_sel;

    always @(*) begin
        // initializing sel signals to 0
        // they will change to enable forwrding if needed.
        {alu_input1_sel, alu_input2_sel, store_val_sel} = 0;

        // determining forwarding control signal for store value (store_val)
        if ((store_src_EXE != 5'b00000) && reg_write_en_MEM && (store_src_EXE == write_reg_MEM)) begin
            store_val_sel = 2'b01;
        end
        else if ((store_src_EXE != 5'b00000) && reg_write_en_WB && (store_src_EXE == write_reg_WB)) begin
            store_val_sel = 2'b10;
        end

        // determining forwarding control signal for ALU alu_input1
        if ((src1_EXE != 5'b00000) && reg_write_en_MEM && (src1_EXE == write_reg_MEM)) begin
            alu_input1_sel = 2'b01;
        end
        else if ((src1_EXE != 5'b00000) && reg_write_en_WB && (src1_EXE == write_reg_WB)) begin
            alu_input1_sel = 2'b10;
        end

        // determining forwarding control signal for ALU alu_input2
        if ((src2_EXE != 5'b00000) && reg_write_en_MEM && (src2_EXE == write_reg_MEM)) begin
            alu_input2_sel = 2'b01;
        end
        else if ((src2_EXE != 5'b00000) && reg_write_en_WB && (src2_EXE == write_reg_WB)) begin
            alu_input2_sel = 2'b10;
        end
    end
    
endmodule