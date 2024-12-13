import java.util.HashMap;
static class Data {
  private String date;
  private String day;
  private ArrayList<String[]> data;
  private ArrayList<String[]> coords;

  Data(String date, String day, ArrayList<String[]> data) {
    this.date = date;
    this.day = day;
    this.data = data;
    this.coords = new ArrayList<String[]>();
  }

  public String getDate() {
    return this.date;
  }

  public String getDay() {
    return this.day;
  }

  public String[] getData(int task) {
    return this.data.get(task);
  }

  public int getNumberOfTasks() {
    return this.data.size();
  }

  public String[] getCoords(int taskNumber) {
    return this.coords.get(taskNumber);
  }

  public void setCoords(int coordNumber, String[] coords) {
    this.coords.add(coordNumber, coords);
  }

  public int getNumberOfCoords() {
    return this.coords.size();
  }

  public int getTimeInSeconds(int task) {
    String date = this.getData(task)[0];
    return Data.TimeInSeconds(date);
  }

  public static int TimeInSeconds(String date) {
    int hours = int(date.substring(0, 2));
    int minutes = int(date.substring(2, 4));
    int seconds = int(date.substring(4, 6));
    return (hours * 60 * 60) + (minutes * 60) + seconds;
  }
}
