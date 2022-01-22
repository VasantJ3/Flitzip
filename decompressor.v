`timescale 1ns / 1ps

module decompressor #(
    parameter INPUT_WIDTH  = 128,
    parameter OUTPUT_WIDTH = 128,
    parameter CHUNK_SIZE = 8,
    parameter EN_BITS = 3,
    parameter PACKET_SIZE = 512,
    parameter META_START = 75,
    parameter FT_LOC = 126,
    parameter BE_PAIR = 11 
) (
    input                               clk_in,is_head,
    input  [INPUT_WIDTH - 1 : 0]        data_in, // compressed input data
    output [OUTPUT_WIDTH - 1 : 0]   data_out // decompressed output data
);

//wire [INPUT_WIDTH - 1 : 0] buff_out;
reg [(BE_PAIR*4) - 1 : 0] meta_data; // buffer for whole metadata
wire [BE_PAIR - 1 : 0]   meta; // signle base-encoding pair
wire [CHUNK_SIZE - 1 : 0] c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,mux_out,base;
reg [CHUNK_SIZE - 1 : 0] d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16;
wire [EN_BITS - 1 : 0] en_bits;
wire sel_bit;


integer count = 0; // flit counter
integer meta_count=43;


always @(posedge clk_in) begin
    //count = count+1 % 5; // keep track of count of flits


    if (is_head == 1'b1) begin   // If the flit is a head flit, then take the meta data
        meta_data <= data_in[META_START-:44];
    end
    else if (is_head == 1'b0) // If the flit is a body flit, then take the data
        {d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16} <= data_in; 

end

assign meta = meta_data[meta_count-:11];

assign en_bits = meta[10:8];
assign base = meta[7:0];

assign data_out = {c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16};


small_comb comb_logic(
    .data_in(en_bits),
    .data_out(sel_bit)
);

MUX_2_1 vec_mux_d(
    .b(base),
    .a(8'b00000000),
    .out(mux_out),
    .sel(sel_bit)
);

// Parallel Subtractors

subtractor sb1(
    .a(d1),
    .b(mux_out),
    .data_out(c1)
);

subtractor sb2(
    .a(d2),
    .b(mux_out),
    .data_out(c2)
);

subtractor sb3(
    .a(d3),
    .b(mux_out),
    .data_out(c3)
);

subtractor sb4(
    .a(d4),
    .b(mux_out),
    .data_out(c4)
);

subtractor sb5(
    .a(d5),
    .b(mux_out),
    .data_out(c5)
);

subtractor sb6(
    .a(d6),
    .b(mux_out),
    .data_out(c6)
);

subtractor sb7(
    .a(d7),
    .b(mux_out),
    .data_out(c7)
);

subtractor sb8(
    .a(d8),
    .b(mux_out),
    .data_out(c8)
);

subtractor sb9(
    .a(d9),
    .b(mux_out),
    .data_out(c9)
);

subtractor sb10(
    .a(d10),
    .b(mux_out),
    .data_out(c10)
);

subtractor sb11(
    .a(d11),
    .b(mux_out),
    .data_out(c11)
);

subtractor sb12(
    .a(d12),
    .b(mux_out),
    .data_out(c12)
);

subtractor sb13(
    .a(d13),
    .b(mux_out),
    .data_out(c13)
);

subtractor sb14(
    .a(d14),
    .b(mux_out),
    .data_out(c14)
);

subtractor sb15(
    .a(d15),
    .b(mux_out),
    .data_out(c15)
); 

subtractor sb16(
    .a(d16),
    .b(mux_out),
    .data_out(c16)
);
// End of Parallel Subtractors




endmodule  //decompressor