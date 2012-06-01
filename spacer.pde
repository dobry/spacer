import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;
FFT fft;
MyFFT my_fft;
int domF; // dominant frequency index
float maxAmp; // amplitude for the max frequency
int fScopeMax = 0,
  fScopeMin = 1000;

int displayH = 300;
int displayW = 512;

int step = 200;
final int minFrequency = 44;
final int maxFrequency = 135;


int printValues = 1;

void setup()
{
  size(displayW, displayH, P2D);

  minim = new Minim(this);
  
  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 512, 8000);
  
  fft = new FFT(in.bufferSize(), in.sampleRate());
  my_fft = new MyFFT(in.bufferSize(), in.sampleRate());
  //fft.window(FFT.HAMMING);
}

void draw()
{
  background(0);
  stroke(255);
  
  fft.forward(in.mix);
  
  drawShip();
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
    case 'r':
      fScopeMax = 0;
      fScopeMin = 1000;
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


// draw the waveform and spectrum
// It is in two loop for eficiency reasons, first it draws waveform and spectrum, which is ~2x shorter.
// Then in second loop it finishes only waveform. Also detect min and max frequency.
void spectrumExtremes()
{
  // reset dominant frequency and amplitude for new batch of fft
  domF = 0;
  maxAmp = 0;
    
  for(int i = 0; i < fft.specSize(); i++)
  {
    line(i, 50 + in.mix.get(i)*step, i+1, 50 + in.mix.get(i+1)*step);
    line(i, height, i, height - fft.getBand(i)*4);
    
    // find dominant frequency (max amplitude)
    if (fft.getBand(i) > maxAmp)
    {
      maxAmp = fft.getBand(i);
      domF = i;
      if (i> fScopeMax)
      {
        fScopeMax = i;
      }
      else if (i > 35 && i < fScopeMin)
      {
        fScopeMin = i;
      }
    } 
  }
  for(int i = fft.specSize(); i < in.bufferSize() - 1; i++)
  {
    line(i, 50 + in.mix.get(i)*step, i+1, 50 + in.mix.get(i+1)*step);
  }
  
  // print some output or not
  if (printValues == 1)
  {
    println(domF + " freq: " + (domF * in.sampleRate() / fft.timeSize()) + " Hz");
  }
  else if (printValues == 2)
  {
    println("scope " + fScopeMin + " min " + fScopeMin * in.sampleRate() / fft.timeSize() + "Hz and " + fScopeMax + " max " + fScopeMax * in.sampleRate() / fft.timeSize() + "Hz");
  }
}

void drawShip()
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
  
  //println("" + 700 / in.sampleRate() * fft.timeSize() + " " + 2100 / in.sampleRate() * fft.timeSize());
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
  h = (dominantFreq - minFrequency) * displayH / (maxFrequency - minFrequency);
  //println("height " + h + " " + domF + " " + dominantFreq + " " + displayH + " " + maxFrequency + " " + minFrequency);  
  println("height " + h);
  //background(192, 64, 0);
  //stroke(255, 255, 0);
  
  //rect(50, h + 25, 100, h - 
  //println(domF + " freq: " + (domF * in.sampleRate() / fft.timeSize()) + " Hz");
}
