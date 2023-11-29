module complex_forwarding_EXE (
    src1_EXE,
    src2_EXE,
    src3_EXE,
    src4_EXE,
    store_src_EXE,
    store_src2_EXE,
    write_reg_MEM,
    write_reg2_MEM,
    write_reg_WB,
    write_reg2_WB,
    reg_write_en_MEM,
    reg_write_en_WB,
    alu_input1_sel,
    alu_input2_sel,
    alu_input3_sel,
    alu_input4_sel,
    store_val_sel,
    store_val2_sel  
);

    input [3:0] src1_EXE, src2_EXE, src3_EXE, src4_EXE, store_src_EXE, store_src2_EXE;
    input [3:0] write_reg_MEM, write_reg2_MEM, write_reg_WB, write_reg2_WB;
    input reg_write_en_MEM, reg_write_en_WB;
    output reg [2:0] alu_input1_sel, alu_input2_sel, alu_input3_sel, alu_input4_sel, store_val_sel, store_val2_sel;

    always @(*) begin

        {alu_input1_sel, alu_input2_sel, alu_input3_sel, alu_input4_sel, store_val_sel, store_val2_sel} = 0;

        if ((store_src_EXE != 4'b0000) && reg_write_en_MEM && (store_src_EXE == write_reg_MEM)) begin
            store_val_sel = 3'b001;
        end
        else if ((store_src_EXE != 4'b0000) && reg_write_en_WB && (store_src_EXE == write_reg_WB)) begin
            store_val_sel = 3'b010;
        end 

        if ((store_src2_EXE != 4'b0000) && reg_write_en_MEM && (store_src2_EXE == write_reg_MEM)) begin
            store_val2_sel = 3'b001;
        end
        else if ((store_src2_EXE != 4'b0000) && reg_write_en_WB && (store_src2_EXE == write_reg_WB)) begin
            store_val2_sel = 3'b010;
        end 

        if ((store_src_EXE != 4'b0000) && reg_write_en_MEM && (store_src_EXE == write_reg2_MEM)) begin
            store_val_sel = 3'b011;
        end
        else if ((store_src_EXE != 4'b0000) && reg_write_en_WB && (store_src_EXE == write_reg2_WB)) begin
            store_val_sel = 3'b100;
        end 
        if ((store_src2_EXE != 4'b0000) && reg_write_en_MEM && (store_src2_EXE == write_reg2_MEM)) begin
            store_val2_sel = 3'b011;
        end
        else if ((store_src2_EXE != 4'b0000) && reg_write_en_WB && (store_src2_EXE == write_reg2_WB)) begin
            store_val2_sel = 3'b100;
        end


        if ((src1_EXE != 4'b0000) && reg_write_en_MEM && (src1_EXE == write_reg_MEM)) begin
            alu_input1_sel = 3'b001;
        end
        else if ((src1_EXE != 4'b0000) && reg_write_en_WB && (src1_EXE == write_reg_WB)) begin
            alu_input1_sel = 3'b010;
        end 

        if ((src2_EXE != 4'b0000) && reg_write_en_MEM && (src2_EXE == write_reg_MEM)) begin
            alu_input2_sel = 3'b001;
        end
        else if ((src2_EXE != 4'b0000) && reg_write_en_WB && (src2_EXE == write_reg_WB)) begin
            alu_input2_sel = 3'b010;
        end 

        if ((src1_EXE != 4'b0000) && reg_write_en_MEM && (src1_EXE == write_reg2_MEM)) begin
            alu_input1_sel = 3'b011;
        end
        else if ((src1_EXE != 4'b0000) && reg_write_en_WB && (src1_EXE == write_reg2_WB)) begin
            alu_input1_sel = 3'b100;
        end 
        if ((src2_EXE != 4'b0000) && reg_write_en_MEM && (src2_EXE == write_reg2_MEM)) begin
            alu_input2_sel = 3'b011;
        end
        else if ((src2_EXE != 4'b0000) && reg_write_en_WB && (src2_EXE == write_reg2_WB)) begin
            alu_input2_sel = 3'b100;
        end


        if ((src3_EXE != 4'b0000) && reg_write_en_MEM && (src3_EXE == write_reg_MEM)) begin
            alu_input3_sel = 3'b001;
        end
        else if ((src3_EXE != 4'b0000) && reg_write_en_WB && (src3_EXE == write_reg_WB)) begin
            alu_input3_sel = 3'b010;
        end 

        if ((src4_EXE != 4'b0000) && reg_write_en_MEM && (src4_EXE == write_reg_MEM)) begin
            alu_input4_sel = 3'b001;
        end
        else if ((src4_EXE != 4'b0000) && reg_write_en_WB && (src4_EXE == write_reg_WB)) begin
            alu_input4_sel = 3'b010;
        end 

        if ((src3_EXE != 4'b0000) && reg_write_en_MEM && (src3_EXE == write_reg2_MEM)) begin
            alu_input3_sel = 3'b011;
        end
        else if ((src3_EXE != 4'b0000) && reg_write_en_WB && (src3_EXE == write_reg2_WB)) begin
            alu_input3_sel = 3'b100;
        end 
        if ((src4_EXE != 4'b0000) && reg_write_en_MEM && (src4_EXE == write_reg2_MEM)) begin
            alu_input4_sel = 3'b011;
        end
        else if ((src4_EXE != 4'b0000) && reg_write_en_WB && (src4_EXE == write_reg2_WB)) begin
            alu_input4_sel = 3'b100;
        end

    end
    
endmodule