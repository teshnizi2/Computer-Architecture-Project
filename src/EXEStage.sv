module EXEStage (
    val1,
    val2,
    val3,
    val4,
    alu_result_MEM,
    alu_result2_MEM,
    rd_data_WB,
    store_val_in,
    store_val2_in,
    rd_data_forwarding_C_WB,
    rd_data2_forwarding_C_WB,
    alu_input1_sel,
    alu_input2_sel,
    alu_input3_sel_C,
    alu_input4_sel_C,
    store_val_sel,
    store_val2_sel,
    alu_op,
    func,
    shift_amount,
    alu_result,
    alu_result2,
    store_val_out,
    store_val2_out,
    alu_input1_sel_C,
    alu_input2_sel_C,
    complex,
    store_val_sel_C
);

    input [31:0] val1, val2, val3, val4, alu_result_MEM, alu_result2_MEM, rd_data_WB, rd_data2_forwarding_C_WB, store_val_in, store_val2_in;
    input [1:0] alu_input1_sel, alu_input2_sel, store_val_sel;
    input [2:0] alu_input3_sel_C, alu_input4_sel_C, store_val2_sel;
    input [4:0] alu_op, shift_amount;
    input [5:0] func;
    input [2:0] alu_input1_sel_C, alu_input2_sel_C, store_val_sel_C;
    input complex;
    input [31:0] rd_data_forwarding_C_WB;
    output [31:0] alu_result, alu_result2;
    output reg [31:0] store_val_out, store_val2_out;

    wire [5:0] alu_select;
    reg [31:0] alu_input1, alu_input2, alu_input3, alu_input4;

    always @(*) begin
        if(~complex) begin
            case(alu_input1_sel)
            2'b00: alu_input1 = val1;
            2'b01: alu_input1 = alu_result_MEM;
            2'b10: alu_input1 = rd_data_WB;
            default: alu_input1 = 32'b0;
        endcase
        end     
        else begin
            case(alu_input1_sel_C)
            3'b000: alu_input1 = val1;
            3'b001: alu_input1 = alu_result_MEM;
            3'b010: alu_input1 = rd_data_forwarding_C_WB;
            3'b011: alu_input1 = alu_result2_MEM;
            3'b100: alu_input1 = rd_data2_forwarding_C_WB;
            default: alu_input1 = 32'b0;
            endcase
        end
    end

    always @(*) begin
        if(~complex) begin
            case(alu_input2_sel)
            2'b00: alu_input2 = val2;
            2'b01: alu_input2 = alu_result_MEM;
            2'b10: alu_input2 = rd_data_WB;
            default: alu_input2 = 32'b0;
        endcase
        end     
        else begin
            case(alu_input2_sel_C)
            3'b000: alu_input2 = val2;
            3'b001: alu_input2 = alu_result_MEM;
            3'b010: alu_input2 = rd_data_forwarding_C_WB;
            3'b011: alu_input2 = alu_result2_MEM;
            3'b100: alu_input2 = rd_data2_forwarding_C_WB;
            default: alu_input2 = 32'b0;
            endcase
        end
    end


    always @(*) begin
        case(alu_input3_sel_C)
            3'b000: alu_input3 = val3;
            3'b001: alu_input3 = alu_result_MEM;
            3'b010: alu_input3 = rd_data_forwarding_C_WB;
            3'b011: alu_input3 = alu_result2_MEM;
            3'b100: alu_input3 = rd_data2_forwarding_C_WB;
            default: alu_input3 = 32'b0;
        endcase
    end

    always @(*) begin
        case(alu_input4_sel_C)
            3'b000: alu_input4 = val4;
            3'b001: alu_input4 = alu_result_MEM;
            3'b010: alu_input4 = rd_data_forwarding_C_WB;
            3'b011: alu_input4 = alu_result2_MEM;
            3'b100: alu_input4 = rd_data2_forwarding_C_WB;
            default: alu_input4 = 32'b0;
        endcase
    end

    always @(*) begin
        if (~complex) begin
            case(store_val_sel)
            2'b00: store_val_out = store_val_in;
            2'b01: store_val_out = alu_result_MEM;
            2'b10: store_val_out = rd_data_WB;
            default: store_val_out = 32'b0;
            endcase
        end
        else begin
            case(store_val_sel_C)
            3'b000: store_val_out = store_val_in;
            3'b001: store_val_out = alu_result_MEM;
            3'b010: store_val_out = rd_data_forwarding_C_WB;
            3'b011: store_val_out = alu_result2_MEM;
            3'b100: store_val_out = rd_data2_forwarding_C_WB;
            default: store_val_out = 32'b0;
            endcase
        end  
    end

    always @(*) begin
        case(store_val2_sel)
            3'b000: store_val2_out = store_val2_in;
            3'b001: store_val2_out = alu_result_MEM;
            3'b010: store_val2_out = rd_data_forwarding_C_WB;
            3'b011: store_val2_out = alu_result2_MEM;
            3'b100: store_val2_out = rd_data2_forwarding_C_WB;
            default: store_val2_out = 32'b0;
        endcase
    end
    
    
    alu_ctrl aluControl(
        .funct(func),
        .alu_op(alu_op),
        .alu_select(alu_select)
    );

    alu alu(
        .data1(alu_input1),
        .data2(alu_input2),
        .data3(alu_input3),
        .data4(alu_input4),
        .shift_amount(shift_amount),
        .alu_select(alu_select),
        .result(alu_result),
        .result2(alu_result2)
    );
    
endmodule