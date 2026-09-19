`timescale 1ns / 1ps

module VM (
    input clk,
    input rstn,
    input [1:0] coin_in,
    input beverage_take,
    input change_take,
    output reg [4:0] money_account,
    output reg beverage_out,
    output reg [1:0] change_out
);

    localparam [1:0] NO_COIN   = 2'b00;
    localparam [1:0] COIN_1000 = 2'b01;
    localparam [1:0] COIN_5000 = 2'b10;

    localparam [4:0] BEVERAGE_PRICE = 5'd10;
    localparam [4:0] MAX_BALANCE    = 5'd20;

    // rstn is active-high in the original project specification/testbench.
    always @(posedge clk or posedge rstn) begin
        if (rstn) begin
            money_account <= 5'd0;
            beverage_out <= 1'b0;
            change_out <= 2'b00;
        end
        else begin
            // beverage_out and change_out are one-cycle pulses.
            beverage_out <= 1'b0;
            change_out <= 2'b00;

            // Accept a coin only when no other command is asserted.
            if (
                coin_in != NO_COIN
                && beverage_take == 1'b0
                && change_take == 1'b0
            ) begin
                case (coin_in)
                    COIN_1000: begin
                        if (money_account + 5'd1 <= MAX_BALANCE) begin
                            money_account <= money_account + 5'd1;
                        end
                        else begin
                            change_out <= COIN_1000;
                        end
                    end

                    COIN_5000: begin
                        if (money_account + 5'd5 <= MAX_BALANCE) begin
                            money_account <= money_account + 5'd5;
                        end
                        else begin
                            change_out <= COIN_5000;
                        end
                    end

                    default: begin
                        // 2'b11 is not a valid coin input.
                    end
                endcase
            end

            // Dispense a beverage only when it is the sole command.
            else if (
                coin_in == NO_COIN
                && beverage_take == 1'b1
                && change_take == 1'b0
            ) begin
                if (money_account >= BEVERAGE_PRICE) begin
                    money_account <= money_account - BEVERAGE_PRICE;
                    beverage_out <= 1'b1;
                end
            end

            // Return change only when it is the sole command.
            else if (
                coin_in == NO_COIN
                && beverage_take == 1'b0
                && change_take == 1'b1
            ) begin
                if (money_account >= 5'd5) begin
                    money_account <= money_account - 5'd5;
                    change_out <= COIN_5000;
                end
                else if (money_account > 5'd0) begin
                    money_account <= money_account - 5'd1;
                    change_out <= COIN_1000;
                end
            end

            // All other input combinations are ignored.
        end
    end

endmodule
