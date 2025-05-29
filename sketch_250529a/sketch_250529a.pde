int[] board = new int[9]; // 0 = empty, 1 = X, -1 = O
int currentPlayer = 1; // 1 for X, -1 for O
boolean gameOver = false;
boolean vsAI = false; // Toggle AI mode
String winnerMessage = "";

// Scoreboard
int scoreX = 0;
int scoreO = 0;
int scoreTies = 0;

void setup() {
  size(500, 600); // Increased height for buttons and scoreboard
  textAlign(CENTER, CENTER);
  textSize(32);
}

void draw() {
  background(220, 240, 255); // Light blue background
  drawScoreboard();
  drawBoard();
  drawButtons();
  if (gameOver) {
    fill(0);
    text(winnerMessage, width / 2, height - 150); // Display winner message
  }
}

void drawScoreboard() {
  fill(0);
  textSize(24);
  text("Player X: " + scoreX, width / 4, 40);
  text("Player O: " + scoreO, width / 2, 40);
  text("Ties: " + scoreTies, 3 * width / 4, 40);
}

void drawBoard() {
  stroke(50);
  strokeWeight(4);

  // Draw grid
  for (int i = 1; i < 3; i++) {
    line(i * 150, 100, i * 150, 550); // Vertical lines
    line(0, 100 + i * 150, 450, 100 + i * 150); // Horizontal lines
  }

  // Draw X and O
  for (int i = 0; i < 9; i++) {
    int x = (i % 3) * 150 + 75;
    int y = (i / 3) * 150 + 175;
    if (board[i] == 1) {
      drawX(x, y);
    } else if (board[i] == -1) {
      drawO(x, y);
    }
  }
}

void drawX(int x, int y) {
  stroke(0, 102, 204); // Blue for X
  strokeWeight(6);
  line(x - 40, y - 40, x + 40, y + 40);
  line(x + 40, y - 40, x - 40, y + 40);
}

void drawO(int x, int y) {
  stroke(255, 102, 102); // Pink for O
  strokeWeight(6);
  noFill();
  ellipse(x, y, 80, 80);
}

void drawButtons() {
  // Restart Button
  fill(100, 200, 100); // Green button
  rect(50, height - 80, 150, 50, 10);
  fill(255);
  textSize(20);
  text("Restart", 125, height - 55);

  // AI Toggle Button
  fill(200, 100, 100); // Red button
  rect(300, height - 80, 150, 50, 10);
  fill(255);
  textSize(20);
  text(vsAI ? "AI: ON" : "AI: OFF", 375, height - 55);
}

void mousePressed() {
  // Restart Button
  if (mouseX > 50 && mouseX < 200 && mouseY > height - 80 && mouseY < height - 30) {
    resetGame();
    return;
  }

  // AI Toggle Button
  if (mouseX > 300 && mouseX < 450 && mouseY > height - 80 && mouseY < height - 30) {
    vsAI = !vsAI;
    resetGame();
    return;
  }

  if (gameOver) return;

  // Handle player moves
  int col = mouseX / 150;
  int row = (mouseY - 100) / 150;
  int index = row * 3 + col;

  if (index >= 0 && index < 9 && board[index] == 0) {
    board[index] = currentPlayer;
    if (checkWinner()) {
      gameOver = true;
      if (currentPlayer == 1) {
        scoreX++;
        winnerMessage = "Player X Wins!";
      } else {
        scoreO++;
        winnerMessage = "Player O Wins!";
      }
    } else if (isBoardFull()) {
      gameOver = true;
      scoreTies++;
      winnerMessage = "It's a Tie!";
    } else {
      currentPlayer *= -1; // Switch player
      if (vsAI && currentPlayer == -1) {
        aiMove();
      }
    }
  }
}

void aiMove() {
  // Simple AI: Pick the first available cell
  for (int i = 0; i < 9; i++) {
    if (board[i] == 0) {
      board[i] = -1;
      if (checkWinner()) {
        gameOver = true;
        scoreO++;
        winnerMessage = "Player O Wins!";
      } else if (isBoardFull()) {
        gameOver = true;
        scoreTies++;
        winnerMessage = "It's a Tie!";
      }
      currentPlayer = 1; // Switch back to player
      return;
    }
  }
}

boolean checkWinner() {
  // Winning combinations
  int[][] winCombos = {
    {0, 1, 2}, {3, 4, 5}, {6, 7, 8}, // Rows
    {0, 3, 6}, {1, 4, 7}, {2, 5, 8}, // Columns
    {0, 4, 8}, {2, 4, 6}             // Diagonals
  };

  for (int[] combo : winCombos) {
    if (board[combo[0]] == board[combo[1]] && board[combo[1]] == board[combo[2]] && board[combo[0]] != 0) {
      return true;
    }
  }
  return false;
}

boolean isBoardFull() {
  for (int i = 0; i < 9; i++) {
    if (board[i] == 0) return false;
  }
  return true;
}

void resetGame() {
  board = new int[9]; // Clear the board
  currentPlayer = 1; // Reset to Player X
  gameOver = false; // Reset game over state
  winnerMessage = ""; // Clear the winner message
}
