`timescale 1ns / 1ps

module compressor #(
    parameter    INPUT_WIDTH  = 128,
    parameter    OUTPUT_WIDTH = 128,
    parameter CHUNK_SIZE = 8,
    parameter EN_BITS = 3
) (
    input                           clk_in,is_head, // clock, signals from control logic
    input  [INPUT_WIDTH - 1 : 0]    data_in, // input flit
    output reg [OUTPUT_WIDTH - 1 : 0]   data_out, head_buffer // compressed flit
);

wire [CHUNK_SIZE - 1 : 0] Clarge,Csmall,sb0_out,mux_out;
reg [CHUNK_SIZE - 1 : 0] c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16; // chunks
wire [CHUNK_SIZE - 1 : 0] d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16,base; // deltas
wire [EN_BITS - 1 : 0] en_bits;
wire sel_bit;
integer count = 74; // meta data starting location
// debug values
//assign data_in = 128'hA47642BB000000000000000000000000;

assign base = (Clarge + Csmall)/2; // Base flit

always @(posedge clk_in) begin
    if (is_head == 1'b1) begin
         // if flit type is head, then no output for compressor
        data_out <= 128'bz; // high impedance
        head_buffer <= data_in; // store head flit for adding metadata
    end

    else if(is_head == 1'b0) begin
        {c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16} <= data_in; // chunking of flit

        

        head_buffer[count-:11] <= {en_bits,base}; // add metadata to head flit

        if (en_bits == 3'b000) begin
            data_out <= 128'bz; // if all chunks are same, high impedence
        end

        else begin
            data_out <= {d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16};
            // else, output deltas
        end
    end
end




CompMAX max(
    .clk_in(clk_in),
    .data_in(data_in),
    .data_out(Clarge)
); // Compute the maximum value of the input data

CompMIN min(
    .clk_in(clk_in),
    .data_in(data_in),
    .data_out(Csmall)
); // Compute the minimum value of the input data


subtractor sb0 (
    .a(base),
    .b(Clarge),
    .data_out(sb0_out)
); // Subtract the maximum value from the base value

priority_encoder p_enc(
    .data_in(sb0_out),
    .code_out(en_bits)
); // Encode the difference between the base and maximum values

small_comb comb_logic(
    .data_in(en_bits),
    .data_out(sel_bit)

); // Generate the select bit to be sent to the MUX

MUX_2_1 vec_mux(
    .b(base),
    .a(8'b00000000),
    .out(mux_out),
    .sel(sel_bit)
); // MUX to select the correct value to be sent to the subtractor


// Parallel Subtractors

subtractor sb1(
    .a(c1),
    .b(mux_out),
    .data_out(d1)
);

subtractor sb2(
    .a(c2),
    .b(mux_out),
    .data_out(d2)
);

subtractor sb3(
    .a(c3),
    .b(mux_out),
    .data_out(d3)
);

subtractor sb4(
    .a(c4),
    .b(mux_out),
    .data_out(d4)
);

subtractor sb5(
    .a(c5),
    .b(mux_out),
    .data_out(d5)
);

subtractor sb6(
    .a(c6),
    .b(mux_out),
    .data_out(d6)
);

subtractor sb7(
    .a(c7),
    .b(mux_out),
    .data_out(d7)
);

subtractor sb8(
    .a(c8),
    .b(mux_out),
    .data_out(d8)
);

subtractor sb9(
    .a(c9),
    .b(mux_out),
    .data_out(d9)
);

subtractor sb10(
    .a(c10),
    .b(mux_out),
    .data_out(d10)
);

subtractor sb11(
    .a(c11),
    .b(mux_out),
    .data_out(d11)
);

subtractor sb12(
    .a(c12),
    .b(mux_out),
    .data_out(d12)
);

subtractor sb13(
    .a(c13),
    .b(mux_out),
    .data_out(d13)
);

subtractor sb14(
    .a(c14),
    .b(mux_out),
    .data_out(d14)
);

subtractor sb15(
    .a(c15),
    .b(mux_out),
    .data_out(d15)
); 

subtractor sb16(
    .a(c16),
    .b(mux_out),
    .data_out(d16)
);
// End of Parallel Subtractors



endmodule  //compressor