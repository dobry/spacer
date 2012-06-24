// draw the waveform and spectrum
// It is in two loop for eficiency reasons, first it draws waveform and spectrum, which is ~2x shorter.
// Then in second loop it finishes only waveform. Also detect min and max frequency.
class SpectrumExtremes implements displayHandler
{
  void draw()
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
}
