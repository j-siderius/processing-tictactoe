/*
 * Tic-Tac-Toe / Boter-Kaas-Eieren
 * Jannick Siderius
 * 28 november 2021
 * 50 minuten
 *
 * Set field size using the fieldSize variable below (n x n field)
 * You need n-in-a-row to win (e.g. 4x4 > 4-in-a-row)
 *
 */


// playing field variables
int fieldSize = 4;
int[][] playingField = new int[fieldSize][fieldSize]; // legend: 0=empty, 1=nought, 2=cross

// game variables
int turn;
int roundCount, tieCount;
int neededToWin;
boolean gameRun;
color white = color(255, 255, 255);
color blue = color(0, 0, 220);

// image variables
PImage vline, hline, nought, cross;


void setup() {
  // setup game window
  size(100, 100);
  surface.setResizable(true);
  surface.setSize(fieldSize*100, fieldSize*100);

  // setup images
  vline = loadImage("vline.png");
  hline = loadImage("hline.png");
  nought = loadImage("nought.png");
  cross = loadImage("cross.png");

  // setup the playing field
  for (int y = 0; y < fieldSize; y++) {
    for (int x = 0; x < fieldSize; x++) {
      playingField[y][x] = 0;
      tieCount++;
    }
  }

  // setting up the game variables
  turn = 1;
  roundCount = 0;
  neededToWin = fieldSize - 1;
  gameRun = true;
  textAlign(CENTER);
  textSize(fieldSize * 12);
}


void draw() {
  // draw the board
  drawBoard();

  // check if there is a winner
  int winner = checkBoard();

  // draw winning messages
  if (winner == 1 || winner == 2) { // player winner
    gameRun = false;
    fill(blue);
    String winMessage = "Player " + winner + " won!";
    text(winMessage, (fieldSize * 100) / 2, (fieldSize * 100) / 2 + (fieldSize * 5));
  } else if (winner == 3) { // tie
    gameRun = false;
    fill(blue);
    String message = "Tie!";
    text(message, (fieldSize * 100) / 2, (fieldSize * 100) / 2 + (fieldSize * 5));
  }
}

void mouseReleased() {
  // check for mouse clicks and send them to the function
  if (gameRun) clickBoard(mouseX, mouseY);
}

void keyPressed() {
  if (key == ESC) exit();
}


void drawBoard() {
  background(white);

  // go over every board tile
  for (int y = 0; y < fieldSize; y++) {
    for (int x = 0; x < fieldSize; x++) {
      // board lines
      if (x > 0) image(vline, (x * 100) - 5, (y * 100));
      if (y > 0) image(hline, (x * 100), (y * 100) - 5);

      // noughts and crosses
      if (playingField[y][x] == 1) image(nought, (x * 100), (y * 100));
      else if (playingField[y][x] == 2) image(cross, (x * 100), (y * 100));
    }
  }
}

void clickBoard(int mx, int my) {
  // convert the click to the corresponding box on the playing field
  int clickBoxX = mx / 100;
  int clickBoxY = my / 100;

  // check if player clicked an empty box
  if (gameRun && playingField[clickBoxY][clickBoxX] == 0) {
    // place the token in the box and switch turns
    playingField[clickBoxY][clickBoxX] = turn;
    roundCount++;
    if (turn == 1) turn = 2;
    else turn = 1;
  }
}

// checks the playing board for a winning combination
int checkBoard() {
  // check vertical
  for (int x = 0; x < fieldSize; x++) {
    int columnCount = 0;
    for (int y = 0; y < fieldSize - 1; y++) {
      if (playingField[y][x] != 0 && playingField[y][x] == playingField[y+1][x]) {
        columnCount++;
      }
    }
    // if all boxes in the column are the same
    if (columnCount == neededToWin) {
      return playingField[0][x];
    }
  }

  // check horizontal
  for (int y = 0; y < fieldSize; y++) {
    int rowCount = 0;
    for (int x = 0; x < fieldSize - 1; x++) {
      if (playingField[y][x] != 0 && playingField[y][x] == playingField[y][x+1]) {
        rowCount++;
      }
    }
    // if all boxes in the row are the same
    if (rowCount == neededToWin) {
      return playingField[y][0];
    }
  }

  // check diagonal TopLeft>BottomRight
  int diagCountTL = 0;
  for (int y = 0; y < fieldSize - 1; y++) {
    if (playingField[y][y] != 0 && playingField[y][y] == playingField[y+1][y+1]) {
      diagCountTL++;
    }
  }
  // if all boxes in the diagonal are the same
  if (diagCountTL == neededToWin) {
    return playingField[0][0];
  }

  // check diagonal BottomLeft > TopRight
  int diagCountBL = 0;
  for (int y = 0; y < fieldSize - 1; y++) {
    if (playingField[y][(fieldSize - 1) - y] != 0 && playingField[y][(fieldSize - 1) - y] == playingField[y+1][(fieldSize - 1) - (y+1)]) {
      diagCountBL++;
    }
  }
  // if all boxes in the diagonal are the same
  if (diagCountBL == neededToWin) {
    return playingField[0][fieldSize - 1];
  }

  // check tie
  if (roundCount == tieCount) return 3;

  // if none of the rows, columns or diagonals were won
  return 0;
}
