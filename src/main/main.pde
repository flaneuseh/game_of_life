color black = color(0);
color white = color(255);
int side = 10;
int[][] cells = new int[side][side];
int size = 10;
boolean continuous = false; // Whether to draw in continuous or single step mode.

void setup() {
  size(1000, 1000);
  
}

void draw() {
  background(black);
  
  for (int x = 0; x < 10; x++) {
    for (int y = 0; y < 10; y++) {
      // Populate grid.
      if (cells[x][y] == 1) {
        int gridX = cell_to_grid(x);
        int gridY = cell_to_grid(y);
        square(gridX, gridY, size);
      }
      if (continuous) {
        // Updating every loop.
        update(x, y);
      }
    }
  }
}

// Translate cell coordinates to grid coordinates.
int cell_to_grid(int cell) {
  return cell * size;
}

// Translate grid coordinates to cell coordinates.
int grid_to_cell(int grid) {
  return grid / size; // Integer division results in the floor of the floating point value.
}

void update() {
  for (int x = 0; x < 10; x++) {
    for (int y = 0; y < 10; y++) {
      update(x, y);
    }
  }
}

// Update cell x, y for the next draw.
void update(int x, int y) {
  switch (n(x, y)) {
    case 2:
      // Stasis.
      break;
    case 3:
      // Birth.
      cells[x][y] = 1;
      break;
    default:
      // Death.
      cells[x][y] = 0;
  }
}

// The number of live neighbors of cell x,y.
int n(int x, int y) {
  int n = 0;
  for (int xn = -1; xn <= 1; xn++) {
    for (int yn = -1; yn <= 1; yn++) {
      if ((xn == 0) && (yn == 0)) {
        // The original cell.
        continue;
      }
      // Toroidal wrap of cell neighbors.
      int xx = (x + xn + side) % side;
      int yy = (y + yn + side) % side;
      n += cells[xx][yy];
    }
  }
  return n;
}

// Randomize grid.
void randomize() {
  for (int x = 0; x < 10; x++) {
    for (int y = 0; y < 10; y++) {
      cells[x][y] = round(noise(x, y));
    }
  }
}

// Click on cells to turn them live.
void mousePressed() {
  int x = grid_to_cell(mouseX);
  int y = grid_to_cell(mouseY);
  cells[x][y] = 1;
}

void keyPressed() {
  switch (key) {
    case ('c'):
    case ('C'):
      // Mass extinction!
      cells = new int[side][side];
      break;
    case ('r'):
    case ('R'):
      randomize();
      break;
    case ('g'):
    case ('G'):
      continuous = !continuous;
      break;
    case (' '):
      continuous = false;
      update();
      break;
    default:
      break;
  }
}
