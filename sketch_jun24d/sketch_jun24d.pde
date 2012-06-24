//draw the game


class Game implements displayHandler
{

  PImage plane; // plane graphics
  int hh_plane; // half of the plane height
  PImage [] smiles = new PImage[3];
  PImage [] grims = new PImage[3];
  PImage [] gclouds = new PImage[7];
  PImage bg;
  
  
  Iterator iterator;

  Queue<Cloud> clouds;

  long progress = 0;//145; // game progress, tell, how far the plane is
  public long gameSpeed = 6;
  long cloud_shift = 3000;//defaultFrameRate * 2; // how fast game clouds will appear on the screen
  
  final int planePosition = 50;
  final int colTolP = 75;
  final int colTolH = 45;
  int planeCurH = 0;
  
  int points = 0;
  
  public Game()
  {
    //get plane graphics
    // something is wrong with paths, it doesn't work with local "p.jpg" or "data/p.jpg"
    plane = loadImage(path + "p.png");
    hh_plane = plane.height/2;
    
    bg = loadImage(dataPath("bg1.png"));
    
    //get graphics of cloudes, smiles and grims
    for (int i = 0; i < 3; i++)
    {
      smiles[i] = loadImage(dataPath("fs" + (i + 1) + ".jpg"));
      grims[i] = loadImage(dataPath("fb" + (i + 1) + ".jpg"));
      gclouds[i] = loadImage(dataPath("c" + (i + 1) + ".jpg"));
      gclouds[i] = loadImage(dataPath("c" + (i + 4) + ".jpg"));
    }
    gclouds[6] = loadImage(dataPath("c7.jpg"));
    
    
    // initiate notes/clouds
    clouds = new LinkedList<Cloud>();
    readNotes();
  }
  
  boolean inCollision(int pos, int h)
  {
    
    stroke(255, 0, 255);
    /*rect(x, y, w, h);
    //rect(planePosition + 10, 
    planeCurH - colTolP + 40, 
    2 * colTolP + 0, 
    2 * colTolH - 30);*/
    if ((pos > planePosition + 10) &&
        (pos < planePosition + 10 + 2 * colTolP + 0) &&
        (h >     planeCurH - colTolP + 40) &&
        (h <     planeCurH - colTolP + 60 + 2 * colTolH - 30))
    {
      return true;
    }
    else
    {
      return false;
    }
  }

  void draw()
  {
    int dominantFreq = (minFrequency + maxFrequency)/2, h;
    
    progress = progress + gameSpeed;
    
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
    h = calcHeight(dominantFreq);
    planeCurH = h;
    image(bg, 0, 0, displayW, displayH);
    //background(192, 64, 0);
    stroke(255, 255, 0);
    
    //rect(50, h - 10, 50, 20);
    image(plane, planePosition, h - hh_plane);
    //println(plane.height + " " + plane.width);
    
    drawClouds();
    
    drawPoints();
  //  println(domF + " freq: " + (domF * in.sampleRate() / fft.timeSize()) + " Hz");
  }
  
  void drawClouds()
  {
    Cloud c;
    int pos;
    int h;
    iterator = clouds.iterator(); 
    while (iterator.hasNext()) {
      c = (Cloud)iterator.next();
      if (c.taken == true) continue;

      pos = calcPosition(c.timing);
      h = calcHeight(c.note);
      
      if (inCollision(pos, h))
      {
        c.taken = true;
        points = points + c.points;
      }
      else
      {
        image(gclouds[6], pos, h - gclouds[6].height/2);
      }
      //println(pos + " " + (h - gclouds[6].height/2));
      
    }
        
    //image(gclouds[0], 200, 200);
    //printClouds();
  }
  
  void drawPoints()
  {
    //println("points: " + points);
    
    fill(255,255,255);
    stroke(255,255,255);
    rect(displayW - 150, 20, 130, 40);
    
    fill(0,0,0);
    stroke(0,0,0);
    PFont font;
// The font must be located in the sketch's 
// "data" directory to load successfully
font = loadFont("CharterBT-Bold-48.vlw"); 
textFont(font); 
text(str(points), displayW - 150, 55); 

  }
  
  void printClouds()
  {
    Iterator it = clouds.iterator();

    System.out.println("Initial Size of Queue :" + clouds.size());

    while(it.hasNext())
    {
        Cloud iteratorValue = (Cloud)it.next();
        System.out.println("Queue Next Value :" + iteratorValue);
    }
    println();
  }
  
  void readNotes()
  {
    BufferedReader reader = createReader("/home/krzys/projekty/processing-skechbook/spacer/data/marry.notes");
    String line;
    String[] pieces;
    float timing = 0;
    float duration;
    
    while(true)
    {
      try {
        line = reader.readLine();
      } catch (IOException e) {
        e.printStackTrace();
        line = null;
      }
      if (line == null) {
        // Stop reading because of an error or file is empty
        break;
      } else {
        pieces = split(line, ' ');


        // next note
        if (pieces.length == 3)
        {
          timing = timing + 2000/float(pieces[1]);         
          clouds.add(new Cloud(int(pieces[0]), int(pieces[2]), timing));
        }
        // break
        else if (pieces.length == 2)
        {
          // nothing to do
        }
      }
    }
  }
  
  int calcPosition(float timing)
  {
    return int((cloud_shift + timing) * displayW / 200 / defaultFrameRate - progress);
  }
  
  int calcHeight(int dominantFreq)
  {
    return displayH * (maxFrequency  - dominantFreq) / (maxFrequency - minFrequency);
  }
}
