// PDF
boolean writePDF = true;
PGraphicsPDF pdf;
boolean beganPDF = false;
// IntList wordPDF;
boolean[] wordPDF;

int writtenPages = -1;


void initPDF() {
  String pdfName = "output-" + random(999999) + ".pdf";
  pdf = (PGraphicsPDF) createGraphics(width, height, PDF, pdfName);
  pdf.beginDraw();
  pdf.textMode(SHAPE);
  pdf.textAlign(LEFT, CENTER);
  beganPDF = true;
  println();
  //println("PDF file created.");
}

void endPDF() {
  if (beganPDF) {
    pdf.dispose();
    pdf.endDraw();
    beganPDF = false;
    println("PDF file written to disk.");
  }
}

void writePDF(int page, int startPageLine) {
  // also check if page has not been already written to pdf
  if (beganPDF && page > writtenPages) {
    int currentWord = 0;
    int pageLine = startPageLine-1;

    for (int line = 0; line <= currentLine; line++) { // step through lines until current one
      pageLine++;
      float textSpace = 0;  // reset x position
      String[] lineWords = loadedText[line].split(" "); 
      //maxLineH.get(nextLine);
      for (int word=0; word < words.get(line); word++) { // step through words of lines
        currentWord++;
        try {
          // get font index from int list and set as font
          if (wordFontBank.get(currentWord) == 1) myFont = headFonts[wordFont.get(currentWord)];
          else myFont = bodyFonts[wordFont.get(currentWord)];
          pdf.textFont(myFont);
          pdf.textAlign(LEFT, CENTER);
          float s = map(wordVolume.get(currentWord), minMax[0], minMax[1], minFont, maxFont);
          s = constrain(s, minFont, maxFont)/displayDensity();
          println("PDF TEXT SIZE: " + s + " " + lineWords[word]);
          pdf.fill(0);
          //pdf.textFont(myFont);
          pdf.textSize(s);

          // check if have to move to next line
          if (textSpace + (textWidth(lineWords[word]) + textWidth(" "))/displayDensity() > width-2*ws) {
            println("next line"); 
            pageLine++;
            textSpace = 0;
            maxLineH.set(pageLine, lineHeight);
          }

          float xPos=wordX.get(currentWord)/displayDensity();
          float yPos=wordY.get(currentWord)/displayDensity();
          // calculate y position
          //for (int l=startPageLine; l < pageLine; l++) {
          //  yPos+=maxLineH.get(l);
          //}
          //println("y: " +yPos);
          if (wordPage.get(currentWord) == page) {
            pdf.text(lineWords[word], xPos, yPos);
            textSpace = textSpace + ((textWidth(lineWords[word]) + textWidth(" "))/displayDensity());
          }
        } 
        catch (ArrayIndexOutOfBoundsException e) {
          e.printStackTrace();
        }
      } // end words
    }  // end PDF    
    pdf.nextPage();
    writtenPages++;
  }
}
