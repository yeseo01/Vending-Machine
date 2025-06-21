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
    // 상태 정의
    localparam S0 = 5'd0, S1 = 5'd1, S2 = 5'd2, S3 = 5'd3, S5 = 5'd5, S6 = 5'd6, S7 = 5'd7, S8 = 5'd8, S10 = 5'd10, S11 = 5'd11, S12 = 5'd12, S15 = 5'd15, S16 = 5'd16, S20 = 5'd20;
    // 현재 상태, 다음 상태
    reg [4:0] state_now, state_next;
    reg beverage_now, beverage_next;
    reg [1:0] change_now, change_next;

    // 상태 업데이트
    always @(posedge clk or posedge rstn) begin
         // 1일때 Reset: 상태를 S0로 초기화
        if (rstn) begin
            // 초기화 현재 출력
            state_now <= S0; 
            beverage_now <= 1'b0; 
            change_now <= 2'b00; 
            // 초기화 다음 출력
            state_next <= S0; 
            beverage_next <= 1'b0; 
            change_next <= 2'b00; 
        end 
        // 클락 신호가 오면 상태 업데이트
        else begin
            state_now <= state_next;
            beverage_now <= beverage_next;
            change_now <= change_next;

            case(state_next)
                S0: begin
                    // 동전 입력 명령만 있을 경우
                    if (coin_in != 2'b00 && beverage_take == 1'b0 && change_take == 1'b0) begin
                        if (coin_in == 2'b01) begin
                            state_next <= S1;
                            beverage_next <= 1'b0;
                            change_next <= 2'b00;
                        end
                        else if (coin_in == 2'b10) begin
                            state_next <= S5;
                            beverage_next <= 1'b0;
                            change_next <= 2'b00;
                        end
                    end
                    // 그외 경우는 현재 상태 유지
                    else begin
                        state_next <= S0;
                        beverage_next <= 1'b0;
                        change_next <= 2'b00;
                    end
                end

                S1: begin
                    // 동전 입력 명령만 있을 경우
                    if (coin_in != 2'b00 && beverage_take == 1'b0 && change_take == 1'b0) begin
                        if (coin_in == 2'b01) begin 
                            state_next <= S2;
                            beverage_next <= 1'b0;
                            change_next <= 2'b00;
                        end
                        else if (coin_in == 2'b10) begin
                            state_next <= S6;
                            beverage_next <= 1'b0;
                            change_next <= 2'b00;
                        end
                    end
                    // 잔돈반환 명령만 있을 경우
                    else if (coin_in == 2'b00 && beverage_take == 1'b0 && change_take == 1'b1) begin
                        state_next <= S0;
                        change_next <= 2'b01;
                    end
                    // 그외 경우는 현재 상태 유지
                    else begin
                        state_next <= S1;
                        beverage_next <= 1'b0;
                        change_next <= 2'b00;
                    end
                end

                S2: begin
                    // 동전 입력 명령만 있을 경우
                    if (coin_in != 2'b00 && beverage_take == 1'b0 && change_take == 1'b0) begin
                        if (coin_in == 2'b01) begin
                            state_next <= S3;
                            beverage_next <= 1'b0;
                            change_next <= 2'b00;
                        end
                        else if (coin_in == 2'b10) begin
                            state_next <= S7;
                            beverage_next <= 1'b0;
                            change_next <= 2'b00;
                        end
                    end
                    // 잔돈반환 명령만 있을 경우
                    else if (coin_in == 2'b00 && beverage_take == 1'b0 && change_take == 1'b1) begin
                        state_next <= S1;
                        change_next <= 2'b01;
                    end
                    // 그외 경우는 현재 상태 유지
                    else begin
                        state_next <= S2;
                        beverage_next <= 1'b0;
                        change_next <= 2'b00;
                    end
                end

                S5: begin
                    // 동전 입력 명령만 있을 경우
                    if (coin_in != 2'b00 && beverage_take == 1'b0 && change_take == 1'b0) begin
                        if (coin_in == 2'b01) begin
                            state_next <= S6;
                            beverage_next <= 1'b0;
                            change_next <= 2'b00;
                        end
                        else if (coin_in == 2'b10) begin
                            state_next <= S10;
                            beverage_next <= 1'b0;
                            change_next <= 2'b00;
                        end
                    end
                    // 잔돈반환 명령만 있을 경우
                    else if (coin_in == 2'b00 && beverage_take == 1'b0 && change_take == 1'b1) begin
                        state_next <= S0;
                        change_next <= 2'b10;
                    end
                    // 그외 경우는 현재 상태 유지
                    else begin
                        state_next <= S5;
                        beverage_next <= 1'b0;
                        change_next <= 2'b00;
                    end
                end

                S7: begin
                    // 동전 입력 명령만 있을 경우
                    if (coin_in != 2'b00 && beverage_take == 1'b0 && change_take == 1'b0) begin
                        if (coin_in == 2'b01) begin
                            state_next <= S8;
                            beverage_next <= 1'b0;
                            change_next <= 2'b00;
                        end
                        else if (coin_in == 2'b10) begin
                            state_next <= S12;
                            beverage_next <= 1'b0;
                            change_next <= 2'b00;
                        end
                    end
                    // 잔돈반환 명령만 있을 경우
                    else if (coin_in == 2'b00 && beverage_take == 1'b0 && change_take == 1'b1) begin
                        state_next <= S2;
                        change_next <= 2'b10;
                    end
                    // 그외 경우는 현재 상태 유지
                    else begin
                        state_next <= S7;
                        beverage_next <= 1'b0;
                        change_next <= 2'b00;
                    end
                end

                S10: begin
                    // 동전 입력 명령만 있을 경우
                    if (coin_in != 2'b00 && beverage_take == 1'b0 && change_take == 1'b0) begin
                        if (coin_in == 2'b01) begin
                            state_next <= S11;
                            beverage_next <= 1'b0;
                            change_next <= 2'b00;
                        end
                        else if (coin_in == 2'b10) begin
                            state_next <= S15;
                            beverage_next <= 1'b0;
                            change_next <= 2'b00;
                        end
                    end
                    // 음료뽑기 명령만 있을 경우
                    else if (coin_in == 2'b00 && beverage_take == 1'b1 && change_take == 1'b0) begin
                        state_next <= S0;
                        beverage_next <= 1'b1;
                        change_next <= 2'b00;
                    end
                    // 잔돈반환 명령만 있을 경우    
                    else if (coin_in == 2'b00 && beverage_take == 1'b0 && change_take == 1'b1) begin
                        state_next <= S5;
                        beverage_next <= 1'b0;
                        change_next <= 2'b10;
                    end
                    // 그외 경우는 현재 상태 유지
                    else begin
                        state_next <= S10;
                        beverage_next <= 1'b0;
                        change_next <= 2'b00;
                    end
                end

                S15: begin
                    // 동전 입력 명령만 있을 경우
                    if (coin_in != 2'b00 && beverage_take == 1'b0 && change_take == 1'b0) begin
                        if (coin_in == 2'b01) begin
                            state_next <= S16;
                            beverage_next <= 1'b0;
                            change_next <= 2'b00;
                        end
                        else if (coin_in == 2'b10) begin
                            state_next <= S20;
                            beverage_next <= 1'b0;
                            change_next <= 2'b00;
                        end
                    end
                    // 음료뽑기 명령만 있을 경우
                    else if (coin_in == 2'b00 && beverage_take == 1'b1 && change_take == 1'b0) begin
                        state_next <= S5;
                        beverage_next <= 1'b1;
                        change_next <= 2'b00;
                    end
                    // 잔돈반환 명령만 있을 경우
                    else if (coin_in == 2'b00 && beverage_take == 1'b0 && change_take == 1'b1) begin
                        state_next <= S10;
                        beverage_next <= 1'b0;
                        change_next <= 2'b10;
                    end
                    // 그외 경우는 현재 상태 유지
                    else begin
                        state_next <= S15;
                        beverage_next <= 1'b0;
                        change_next <= 2'b00;
                    end
                end

                S20: begin
                    // 동전 입력 명령만 있을 경우
                    if (coin_in != 2'b00 && beverage_take == 1'b0 && change_take == 1'b0) begin
                        if (coin_in == 2'b01) begin
                            state_next <= S20;
                            beverage_next <= 1'b0;
                            change_next <= 2'b01;
                        end
                        else if (coin_in == 2'b10) begin
                            state_next <= S20;
                            beverage_next <= 1'b0;
                            change_next <= 2'b10;
                        end
                    end
                    // 음료뽑기 명령만 있을 경우
                    else if (coin_in == 2'b00 && beverage_take == 1'b1 && change_take == 1'b0) begin
                        state_next <= S10;
                        beverage_next <= 1'b1;
                        change_next <= 2'b00;
                    end
                    // 잔돈반환 명령만 있을 경우
                    else if (coin_in == 2'b00 && beverage_take == 1'b0 && change_take == 1'b1) begin
                        state_next <= S15;
                        beverage_next <= 1'b0;
                        change_next <= 2'b10;
                    end
                    // 그외 경우는 현재 상태 유지
                    else begin
                        state_next <= S20;
                        beverage_next <= 1'b0;
                        change_next <= 2'b00;
                    end
                end     
            endcase
        end
    end

    // 출력 업데이트
    always @(state_now or beverage_now or change_now) begin
        case(state_now)
            S0: money_account <= 5'd0;
            S1: money_account <= 5'd1;
            S2: money_account <= 5'd2;
            S5: money_account <= 5'd5;
            S7: money_account <= 5'd7;
            S10: money_account <= 5'd10;
            S15: money_account <= 5'd15;
            S20: money_account <= 5'd20;
        endcase
        case (beverage_now)
            1'b0: beverage_out <= 1'b0;
            1'b1: beverage_out <= 1'b1;
        endcase
        case (change_now)
            2'b00: change_out <= 2'b00;
            2'b01: change_out <= 2'b01;
            2'b10: change_out <= 2'b10;
        endcase
    end

endmodule