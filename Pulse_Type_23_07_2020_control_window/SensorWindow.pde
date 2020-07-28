int[] rawY;      // HOLDS HEARTBEAT WAVEFORM DATA BEFORE SCALING
int[] scaledY;   // USED TO POSITION SCALED HEARTBEAT WAVEFORM

class SensorWindow extends PApplet {
  //JFrame frame;

  public SensorWindow() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  int w;
  
  public void settings() {
    w = (displayWidth-pdfW*3)/2;
    w = constrain(w, 200, pdfW*3);
    size(w, displayHeight/2);
    pixelDensity(displayDensity());
    pixelDensity(displayDensity());
  }
  public void setup() { 
    surface.setTitle("Sensor Data");
    surface.setLocation(0, displayHeight/2-height/2);
    surface.setResizable(true);
    scaledY = new int[width];       // initialize scaled pulse waveform array
    rawY = new int[width];          // initialize raw pulse waveform array
  }

  public void draw() {
    // background with alpha
    fill(255, 10);
    noStroke();
    // background of bpm text
    rect(0, 0, width, height);
    fill(242);
    rect(10, height-40, 80, height/20);
    // bpm text
    fill(0);
    textSize(height/20);
    // textFont(myFonts[round(random (myFonts.length-1))]);
    text(BPM + " BPM", 20, height-20);
    drawPulseWaveform();
  }

  public void mousePressed() {
  }

  public void mouseDragged() {
  }

  public void drawPulseWaveform() {
    // DRAW THE PULSE WAVEFORM
    // prepare pulse data points
    strokeWeight(height/60);
    rawY[rawY.length-1] = (1023 - sensor) - height/2;   // place the new raw datapoint at the end of the array
    float zoom = 0.5;                      // get current waveform scale value
    float offset = map(zoom, 0.5, 1, 150, 0);                // calculate the offset needed at this scale
    for (int i = 0; i < rawY.length-1; i++) {      // move the pulse waveform by
      rawY[i] = rawY[i+1];                         // shifting all raw datapoints one pixel left
      float dummy = rawY[i] * zoom + offset;       // adjust the raw data to the selected scale
      scaledY[i] = constrain(int(dummy), 44, 556);   // transfer the raw data array to the scaled array
    }
    noFill();
    stroke(25, 200, 200);             
    beginShape();  //using beginShape() renders fast
    for (int x = 1; x < scaledY.length-1; x++) {
      vertex(x+10, scaledY[x]);                    //draw a line connecting the data points
    }
    endShape();
  }
}
