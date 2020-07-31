// PDF
boolean writePDF = true;
PGraphicsPDF pdf;
boolean beganPDF = false;
boolean pdfFinished = false;
// IntList wordPDF;
boolean[] wordPDF;

PFont pdfFont;

int writtenPages = -1;

void initPDF() {
  if (!beganPDF) {
    String pdfName = sketchPath() + "/pdfs/" + projectName +"_" + timestamp() + ".pdf";
    pdf = (PGraphicsPDF) createGraphics(width, height, PDF, pdfName);
    pdf.beginDraw();
    //pdf.textMode(SHAPE);
    pdf.textAlign(LEFT, CENTER);
    beganPDF = true;
    println();
    println("PDF file created.");
    println(pdfName);
   // page = 0; // reset page counter 
  }
}

void endPDF(int page) {
  if (beganPDF) {
    if (page==0) writePDF(0);
    pdf.dispose();
    pdf.endDraw();
    beganPDF = false;
    writtenPages = -1;
    println("PDF file written to disk.");
  }
}

void writePDF(int page) {
 // pdfFont = myFont; // just initializing
  // also check if page has not been already written to pdf
  if (beganPDF && page > writtenPages) {
    println("pdf page: " + page);
    int currentWord = 0;
    for (int line = 0; line <= currentLine; line++) { // step through lines until current one
      currentWord++;
      String[] lineWords = loadedText[line].split(" "); 
      //maxLineH.get(nextLine);
      for (int word=0; word < words.get(line); word++) { // step through words of lines
        try {
          if (wordPage.get(currentWord) == page) {
            // check if head or body font
            if (wordFontBank.get(currentWord) == 2) {
              pdfFont = headFonts[wordFont.get(currentWord)];
            } else if (wordFontBank.get(currentWord) == 1) {
              pdfFont = bodyFonts[wordFont.get(currentWord)];
            } else {
              pdfFont = bodyFonts[wordFont.get(currentWord)];
            }
            pdf.textFont(pdfFont);
            pdf.textAlign(LEFT, alignment);
            //float s = map(wordVolume.get(currentWord), minMax[0], minMax[1], minF, maxF);
            //s = constrain(s, minF, maxF);
            float pdfFontSize = wordFontSize.get(currentWord);
            println("PDF TEXT SIZE: " + pdfFontSize + " " + lineWords[word]);
            pdf.textSize(pdfFontSize/displayDensity());
            pdf.fill(0);
            //pdf.textFont(myFont);

            float xPos=wordX.get(currentWord)/displayDensity();
            float yPos=wordY.get(currentWord)/displayDensity();
            pdf.text(lineWords[word], xPos, yPos);
          }
            currentWord++;
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
