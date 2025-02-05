module avalon_st_master_wrapper (
    input [31:0] A,
    input [31:0] B,
    input clk,
    input _rst,
    input ready_in,
    input startofpacket_in,
    input endofpacket_in,
    input [7:0] data_in,
    input valid_in,
    output out_clk,
    output reg startofpacket_out,
    output reg endofpacket_out,
    output reg [7:0] data_out,
    output reg ready_out,
    output reg [63:0] RES,
    output reg ready_res,
    output reg valid_out
);
    reg [7:0] send_state;
    reg [7:0] receive_state;
    assign out_clk = clk;
    always @(posedge clk, negedge _rst) begin
        if (!_rst) begin
            send_state <= 0;
            startofpacket_out <= 0;
            endofpacket_out <= 0;
            data_out <= 0;
            valid_out <= 0;
        end
        else begin
            // Sending A
            if (send_state == 0) begin
                if (ready_in == 1) begin
                    send_state <= 1;
                    startofpacket_out <= 1;
                    endofpacket_out <= 0;
                    data_out <= 1;
                    valid_out <= 1;
                end
            end
            else if (send_state == 1) begin
                if (ready_in == 1) begin
                    send_state <= 2;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= A[31:24];
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
                    data_out <= A[23:16];
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
                    data_out <= A[15:8];
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
                    endofpacket_out <= 1;
                    data_out <= A[7:0];
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


            // Sending B
            if (send_state == 6) begin
                if (ready_in == 1) begin
                    send_state <= 7;
                    startofpacket_out <= 1;
                    endofpacket_out <= 0;
                    data_out <= 2;
                    valid_out <= 1;
                end
            end
            else if (send_state == 7) begin
                if (ready_in == 1) begin
                    send_state <= 8;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= B[31:24];
                    valid_out <= 1;
                end
                else begin
                    send_state <= 6;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= 0;
                    valid_out <= 0;
                end
            end
            else if (send_state == 8) begin
                if (ready_in == 1) begin
                    send_state <= 9;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= B[23:16];
                    valid_out <= 1;
                end
                else begin
                    send_state <= 6;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= 0;
                    valid_out <= 0;
                end
            end
            else if (send_state == 9) begin
                if (ready_in == 1) begin
                    send_state <= 10;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= B[15:8];
                    valid_out <= 1;
                end
                else begin
                    send_state <= 6;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= 0;
                    valid_out <= 0;
                end
            end
            else if (send_state == 10) begin
                if (ready_in == 1) begin
                    send_state <= 11;
                    startofpacket_out <= 0;
                    endofpacket_out <= 1;
                    data_out <= B[7:0];
                    valid_out <= 1;
                end
                else begin
                    send_state <= 6;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= 0;
                    valid_out <= 0;
                end
            end
            else if (send_state == 11) begin
                if (ready_in == 1) begin
                    send_state <= 0;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= 0;
                    valid_out <= 0;
                end
                else begin
                    send_state <= 6;
                    startofpacket_out <= 0;
                    endofpacket_out <= 0;
                    data_out <= 0;
                    valid_out <= 0;
                end
            end
        end
    end



    always @(posedge clk, negedge _rst) begin
        if (!_rst) begin
            receive_state <= 0;
            ready_res <= 0;
            RES <= 0;
            ready_out <= 1;
        end
        else begin
            // Reading Result
            if (receive_state == 0) begin
                if (valid_in == 1) begin
                    if (startofpacket_in == 1) begin
                        receive_state <= 1;
                        ready_res <= 0;
                        RES[63:56] <= data_in;
                        ready_out <= 1;
                    end
                end
                else begin
                    receive_state <= 0;
                    ready_res <= 0;
                    RES <= 0;
                    ready_out <= 1;
                end
            end
            if (receive_state == 1) begin
                if (valid_in == 1) begin
                    receive_state <= 2;
                    ready_res <= 0;
                    RES[55:48] <= data_in;
                    ready_out <= 1;
                end
                else begin
                    receive_state <= 0;
                    ready_res <= 0;
                    RES <= 0;
                    ready_out <= 1;
                end
            end
            if (receive_state == 2) begin
                if (valid_in == 1) begin
                    receive_state <= 3;
                    ready_res <= 0;
                    RES[47:40] <= data_in;
                    ready_out <= 1;
                end
                else begin
                    receive_state <= 0;
                    ready_res <= 0;
                    RES <= 0;
                    ready_out <= 1;
                end
            end
            if (receive_state == 3) begin
                if (valid_in == 1) begin
                    receive_state <= 4;
                    ready_res <= 0;
                    RES[39:32] <= data_in;
                    ready_out <= 1;
                end
                else begin
                    receive_state <= 0;
                    ready_res <= 0;
                    RES <= 0;
                    ready_out <= 1;
                end
            end
            if (receive_state == 4) begin
                if (valid_in == 1) begin
                    receive_state <= 5;
                    ready_res <= 0;
                    RES[31:24] <= data_in;
                    ready_out <= 1;
                end
                else begin
                    receive_state <= 0;
                    ready_res <= 0;
                    RES <= 0;
                    ready_out <= 1;
                end
            end
            if (receive_state == 5) begin
                if (valid_in == 1) begin
                    receive_state <= 6;
                    ready_res <= 0;
                    RES[23:16] <= data_in;
                    ready_out <= 1;
                end
                else begin
                    receive_state <= 0;
                    ready_res <= 0;
                    RES <= 0;
                    ready_out <= 1;
                end
            end
            if (receive_state == 6) begin
                if (valid_in == 1) begin
                    receive_state <= 7;
                    ready_res <= 0;
                    RES[15:8] <= data_in;
                    ready_out <= 1;
                end
                else begin
                    receive_state <= 0;
                    ready_res <= 0;
                    RES <= 0;
                    ready_out <= 1;
                end
            end
            if (receive_state == 7) begin
                if (valid_in == 1) begin
                    receive_state <= 0;
                    ready_res <= 1;
                    RES[7:0] <= data_in;
                    ready_out <= 1;
                end
                else begin
                    receive_state <= 0;
                    ready_res <= 0;
                    RES <= 0;
                    ready_out <= 1;
                end
            end
        end
    end
endmodule
