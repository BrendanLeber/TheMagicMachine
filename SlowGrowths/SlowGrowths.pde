final float TAU = 6.28318530718;

color empty_color = color(127, 201, 127);
color active_color = color(190, 174, 212);
color static_color = color(253, 192, 134);
color edge_color = color(255, 255, 153);

int seed_size = 16;
int flake_size = 8;

/**
 * A crystal flake that is moving around the world and trying to
 * attach to the seed/lattice.
 */
class Flake
{
  int x, y;

  Flake() {
    int offset = seed_size / 2;
    float select = random(0, 100);
    if (select <= 25) {
      x = width / 2 + offset;
      y = height / 2;
    } else if (select > 25 && select <= 50) {
      x = width / 2 - offset - flake_size;
      y = height / 2;
    } else if (select > 50 && select <= 75) {
      x = width / 2;
      y = height / 2 + offset;
    } else if (select > 75) {
      x = width / 2;
      y = height / 2 - offset - flake_size;
    }
  }

  void draw(boolean alive) {
    if (alive) { //<>//
      fill(active_color);
    }
    else {
      fill(static_color);
    }
    
    noStroke();
    rect(x, y, flake_size, flake_size);
  }

  void move() {
    float select = random(0, 100);
    if (select <= 25) {
      x += flake_size;
    } else if (select > 25 && select <= 50) {
      x -= flake_size;
    } else if (select > 50 && select <= 75) {
      y += flake_size;
    } else if (select > 75) {
      y -= flake_size;
    }
  }
  
  // distance from the center of the window
  int distance() {
    int dx = x - width / 2;
    int dy = y - height / 2;
    float d = sqrt(dx * dx + dy * dy);
    println(d);
    return int(d);
  }
}

ArrayList<Flake> crystal;
Flake flake;


void setup()
{
  size(480, 480);
  crystal = new ArrayList<Flake>();
  flake = new Flake();
}


void draw()
{
  background(empty_color);
  
  // the "petri" dish
  int span = min(width, height);
  stroke(edge_color);
  fill(0);
  ellipse(width / 2, height / 2, span, span);

  // our seed crystal in the center
  fill(static_color);
  noStroke();
  rect(width / 2 - seed_size / 2, height / 2 - seed_size / 2, seed_size, seed_size);
  
  // the static flakes
  for (Flake dead : crystal) {
    dead.draw(false); //<>//
  }
  
  // our active flake
  flake.move();
  if (flake.distance() >= span / 2) {
    flake.draw(false); //<>//
    crystal.add(flake);
    
    flake = new Flake();
  }
  flake.draw(true);
  
/*
  // saveFrame("frames/frame-######.png");

  // stop rendering after 10 minutes
  if (frameCount > 10 * 60 * 24) {
    noLoop();
  }
*/
}
