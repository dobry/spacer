//draw the game
class Game implements displayHandler
{
  PImage plane; // plane graphics
  int hh_plane; // half of the plane height
  
  public Game()
  {
    // something is wrong with paths, it doesn't work with local "p.jpg" or "data/p.jpg"
    plane = loadImage("/home/krzys/projekty/processing-skechbook/spacer/data/p.png");
    hh_plane = plane.height/2;
  }
  
  void draw()
  {
    int dominantFreq = (minFrequency + maxFrequency)/2, h;
    maxAmp = 0;
    // find dominant frequency
    for(int i = 0; i < fft.specSize(); i++)
    {
      if (fft.getBand(i) > maxAmp)
      {
        maxAmp = fft.getBand(i);
        dominantFreq = i;
      }
    }
    
    
  //  println("" + 700 / in.sampleRate() * fft.timeSize() + " " + 2150 / in.sampleRate() * fft.timeSize());
    // check if it's valid (in scope), if not, get the previous the last found
    if (dominantFreq < minFrequency || dominantFreq > maxFrequency) // 32 and 147 are the numbers of border fft band
    {
      dominantFreq = domF;
    }
    else
    {
      domF = dominantFreq;
    }
    
    // calculate height
    h = displayH * (maxFrequency  - dominantFreq) / (maxFrequency - minFrequency);
    background(192, 64, 0);
    stroke(255, 255, 0);
    
    //rect(50, h - 10, 50, 20);
    image(plane, 50, h - hh_plane);
    println(plane.height + " " + plane.width);
  //  println(domF + " freq: " + (domF * in.sampleRate() / fft.timeSize()) + " Hz");
  }
}
