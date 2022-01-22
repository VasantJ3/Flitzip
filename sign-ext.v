`timescale 1ns / 1ps

module SignExtender #(
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 8
)
(
    input [INPUT_WIDTH - 1 :0] extend,
    output [OUTPUT_WIDTH - 1 :0] extended
);
    assign extended = (extend[INPUT_WIDTH - 1] ? (extend[INPUT_WIDTH - 1:0] | (2'b1 << INPUT_WIDTH)) : extend[INPUT_WIDTH - 1:0]);
endmodule // SignExtender