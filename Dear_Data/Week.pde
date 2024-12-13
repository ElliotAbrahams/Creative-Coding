float rotation = 0.0;

void drawWeek() {

  int SPACING = round(SCREEN_HEIGHT / 9);
  int padX = round(SCREEN_LENGTH * 0.04);

  drawStructure(SPACING, padX);

  drawData(SPACING);

  drawXAxisLabel(SPACING, padX);
}

void drawStructure(int SPACING, int padX) {

  background(BACKGROUND);

  // draw MON - SUN

  String[] daysOfTheWeek = {"MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"};

  int padY = round(SCREEN_HEIGHT * 0.05);
  int TEXT_SIZE = 20;

  fill(80);
  stroke(230);
  strokeWeight(3);
  textSize(TEXT_SIZE);

  line(padX, padY-(0.5 * TEXT_SIZE), SCREEN_LENGTH-padX, padY-(0.5 * TEXT_SIZE));

  for (int day=0; day<7; day++) {
    // draw MON - SUN
    text(daysOfTheWeek[day], padX, padY + SPACING * (day + 0.5));
    // draw seperation lines
    line(padX, padY + (day + 1) * SPACING - 0.5 * TEXT_SIZE, SCREEN_LENGTH - padX, padY + (day + 1) * SPACING - 0.5 * TEXT_SIZE);
  }
}

void drawData(int SPACING) {

  // loop through each day
  for (int dayCount = 0; dayCount < dataList.length; dayCount++) {

    int coordNumber = 0;
    // loop through each task
    for (int taskNumber = 0; taskNumber<dataList[dayCount].getNumberOfTasks(); taskNumber++) {
      // if not last task of day and not a pause and not downtime
      if (taskNumber != dataList[dayCount].getNumberOfTasks() - 1 && !dataList[dayCount].getData(taskNumber)[1].equals("Pause") && ! dataList[dayCount].getData(taskNumber)[1].equals("Downtime")) {
        drawRect(120, -5, SPACING, dataList[dayCount], taskNumber, coordNumber);
        coordNumber += 1;
      }
    }
  }
}

String findMinTime(Data[] data) {
  String maxTime = findMinMaxTime(data, true);
  if (maxTime.substring(2, 6) != "0000") {
    maxTime = str(int(maxTime.substring(0, 2))) + "0000";
  }
  return maxTime;
}

String findMaxTime(Data[] data) {
  String minTime = findMinMaxTime(data, false);
  if (minTime.substring(2, 6) != "0000") {
    minTime = str(int(minTime.substring(0, 2))) + "0000";
  }
  return minTime;
}

String findMinMaxTime(Data[] data, boolean min) {
  int time;
  if (min) {
    time = 235959;
  } else {
    time = 000000;
  }
  // loop through each day
  for (int dayCount = 0; dayCount < data.length; dayCount++) {
    if (min) {
      if (int(data[dayCount].getData(0)[0]) < time) {
        time = int(data[dayCount].getData(0)[0]);
      }
    } else {
      if (int(data[dayCount].getData(data[dayCount].getNumberOfTasks() - 1)[0]) > time) {
        time = int(data[dayCount].getData(data[dayCount].getNumberOfTasks() - 1)[0]);
      }
    }
  }
  return str(time);
}

