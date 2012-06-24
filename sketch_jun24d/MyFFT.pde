import ddf.minim.analysis.*;

class MyFFT extends FFT
{
  MyFFT (int bufferSize, float sampleRate)
  {
    super(bufferSize, sampleRate);
  }
  
  float [] getSpectrum()
  {
    return spectrum;
  }
}
