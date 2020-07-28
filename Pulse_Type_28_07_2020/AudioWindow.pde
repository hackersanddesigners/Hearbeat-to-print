float[] waveY;        // HOLDS AUDIO VOLUME WAVEFORM DATA BEFORE SCALING
float[] scaledWaveY;   // USED TO POSITION SCALED AUDIO WAVEFORM

class AudioWindow extends PApplet {
  //JFrame frame;

  public AudioWindow() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  int w;

  public void settings() {
    w = (displayWidth-pdfW*3)/2;
    w = constrain(w, 200, pdfW*3);
    size(w, displayHeight/2);
    pixelDensity(displayDensity());
  }
  public void setup() { 
    surface.setTitle("Audio Data");
    surface.setLocation(displayWidth-w, displayHeight/2-height/2);
    surface.setResizable(true);
    scaledWaveY = new float[width];       // initialize scaled pulse waveform array
    waveY = new float[width];          // initialize raw pulse waveform array
  }

  public void draw() {
    // background with alpha
    fill(255, 60);
    noStroke();
    rect(0, 0, width, height);
    // background of bpm text
    fill(255);
    rect(ws/2, height-50, 200, height/10); // might need some refinement
    // bpm text
    fill(0);
    textSize(height/20);
    // textFont(myFonts[round(random (myFonts.length-1))]);
    text(nf(volume*10, 1, 4) + " VOL", ws, height-20);
    drawWaveform(waveform);
  }

  public void mousePressed() {
  }

  public void mouseDragged() {
  }

  public void drawWaveform(Waveform _waveform) {
    // DRAW THE SOUND WAVEFORM
    strokeWeight(height/60);
    noFill();
    stroke(100, 205, 100);             
    // Perform the analysis
    waveform.analyze();

    beginShape();
    for (int i = 0; i < samples; i++) {
      // Draw current data of the waveform
      // Each sample in the data array is between -1 and +1 
      vertex(
        map(i, 0, samples, ws, width-ws), 
        map(waveform.data[i]*2, -1, 1, 0, height-ws)
        );
    }
    endShape();
  }
}