void drawRect(float padX, int y, int SPACING, Data data, int taskNumber, int coordNumber) {
  String[] taskData = data.getData(taskNumber);

  HashMap<String, Integer> mapTask = new HashMap<String, Integer>();
  if (TimesDied) {
    assignMapTask(mapTask, int(taskData[4]));
  } else {
    // full opacity (255) when times died interaction is false
    assignMapTask(mapTask, 0);
  }

  strokeWeight(10);
  noStroke();

  fill(mapTask.get(taskData[1]));

  int dateNum = int(data.getDate());
  int dayNum = int(data.getDay());
  int YPos = round(SPACING*dayNum);

  float startTime = data.getTimeInSeconds(taskNumber);
  float endTime = data.getTimeInSeconds(taskNumber + 1);

  // find X1Pos (start of task) and X2Pos (end of task)
  int X1Pos = round(map(startTime, Data.TimeInSeconds(findMinTime(dataList)), Data.TimeInSeconds(findMaxTime(dataList)), padX, SCREEN_LENGTH - padX));
  int X2Pos = round(map(endTime, Data.TimeInSeconds(findMinTime(dataList)), Data.TimeInSeconds(findMaxTime(dataList)), padX, SCREEN_LENGTH - padX));
  int XLength = X2Pos - X1Pos;

  // find y length (duration) and y width (productivity)
  float YHeight = float(taskData[2]);
  if (taskData[1] == "Downtime") {
    YHeight = 10;
  }
  int YCenter = y + YPos + round(SPACING * 0.5) + round(SPACING * 0.4);
  int YLength = round(map(YHeight, 0.0, 10.0, 0.0, float(round(SPACING * 0.8))));
  int YTop = round(YCenter - 0.5 * YLength);

  // random movement for creeper explosions
  int randomXMovement = 0;
  int randomYMovement = 0;

  if (CreeperExplosion) {
    if (!taskData[6].equals("0"))
      randomXMovement = int(random(-5 * int(taskData[6]), 5 * int(taskData[6]) + 1));
    randomYMovement = int(random(-5 * int(taskData[6]), 5 * int(taskData[6]) + 1));
  }

  // opacity of border depending on number of other players
  if (OtherPlayers) {
    if (!taskData[7].equals("0"))
      stroke(0, 80 + 80 * int(taskData[7]));
    strokeWeight(5);
  } else {
    noStroke();
  }

  if (TimesSlept) {
    // rotate instance of data if times slept is not zero
    if (!taskData[3].equals("0")) {
      pushMatrix();
      // rotation speed depends on number of times slept
      translate((0.3*padX) + X1Pos + 0.5 * XLength, YTop + 0.5 * YLength);
      rotation = rotation + degrees(0.05 * int(taskData[3]));
      rotate(rotation);
      rectMode(CENTER);
      rect(randomXMovement, randomYMovement, XLength, YLength);
      rectMode(CORNER);
      popMatrix();
    } else {
      rect((0.3*padX) + X1Pos + randomXMovement, YTop + randomYMovement, XLength, YLength);
    }
  } else {
    rect((0.3*padX) + X1Pos + randomXMovement, YTop + randomYMovement, XLength, YLength);
  }

  // add coords to coords array
  String minX = str(int((0.3*padX) + X1Pos + randomXMovement));
  String maxX = str(int(minX) + XLength);
  String minY = str(int(YTop + randomYMovement));
  String maxY = str(int(minY) + YLength);
  String[] coords = {minX, maxX, minY, maxY, taskData[8]};
  data.setCoords(coordNumber, coords);

  // draw lines depending on mobs killed
  if (MobsKilled) {
    int numberOfLines = int(taskData[5]);

    //break if no mobs killed
    if (numberOfLines == 0 || YLength == 0) {
      return;
    }

    int lineYDistance = int((0.5 * YLength) / numberOfLines);
    boolean oddNumberOfLines = numberOfLines % 2 == 1;

    stroke(80);
    strokeWeight(2);

    // if line goes through the middle
    if (oddNumberOfLines) {
      line((0.3*padX) + X1Pos + randomXMovement, YCenter + randomYMovement, (0.3*padX) + X2Pos + randomXMovement, YCenter + randomYMovement);
      numberOfLines -= 1;
    }
    if (numberOfLines != 0) {
      for (int line = numberOfLines; line > 0; line -= 2) {
        int deltaY = (lineYDistance * line);
        deltaY -= 0.5 * lineYDistance;

        line((0.3*padX) + X1Pos + randomXMovement, YCenter + deltaY + randomYMovement, (0.3*padX) + X2Pos + randomXMovement, YCenter + deltaY + randomYMovement);
        line((0.3*padX) + X1Pos + randomXMovement, YCenter - deltaY + randomYMovement, (0.3*padX) + X2Pos + randomXMovement, YCenter - deltaY + randomYMovement);
      }
    }
  }
}


void drawXAxisLabel(int SPACING, int padX) {
  String minTime = findMinTime(dataList);
  String maxTime = findMaxTime(dataList);

  int numberOfHours = ((int(maxTime) - int(minTime)) / 10000) + 1;
  int hourPadX = round(((SCREEN_LENGTH - padX) - padX) / numberOfHours);

  rotate(-0.5 * PI);
  for (int i = 0; i<=numberOfHours; i++) {
    String time = str(int(minTime) + i * 10000);
    // map Xpos of time text
    int XPos = round(map(float(Data.TimeInSeconds(time)), Data.TimeInSeconds(minTime), Data.TimeInSeconds(maxTime), padX + 0.65 * SPACING, SCREEN_LENGTH - padX - 0.3 * SPACING));
    // add ':' to time text
    String text = time.substring(0, 2) + ":" + time.substring(2, 4) + ":" + time.substring(4, 6);
    fill(80);
    text(text, -SCREEN_HEIGHT * 0.92, ( 0.3 * padX + XPos));
  }
  rotate(0.5 * PI);
}

void checkMouse() {

  // loop through each day
  for (Data dayData : dataList) {
    // loop through each task
    for (int coordNumber = 0; coordNumber<dayData.getNumberOfCoords(); coordNumber++) {
      String[] coords = dayData.getCoords(coordNumber);
      if (! coords[0].equals(null)) {
        // if mouse within block
        if (mouseX >= int(coords[0]) && mouseX <= int(coords[1]) && mouseY >= int(coords[2]) && mouseY <= int(coords[3])) {
          if (! coords[4].equals("0")) {
            // show text
            strokeWeight(2);
            text(coords[4], mouseX+10, mouseY-25);
          }
        }
      }
    }
  }
}

void assignMapTask(HashMap<String, Integer> mapTask, int timesDied) {
  mapTask.clear();
  // opacity depends on no.times died
  int opacity = round(255 - 90*timesDied);

  // colour of block depends on task
  mapTask.put("Mining", color(213, 62, 80, opacity));
  mapTask.put("Resources", color(253, 175, 97, opacity));
  mapTask.put("Downtime", color(230, 245, 152, opacity));
  mapTask.put("Farming", color(171, 221, 164, opacity));
  mapTask.put("Building", color(50, 136, 189, opacity));
  mapTask.put("Smelting", color(94, 79, 162, opacity));
}
