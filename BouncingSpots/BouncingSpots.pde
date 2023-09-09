/**
 * Bouncing Spots - a simple animation of bouncing spots.
 *
 * Author: Brendan Leber <brendan@brendanleber.com>
 */


class Spot
{
  float x, y;
  float diameter;
  float speed;
  int direction = 1;

  Spot(float xpos, float ypos, float dia, float sp)
  {
    x = xpos;
    y = ypos;
    diameter = dia;
    speed = sp;
  }

  void move()
  {
    y += speed * direction;
    if ((y > (height - diameter / 2)) || (y < diameter / 2)) {
      direction *= -1;
    }
  }

  void display()
  {
    ellipse(x, y, diameter, diameter);
  }
}


final int framesPerSecond = 30;
final int secondsOfVideo = 5 * 60 + 23;  /* 5:23 */
final int numFrames = secondsOfVideo * framesPerSecond;
final int numSpots = 96;


ArrayList<Spot> spots;


void setup()
{
  size(1920, 1080);
  noStroke();

  float dia = width / numSpots;

  spots = new ArrayList<Spot>();
  for (int i = 0; i < numSpots; ++i) {
    float x = dia / 2 + i * dia;
    float rate = random(1.0, 5.0);
    spots.add(new Spot(x, height / 2, dia, rate));
  }
}


void draw()
{
  fill(0, 12);
  rect(0, 0, width, height);

  fill(255);

  for (Spot s : spots) {
    s.move();
    s.display();
  }

  saveFrame("../frames/frame-######.png");

  if (frameCount >= numFrames) {
    noLoop();
  }
}
