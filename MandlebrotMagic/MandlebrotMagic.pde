/**
 * The Magic Machine: Mandlebrot Magic
 *
 * My implementation of "Mandlebrot Magic" from Chapter 1 of the book:
 *
 * The Magic Machine: A Handbook of Computer Sorcery.
 * Author: A.K. Dewdney
 * Publisher: W.H. Freeman
 * ISBN: 0-7167-2125-2
 * QA76.6.D5173 1990
 * 794.8'1536 -- dc20
 *
 * Author: Brendan Leber <brendan@brendanleber.com>
 */

final int frames_per_second = 24;
final int seconds_of_video = 5 * 60 + 23;  /* 5:23 */
final int num_frames = seconds_of_video * frames_per_second;


void setup()
{
  size(1920, 1080);
  noStroke();
}


void draw()
{
  // do work

  //saveFrame("frame-######.png")
  if (frameCount >= num_frames) {
    noLoop();
  }
}
   
