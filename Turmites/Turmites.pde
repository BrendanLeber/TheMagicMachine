/**
 * Turmites - an implementation of Turmites from 'The Tinkertoy Computer'
 * by A.K. Dewdney.
 *
 * Author: Brendan Leber <brendan@brendanleber.com>
 */


import java.util.Map;


// the possible colors for our turmite
static final int COLOR_BLACK = 0;
static final int COLOR_RED = 1;
static final int COLOR_YELLOW = 2;
static final int COLOR_GREEN = 3;
static final int NUM_COLORS = 4;

// the possible headings
public enum Heading {
  NORTH(0),
  EAST(1),
  SOUTH(2),
  WEST(3);
  
  private int value;
  private static Map map = new HashMap<>();
  
  private Heading(int value) {
    this.value = value;
  }
  
  static {
    for (Heading heading : Heading.values()) {
      map.put(heading.value, heading);
    }
  }
  
  public static Heading valueOf(int heading) {
    return (Heading) map.get(heading);
  }
  
  public int getValue() {
    return value;
  }
  
  static public int size() {
    return map.size();
  }
}

/*
static final int H_NORTH = 0;
static final int H_EAST = 1;
static final int H_SOUTH = 2;
static final int H_WEST = 3;
static final int NUM_HEADINGS = 4;
*/

// the possible motions
static final int M_FORWARD = 0;
static final int M_BACKWARD = 1;
static final int M_LEFT = 2;
static final int M_RIGHT = 3;
static final int NUM_MOTIONS = 4;


class Turmite
{
  private int[] colors;
  private int[] motions;
  private Heading[][] headings;

  private int row, col;
  private Heading heading;

  Turmite(int r, int c, Heading h)
  {
    // Translate a heading and motion into the new heading.
    // This does not change based on the turmite's brain.
    headings = new Heading[Heading.size()][NUM_MOTIONS];
    headings[Heading.NORTH.getValue()][M_FORWARD]  = Heading.NORTH;
    headings[Heading.NORTH.getValue()][M_RIGHT]    = Heading.EAST;
    headings[Heading.NORTH.getValue()][M_LEFT]     = Heading.WEST;
    headings[Heading.NORTH.getValue()][M_BACKWARD] = Heading.SOUTH;

    headings[Heading.EAST.getValue()][M_FORWARD]  = Heading.EAST;
    headings[Heading.EAST.getValue()][M_RIGHT]    = Heading.SOUTH;
    headings[Heading.EAST.getValue()][M_LEFT]     = Heading.NORTH;
    headings[Heading.EAST.getValue()][M_BACKWARD] = Heading.WEST;

    headings[Heading.SOUTH.getValue()][M_FORWARD]  = Heading.SOUTH;
    headings[Heading.SOUTH.getValue()][M_RIGHT]    = Heading.WEST;
    headings[Heading.SOUTH.getValue()][M_LEFT]     = Heading.EAST;
    headings[Heading.SOUTH.getValue()][M_BACKWARD] = Heading.NORTH;

    headings[Heading.WEST.getValue()][M_FORWARD]  = Heading.WEST;
    headings[Heading.WEST.getValue()][M_RIGHT]    = Heading.NORTH;
    headings[Heading.WEST.getValue()][M_LEFT]     = Heading.SOUTH;
    headings[Heading.WEST.getValue()][M_BACKWARD] = Heading.EAST;

    // turmite 'brain' state machine
    colors = new int[NUM_COLORS];
    motions = new int[NUM_COLORS];

    colors[COLOR_BLACK] = COLOR_RED;
    motions[COLOR_BLACK] = M_RIGHT;

    colors[COLOR_RED] = COLOR_YELLOW;
    motions[COLOR_RED] = M_RIGHT;

    colors[COLOR_YELLOW] = COLOR_GREEN;
    motions[COLOR_YELLOW] = M_LEFT;

    colors[COLOR_GREEN] = COLOR_BLACK;
    motions[COLOR_GREEN] = M_LEFT;

    heading = h;
    row = r;
    col = c;
  }

  public void step(World w)
  {
    // lookup new color, motion and state
    int clr = w.getColor(row, col);

    // color current point
    w.setColor(row, col, colors[clr]);

    // move based on heading & motion
    int motion = motions[clr];
    heading = headings[heading.getValue()][motion];
    switch (heading) {
      case NORTH:
        row--;
        if (row < 0)
          row = w.height() - 1;
        break;
      case SOUTH:
        row = (row + 1) % w.height();
        break;
      case WEST:
        col--;
        if (col < 0)
          col = w.width() - 1;
        break;
      case EAST:
        col = (col + 1) % w.width();
        break;
    }
  }
}


class World
{
  PGraphics pg;
  int sz;
  int cx, cy;
  int cells[][];
  color[] rgb_values;

  ArrayList<Turmite> turmites;

  World() {
    turmites = new ArrayList<Turmite>();
  }

  void initialize(int w, int h, int cell_size)
  {
    // initialize the RGB values for our colors
    rgb_values = new color[NUM_COLORS];
    rgb_values[COLOR_BLACK] = color(127, 201, 127);
    rgb_values[COLOR_RED] = color(190, 174, 212);
    rgb_values[COLOR_YELLOW] = color(253, 192, 134);
    rgb_values[COLOR_GREEN] = color(255, 255, 153);

    // calculate the size of our world based on the size of our window
    sz = cell_size;
    cx = floor(w / sz);
    cy = floor(h / sz);
    
    int mid_x = cx / 2;
    int mid_y = cy / 2;

    // setup the initial values for the world
    cells = new int[cy][cx];
    for (int row = 0; row < cy; ++row)
      for (int col = 0; col < cx; ++col)
        cells[row][col] = COLOR_BLACK;

    // render the initial state of the world
    pg = createGraphics(w, h);
    pg.beginDraw();
    pg.background(rgb_values[COLOR_BLACK]);
    pg.endDraw();

    turmites.clear();
    turmites.add(new Turmite(mid_y, mid_x, Heading.NORTH));
    turmites.add(new Turmite(mid_y - mid_y / 2, mid_x - mid_x / 2, Heading.EAST));
    turmites.add(new Turmite(mid_y - mid_y / 2, mid_x + mid_x / 2, Heading.SOUTH));
    turmites.add(new Turmite(mid_y + mid_y / 2, mid_x - mid_x / 2, Heading.WEST));
    turmites.add(new Turmite(mid_y + mid_y / 2, mid_x + mid_x / 2, Heading.NORTH));
  }

  int getColor(int row, int col)
  {
    return cells[row][col];
  }

  void setColor(int row, int col, int c)
  {
    cells[row][col] = c;

    pg.beginDraw();
    pg.fill(rgb_values[c]);
    pg.rect(col * sz, row * sz, sz, sz);
    pg.endDraw();
  }

  int height()
  {
    return cy;
  }

  int width()
  {
    return cx;
  }

  void stepAndRender()
  {
    for (Turmite turmite : turmites) {
      turmite.step(this);
    }

    image(pg, width - cx * sz, 0);
  }
}


World world;


void setup()
{
  size(1920, 1080);
  //frameRate(24);
  
  world = new World();
  world.initialize(width, height, 8);
}

// loop to run the turmite
void draw()
{
  background(0);
  world.stepAndRender();

/*
  saveFrame("../frames/frame-######.png");

  // stop rendering after 10 mintues
  if (frameCount > 10 * 60 * 24)
    noLoop();
*/
}
