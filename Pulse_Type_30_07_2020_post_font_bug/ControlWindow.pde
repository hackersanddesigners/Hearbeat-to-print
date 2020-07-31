ControlP5 cp5;

class ControlWindow extends PApplet {
  //JFrame frame;

  public ControlWindow() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  int w;
  CColor uiCol = new CColor(); 


  public void settings() {
    size(int(pdfW*1.5), 400+ws/2);
    pixelDensity(displayDensity());
  }
  public void setup() { 
    surface.setTitle("Settings");
    surface.setLocation(0, displayHeight-height-20);

    cp5 = new ControlP5(this); 

    uiCol.setActive(color(0, 0, 255));
    uiCol.setBackground(color(0));
    uiCol.setForeground(color(0, 0, 255));
    uiCol.setCaptionLabel(color(0, 0, 255));
    uiCol.setValueLabel(color(255, 255, 0));


    int fontBWidth = 100;
    int fontBHeight = 40;

    ButtonBar b = cp5.addButtonBar("fontBar")
      .setPosition(width/2-ws/2-fontBWidth, ws/2)
      .setSize(fontBWidth*2+ws, fontBHeight)
      .addItems(split("a b c", " "))
      ;
    println(b.getItem("a"));
    b.changeItem("a", "text", "head");
    b.changeItem("b", "text", "body");
    b.changeItem("c", "text", "foot");
    b.setColor(uiCol);

    cp5.addNumberbox("min font head")
      .setSize(fontBWidth, fontBHeight/2)
      .setPosition(width/2-ws/2-fontBWidth, ws+fontBHeight)
      .setScrollSensitivity(-1.1)
      .setDirection(Controller.HORIZONTAL) // change the control direction to left/right
      .setMin(1)
      .setColor(uiCol)
      .setValue(minFontHead)
      .setId(4)
      ;

    cp5.addNumberbox("max font head")
      .setSize(fontBWidth, fontBHeight/2)
      .setPosition(width/2+ws/2, ws+fontBHeight)
      .setScrollSensitivity(1.1)
      .setDirection(Controller.HORIZONTAL) // change the control direction to left/right
      .setMin(1)
      .setColor(uiCol)
      .setId(5)
      .setValue(maxFontHead)
      ;

    cp5.addNumberbox("min font body")
      .setSize(fontBWidth, fontBHeight/2)
      .setPosition(width/2-ws/2-fontBWidth, (ws+fontBHeight*2))
      .setScrollSensitivity(-1.1)
      .setDirection(Controller.HORIZONTAL) // change the control direction to left/right
      .setMin(1)
      .setColor(uiCol)
      .setId(6)
      .setValue(minFont)
      ;

    cp5.addNumberbox("max font body")
      .setSize(fontBWidth, fontBHeight/2)
      .setPosition(width/2+ws/2, (ws+fontBHeight*2))
      .setScrollSensitivity(1.1)
      .setDirection(Controller.HORIZONTAL) // change the control direction to left/right
      .setMin(1)
      .setColor(uiCol)
      .setId(7)
      .setValue(maxFont)
      ;

    cp5.addNumberbox("min font foot")
      .setSize(fontBWidth, fontBHeight/2)
      .setPosition(width/2-ws/2-fontBWidth, (ws+fontBHeight*3))
      .setScrollSensitivity(-1.1)
      .setDirection(Controller.HORIZONTAL) // change the control direction to left/right
      .setMin(1)
      .setColor(uiCol)
      .setId(8)
      .setValue(minFont)
      ;

    cp5.addNumberbox("max font foot")
      .setSize(fontBWidth, fontBHeight/2)
      .setPosition(width/2+ws/2, (ws+fontBHeight*3))
      .setScrollSensitivity(1.1)
      .setDirection(Controller.HORIZONTAL) // change the control direction to left/right
      .setMin(1)
      .setColor(uiCol)
      .setId(9)
      .setValue(maxFont)
      ;

    ButtonBar b2 = cp5.addButtonBar("alignmentBar")
      .setPosition(width/2-ws/2-fontBWidth, ws+fontBHeight*4.5)
      .setSize(fontBWidth*2+ws, fontBHeight)
      .addItems(split("a b c d", " "))
      ;
    b2.changeItem("a", "text", "base");
    b2.changeItem("b", "text", "center");
    b2.changeItem("c", "text", "bottom");
    b2.changeItem("d", "text", "top");
    b2.setValueSelf(1);
    b2.setColor(uiCol);


    cp5.addSlider("BPM difference")
      .setSize(fontBWidth+ws, fontBHeight)
      .setPosition(width/2-ws/2-fontBWidth, ws+fontBHeight*6)
      .setScrollSensitivity(1.1)
      .setRange(0.1, 10)
      .setMin(0.1)
      .setColor(uiCol)
      .setId(10)
      .setValue(1);
    ;


    cp5.addButton("save PDF")
      .setPosition(width/2+ws/2, ws+fontBHeight*7.5)
      .setSize(fontBWidth, fontBHeight)
      .setColor(uiCol)
      .setColorLabel(color(255, 255, 0))
      .setId(11)
      ;
  }

  public void draw() {
    // background with alpha
    background(200);
  }
  
   void fontBar(int n) {
    //println("bar clicked, item-value:", n);
    switch(n) {
      case(0):
      switchFontBank(2);
      break;
      case(1):
      switchFontBank(1);
      break;
      case(2):
      switchFontBank(0);
      break;
    }
  }

  void alignmentBar(int n) {
    //println("bar clicked, item-value:", n);
    switch(n) {
      case(0):
      alignment=BASELINE;
      break;
      case(1):
      alignment=CENTER;
      break;
      case(2):
      alignment=BOTTOM;
      break;
      case(3):
      alignment=TOP;
      break;
    }
  }


  void controlEvent(ControlEvent theEvent) {
   // println("got a control event from controller with id "+theEvent.getController().getId());

    switch(theEvent.getController().getId()) {
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
      //println("BPM threshold set to: "+BPMthreshold);
      break;
      case(11):
      initPDF();
      break;
    }
  }
}
