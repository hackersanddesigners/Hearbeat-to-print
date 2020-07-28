ControlP5 cp5;

class ControlWindow extends PApplet {
  //JFrame frame;

  public ControlWindow() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  int w;
  color activeC, defaultC;


  public void settings() {
    size(int(pdfW*1.5), 400);
    pixelDensity(displayDensity());
  }
  public void setup() { 
    surface.setTitle("Settings");
    surface.setLocation(displayWidth/2-width/2, displayHeight-height-20);
    surface.setResizable(true);
    scaledWaveY = new float[width];       // initialize scaled pulse waveform array
    waveY = new float[width];          // initialize raw pulse waveform array
    cp5 = new ControlP5(this); 

    activeC = color(26, 88, 211);
    defaultC = color(9, 27, 72);


    int fontBWidth = 100;
    int fontBHeight = 40;

    cp5.addButton("head")
      .setPosition(width/2-ws/2-fontBWidth, ws/2)
      .setSize(fontBWidth/3, fontBHeight)
      .setId(1)
      ;

    cp5.addButton("body")
      .setPosition(width/2-ws/2-fontBWidth+fontBHeight, ws/2)
      .setSize(fontBWidth/3, fontBHeight)
      .setId(2)
      ;

    cp5.addButton("foot")
      .setPosition(width/2-ws/2-fontBWidth+fontBHeight*2, ws/2)
      .setSize(fontBWidth/3, fontBHeight)
      .setId(3)
      ;

    cp5.addNumberbox("min font head")
      .setSize(fontBWidth, fontBHeight/2)
      .setPosition(width/2-ws/2-fontBWidth, ws+fontBHeight)
      .setScrollSensitivity(-1.1)
      .setDirection(Controller.HORIZONTAL) // change the control direction to left/right
      .setMin(1)
      .setId(4)
      .setValue(minFontHead)
      ;

    cp5.addNumberbox("max font head")
      .setSize(fontBWidth, fontBHeight/2)
      .setPosition(width/2+ws/2, ws+fontBHeight)
      .setScrollSensitivity(1.1)
      .setDirection(Controller.HORIZONTAL) // change the control direction to left/right
      .setMin(1)
      .setId(5)
      .setValue(maxFontHead)
      ;

    cp5.addNumberbox("min font body")
      .setSize(fontBWidth, fontBHeight/2)
      .setPosition(width/2-ws/2-fontBWidth, (ws+fontBHeight*2))
      .setScrollSensitivity(-1.1)
      .setDirection(Controller.HORIZONTAL) // change the control direction to left/right
      .setMin(1)
      .setId(6)
      .setValue(minFont)
      ;

    cp5.addNumberbox("max font body")
      .setSize(fontBWidth, fontBHeight/2)
      .setPosition(width/2+ws/2, (ws+fontBHeight*2))
      .setScrollSensitivity(1.1)
      .setDirection(Controller.HORIZONTAL) // change the control direction to left/right
      .setMin(1)
      .setId(7)
      .setValue(maxFont)
      ;

    cp5.addNumberbox("min font foot")
      .setSize(fontBWidth, fontBHeight/2)
      .setPosition(width/2-ws/2-fontBWidth, (ws+fontBHeight*3))
      .setScrollSensitivity(-1.1)
      .setDirection(Controller.HORIZONTAL) // change the control direction to left/right
      .setMin(1)
      .setId(8)
      .setValue(minFont)
      ;

    cp5.addNumberbox("max font foot")
      .setSize(fontBWidth, fontBHeight/2)
      .setPosition(width/2+ws/2, (ws+fontBHeight*3))
      .setScrollSensitivity(1.1)
      .setDirection(Controller.HORIZONTAL) // change the control direction to left/right
      .setMin(1)
      .setId(9)
      .setValue(maxFont)
      ;


    cp5.addSlider("BPM difference")
      .setSize(fontBWidth, fontBHeight/2)
      .setPosition(width/2-ws/2-fontBWidth, ws+fontBHeight*4)
      .setScrollSensitivity(1.1)
      .setRange(0.1, 10)
      .setMin(0.1)
      .setId(10)
      .setValue(1);
    ;

    cp5.addButton("save PDF")
      .setPosition(width/2+ws/2, ws+fontBHeight*5)
      .setSize(fontBWidth, fontBHeight)
      .setId(11)
      ;
  }

  public void draw() {
    // background with alpha
    background(155);
  }

  void controlEvent(ControlEvent theEvent) {
    println("got a control event from controller with id "+theEvent.getController().getId());

    switch(theEvent.getController().getId()) {
      case(1):
      switchFontBank(2);
      break;
      case(2):
      switchFontBank(1);
      break;
      case(3):
      switchFontBank(0);
      break;

      case(4):
      minFontHead = int(theEvent.getController().getValue());
      break;
      case(5):
      maxFontHead = int(theEvent.getController().getValue());
      break;
      case(6):
      minFont = int(theEvent.getController().getValue());
      break;
      case(7):
      maxFont = int(theEvent.getController().getValue());
      break;
      case(8):
      minFontFoot = int(theEvent.getController().getValue());
      break;
      case(9):
      maxFontFoot = int(theEvent.getController().getValue());
      break;
      case(10):
      BPMthreshold = theEvent.getController().getValue();
      println("BPM threshold set to: "+BPMthreshold);
      break;
      case(11):
      initPDF();
      break;
    }
  }
}
