module tb;

    parameter COLS = 40;
    parameter ROWS = 32;

    logic clk;
    logic rst;
    logic [COLS-1:0] col_enable;
    logic [ROWS-1:0] row_enable;
    logic done;

    roic_shift #(COLS, ROWS) dut (.*);
    //adding scoreboard here --Observes DUT output
//Compares with expected behavior
//Does NOT affect hardware
     int expected_row = 0;
    int expected_col = 0;

    always @(posedge clk) begin
        if (!rst && col_enable != 0 && row_enable != 0) begin

            if (col_enable != (1 << expected_col))
                $error("Column mismatch at time %t", $time);

            if (row_enable != (1 << expected_row))
                $error("Row mismatch at time %t", $time);

            if (expected_col < COLS-1)
                expected_col++;
            else begin
                expected_col = 0;
                expected_row++;
            end
             if (expected_row >= ROWS) begin
            $display("All rows scanned successfully");
            $finish;
        end
        end
    end
  //to print all values to check whether all are touched
always @(posedge clk) begin
    if (!rst && !done)
        $display("Time=%0t Row=%0d Col=%0d", $time, dut.row_cnt, dut.col_cnt);
end
    // Clock
    always #5 clk = ~clk;
  
  //assertions
  property one_hot_col;
    @(posedge clk) disable iff (rst)
    $onehot0(col_enable);
endproperty

assert property (one_hot_col);
  
  property one_hot_row;
    @(posedge clk) disable iff (rst)
    $onehot0(row_enable);
endproperty

assert property (one_hot_row);
  
  //to define covergroups --functional coverage
  covergroup cg @(posedge clk);
    coverpoint col_enable;
    coverpoint row_enable;
endgroup
  
  cg cov = new();
  //sampling it --added functional coverage to ensure all scan combinations are exercised
  
  always @(posedge clk)
    cov.sample();
//to dump the file
  initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
    end
    // Reset + random resets
    initial begin
        clk = 0;
        rst = 1;
        #20 rst = 0;
    end
  //finish condition
  
  initial begin
    wait(done);
    #50;
    $display("Simulation completed successfully");
    $finish;
end
endmodule
