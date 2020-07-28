// P U L S E
int sensor;      // HOLDS PULSE SENSOR DATA FROM ARDUINO
int IBI;         // HOLDS TIME BETWEN HEARTBEATS FROM ARDUINO
int BPM;         // HOLDS HEART RATE VALUE FROM ARDUINO
float BPMthreshold;


boolean beat = false;    // set when a heart beat is detected, then cleared when the BPM graph is advanced
int heart = 0;   // This variable times the heart image 'pulse' on screen

// for sensor calibration
int sensorMin = 1023;
int sensorMax = 0;
int waitTime = 3000;
long startTime =0;

// analysis
float prevBPM = 0;
float avgBPM = 0;
FloatList wordBPM;

float mapPulse (int minOut, int maxOut) {
  int sensorValue = sensor;

  if (millis() - startTime < waitTime) {
    // record the maximum sensor value
    if (sensorValue > sensorMax) {
      sensorMax = sensorValue;
    }
    // record the minimum sensor value
    if (sensorValue < sensorMin) {
      sensorMin = sensorValue;
    }
  } else {  // reset rangefinder
    // println(sensorMin, sensorMax);
    sensorMin = 1023;
    sensorMax = 0;
    waitTime = 3000;
    startTime = millis();
  }

  return(map(sensor, sensorMin, sensorMax+1, minOut, maxOut));
}
