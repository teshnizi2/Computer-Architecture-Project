module alu (
    data1,
    data2,
    data3,
    data4,
    shift_amount,
    alu_select,
    result,
    result2
);

    input [31:0] data1;
    input [31:0] data2;
    input [31:0] data3;
    input [31:0] data4;
    input [4:0] shift_amount;
    input [5:0] alu_select;
    output reg [31:0] result;
    output reg [31:0] result2;

    wire signed [31:0] signed_data1;
    wire signed [31:0] signed_data2;
    wire signed [31:0] signed_data3;
    wire signed [31:0] signed_data4;

    // wire [31:0] unsigned_data2 = {16'b0, data2[15:0]};

    assign signed_data1 = data1;
    assign signed_data2 = data2;
    assign signed_data3 = data3;
    assign signed_data4 = data4;

    always@(alu_select) begin
        result = 0;
        result2 = 0;
        case(alu_select)
            6'b000000 : result = data1 ^ data2;                       // xor
            6'b000001 : result = data1 | data2;                       // or
            6'b000010 : result = data1 ~| data2;                      // nor
            6'b000011 : result = data1 & data2;                       // and
            6'b000100 : result = signed_data1 + signed_data2;         // add signed
            6'b000101 : result = signed_data1 - signed_data2;         // sub
            6'b000110 : result = data2 + data1;                       // add unsigned
            6'b000111 : result = data1 - data2;                       // sub unsigned
            6'b001000 : result = signed_data1 * signed_data2;         // mult
            6'b001001 : result = signed_data1 / signed_data2;         // div
            6'b001010 : result = data2 << shift_amount;               // shift left logical, amount
            6'b001011 : result = data2 << data1;                      // shift left logical variable, register
            6'b001100 : result = data2 >> shift_amount;               // shift right, amount
            6'b001101 : result = data2 >> data1;                      // shift right, register
            6'b001110 : result = signed_data2 >>> shift_amount;                     // shift right signed
            6'b001111 : result = {31'b0, signed_data1 < signed_data2};                       // slt
            6'b010000 : result = 1;                                   // syscall - can't reach to this point. so don't care
            6'b010001 : result = 1;                                   // JR
            // 6'b010111 : result = {31'b0, signed_data1 < signed_data2}; // TODO: 
            // 6'b010110 : result = data1 + data2;                     //lw
            // 6'b010111 : result = data1 + data2;                     //sw
            // 6'b011000 : result = data1 + data2;                     //lb 
            // 6'b011001 : result = data1 + data2;                     //sb
            6'b010010 : result = {31'b0, signed_data1 < signed_data2};                   // SLTi
            6'b010011 : result = data2 << 16;                       // Lui
            6'b010100 : result = 32'b0;                                 // J - not important
            6'b010101 : result = data1;                             // JAL
            //
            6'b010110 : begin                                       // addc.p
                result = signed_data1 + signed_data3;
                result2 = signed_data2 + signed_data4;
            end
            6'b010111 : begin                                       // subc.p
                result = signed_data1 - signed_data3;
                result2 = signed_data2 - signed_data4;
            end
            6'b011000 : begin                                       // mulc.p
                result = signed_data1 * signed_data3 - signed_data2 * signed_data4;             // real
                result2 = signed_data1 * signed_data4 + signed_data2 * signed_data3;            // imaginary
            end
            6'b011001 : begin                                       // divc.p
                if (signed_data3 ** 2 + signed_data4 ** 2 != 32'b0) begin
                    result = (signed_data1 * signed_data3 + signed_data2 * signed_data4) / (signed_data3 ** 2 + signed_data4 ** 2);  // real
                    result2 = (signed_data2 * signed_data3 - signed_data1 * signed_data4) / (signed_data3 ** 2 + signed_data4 ** 2); // imaginary
                end
            end
            6'b011010 : begin                                        // invc.p
                if (signed_data1 ** 2 + signed_data2 ** 2 != 32'b0) begin
                    result = signed_data1 / (signed_data1 ** 2 + signed_data2 ** 2);         // real
                    result2 = -signed_data2 / (signed_data1 ** 2 + signed_data2 ** 2);       // imaginary
                end
            end
            6'b011011 : begin                                       // conjc.p
                result = signed_data1;                                     // real
                result2 = -signed_data2;                                   // imaginary
            end
            6'b011100 : begin                                       // compare.p
                // first < second then {result, result2} = 1;
                if ((signed_data1 < signed_data3) || (signed_data1 == signed_data3 && signed_data2 < signed_data4)) begin
                    result = 32'b0;
                    result2 = 32'b1;
                end
                // first > second then {result, result2} = 2 ^ 32;
                else if ((signed_data1 > signed_data3) || (signed_data1 == signed_data3 && signed_data2 > signed_data4)) begin
                    result = 32'b1;
                    result2 = 32'b0;
                end
                // first = second then {result, result2} = 0;
                else begin
                    result = 32'b0;
                    result2 = 32'b0;
                end
            end
            6'b011101 : begin                                       // exp2pol
                result = $rtoi(signed_data1 * $cos(signed_data2));
                result2 = $rtoi(signed_data1 * $sin(signed_data2));
            end
            6'b011110 : begin                                       // pol2exp
                result = $rtoi($sqrt(signed_data1 ** 2 + signed_data2 ** 2));
                if (signed_data1 != 32'b0)
                    result2 = $rtoi($atan(signed_data2/signed_data1));
            end
            default: ;
        endcase
    end

endmodule