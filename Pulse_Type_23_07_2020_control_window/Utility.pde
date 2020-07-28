// SELECTING FOLDERS AND LOADING FILES

boolean fontsLoaded = false;
boolean textLoaded = false;

void mainFolder(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath()); 
    println();
    
    // loading fonts from folder
    headFNames = loadFontNames(selection.getAbsolutePath(), "head");
    println("Available head fonts:");
    printArray(headFNames); println();
    headFonts = initFonts(headFNames);
    bodyFNames = loadFontNames(selection.getAbsolutePath(), "body");
    println("Available body fonts:");
    printArray(bodyFNames); println();
    bodyFonts = initFonts(bodyFNames); 
    
    loadText(selection.getAbsolutePath());
    
    println("Switching to head fonts:");
    initFonts(headFNames);
  }
  // selectInput("Select text file.", "loadFile");
}



void loadText(String path) {
  //println("Listing all filenames in a directory: ");
  String[] filenames = listFileNames(path);
  // printArray(filenames);
  File[] files = listFiles(path);
  for (int i = 0; i < files.length; i++) {
    File f = files[i];    
    if (!f.isDirectory() && f.getName().equals(".DS_Store") == false) {
      println("Text file " + f.getName() + " loaded.");
      loadFile(f);
      break;
    }
  }
}


void loadFile(File selection) {
  println("U selected " + selection.getAbsolutePath()); 
  String [] lines = loadStrings(selection.getAbsolutePath()); 
  loadedText = lines; 
  println("There are " + lines.length + " lines"); 
  for (int i = 0; i < lines.length; i++) {
    words.append(0);
    totalWords+=loadedText[i].split(" ").length;
  }
  println("There are " + totalWords + " words in total."); println();
  wordPDF = new boolean[totalWords];
  wordVolAnalysed = new boolean[totalWords*3];
  bpmSwitched = new boolean[totalWords*3];
  textLoaded=true;
}

String[] loadFontNames(String rootPath, String subPath) {
  String fontPath = rootPath+"/" +subPath;
  File directoryPath = new File(fontPath);
  String contents[] = directoryPath.list();
  //PFont[] loadedFonts = new PFont[contents.length];
  //println("Loading " + contents.length + " fonts for "+ subPath + ": ");
  //for (int i=0; i<contents.length; i++) {
  //  loadedFonts[i] = createFont(fontPath+"/"+contents[i], 48);
  //  println("Loaded font " + contents[i]);
  //}
  //println();
  return contents;
}


PFont[] loadFonts(String rootPath, String subPath) {
  String fontPath = rootPath+"/" +subPath;
  File directoryPath = new File(fontPath);
  String contents[] = directoryPath.list();
  PFont[] loadedFonts = new PFont[contents.length];
  println("Loading " + contents.length + " fonts for "+ subPath + ": ");
  for (int i=0; i<contents.length; i++) {
    loadedFonts[i] = createFont(fontPath+"/"+contents[i], 48);
    println("Loaded font " + contents[i]);
  }
  println();
  return loadedFonts;
}




// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}

// This function returns all the files in a directory as an array of File objects
// This is useful if you want more info about the file
File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}
