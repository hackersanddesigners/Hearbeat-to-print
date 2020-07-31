import controlP5.*;
import processing.pdf.*;
import processing.sound.*;
import processing.serial.*; 


// PULSE TYPE PROTOTYPE
// FOR HACKERS AND DESIGNERS
// PRESS SPACE TO PROGRESS THROUGH WORDS
// KEEP SPACE PRESSED WHILE SPEAKING A WORD TO REGISTER VOLUME & BPM OF CURRENT WORD
// WALKIE TALKIE STYLE
// VOLUME INFLUENCES FONT SIZE
// BPM CHANGE INFLUENCES SELECTED FONT 
// CODE: JONAS BO

// PRESS R FOR NEW RANDOM FONT

int pdfW = 140; // width and height of PDF
int pdfH = 180;
int alignment = CENTER; // default vertical alignment 
int theme = 1;

// L A Y O U T
int ws; // white space
float lineHeight;
int page;
int pageLine = 0;
int seedling = 1234; // random seed to control random processes

String disText = "";
String[] loadedText;
//int[][] wordFont = new int[0][0];
int currentLine=0;
int nextLine=0;
IntList words, wordFontBank, wordFont, wordPage;
FloatList wordVolume, wordWidth, maxLineH, wordX, wordY, wordFontSize;
int wordCount, totalWords=0;
String[] lineWords;
boolean keyDown = false;
int emptyLineCount = 0;
boolean endOfDocument = false;

boolean fontsSwitched = false;


// S E C O N D A R Y  W I N D O W S
SensorWindow sensorWindow;
AudioWindow audioWindow;
ControlWindow controlWindow;
color fore, back, wave;


void settings() {
  //fullScreen();
  size(pdfW*3, pdfH*3);
  // Pulling the display's density dynamically
  pixelDensity(displayDensity());
}

void setup() {
  surface.setLocation(displayWidth/2-width/2, displayHeight/2-height/2);
  textAlign(LEFT, alignment); 
  ws=width/10;

  // Font Sizes
  minFont = 8;
  maxFont = 24;
  minFontHead = 32;
  maxFontHead = 48;

  words = new IntList();
  wordFontBank = new IntList();
  wordFont = new IntList();
  wordFontSize = new FloatList();
  wordWidth = new FloatList();
  wordVolume = new FloatList();
  maxLineH = new FloatList();
  wordBPM = new FloatList();
  wordPage = new IntList();
  wordX = new FloatList();
  wordY = new FloatList();


  initAudio();
  myFonts = initFonts(fontNames);
  // I N T E R F A C E
  font = myFonts[2];
  textFont(font);
  rectMode(CENTER);
  ellipseMode(CENTER);

  // Fonts and files getting loaded after folder is selected
  selectFolder("Select main folder.", "mainFolder");
  //loadFile(sketchPath()+"/_texts/eurico.txt"); // load static file

  // initPDF();

  // GO FIND THE ARDUINO
  fill(0);
  textSize(width/30);
  text("Please select port of connected Arduino", ws, 30);
  text("or press 'a' to skip.", ws, 30+width/30);
  listAvailablePorts();

   if (theme == 1) {
      fore = color (255);
      back = color (0);
      wave = color (255, 255, 0);
    }

  // sensor & audio application window
  sensorWindow = new SensorWindow();
  audioWindow = new AudioWindow();
  controlWindow = new ControlWindow();

  soundfile = new SoundFile(this, "vibraphon.wav");
}


