module comparison_unit (
    compare_select,
    data1,
    data2,
    zero
);
    input [5:0] compare_select;
    input [31:0] data1, data2;
    output reg zero;

    wire signed [31:0] signed_data1;
    wire signed [31:0] signed_data2;

    assign signed_data1 = data1;
    assign signed_data2 = data2;

    always @(compare_select) begin
        zero = 1'b0;
        case(compare_select)
            6'b010110 : zero = (signed_data1 == signed_data2);      // BEQ
            6'b010111 : zero = (signed_data1 != signed_data2);      // BNE
            6'b011000 : zero = (signed_data1 <= 0);                 // BLEZ
            6'b011001 : zero = (signed_data1 > 0);                  // BGTZ
            6'b011010 : zero = (signed_data1 >= 0);                 // BGEZ
            default: ;
        endcase
    end
    
endmodule