module tb;

    parameter COLS = 40;
    parameter ROWS = 32;

    logic clk;
    logic rst;
    logic [COLS-1:0] col_enable;
    logic [ROWS-1:0] row_enable;
    logic done;

    roic_shift #(COLS, ROWS) dut (
        .* 
    );
  //to print all values to check whether all are touched
always @(posedge clk) begin
    if (!rst && !done)
        $display("Time=%0t Row=%0d Col=%0d", $time, dut.row_cnt, dut.col_cnt);
end
    // Clock
    always #5 clk = ~clk;
  
  //asserions
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
  
  //to define covergroups
  covergroup cg @(posedge clk);
    coverpoint col_enable;
    coverpoint row_enable;
endgroup
  
  cg cov = new();
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
