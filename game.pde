//draw the game
class Game implements displayHandler
{

  PImage plane; // plane graphics
  int hh_plane; // half of the plane height
  PImage [] smiles = new PImage[3];
  PImage [] grims = new PImage[3];
  PImage [] gclouds = new PImage[7];

  String path = "/home/krzys/projekty/processing-skechbook/spacer/data/";
  
  Iterator iterator;

  Queue<Cloud> clouds;

  long progress = 14500; // game progress, tell, how far the plane is
  long cloud_start = defaultFrameRate * 2; // how fast game clouds will appear on the screen
  
  public Game()
  {
    //get plane graphics
    // something is wrong with paths, it doesn't work with local "p.jpg" or "data/p.jpg"
    plane = loadImage(path + "p.png");
    hh_plane = plane.height/2;
    
    //get graphics of cloudes, smiles and grims
    for (int i = 0; i < 3; i++)
    {
      smiles[i] = loadImage(path + "fs" + (i + 1) + ".jpg");
      grims[i] = loadImage(path + "fb" + (i + 1) + ".jpg");
      gclouds[i] = loadImage(path + "c" + (i + 1) + ".jpg");
      gclouds[i] = loadImage(path + "c" + (i + 4) + ".jpg");
    }
    gclouds[6] = loadImage(path + "c7.jpg");
    
    
    // initiate notes/clouds
    clouds = new LinkedList<Cloud>();
    readNotes();
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
    h = calcHeight(dominantFreq);
    background(192, 64, 0);
    stroke(255, 255, 0);
    
    //rect(50, h - 10, 50, 20);
    image(plane, 50, h - hh_plane);
    //println(plane.height + " " + plane.width);
    
    drawClouds();
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
      pos = int((cloud_start + c.timing) * displayW / defaultFrameRate - progress);
      h = calcHeight(c.note);
      
      println(pos + " " + (h - gclouds[6].height/2));
      image(gclouds[6], pos, h - gclouds[6].height/2);      
    }
        
    //image(gclouds[0], 200, 200);
    //printClouds();
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

        timing = timing + 2000/float(pieces[1]);         
        // next note
        if (pieces.length == 3)
        {

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
  
  int calcHeight(int dominantFreq)
  {
    return displayH * (maxFrequency  - dominantFreq) / (maxFrequency - minFrequency);
  }
}
