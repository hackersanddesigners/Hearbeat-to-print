int[] rawY;      // HOLDS HEARTBEAT WAVEFORM DATA BEFORE SCALING
int[] scaledY;   // USED TO POSITION SCALED HEARTBEAT WAVEFORM

class SensorWindow extends PApplet {
  //JFrame frame;

  public SensorWindow() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  int w;
  int xZoom=8;
  
  public void settings() {
    w = (displayWidth-pdfW*3)/2;
    w = constrain(w, 200, pdfW*3);
    size(w, displayHeight/2);
    pixelDensity(displayDensity());
    pixelDensity(displayDensity());
  }
  public void setup() { 
    surface.setTitle("Sensor Data");
    surface.setLocation(0, 0);
    surface.setResizable(true);
    scaledY = new int[width/xZoom];       // initialize scaled pulse waveform array
    rawY = new int[width/xZoom];          // initialize raw pulse waveform array
  }

  public void draw() {
    // background with alpha
    fill(red(back), green(back), blue(back), 60);
    noStroke();
    // background of bpm text
    rect(0, 0, width, height);
    fill(back);
    rect(ws, height-40, 80, height/20);
    // bpm text
    fill(fore);
    textSize(height/20);
    // textFont(myFonts[round(random (myFonts.length-1))]);
    text(BPM + " BPM", ws, height-20);
    drawPulseWaveform();
  }

  public void mousePressed() {
  }

  public void mouseDragged() {
  }

  public void drawPulseWaveform() {
    // DRAW THE PULSE WAVEFORM
    // prepare pulse data points
    strokeWeight(width/60);
    rawY[rawY.length-1] = (1023 - sensor)-height/3;   // place the new raw datapoint at the end of the array
    float zoom = 0.5;                      // get current waveform scale value
    float offset = map(zoom, 0.5, 1, 150, 0);                // calculate the offset needed at this scale
    for (int i = 0; i < rawY.length-1; i++) {      // move the pulse waveform by
      rawY[i] = rawY[i+1];                         // shifting all raw datapoints one pixel left
      float dummy = rawY[i] * zoom + offset;       // adjust the raw data to the selected scale
      scaledY[i] = constrain(int(dummy), ws, height-ws);   // transfer the raw data array to the scaled array
    }
    noFill();
    stroke(wave);             
    beginShape();  //using beginShape() renders fast
    for (int x = 0; x < scaledY.length-1; x++) {
      float xPos=map(x, 0, width/xZoom, ws, width-ws);
      xPos=constrain(xPos, ws, width-ws);
      vertex(xPos, scaledY[x]-ws);                    //draw a line connecting the data points
    }
    endShape();
  }
}
