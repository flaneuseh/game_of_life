color black = color(0);
color white = color(255);
int side = 100;
int[][] cells = new int[side][side];
int[][] neighbors = new int[side][side];
int size = 10;
boolean continuous = false; // Whether to draw in continuous or single step mode.

void setup() {
  size(1000, 1000);
}

void draw() {
  background(black);
  for (int x = 0; x < side; x++) {
    for (int y = 0; y < side; y++) {
      // Populate grid.
      if (cells[x][y] == 1) {
        int gridX = cell_to_grid(x);
        int gridY = cell_to_grid(y);
        square(gridX, gridY, size);
      }
    }
  }
  if (continuous) {
    update(); 
  }
}

// Update all cell values for the next draw.
void update() {
  // We loop twice so that cells don't change values based on their
  // neighbors' new values.
  for (int x = 0; x < side; x++) {
    for (int y = 0; y < side; y++) {
      neighbors[x][y] = n(x, y);
    }
  }
  for (int x = 0; x < side; x++) {
    for (int y = 0; y < side; y++) {
      switch (neighbors[x][y]) {
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
  for (int x = 0; x < side; x++) {
    for (int y = 0; y < side; y++) {
      cells[x][y] = round(random(1));
    }
  }
}

// Click on cells to turn them live.
void mousePressed() {
  int x = grid_to_cell(mouseX);
  int y = grid_to_cell(mouseY);
  cells[x][y] = 1;
  println("Clicked " + x + ", " + y);
}

void keyPressed() {
  switch (key) {
    case ('c'):
    case ('C'):
      // Mass extinction!
      cells = new int[side][side];
      println("Mass extinction!");
      break;
    case ('r'):
    case ('R'):
      randomize();
      println("Randomize");
      break;
    case ('g'):
    case ('G'):
      println("Toggle stepping");
      continuous = !continuous;
      break;
    case (' '):
      println("Step update");
      continuous = false;
      update();
      break;
    default:
      break;
  }
}
