module comparison_control (
    compare_op,
    compare_select
);
    input [4:0] compare_op;
    output reg [5:0] compare_select;

    always @(compare_op) begin
        case(compare_op)
            5'b00110 : compare_select = 6'b010110; // BEQ
            5'b00111 : compare_select = 6'b010111; // BNE
            5'b01000 : compare_select = 6'b011000; // BLEZ
            5'b01001 : compare_select = 6'b011001; // BGTZ
            5'b01010 : compare_select = 6'b011010; // BGEZ
            default : compare_select = 6'b000000;
        endcase
    end
    
endmodule