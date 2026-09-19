`timescale 1ns / 1ps

module VM_tb;

    reg clk;
    reg rstn;
    reg [1:0] coin_in;
    reg beverage_take;
    reg change_take;

    wire [4:0] money_account;
    wire beverage_out;
    wire [1:0] change_out;

    integer failures;
    integer operations;
    integer balance;

    localparam [1:0] NO_COIN   = 2'b00;
    localparam [1:0] COIN_1000 = 2'b01;
    localparam [1:0] COIN_5000 = 2'b10;

    VM dut (
        .clk(clk),
        .rstn(rstn),
        .coin_in(coin_in),
        .beverage_take(beverage_take),
        .change_take(change_take),
        .money_account(money_account),
        .beverage_out(beverage_out),
        .change_out(change_out)
    );

    always #5 clk = ~clk;


    task reset_dut;
        begin
            coin_in = NO_COIN;
            beverage_take = 1'b0;
            change_take = 1'b0;

            rstn = 1'b1;
            #1;

            if (
                money_account !== 5'd0
                || beverage_out !== 1'b0
                || change_out !== 2'b00
            ) begin
                failures = failures + 1;
                $display(
                    "FAIL reset: balance=%0d beverage=%b change=%b",
                    money_account,
                    beverage_out,
                    change_out
                );
            end

            @(negedge clk);
            rstn = 1'b0;

            @(posedge clk);
            #1;
        end
    endtask


    task insert_coin_silent;
        input [1:0] coin;
        begin
            @(negedge clk);

            coin_in = coin;
            beverage_take = 1'b0;
            change_take = 1'b0;

            @(posedge clk);
            #1;

            @(negedge clk);
            coin_in = NO_COIN;

            @(posedge clk);
            #1;
        end
    endtask


    task set_balance;
        input integer target;
        integer five_count;
        integer one_count;
        integer j;

        begin
            reset_dut;

            five_count = target / 5;
            one_count = target % 5;

            for (j = 0; j < five_count; j = j + 1) begin
                insert_coin_silent(COIN_5000);
            end

            for (j = 0; j < one_count; j = j + 1) begin
                insert_coin_silent(COIN_1000);
            end

            if (money_account !== target) begin
                failures = failures + 1;

                $display(
                    "FAIL setup: expected balance=%0d observed=%0d",
                    target,
                    money_account
                );
            end
        end
    endtask


    task apply_and_check;
        input [1:0] test_coin;
        input test_beverage;
        input test_change;

        input [4:0] expected_balance;
        input expected_beverage;
        input [1:0] expected_change;

        reg [4:0] before_balance;

        begin
            operations = operations + 1;
            before_balance = money_account;

            // Apply input halfway through the cycle.
            @(negedge clk);

            coin_in = test_coin;
            beverage_take = test_beverage;
            change_take = test_change;

            #1;

            // Outputs must not change before the next active edge.
            if (
                money_account !== before_balance
                || beverage_out !== 1'b0
                || change_out !== 2'b00
            ) begin
                failures = failures + 1;

                $display(
                    "FAIL op %0d pre-edge: balance=%0d beverage=%b change=%b",
                    operations,
                    money_account,
                    beverage_out,
                    change_out
                );
            end

            // Command is processed on this clock edge.
            @(posedge clk);
            #1;

            if (
                money_account !== expected_balance
                || beverage_out !== expected_beverage
                || change_out !== expected_change
            ) begin
                failures = failures + 1;

                $display(
                    "FAIL op %0d action: expected=(%0d,%b,%b) observed=(%0d,%b,%b)",
                    operations,
                    expected_balance,
                    expected_beverage,
                    expected_change,
                    money_account,
                    beverage_out,
                    change_out
                );
            end

            // Remove the command.
            @(negedge clk);

            coin_in = NO_COIN;
            beverage_take = 1'b0;
            change_take = 1'b0;

            // Pulse outputs must remain valid for the full cycle.
            #1;

            if (
                beverage_out !== expected_beverage
                || change_out !== expected_change
            ) begin
                failures = failures + 1;

                $display(
                    "FAIL op %0d pulse duration: beverage=%b change=%b",
                    operations,
                    beverage_out,
                    change_out
                );
            end

            // On the following cycle, pulse outputs must clear.
            @(posedge clk);
            #1;

            if (
                money_account !== expected_balance
                || beverage_out !== 1'b0
                || change_out !== 2'b00
            ) begin
                failures = failures + 1;

                $display(
                    "FAIL op %0d pulse clear: balance=%0d beverage=%b change=%b",
                    operations,
                    money_account,
                    beverage_out,
                    change_out
                );
            end
        end
    endtask


    initial begin
        clk = 1'b0;
        rstn = 1'b0;
        coin_in = NO_COIN;
        beverage_take = 1'b0;
        change_take = 1'b0;

        failures = 0;
        operations = 0;


        // --------------------------------------------------
        // 1. 1000-won insertion at every possible balance.
        // --------------------------------------------------

        for (balance = 0; balance <= 20; balance = balance + 1) begin
            set_balance(balance);

            if (balance < 20) begin
                apply_and_check(
                    COIN_1000,
                    1'b0,
                    1'b0,
                    balance + 1,
                    1'b0,
                    2'b00
                );
            end
            else begin
                apply_and_check(
                    COIN_1000,
                    1'b0,
                    1'b0,
                    balance,
                    1'b0,
                    COIN_1000
                );
            end
        end


        // --------------------------------------------------
        // 2. 5000-won insertion at every possible balance.
        // --------------------------------------------------

        for (balance = 0; balance <= 20; balance = balance + 1) begin
            set_balance(balance);

            if (balance <= 15) begin
                apply_and_check(
                    COIN_5000,
                    1'b0,
                    1'b0,
                    balance + 5,
                    1'b0,
                    2'b00
                );
            end
            else begin
                apply_and_check(
                    COIN_5000,
                    1'b0,
                    1'b0,
                    balance,
                    1'b0,
                    COIN_5000
                );
            end
        end


        // --------------------------------------------------
        // 3. Beverage purchase at every possible balance.
        // --------------------------------------------------

        for (balance = 0; balance <= 20; balance = balance + 1) begin
            set_balance(balance);

            if (balance >= 10) begin
                apply_and_check(
                    NO_COIN,
                    1'b1,
                    1'b0,
                    balance - 10,
                    1'b1,
                    2'b00
                );
            end
            else begin
                apply_and_check(
                    NO_COIN,
                    1'b1,
                    1'b0,
                    balance,
                    1'b0,
                    2'b00
                );
            end
        end


        // --------------------------------------------------
        // 4. Change return at every possible balance.
        // --------------------------------------------------

        for (balance = 0; balance <= 20; balance = balance + 1) begin
            set_balance(balance);

            if (balance >= 5) begin
                apply_and_check(
                    NO_COIN,
                    1'b0,
                    1'b1,
                    balance - 5,
                    1'b0,
                    COIN_5000
                );
            end
            else if (balance > 0) begin
                apply_and_check(
                    NO_COIN,
                    1'b0,
                    1'b1,
                    balance - 1,
                    1'b0,
                    COIN_1000
                );
            end
            else begin
                apply_and_check(
                    NO_COIN,
                    1'b0,
                    1'b1,
                    0,
                    1'b0,
                    2'b00
                );
            end
        end


        // --------------------------------------------------
        // 5. Simultaneous commands must be ignored.
        // Test every balance with every meaningful conflict.
        // --------------------------------------------------

        for (balance = 0; balance <= 20; balance = balance + 1) begin

            set_balance(balance);
            apply_and_check(
                COIN_1000, 1'b1, 1'b0,
                balance, 1'b0, 2'b00
            );

            set_balance(balance);
            apply_and_check(
                COIN_1000, 1'b0, 1'b1,
                balance, 1'b0, 2'b00
            );

            set_balance(balance);
            apply_and_check(
                COIN_1000, 1'b1, 1'b1,
                balance, 1'b0, 2'b00
            );

            set_balance(balance);
            apply_and_check(
                COIN_5000, 1'b1, 1'b0,
                balance, 1'b0, 2'b00
            );

            set_balance(balance);
            apply_and_check(
                COIN_5000, 1'b0, 1'b1,
                balance, 1'b0, 2'b00
            );

            set_balance(balance);
            apply_and_check(
                COIN_5000, 1'b1, 1'b1,
                balance, 1'b0, 2'b00
            );

            set_balance(balance);
            apply_and_check(
                NO_COIN, 1'b1, 1'b1,
                balance, 1'b0, 2'b00
            );
        end


        // --------------------------------------------------
        // 6. Explicit asynchronous reset test.
        // --------------------------------------------------

        set_balance(12);

        @(negedge clk);

        rstn = 1'b1;
        #1;

        operations = operations + 1;

        if (
            money_account !== 5'd0
            || beverage_out !== 1'b0
            || change_out !== 2'b00
        ) begin
            failures = failures + 1;

            $display(
                "FAIL async reset: balance=%0d beverage=%b change=%b",
                money_account,
                beverage_out,
                change_out
            );
        end

        rstn = 1'b0;


        $display("");
        $display("===== FULL SPECIFICATION SUMMARY =====");
        $display("Operations tested: %0d", operations);
        $display("Failures: %0d", failures);

        if (failures == 0) begin
            $display("PASS: all specification checks passed.");
            $finish;
        end
        else begin
            $fatal(1, "FAIL: specification violations detected.");
        end
    end

endmodule
