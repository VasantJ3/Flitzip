`timescale 1ns / 1ps

module priority_encoder #(
    parameter    INPUT_WIDTH  = 8,
    parameter    OUTPUT_WIDTH = 3
)
(
 input [INPUT_WIDTH - 1 :0]         data_in,
 output reg [OUTPUT_WIDTH - 1 :0]   code_out
);

always @(data_in) begin
    if (data_in < 8'b00000111)
        code_out <= (data_in);
    else
        code_out <= 3'b111;
end
 
 endmodule // priority_encoder
