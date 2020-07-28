ControlP5 cp5;

class ControlWindow extends PApplet {
  //JFrame frame;

  public ControlWindow() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  int w;

  public void settings() {
    size(pdfW*3, 200);
    pixelDensity(displayDensity());
  }
  public void setup() { 
    surface.setTitle("Settings");
    surface.setLocation(displayWidth/2-width/2, displayHeight-height-20);
    surface.setResizable(true);
    scaledWaveY = new float[width];       // initialize scaled pulse waveform array
    waveY = new float[width];          // initialize raw pulse waveform array
    cp5 = new ControlP5(this); 

    // create a new button with name 'buttonA'
    //cp5.addButton("savePDF")
    //  .setValue(0)
    //  .setPosition(100, 100)
    //  .setSize(200, 19)
    //  ;
    int fontBWidth = 100;
    int fontBHeight = 40;
    // and add another 2 buttons
    cp5.addButton("switch fonts")
      .setPosition(width/2-ws/2-fontBWidth, ws/2)
      .setSize(fontBWidth, fontBHeight)
      .setId(1)
      ;

    cp5.addButton("save PDF")
      .setPosition(width/2+ws/2, ws/2)
      .setSize(fontBWidth, fontBHeight)
      .setId(2)
      ;

    cp5.addNumberbox("min font size")
      .setSize(fontBWidth, fontBHeight/2)
      .setPosition(width/2-ws/2-fontBWidth, ws+fontBHeight)
      .setScrollSensitivity(-1.1)
      .setDirection(Controller.HORIZONTAL) // change the control direction to left/right
      .setMin(1)
      .setId(3)
      .setValue(minFont)
      ;

    cp5.addNumberbox("max font size")
      .setSize(fontBWidth, fontBHeight/2)
      .setPosition(width/2+ws/2, ws+fontBHeight)
      .setScrollSensitivity(1.1)
      .setDirection(Controller.HORIZONTAL) // change the control direction to left/right
      .setMin(1)
      .setId(4)
      .setValue(maxFont)
      ;

    cp5.addSlider("BPM difference")
      .setSize(fontBWidth*2+ws, fontBHeight/2)
      .setPosition(width/2-ws/2-fontBWidth, ws+fontBHeight+ws)
      .setScrollSensitivity(1.1)
      .setRange(0.1, 10)
      .setMin(0.1)
      .setId(5)
      .setValue(1);
    ;
  }

  public void draw() {
    // background with alpha
    fill(255, 10);
  }

  public void PDF() {
    endPDF();
  }

  void controlEvent(ControlEvent theEvent) {
    println("got a control event from controller with id "+theEvent.getController().getId());

    switch(theEvent.getController().getId()) {
      case(1):
      switchFontBank();
        break;
      case(2):
      endPDF();
        break;
      case(3):
      minFont = int(theEvent.getController().getValue());
      break;
      case(4):
      maxFont = int(theEvent.getController().getValue());
      break;
      case(5):
      BPMthreshold = theEvent.getController().getValue();
      println("BPM threshold set to: "+BPMthreshold);
      break;
    }
  }
}
