`include "src/flags.svh"
module avalon_mm_slave_wrapper #(
    parameter int SZ = 32
) (
    input _rst,
    input clk,
    input [3:0] addr,  // A1 A0 B1 B0 C3 C2 C1 C0
    input read,
    input write,
    input [15:0] write_data,
    output reg [15:0] read_data
);

    reg  [  SZ-1:0] areg;
    reg  [  SZ-1:0] breg;

    wire [2*SZ-1:0] res;

    wire ready, start;


    mult #(
        .SZ(SZ)
    ) main_module (
        .a(areg),
        .b(breg),
        .res(res),
        .start(start),
        ._rst(_rst),
        .clk(clk),
        .ready(ready)
    );

    always @(posedge clk, negedge _rst) begin
        if (!_rst) begin
            areg <= 0;
            breg <= 0;
            read_data <= 0;
        end
        else begin
            if (read) begin
                if (addr == 4) begin
                    read_data <= res[15:0];
                end
                else if (addr == 5) begin
                    read_data <= res[31:16];
                end
                else if (addr == 6) begin
                    read_data <= res[47:32];
                end
                else if (addr == 7) begin
                    read_data <= res[63:48];
                end
                else begin
                    read_data <= 0;
                end
            end
            else if (write) begin
                if (addr == 0) begin
                    areg[15:0] <= write_data;
                end
                else if (addr == 1) begin
                    areg[31:16] <= write_data;
                end
                if (addr == 2) begin
                    breg[15:0] <= write_data;
                end
                else if (addr == 3) begin
                    breg[31:16] <= write_data;
                end
            end
        end
    end
endmodule

module avalon_mm_master_wrapper #(
    parameter int SZ = 32
) (
    input _rst,
    input clk,
    input [31:0] A,
    input [31:0] B,
    input [15:0] read_data,
    output out_clk,
    output reg [63:0] res,
    output reg [3:0] addr,  // A1 A0 B1 B0 C3 C2 C1 C0
    output reg read,
    output reg write,
    output reg [15:0] write_data
);

    assign out_clk = clk;

    reg [7:0] state;

    always @(posedge clk, negedge _rst) begin
        if (!_rst) begin
            state <= 0;
            addr <= 0;
            read <= 0;
            write <= 0;
            write_data <= 0;
            res <= 0;
        end
        else begin
            if (state == 0) begin
                state <= 1;
                addr <= 0;
                read <= 0;
                write <= 1;
                write_data <= A[15:0];
            end
            else if (state == 1) begin
                state <= 2;
                addr <= 1;
                read <= 0;
                write <= 1;
                write_data <= A[31:16];
            end
            else if (state == 2) begin
                state <= 3;
                addr <= 2;
                read <= 0;
                write <= 1;
                write_data <= B[15:0];
            end
            else if (state == 3) begin
                state <= 4;
                addr <= 3;
                read <= 0;
                write <= 1;
                write_data <= B[31:16];
            end
            else if (state == 4) begin
                state <= 5;
                addr  <= 4;
                read  <= 1;
                write <= 0;
            end
            else if (state == 5) begin
                state <= 6;
                addr  <= 5;
                read  <= 1;
                write <= 0;
            end
            else if (state == 6) begin
                state <= 7;
                addr <= 6;
                read <= 1;
                write <= 0;
                res[15:0] <= read_data;
`ifdef VERBOSE
                $display("%b", res);
`endif
            end
            else if (state == 7) begin
                state <= 8;
                addr <= 7;
                read <= 1;
                write <= 0;
                res[31:16] <= read_data;
`ifdef VERBOSE
                $display("%b", res);
`endif
            end
            else if (state == 8) begin
                state <= 9;
                addr <= 0;
                read <= 0;
                write <= 0;
                res[47:32] <= read_data;
`ifdef VERBOSE
                $display("%b, %b", res, read_data);
`endif
            end
            else if (state == 9) begin
                state <= 0;
                addr <= 0;
                read <= 0;
                write <= 0;
                res[63:48] <= read_data;
`ifdef VERBOSE
                $display("%b", res);
`endif
            end
        end
    end
endmodule
