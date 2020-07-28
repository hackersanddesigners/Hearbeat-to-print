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
    fill(255, 10);
    noStroke();
    // background of bpm text
    rect(0, 0, width, height);
    fill(242);
    rect(10, height-50, 200, height/10); // might need some refinement
    // bpm text
    fill(0);
    textSize(height/20);
   // textFont(myFonts[round(random (myFonts.length-1))]);
    text(nf(volume*10, 1, 4) + " VOL", 20, height-20);
    drawPulseWaveform((volume*10)*100);
  }

  public void mousePressed() {
  }

  public void mouseDragged() {
  }

  public void drawPulseWaveform(float sensor) {
    // DRAW THE PULSE WAVEFORM
    // prepare pulse data points
    strokeWeight(height/60);
    waveY[waveY.length-1] = height/2-sensor;         // place the new raw datapoint at the end of the array
    float zoom = 1;                      // get current waveform scale value
    float offset = map(zoom, 0.5, 1, 150, 0);                // calculate the offset needed at this scale
    for (int i = 0; i < waveY.length-1; i++) {      // move the pulse waveform by
      waveY[i] = waveY[i+1];                        // shifting all raw datapoints one pixel left
      float dummy = waveY[i] * zoom + offset;       // adjust the raw data to the selected scale
      scaledWaveY[i] = constrain(int(dummy), ws, height-ws);   // transfer the raw data array to the scaled array
    }
    noFill();
    stroke(250, 20, 200);             
    beginShape();  //using beginShape() renders fast
    for (int x = 1; x < scaledWaveY.length-1; x++) {
      vertex(x+10, scaledWaveY[x]);                 //draw a line connecting the data points
    }
    endShape();
  }
}
