// Game variables
int[] board = new int[9]; // 1D array for the board (0 = empty, 1 = X, -1 = O)
int currentPlayer = 1; // 1 for X, -1 for O
boolean gameOver = false;
boolean vsAI = false; // Toggle AI mode
String winnerMessage = "";

// Scoreboard
int scoreX = 0;
int scoreO = 0;
int scoreTies = 0;

void setup() {
  size(500, 600); // Window size
  textAlign(CENTER, CENTER); // Center text alignment
  textSize(32); // Default text size
}

void draw() {
  background(220, 240, 255); // Light blue background
  drawScoreboard(); // Draw the scoreboard
  drawBoard(); // Draw the game board
  drawButtons(); // Draw the buttons
  if (gameOver) {
    fill(0);
    text(winnerMessage, width / 2, height - 150); // Show winner message
  }
}

// Draw the scoreboard at the top
void drawScoreboard() {
  fill(0);
  textSize(24);
  text("Player X: " + scoreX, width / 4, 40);
  text("Player O: " + scoreO, width / 2, 40);
  text("Ties: " + scoreTies, 3 * width / 4, 40);
}

// Draw the Tic Tac Toe board
void drawBoard() {
  stroke(50);
  strokeWeight(4);

  // Draw grid lines
  for (int i = 1; i < 3; i++) {
    line(i * 150, 100, i * 150, 550); // Vertical lines
    line(0, 100 + i * 150, 450, 100 + i * 150); // Horizontal lines
  }

  // Draw X and O based on the board array
  for (int i = 0; i < 9; i++) {
    int x = (i % 3) * 150 + 75; // Calculate x position
    int y = (i / 3) * 150 + 175; // Calculate y position
    if (board[i] == 1) {
      drawX(x, y); // Draw X
    } else if (board[i] == -1) {
      drawO(x, y); // Draw O
    }
  }
}

// Draw an X at the given position
void drawX(int x, int y) {
  stroke(0, 102, 204); // Blue color for X
  strokeWeight(6);
  line(x - 40, y - 40, x + 40, y + 40); // First line of X
  line(x + 40, y - 40, x - 40, y + 40); // Second line of X
}

// Draw an O at the given position
void drawO(int x, int y) {
  stroke(255, 102, 102); // Pink color for O
  strokeWeight(6);
  noFill();
  ellipse(x, y, 80, 80); // Draw circle
}

// Draw the Restart and AI Toggle buttons
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

// Handle mouse clicks
void mousePressed() {
  // Check if Restart Button is clicked
  if (mouseX > 50 && mouseX < 200 && mouseY > height - 80 && mouseY < height - 30) {
    resetGame(); // Reset the game
    return;
  }

  // Check if AI Toggle Button is clicked
  if (mouseX > 300 && mouseX < 450 && mouseY > height - 80 && mouseY < height - 30) {
    vsAI = !vsAI; // Toggle AI mode
    resetGame();
    return;
  }

  if (gameOver) return; // Ignore clicks if the game is over

  // Handle player moves
  int col = mouseX / 150; // Calculate column
  int row = (mouseY - 100) / 150; // Calculate row
  int index = row * 3 + col; // Convert row and column to 1D index

  if (index >= 0 && index < 9 && board[index] == 0) { // Check if the cell is empty
    board[index] = currentPlayer; // Place the current player's mark
    if (checkWinner()) { // Check if the current player wins
      gameOver = true;
      if (currentPlayer == 1) {
        scoreX++;
        winnerMessage = "Player X Wins!";
      } else {
        scoreO++;
        winnerMessage = "Player O Wins!";
      }
    } else if (isBoardFull()) { // Check if the board is full (tie)
      gameOver = true;
      scoreTies++;
      winnerMessage = "It's a Tie!";
    } else {
      currentPlayer *= -1; // Switch player
      if (vsAI && currentPlayer == -1) {
        aiMove(); // AI makes a move
      }
    }
  }
}

// AI makes a move (simple AI: pick the first empty cell)
void aiMove() {
  for (int i = 0; i < 9; i++) {
    if (board[i] == 0) { // Find the first empty cell
      board[i] = -1; // AI places O
      if (checkWinner()) { // Check if AI wins
        gameOver = true;
        scoreO++;
        winnerMessage = "Player O Wins!";
      } else if (isBoardFull()) { // Check if the board is full (tie)
        gameOver = true;
        scoreTies++;
        winnerMessage = "It's a Tie!";
      }
      currentPlayer = 1; // Switch back to Player X
      return;
    }
  }
}

// Check if there is a winner
boolean checkWinner() {
  // Winning combinations
  int[][] winCombos = {
    {0, 1, 2}, {3, 4, 5}, {6, 7, 8}, // Rows
    {0, 3, 6}, {1, 4, 7}, {2, 5, 8}, // Columns
    {0, 4, 8}, {2, 4, 6}             // Diagonals
  };

  for (int[] combo : winCombos) {
    if (board[combo[0]] == board[combo[1]] && board[combo[1]] == board[combo[2]] && board[combo[0]] != 0) {
      return true; // A winning combination is found
    }
  }
  return false; // No winner
}

// Check if the board is full
boolean isBoardFull() {
  for (int i = 0; i < 9; i++) {
    if (board[i] == 0) return false; // If any cell is empty, the board is not full
  }
  return true; // All cells are filled
}

// Reset the game
void resetGame() {
  board = new int[9]; // Clear the board
  currentPlayer = 1; // Reset to Player X
  gameOver = false; // Reset game over state
  winnerMessage = ""; // Clear the winner message
}
