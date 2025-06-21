`timescale 1ns / 1ps

module VM_tb;

    reg clk;
    reg rstn;
    reg beverage_take;
    reg change_take;
    reg [1:0] coin_in;
    wire beverage_out;
    wire [1:0] change_out;
    wire [4:0] money_account;

    VM u_vm (
        .clk(clk),
        .rstn(rstn),
        .beverage_take(beverage_take),
        .change_take(change_take),
        .coin_in(coin_in),
        .beverage_out(beverage_out),
        .change_out(change_out),
        .money_account(money_account)
    );

    always #5 clk = ~clk;

    initial begin
        // 초기화
        clk = 0; rstn = 1; 

        // 동시입력이 무시되는지 모든 경우 테스트
        #5 rstn = 0; coin_in = 2'b01; beverage_take = 1'b1; change_take = 1'b1; // 모든 명령 동시 입력(1000원 동전입력)
        #10 rstn = 0; coin_in = 2'b01; beverage_take = 1'b1; change_take = 1'b0; // 1000원 동전입력, 음료뽑기 명령 동시 입력
        #10 rstn = 0; coin_in = 2'b01; beverage_take = 1'b0; change_take = 1'b1; // 1000원 동전입력, 잔돈반환 명령 동시 입력
        #10 rstn = 0; coin_in = 2'b10; beverage_take = 1'b1; change_take = 1'b1; // 모든 명령 동시 입력(5000원 동전입력)
        #10 rstn = 0; coin_in = 2'b10; beverage_take = 1'b1; change_take = 1'b0; // 5000원 동전입력, 음료뽑기 명령 동시 입력
        #10 rstn = 0; coin_in = 2'b10; beverage_take = 1'b0; change_take = 1'b1; // 5000원 동전입력, 잔돈반환 명령 동시 입력
        #10 rstn = 0; coin_in = 2'b00; beverage_take = 1'b1; change_take = 1'b1; // 음료뽑기 명령, 잔돈반환 명령 동시 입력

        // 돈 20000원 채우기 (5000원으로 4번)
        #10 rstn = 0; coin_in = 2'b10; beverage_take = 1'b0; change_take = 1'b0; // 5000원 동전입력 
        #10 rstn = 0; coin_in = 2'b10; beverage_take = 1'b0; change_take = 1'b0; // 5000원 동전입력
        #10 rstn = 0; coin_in = 2'b10; beverage_take = 1'b0; change_take = 1'b0; // 5000원 동전입력 
        #10 rstn = 0; coin_in = 2'b10; beverage_take = 1'b0; change_take = 1'b0; // 5000원 동전입력
        
        // 추가로 돈을 넣어 초과된 돈을 반환하는지 확인
        #10 rstn = 0; coin_in = 2'b01; beverage_take = 1'b0; change_take = 1'b0; // 1000원 동전입력
        
        // 음료 두번 출력
        #10 rstn = 0; coin_in = 2'b00; beverage_take = 1'b1; change_take = 1'b0; // 음료뽑기 명령
        #10 rstn = 0; coin_in = 2'b00; beverage_take = 1'b1; change_take = 1'b0; // 음료뽑기 명령
        
        // 7000원 동전 넣기
        #10 rstn = 0; coin_in = 2'b01; beverage_take = 1'b0; change_take = 1'b0; // 1000원 동전입력
        #10 rstn = 0; coin_in = 2'b01; beverage_take = 1'b0; change_take = 1'b0; // 1000원 동전입력
        #10 rstn = 0; coin_in = 2'b10; beverage_take = 1'b0; change_take = 1'b0; // 5000원 동전입력
        
        // 음료뽑기
        #10 rstn = 0; coin_in = 2'b00; beverage_take = 1'b1; change_take = 1'b0;
        
        // 잔돈 반환
        #10 rstn = 0; coin_in = 2'b00; beverage_take = 1'b0; change_take = 1'b1; // 5000원 반환
        #10 rstn = 0; coin_in = 2'b00; beverage_take = 1'b0; change_take = 1'b1; // 1000원 반환
        #10 rstn = 0; coin_in = 2'b00; beverage_take = 1'b0; change_take = 1'b1; // 1000원 반환 -> 잔돈 모두 반환 완료

        #10 rstn = 0; coin_in = 2'b00; beverage_take = 1'b0; change_take = 1'b0; // 종료
        
        // 출력이 모두 확인될 때까지 기다리고 나서 종료
        #20 $finish;
    end

    initial begin
        $dumpfile("VM.vcd");
        $dumpvars(0, VM_tb);
    end
endmodule