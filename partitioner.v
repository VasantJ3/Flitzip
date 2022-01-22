module partitioner #(
    parameter INPUT_WIDTH = 128
    parameter P_SIZE = 8
)
(
  input [INPUT_WIDTH-1 : 0] data
);

wire [P_SIZE-1 : 0] first_byte,
assign first_byte = data[P_SIZE-1 : 0];

wire [P_SIZE-1 : 0] second_byte,
assign second_byte = data[P_SIZE*2 - 1 : P_SIZE*1];
endmodule // partitioner