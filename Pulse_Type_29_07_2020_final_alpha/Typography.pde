// F O N T S  &  T Y P O
String[] fontNames = {"CirrusCumulus", "Coconat", "Compagnon", "Halibut Serif", 
  "kaeru kaeru", "Ortica", "Ovo", "Pilowlava", "Typefesse", "Zarathustra"};
String[] bodyFNames={}, headFNames={};
PFont myFont;
PFont[] myFonts = new PFont[fontNames.length];
PFont[] headFonts, bodyFonts, footFonts;
int fontSelection = 0, fontBank = 0;
int minFont, maxFont, minFontHead, maxFontHead, minFontFoot, maxFontFoot;
//boolean headFont = true;

//called when switching fonts
PFont[] initFonts(String[] fontNames) {
  PFont[] tempFonts = new PFont[fontNames.length];
  int fontSize = width/40;
  lineHeight = fontSize;
  // load fonts
  for (int i=0; i<fontNames.length; i++) {
    println("Loading font: " +fontNames[i]);
    String[] temp = split(fontNames[i], ".");
    fontNames[i] = temp[0];
    //fontNames[i] = temp[0];
    tempFonts[i] = createFont(fontNames[i], fontSize);
  }
  println();
  //randomFont(fontNames.length);
  return tempFonts;
}

void switchFontBank(int bank) {
  int tempRandom=0;
  if (bank > 2) { // for font switching with key
    fontBank++;
    if (fontBank>=3) fontBank=0;
  } else fontBank = bank;
  println(fontBank);
  //seedling = int(random(99999999)); 
  //randomSeed(seedling);
  if (fontBank==1 || fontBank==0) {
    println("Switching to foot/body fonts!");
    randomSeed(int(random(millis())));
    tempRandom = int(random(bodyFonts.length));
    println("Selected font: " + bodyFNames[tempRandom]);
  } else if (fontBank==2) {
    println("Switching to head fonts!");
    randomSeed(int(random(millis())));
    tempRandom = int(random(headFonts.length));
    println("Selected font: " + headFNames[tempRandom]);
  }
  //fontsSwitched = true;
  //emptyLineCount = 0;
  //if (headFont) initFonts(bodyFNames);
  //else initFonts(headFNames);
  // 1 = headfont, 0 = bodyfont
  wordFontBank.set(wordCount, fontBank);
  wordFont.set(wordCount, tempRandom);
}

void switchFont() {
  //seedling = int(random(99999999)); 
  int tempRandom = wordFont.get(wordCount);
  // make sure we get a different font than currently selected
  if (wordFontBank.get(wordCount) == 2) {
    println("head fonts.");
    //printArray(headFonts);
    while (wordFont.get(wordCount) == tempRandom) {
      randomSeed(int(random(millis())));
      tempRandom = int(random(headFonts.length));
    }
  } else {
    //printArray(bodyFonts);
    while (wordFont.get(wordCount) == tempRandom) {
      //  println(tempRandom);
      randomSeed(int(random(millis())));
      tempRandom = int(random(bodyFonts.length));
    }
  }
  fontSelection = tempRandom;
  println("new font: " + fontSelection);  
  wordFont.set(wordCount, fontSelection);  
  loop();
}

void nextFont() {
  //linePos++;
  //fontSelection++; 
  //if (fontSelection == fontNames.length) fontSelection=0; 
  fontSelection++;
  if (fontSelection >= fontNames.length) fontSelection=0; 
  //String selectedF = fontNames[fontSelection]; // select new font
  wordFont.set(wordCount, fontSelection);
  //println("Selected Font: " + selectedF); 
  //disText = selectedF + "\nAÄBCDEFGHIJKLMOÖ\n!@#$%";
  loop();
}


void volumeToSize(int currentWord, int line) {
  float s = map(wordVolume.get(currentWord+line), minMax[0], minMax[1], minFont, maxFont);
  if (s > 0.0) {
    textSize(s);
    lineHeight = s;
    if (lineHeight > maxLineH.get(line)) maxLineH.set(line, lineHeight);
  }
}

void volumeToFont(int currentWord, int line) {
  int f = int(map(wordVolume.get(currentWord+line), minMax[0], minMax[1], 0, fontNames.length-1));
  f = constrain(f, 0, fontNames.length-1);
  if (f >= 0) {
    wordFont.set(currentWord+line, f);
    myFont = myFonts[wordFont.get(currentWord+line)];
    textFont(myFont);
  }
}
