/**
 * Algorithmic Art - Needs a better name.
 *
 * Author: Brendan Leber <brendan@brendanleber.com>
 */

static float HueAngle = 125.0;
static int NumCols = 10;
static int NumRows = 10;

PGraphics pg;
Square[][] world;

class Square
{
  float top, left, right, bottom;
  float angle;

  Square(float x, float y, float w, float h, float a)
  {
    top = y;
    left = x;
    right = left + w;
    bottom = top + h;
    angle = a;
  }

  void oscillate()
  {
    angle += 0.1;
  }

  void display(PGraphics pg)
  {
    float hue = HueAngle * sin(angle) + HueAngle;
    pg.fill(hue, 0, 0);
    pg.stroke(255);
    pg.rect(left, top, right, bottom);
  }
}

void setup()
{
  // YouTube recommended settings
  size(854, 480);  // 480p
  frameRate(24);

  pg = createGraphics(width, height);
  
  world = new Square[NumCols][NumRows];

  int cx = floor(width / (float)NumCols);
  int cy = floor(height / (float)NumRows);

  for (int x = 0; x < NumCols; ++x) {
    for (int y = 0; y < NumRows; ++y) {
      int sx = cx;
      if (x == NumCols - 1)
        sx--;

      int sy = cy;
      if (y == NumRows - 1)
        sy--;

      world[x][y] = new Square(x * cx, y * cy, sx, sy, (float)(x + y) * cos(y));
    }
  }
}

void renderFrame()
{
  pg.beginDraw();
  
  pg.background(0);
  
  for (int i = 0; i < NumCols; ++i) {
    for (int j = 0; j < NumRows; ++j) {
      world[i][j].oscillate();
      world[i][j].display(pg);
    }
  }

  pg.stroke(255);
  pg.strokeWeight(1);
  pg.line(0, height-1, width, height-1);
  pg.line(width-1, 0, width-1, height);
  
  pg.endDraw();
}

void draw()
{
  renderFrame();
  image(pg, 0, 0);

  saveFrame("../frames/frame-######.png");
  if (frameCount > 1440)
    noLoop();  // stop rendering after 1 minute (24 fps * 60 secs = 1440)
}
