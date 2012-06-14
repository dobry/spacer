import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;
FFT fft;
MyFFT my_fft;

final int displayW = 800;//1400;//512;
final int displayH = 600;//1050;//300;

final int minFrequency = 48;
final int maxFrequency = 138;

final int defaultFrameRate = 30;

int domF = (maxFrequency + minFrequency)/2; // dominant frequency index
float maxAmp; // amplitude for the max frequency
int fScopeMax = 0,
  fScopeMin = 1000;

int step = 200;

// display handlers
SpectrumExtremes specExtr = new SpectrumExtremes();
Game game = new Game();
displayHandler handler = game;

int printValues = 1;

void setup()
{
  size(displayW, displayH, P3D);

  frameRate(defaultFrameRate);
  
  minim = new Minim(this);
  
  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 512, 8000);
  
  fft = new FFT(in.bufferSize(), in.sampleRate());
  //my_fft = new MyFFT(in.bufferSize(), in.sampleRate());
  //fft.window(FFT.HAMMING);
}

void draw()
{
  background(0);
  stroke(255);
  
  fft.forward(in.mix);
  
  //spectrumExtremes();
  handler.draw();
  //drawShip();
} 

void keyReleased()
{
  switch (key) {
    case '1': // press 1 to print current frequency
      printValues = 1;
      break;
    case '2': // press 2 to print min and max registered frequency
      printValues = 2;
      break;
    case '[':
      println("Spectrum Extremes");
      handler = specExtr;
      break;
    case ']':
      println("The Game");
      handler = game;
    case 'r':
      fScopeMax = 0;
      fScopeMin = 1000;
      break;
    case '=':
      game.gameSpeed = game.gameSpeed + 1;
      break;
    case '-':
      game.gameSpeed = game.gameSpeed - 1;
      break;    
    default: // disable printing
      printValues = 3;
      break;
  }
}
   
void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
  
  super.stop();
}
