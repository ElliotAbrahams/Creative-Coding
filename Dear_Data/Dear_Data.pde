Data[] dataList = new Data[5];

String interaction = "";

int SCREEN_HEIGHT = 880;
int SCREEN_LENGTH = 1820;
int BACKGROUND = 250;

void settings() {
  size(SCREEN_LENGTH, SCREEN_HEIGHT);
}

void setup() {
  surface.setLocation(50, 50);
  background(BACKGROUND);
  frameRate(10);
  // load data from CSV into data objects
  convertDataFormat();
  noStroke();
}

void draw() {
  drawWeek();
  checkMouse();
  if (keyPressed) {
    weekInteraction();
  }
}


// load data from csv file into data objects
void convertDataFormat() {
  // load csv
  String[] dataString = loadStrings("Data.csv");
  // split dataString into 2D array
  String[][] dataStringSplit = new String[dataString.length - 2][11];
  for (int i = 2; i < dataString.length; i++) {
    dataStringSplit[i-2] = split(dataString[i], ",");
  }
  // seperate dataString into different days
  // temp used for each day -  [individual task][D]
  ArrayList<String[]> dataStringDaysTemp = new ArrayList<String[]>();
  String[] dataStringDaysList = new String[11];
  int numberOfDays = -1;
  String date = "";
  String day = "";

  for (int i = 0; i < dataStringSplit.length; i++) {
    // next day
    if (dataStringSplit[i][2] == "") {
      numberOfDays++;
      if (numberOfDays != 0) {
        // create object for previous day found
        dataList[numberOfDays-1] = new Data(date, day, dataStringDaysTemp);
      }
      // empty temp array
      dataStringDaysTemp = new ArrayList<String[]>();
      // get day and date
      date = dataStringSplit[i][0];
      day = dataStringSplit[i][1];

      continue;
    }
    // add task data
    dataStringDaysTemp.add(dataStringSplit[i]);
  }
  // add last task data
  dataList[numberOfDays] = new Data(date, day, dataStringDaysTemp);
}