void draw() {
  if (textLoaded) {
    if (serialPortFound) {
      colorMode(HSB, 360, 100, 100);
      randomSeed(seedling); 
      //background(random(359), 60, 70); 
      background(360);
      //background(mapPulse(0, 359));
      maxLineH = new FloatList();
      int word=0;
      page = 0;
      int currentWord=0;
      nextLine = -1;
      pageLine = -1;
      int startPageLine = 0;
      emptyLineCount = 0;
      textAlign(LEFT, alignment);


      //println();
      // currentLine == index of file lines, pageLine == index of lines on page
      for (int line = 0; line <= currentLine; line++) { // step through lines until current one
        pageLine++;
        currentWord++;
        //println(line);
        lineWords = loadedText[line].split(" "); 
        float textSpace = 0; 
        maxLineH.set(pageLine, lineHeight); // set default line height 

        // Detecting empty lines
        if (words.get(line) < 2) emptyLineCount++;  
        if (emptyLineCount > 3 && !fontsSwitched) {
          //switchFonts();
        }

        for (word=0; word < words.get(line); word++) { // step through words of lines
          try {
            // compare word bpms and switch font if changed
            if (currentWord > 1 && wordVolAnalysed[currentWord]) {
              float diff = abs(wordBPM.get(currentWord) - wordBPM.get(currentWord-1));
              if (diff > BPMthreshold && diff < 10 && !bpmSwitched[currentWord]) {
                println("bpm switch: " + diff);
                println(currentWord, wordBPM.get(currentWord), wordBPM.get(currentWord-1));
                switchFont();
                bpmSwitched[currentWord] = true;
              }
            }
            // get font index from int list and set as font
            if (wordFontBank.get(currentWord) < 2) myFont = bodyFonts[wordFont.get(currentWord)];
            else myFont = headFonts[wordFont.get(currentWord)];
            textFont(myFont);

            // starting with this font size
            float s = width/30;
            textSize(s);
            lineHeight = s;
            wordFontSize.set(currentWord, s);

            // map recorded volume to text size and line height after analysis finished
            if (wordVolAnalysed[currentWord]) {
              if (wordFontBank.get(currentWord) == 2) {
                s = map(wordVolume.get(currentWord), minMax[0], minMax[1], minFontHead, maxFontHead);
                s = constrain(s, minFontHead, maxFontHead);
              } else if (wordFontBank.get(currentWord) == 1) {
                s = map(wordVolume.get(currentWord), minMax[0], minMax[1], minFont, maxFont);
                s = constrain(s, minFont, maxFont);
              } else if (wordFontBank.get(currentWord) == 0) {
                s = map(wordVolume.get(currentWord), minMax[0], minMax[1], minFontFoot, maxFontFoot);
                s = constrain(s, minFontFoot, maxFontFoot);
              }

              if (s > 0.0) {
                textSize(s);
                wordFontSize.set(currentWord, s);
                lineHeight = s;
                // save lineHeight if greater than previously recorded
                if (lineHeight > maxLineH.get(pageLine)) maxLineH.set(pageLine, lineHeight);
              }
            }
            //volumeToSize(currentWord, line);

            // check if have to move to next line
            if (textSpace + textWidth(lineWords[word]) + textWidth(" ") > width-2*ws) {
              // println("next line"); 
              pageLine++;
              textSpace = 0;
              maxLineH.set(pageLine, lineHeight);
            }

            //fill(random(359), 100, 70); 
            fill(0); // Set text color based on pulse 

            // THIS IS WHERE POSITION OF WORDS ARE CALCULATED
            float xPos = ws+textSpace;
            float yPos = ws;
            //if (pageLine+nextLine > 1) yPos = ws + (pageLine+nextLine * maxLineH.get(pageLine+nextLine-1));
            // calculate y position
            for (int l=startPageLine; l < pageLine; l++) {
              yPos+=maxLineH.get(l);
            }

            wordX.set(currentWord, xPos);
            wordY.set(currentWord, yPos);

            // check if we have to move to next page
            if (yPos > height-ws-s) {
              // println("next page please");
              if (beganPDF) writePDF(page);
              background(360);
              nextLine = 0;
              textSpace = 0;
              yPos = ws;
              xPos = ws;
              // if (page > writtenPages) saveFrame("####-test.jpg"); // for debugging
              wordX.set(currentWord, xPos);
              wordY.set(currentWord, yPos);
              startPageLine = pageLine;
              page++;
            } 
            wordPage.set(currentWord, page);

            if (wordPage.get(currentWord) == page && word < lineWords.length) {
              text(lineWords[word], xPos, yPos);
              textSpace = textSpace + textWidth(lineWords[word]) + textWidth(" ");
            }

            if (beganPDF) writePDF(page);
            currentWord++;
          } 
          catch (ArrayIndexOutOfBoundsException e) {
           // println(e);
           // println("end of document!");
            endOfDocument = true;
            //pageLine--;
          }
          // println(pageLine + " lH: " + maxLineH.get(pageLine) + " page: " + page + " " + lineWords[word]);
        } // end words
      } // end lines

      if (beganPDF) endPDF(99);
      //println(currentWord, wordCount);
      //writePDF = false;
      //noLoop();
      volume = loudness.analyze();
      analyseVolumeBPM();
      //wordVolume.set(wordCount, avgVol);
    } else { // SCAN BUTTONS TO FIND THE SERIAL PORT

      autoScanPorts();

      if (refreshPorts) {
        refreshPorts = false;
        drawDataWindows();
        listAvailablePorts();
      }

      for (int i=0; i<numPorts+1; i++) {
        button[i].overRadio(mouseX, mouseY);
        button[i].displayRadio();
      }

      ////  DO THE SCROLLBAR THINGS
      //scaleBar.update (mouseX, mouseY);
      //scaleBar.display();
    }
  }
}


void nextWord() {
  if (textLoaded && serialPortFound && !endOfDocument) {
    if (currentLine <= loadedText.length) {
      int currentWord = words.get(currentLine); 
      currentWord++; 

      // if  currentWord greater than words in currentLine
      if (currentWord > loadedText[currentLine].split(" ").length && currentLine < loadedText.length-1) {  
        currentWord=0; 
        currentLine++;
        wordCount++;
        println("new line as in file.");
        // pageLine++;
      } else wordCount++;          
      words.set(currentLine, currentWord); 
      wordFontBank.set(wordCount, fontBank);
      wordFont.set(wordCount, fontSelection);
      wordVolume.set(wordCount, 0);
      wordBPM.set(wordCount, 0);
      wordWidth.set(wordCount, 0);
      //println("line: " + currentLine); 
      //println("pageLine: " + currentLine+nextLine); 
      //println("words: " + words.get(currentLine));

      //// Detecting empty lines
      //if (words.get(currentLine) < 2) emptyLineCount++;  
      //else emptyLineCount = 0;
      //if (emptyLineCount > 3) {
      //  println("Switching fonts!");
      //  initFonts(bodyFNames);
      //}
    } else println("please select serial port to continue.");
  } else if (endOfDocument) soundfile.play();
}
