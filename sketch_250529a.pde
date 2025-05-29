int[][] board = {
  {0, 0, 0},
  {0, 0, 0},
  {0, 0, 0}
};
int currentPlayer = 1; // 1 for X, -1 for O
int cellSize = 120; // Size of each cell
int gridOffsetX = 90; // Horizontal offset for centering the grid
int gridOffsetY = 100; // Vertical offset for centering the grid
boolean gameOver = false;
String winnerMessage = "";
boolean vsAI = false; // Toggle between two-player mode and player vs AI
int[] winningLine = null;

// Animation variables
boolean isAnimating = false;
int animRow, animCol;
float animProgress = 0.0;

// Scoreboard
int scoreX = 0;
int scoreO = 0;
int scoreTies = 0;

void setup() {
  size(500, 700); // Increased height for more space
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
    text(winnerMessage, width / 2, height - 150); // Display winner message below the grid
  }

  if (isAnimating) {
    animateShape();
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
  stroke(50, 50, 50); // Dark gray grid lines
  strokeWeight(4);

  // Draw grid lines
  for (int i = 1; i < 3; i++) {
    line(gridOffsetX + i * cellSize, gridOffsetY, gridOffsetX + i * cellSize, gridOffsetY + 3 * cellSize);
    line(gridOffsetX, gridOffsetY + i * cellSize, gridOffsetX + 3 * cellSize, gridOffsetY + i * cellSize);
  }

  // Draw X and O
  for (int row = 0; row < 3; row++) {
    for (int col = 0; col < 3; col++) {
      if (board[row][col] == 1 && !(isAnimating && row == animRow && col == animCol)) {
        drawX(gridOffsetX + col * cellSize, gridOffsetY + row * cellSize, 1.0);
      } else if (board[row][col] == -1 && !(isAnimating && row == animRow && col == animCol)) {
        drawO(gridOffsetX + col * cellSize, gridOffsetY + row * cellSize, 1.0);
      }
    }
  }

  // Highlight winning line
  if (winningLine != null) {
    stroke(255, 0, 0); // Red for the winning line
    strokeWeight(8);
    line(gridOffsetX + winningLine[0] * cellSize + cellSize / 2, gridOffsetY + winningLine[1] * cellSize + cellSize / 2,
         gridOffsetX + winningLine[2] * cellSize + cellSize / 2, gridOffsetY + winningLine[3] * cellSize + cellSize / 2);
  }
}

void drawX(int x, int y, float progress) {
  stroke(0, 102, 204); // Blue for X
  strokeWeight(6);
  float lineLength = (cellSize - 40) * progress;

  // First line
  line(x + 20, y + 20, x + 20 + lineLength, y + 20 + lineLength);

  // Second line
  line(x + cellSize - 20, y + 20, x + cellSize - 20 - lineLength, y + 20 + lineLength);
}

void drawO(int x, int y, float progress) {
  stroke(255, 102, 102); // Pink for O
  strokeWeight(6);
  noFill();
  ellipseMode(CENTER);
  float angle = TWO_PI * progress;
  arc(x + cellSize / 2, y + cellSize / 2, cellSize - 40, cellSize - 40, 0, angle);
}

void drawButtons() {
  // Restart Button
  fill(100, 200, 100); // Green button
  rect(width / 2 - 140, height - 100, 120, 50, 10);
  fill(255);
  textSize(20);
  text("Restart", width / 2 - 80, height - 75);

  // AI Toggle Button
  fill(200, 100, 100); // Red button
  rect(width / 2 + 20, height - 100, 120, 50, 10);
  fill(255);
  textSize(20);
  text(vsAI ? "AI: ON" : "AI: OFF", width / 2 + 80, height - 75);
}

void mousePressed() {
  if (gameOver) {
    // Check if restart button is clicked
    if (mouseX > width / 2 - 140 && mouseX < width / 2 - 20 && mouseY > height - 100 && mouseY < height - 50) {
      resetGame();
    }
    return;
  }

  // Check if AI toggle button is clicked
  if (mouseX > width / 2 + 20 && mouseX < width / 2 + 140 && mouseY > height - 100 && mouseY < height - 50) {
    vsAI = !vsAI;
    resetGame();
    return;
  }

  if (isAnimating) return; // Prevent moves during animation

  int col = (mouseX - gridOffsetX) / cellSize;
  int row = (mouseY - gridOffsetY) / cellSize;

  if (col >= 0 && col < 3 && row >= 0 && row < 3 && board[row][col] == 0) {
    board[row][col] = currentPlayer;
    animRow = row;
    animCol = col;
    animProgress = 0.0;
    isAnimating = true;
  }
}

void animateShape() {
  animProgress += 0.05; // Speed of animation

  if (currentPlayer == 1) {
    drawX(gridOffsetX + animCol * cellSize, gridOffsetY + animRow * cellSize, animProgress);
  } else {
    drawO(gridOffsetX + animCol * cellSize, gridOffsetY + animRow * cellSize, animProgress);
  }

  if (animProgress >= 1.0) {
    isAnimating = false;
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
  for (int row = 0; row < 3; row++) {
    for (int col = 0; col < 3; col++) {
      if (board[row][col] == 0) {
        board[row][col] = -1;
        animRow = row;
        animCol = col;
        animProgress = 0.0;
        isAnimating = true;
        return;
      }
    }
  }
}

boolean checkWinner() {
  // Check rows and columns
  for (int i = 0; i < 3; i++) {
    if (board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0] != 0) {
      winningLine = new int[] {0, i, 2, i};
      return true;
    }
    if (board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[0][i] != 0) {
      winningLine = new int[] {i, 0, i, 2};
      return true;
    }
  }

  // Check diagonals
  if (board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0] != 0) {
    winningLine = new int[] {0, 0, 2, 2};
    return true;
  }
  if (board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2] != 0) {
    winningLine = new int[] {2, 0, 0, 2};
    return true;
  }

  return false;
}

boolean isBoardFull() {
  for (int row = 0; row < 3; row++) {
    for (int col = 0; col < 3; col++) {
      if (board[row][col] == 0) {
        return false;
      }
    }
  }
  return true;
}

void resetGame() {
  board = new int[3][3]; // Clear the board
  currentPlayer = 1; // Reset to Player X
  gameOver = false; // Reset game over state
  winnerMessage = ""; // Clear the winner message
  winningLine = null; // Clear the winning line
  isAnimating = false; // Stop any ongoing animations
  animProgress = 0.0; // Reset animation progress
}
