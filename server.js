const express = require("express");
const { exec } = require("child_process");
const fs = require("fs");

const app = express();
app.use(express.static("public"));

app.get("/roll", (req, res) => {
  // Generate a random seed for Verilog simulation
  const seed = Math.floor(Math.random() * 1e9);
  console.log("Running dice simulation with seed:", seed);

  // Compile and run Verilog with the seed passed to vvp
  const cmd = `iverilog -g2012 -o dice_tb.out dice_tb.v dice.v && vvp dice_tb.out +seed=${seed}`;

  exec(cmd, (err, stdout, stderr) => {
    if (err) {
      console.error("Error:", stderr);
      return res.status(500).send("Error running Verilog simulation.");
    }

    console.log(stdout);

    // Read the result file
    fs.readFile("result.txt", "utf8", (err, data) => {
      if (err) {
        console.error("Error reading result file:", err);
        return res.status(500).send("Error reading result file.");
      }

      const result = parseInt(data.trim(), 10);
      console.log("Dice result:", result);
      res.json({ result });
    });
  });
});

app.listen(3000, () => {
  console.log("Server running at http://localhost:3000");
});

