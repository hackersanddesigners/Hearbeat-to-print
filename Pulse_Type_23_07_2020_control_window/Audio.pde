void initAudio() {
  // Create an Audio input and grab the 1st channel
  input = new AudioIn(this);

  // Begin capturing the audio input
  input.start();

  // Create a new Amplitude analyzer
  loudness = new Amplitude(this);

  // Patch the input to the volume analyzer
  loudness.input(input);

  //minMax = calibrateAudio(1000); 
  minMax[0] = 0.001;
  minMax[1] = 0.1;
}

// also analyses BPM!
void analyseVolume(String word) {
  if (analyseVolume) {
    if (analysisRunning) {
      avgVol += volume;
      avgBPM += BPM;
      volCount++;
      //println(volume);
    } else {
      avgVol = 0;
      avgBPM = 0;
      analysisRunning = true;
      // println("analysis running");
    }
  } else {
    avgVol/=volCount;
    avgBPM/=volCount;
    volCount = 0;
    if (analysisRunning && !wordVolAnalysed[wordCount]) {
      wordVolume.set(wordCount, avgVol);
      wordBPM.set(wordCount, avgBPM);
      println("analysis finished: " + avgVol + ", " + avgBPM + ": " + word);
      //if (wordCount > 0) {
      //  float diff =  abs(wordBPM.get(wordCount-1) - wordBPM.get(wordCount));
      //  // println("BPM diff: " + diff);
      //  if (diff > 0.5) {
      //    //println("BPM diff: " + diff + " :: " + lineWords[word]);
      //    nextFont();
      //  }
      //}
      wordVolAnalysed[wordCount] = true;
      bpmSwitched[wordCount] = false;
      analysisRunning = false;
    }
  }
}
