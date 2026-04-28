`timescale 1ns/1ps
module dice_tb;

  reg clk;
  reg rst;
  reg button;
  wire [6:0] led;   // for 7-seg LED output
  integer file;
  integer seed;     // new: seed variable for randomness

  // Instantiate dice module
  dice uut (
    .clk(clk),
    .rst(rst),
    .button(button),
    .led(led)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    // Create dumpfile for GTKWave
    $dumpfile("dump.vcd");  
    $dumpvars(0, dice_tb);
    $display("Time\tclk\tbutton\tdice_value\tLED");
    $monitor("%0t\t%b\t%b\t%0d\t%b", $time, clk, button, uut.dice_value, led);


    // Initialize
    clk = 0;
    rst = 1;
    button = 0;

    // Get random seed from command line, or fallback
    if (!$value$plusargs("seed=%d", seed))
      seed = 32'hABCD;
    seed = $urandom(seed); // reseed RNG
    $display("Using seed = %0d", seed);

    #20 rst = 0;

    // Simulate button presses
    #50 button = 1;
    #10 button = 0;

    #100 button = 1;
    #10 button = 0;

    // Wait a bit for result to settle
    #50;

    // Write result to file
    file = $fopen("result.txt", "w");
    $fwrite(file, "%0d\n", uut.dice_value);
    $fclose(file);

    $display("Dice result written to result.txt: %0d", uut.dice_value);

    $finish;
  end

endmodule
