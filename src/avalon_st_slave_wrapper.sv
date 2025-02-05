module avalon_st_slave_wrapper (
    input clk,
    input _rst,
    input ready_in,
    input startofpacket_in,
    input endofpacket_in,
    input [7:0] data_in,
    input valid_in,
    output reg startofpacket_out,
    output reg endofpacket_out,
    output reg [7:0] data_out,
    output reg ready_out,
    output reg valid_out
);

    reg  [31:0] A;
    reg  [31:0] B;
    wire [63:0] C;

    mult #(
        .SZ(32)
    ) main_module (
        .a(A),
        .b(B),
        .res(C),
        ._rst(_rst),
        .clk(clk)
    );

    reg isA;
    reg [7:0] receive_state;
    reg [7:0] send_state;
    always @(posedge clk, negedge _rst) begin
        if (!_rst) begin
            receive_state <= 0;
            ready_out <= 1;
            A <= 0;
            B <= 0;
            isA <= 0;
        end
        else begin
            if (receive_state == 0) begin
                if (valid_in == 1) begin
                    if (startofpacket_in == 1) begin
                        receive_state <= 1;
                        ready_out <= 1;
                        if (data_in == 1) begin
                            isA <= 1;
                        end
                    end
                end
                else begin
                    receive_state <= 0;
                    ready_out <= 1;
                    A <= 0;
                    B <= 0;
                    isA <= 0;
                end
            end
            if (receive_state == 1) begin
                if (startofpacket_in == 1) begin
                    receive_state <= 2;
                    ready_out <= 1;
                    if (isA == 1) begin
                        A[31:24] <= data_in;
                    end
                    else begin
                        B[31:24] <= data_in;
                    end
                end
                else begin
                    receive_state <= 0;
                    ready_out <= 1;
                    A <= 0;
                    B <= 0;
                    isA <= 0;
                end
            end
            if (receive_state == 2) begin
                if (startofpacket_in == 1) begin
                    receive_state <= 3;
                    ready_out <= 1;
                    if (isA == 1) begin
                        A[23:16] <= data_in;
                    end
                    else begin
                        B[23:16] <= data_in;
                    end
                end
                else begin
                    receive_state <= 0;
                    ready_out <= 1;
                    A <= 0;
                    B <= 0;
                    isA <= 0;
                end
            end
            if (receive_state == 3) begin
                if (startofpacket_in == 1) begin
                    receive_state <= 4;
                    ready_out <= 1;
                    if (isA == 1) begin
                        A[15:8] <= data_in;
                    end
                    else begin
                        B[15:8] <= data_in;
                    end
                end
                else begin
                    receive_state <= 0;
                    ready_out <= 1;
                    A <= 0;
                    B <= 0;
                    isA <= 0;
                end
            end
            if (receive_state == 4) begin
                if (startofpacket_in == 1) begin
                    receive_state <= 0;
                    ready_out <= 1;
                    if (isA == 1) begin
                        A[7:0] <= data_in;
                    end
                    else begin
                        B[7:0] <= data_in;
                    end
                end
                else begin
                    receive_state <= 0;
                    ready_out <= 1;
                    A <= 0;
                    B <= 0;
                    isA <= 0;
                end
            end
        end
    end


    always @(posedge clk, negedge _rst) begin
        if (!_rst) begin
            send_state <= 0;
            startofpacket_out <= 0;
            endofpacket_out <= 0;
            data_out <= 0;
            valid_out <= 0;
        end
        else begin
            if (send_state == 0) begin
                if (ready_in == 1) begin
                    send_state <= 1;
                    startofpacket_out <= 1;
                    endofpacket_out <= 0;
                    data_out <= C[63:56];
                    valid_out <= 1;
                end
            end
            else if (send_state == 1) begin
                if (ready_in == 1) begin
                    send_state <= 2;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= C[55:48];
                    valid_out <= 1;
                end
                else begin
                    send_state <= 0;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= 0;
                    valid_out <= 0;
                end
            end
            else if (send_state == 2) begin
                if (ready_in == 1) begin
                    send_state <= 3;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= C[47:40];
                    valid_out <= 1;
                end
                else begin
                    send_state <= 0;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= 0;
                    valid_out <= 0;
                end
            end
            else if (send_state == 3) begin
                if (ready_in == 1) begin
                    send_state <= 4;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= C[39:32];
                    valid_out <= 1;
                end
                else begin
                    send_state <= 0;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= 0;
                    valid_out <= 0;
                end
            end
            else if (send_state == 4) begin
                if (ready_in == 1) begin
                    send_state <= 5;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= C[31:24];
                    valid_out <= 1;
                end
                else begin
                    send_state <= 0;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= 0;
                    valid_out <= 0;
                end
            end
            else if (send_state == 5) begin
                if (ready_in == 1) begin
                    send_state <= 6;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= C[23:16];
                    valid_out <= 1;
                end
                else begin
                    send_state <= 0;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= 0;
                    valid_out <= 0;
                end
            end
            else if (send_state == 6) begin
                if (ready_in == 1) begin
                    send_state <= 7;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= C[15:8];
                    valid_out <= 1;
                end
                else begin
                    send_state <= 0;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= 0;
                    valid_out <= 0;
                end
            end
            else if (send_state == 7) begin
                if (ready_in == 1) begin
                    send_state <= 8;
                    startofpacket_out <= 0;
                    endofpacket_out <= 1;
                    data_out <= C[7:0];
                    valid_out <= 1;
                end
                else begin
                    send_state <= 0;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= 0;
                    valid_out <= 0;
                end
            end
            else if (send_state == 8) begin
                if (ready_in == 1) begin
                    send_state <= 0;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= 0;
                    valid_out <= 0;
                end
                else begin
                    send_state <= 0;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= 0;
                    valid_out <= 0;
                end
            end
        end
    end
endmodule

